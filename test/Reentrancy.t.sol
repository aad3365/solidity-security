// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Reentrancy/Dao.sol";
import "src/Reentrancy/Attack.sol";

contract ReentrancyTest is Test {
    Dao public dao;
    Attack public attack;

    // setUp dao contract balance!
    // someone deposit 10 ether on dao
    function setUp() public {
        dao = new Dao();
        attack = new Attack(address(dao));
        vm.deal(address(123), 20 ether);
        vm.prank(address(123));
        dao.deposit{value: 10 ether}();
    }

    // attacker starts attacking dao
    // reentrancy triggered
    function test_hackTheDao() public {
        attack.attack{value: 1 ether}();
        console.logUint(address(attack).balance);
        assertEq(address(attack).balance, 11 ether);
    }
}
