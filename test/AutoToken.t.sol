// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {AutoToken} from "../src/AutoToken.sol";
import {DeployAutoToken} from "../script/DeployAutoToken.s.sol";

contract AutoTokenTest is Test{
    AutoToken public autoToken;
    DeployAutoToken public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    function setUp() public {
        deployer = new DeployAutoToken();
        autoToken = deployer.run();

        vm.prank(msg.sender);
        autoToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view{
        assertEq(autoToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowanceWorks() public{
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 100;

        vm.prank(bob);
        autoToken.approve(alice, initialAllowance);

        vm.prank(alice);
        autoToken.transferFrom(bob, alice, transferAmount);

        assertEq(autoToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(autoToken.balanceOf(alice), transferAmount);
    }

    function testTransfer() public{
        uint256 amount = 1000;
        address receiver = address(0x1);

        vm.prank(msg.sender);
        autoToken.transfer(receiver, amount);
        assertEq(autoToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public{
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialBalance = autoToken.balanceOf(msg.sender);

        vm.prank(msg.sender);
        autoToken.transfer(receiver, amount);
        assertEq(autoToken.balanceOf(msg.sender), initialBalance - amount);
    }

    function testTransferFrom() public{
        uint256 amount = 1000;
        address receiver = address(0x1);

        vm.prank(msg.sender);
        autoToken.approve(address(this), amount);

        autoToken.transferFrom(msg.sender, receiver, amount);
        assertEq(autoToken.balanceOf(receiver), amount);
    }
}