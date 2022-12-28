// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//Element of Struct is declaring
contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    //we are declaring an array of the struct
    Todo [] public todos;

    //Create a default todo array
    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            completed: false
        }));
    }
    //Updating text of given index of the array
    function updateText(uint256 _index,string calldata _text) external {
        todos[_index].text=_text;

        Todo storage todo= todos[_index];
        todo.text=_text;
    }
    //Read of the given index of array 
    function get(uint256 _index) external view returns(string memory,bool){
        Todo memory todo=todos[_index];
        return(todo.text,todo.completed);
    }
    //Changing as completed or incompleted function
    function toggleCompleted(uint256 _index) external {
        todos[_index].completed= !todos[_index].completed;
    }
}
