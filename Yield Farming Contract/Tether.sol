// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Tether {
    string public name = "Mock Tether Token";
    string public symbol = "USDT";
    uint256 public totalSupply = 1000000000000000000000000;
    uint8 public decimal = 18;

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approve(address indexed _owner, address indexed _spender, uint _value);

    mapping(address => uint) public accountBalance;

    mapping(address => mapping(address => uint)) public approvedAmount;

    constructor() {
        accountBalance[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint _amount) public returns (bool feedback){
        if (_amount < accountBalance[msg.sender]){
            accountBalance[msg.sender] -= _amount;
            accountBalance[_to] += _amount;
            //emit Transfer(msg.sender, _to, _amount);
            return true;
        }
    }

    function approve(address _spender, uint _amount) public returns (bool feedback){
        if (_amount <= accountBalance[msg.sender]){
            approvedAmount[msg.sender][_spender] = _amount;
            emit Approve(msg.sender, _spender, _amount);
            return true;
        }
        
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool feedback){
        if (_amount <= approvedAmount[msg.sender][_from]){
            if (_amount <= accountBalance[_from]){
                accountBalance[_from] -= _amount;
                accountBalance[_to] += _amount;
                approvedAmount[msg.sender][_from] -= _amount;
                emit Transfer(_from, _to, _amount);
                return true;
            }
        }
        
    }
}