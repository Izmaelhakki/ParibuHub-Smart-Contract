// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";

contract CrowdFund {
      event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id,address indexed caller, uint amount);
     
    //Declaring campaign elements  
    struct Campaign {
        address creator;
        uint goal;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    //Each user has a number and we store yours pledge amount.Use IERC20 token
    IERC20 public immutable token;
    uint public count;
    mapping(uint=>Campaign) public campaigns;
    mapping(uint=>mapping(address=>uint)) public pledgedAmount;
    
    constructor(address _token){
        token=IERC20(_token);
    }

    function Launch(
        uint _goal,
        uint pledge,
        uint32 _startAt,
        uint32 _endAt
    )external {
        //Control of desired time values
        require(_startAt >= block.timestamp,"Start at < now");
        require(_endAt >=_startAt,"End at < start at");
        require(_endAt<= block.timestamp+ 90 days,"end at >max Duration");
        //new campaings create        
        count +=1;
        campaigns[count]=Campaign({
            creator:msg.sender,
            goal:_goal,
            pledge:0,
            startAt:_startAt,
            endAt:_endAt,
            claimed:false
        });
        emit Launch(count,msg.sender,_goal,_startAt,_endAt);
    }

    function cancel(uint id) external{
        Campaign memory campaign=campaigns[_id];
        require(msg.sender==campaign.creator,"Not Creator");
        require(block.timestamp <campaign.startAt,"Started");
        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint256 id, uint256 _amount)external{
        Campaign storage campaign=campaigns[_id];
        require(block.timestamp>=campaign.startAt,"Not Started");
        require(block.timestamp<=campaign.endAt,"Ended");

        campaign.pledged+=_amount;
        pledgedAmount[_id][msg.sender]+=_amount;
        token.transferFrom(msg.sender,address(this),_amount);

        emit Pledge (_id,msg.sender,_amount);
    }

    function unpledge(uint256 id,uint256 _amount)external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint256 id)external{
        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);
        emit Claim(_id);
    }

    function refund(uint256 id, uint256 _amount)external{
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);

    }
}