// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract CallMain{
    uint public number;
    address public logicAddress;
    address owner;
    event NumberChanged(address _from, uint _newNumber);

    constructor(address _logicAddress){
        logicAddress = _logicAddress;
        owner = msg.sender;
    }

    function delegateChangeNumber(uint newNumber) public ownerOnly{
        (bool success, ) = logicAddress.delegatecall(
            abi.encodeWithSignature("convertNumber(uint256)", newNumber)
        );
        require(success, "Delegate Call Failed");
    }

    function changeLogicAddress(address _newLogicAddress) public ownerOnly{
        logicAddress = _newLogicAddress; 
    }

    modifier ownerOnly(){
        require(msg.sender == owner, "Only allowed for owner");
        _;
    }
}

contract CallLogic{
    uint public number;
    event NumberChanged(address _from, uint _newNumber);

    function convertNumber(uint newNumber) public {
        number = newNumber*3 +2;
        emit NumberChanged(msg.sender, newNumber);
    }
}

contract CallLogicV2{
    uint public number;
    event NumberChanged(address _from, uint _newNumber);

    function convertNumber(uint newNumber) public{
        number = newNumber*100+1;
        emit NumberChanged(msg.sender, newNumber);
    }
}