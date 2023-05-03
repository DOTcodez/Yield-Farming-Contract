// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Coin{
    address owner;
    address[] users;

    mapping (address => uint) balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner of this coin can mint");
        _;
    }

    function mint(uint amount) public onlyOwner {
        balances[owner] += amount;
    }

    function join(address payable user) public {
        users.push(user);
    }

    function transfer(address to, uint amount) public {
        require(balances[msg.sender] > amount, "Insufficient funds");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function getBalance(address account) public view returns (uint){
        return balances[account];
    }
}