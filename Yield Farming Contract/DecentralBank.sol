// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Tether.sol";
import "./Reward.sol";

contract DecentralBank {
    string public name = "Decentral Bank";
    address public owner;
    Tether public tether;
    Reward public reward;

    address[] stakers;

    mapping(address => uint) public stakeBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(Reward _reward, Tether _tether) {
        reward = _reward;
        tether = _tether;
        owner = msg.sender;
        isStaking[msg.sender] = false;
    }

    function stake(uint _amount) public {
        if (_amount > 0){
            tether.transferFrom(msg.sender, address(this), _amount);
            stakeBalance[msg.sender] += _amount;
            if(!hasStaked[msg.sender]){
                stakers.push(msg.sender);
            }
            hasStaked[msg.sender] = true;
            isStaking[msg.sender] = true;
        }
    }

    function rewardStakers() public {
        require(msg.sender == owner);
        if (stakers.length > 0){
            for(uint i=0; i<stakers.length; i++){
                address staker = stakers[i];
                uint balance = stakeBalance[staker];
                reward.transfer(staker, balance);
            }
        }
    }

    function unStake(uint _amount) public {
        if (hasStaked[msg.sender] && stakeBalance[msg.sender] > _amount){
            tether.transferFrom(address(this), msg.sender, _amount);
            stakeBalance[msg.sender] -= _amount;            
            isStaking[msg.sender] = false;
        }
    }

}