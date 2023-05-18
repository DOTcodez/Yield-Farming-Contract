// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Reward {
    string public name = "Reward Token";
    string public symbol = "rUSDT";
    uint256 public totalSupply = 1000000000000000000000000;
    uint8 public decimal = 18;

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approve(address indexed _owner, address indexed _spender, uint _value);

    mapping(address => uint) public accountBalance;

    mapping(address => mapping(address => uint)) public approvedAmount;

    constructor() {
        accountBalance[msg.sender] = totalSupply;
    }

    function getName() public view returns (string memory){
        return name;
    }

    function transfer(address _to, uint _amount) public returns (bool feedback){
        //require(_amount < accountBalance[msg.sender]);
        accountBalance[msg.sender] -= _amount;
        accountBalance[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) public returns (bool feedback){
        require(_amount <= accountBalance[msg.sender]);
        approvedAmount[msg.sender][_spender] = _amount;
        emit Approve(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool feedback){
        require(_amount <= approvedAmount[msg.sender][_from]);
        require(_amount <= accountBalance[msg.sender]);
        accountBalance[_from] -= _amount;
        accountBalance[_to] -= _amount;
        approvedAmount[msg.sender][_from] -= _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
}