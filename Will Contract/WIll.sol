// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Will {
    address owner;
    uint wealth;
    bool hasdesceased;

    constructor() payable {
        require(msg.value > 0, "Set value of wealth!");
        owner = msg.sender;
        wealth = msg.value;
        hasdesceased = false;
    }

    address payable[] recievers;

    mapping (address => uint) inheritance;

    modifier isOwner {
        require(msg.sender == owner);
        _;
    }

    modifier isDeceased {
        require(hasdesceased == true);
        _;
    }

    function setInheritance (address payable reciever, uint amount) public payable isOwner {
        //require(amount < wealth, "Amount can't be geater than wealth!");
        recievers.push(reciever);
        inheritance[reciever] = amount;
    }

    function payout() private isDeceased {
        uint totalPayout;
        for(uint i=0; i<recievers.length; i++){
            recievers[i].transfer(inheritance[recievers[i]]);
            totalPayout += inheritance[recievers[i]];
        }
        //require(totalPayout < wealth, "Total Payout can't be greater than amount!");
    }

    function morte() public  {
        hasdesceased = true;
        payout();
    }

}