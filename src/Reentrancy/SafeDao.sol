// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ReEntrancyGuard {
    bool internal locked;
    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

contract SafeDao is ReEntrancyGuard {
    mapping (address => uint) balanceOf;

    function deposit() external payable {
        require(msg.value > 0);
        balanceOf[msg.sender] += msg.value;
    }

    function withdrawal() external noReentrant() {
        require(balanceOf[msg.sender] > 0);
        (bool sent, ) = msg.sender.call{value: balanceOf[msg.sender]}("");
        require(sent == true);
        balanceOf[msg.sender] = 0; // do not update after sending money!!!
    }
}
