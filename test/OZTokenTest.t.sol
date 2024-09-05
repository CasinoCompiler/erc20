// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {OZTokenTest} from "../src/OZTokenTest.sol";
import {DeployOZTokenTest} from "../script/DeployOZToken.s.sol";

contract TestOZTokenTest is Test {
    /*
        * Events from IERC20
    */

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    /*
        * Variables for test
    */

    OZTokenTest public ozTokenTest;
    DeployOZTokenTest public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address deployerAddress = address(1);

    uint256 public constant STARTING_BALANCE = 100;

    function setUp() public {
        deployer = new DeployOZTokenTest();
        ozTokenTest = deployer.run();
    }

    /*//////////////////////////////////////////////////////////////
                         MINTING INITIAL SUPPLY
    //////////////////////////////////////////////////////////////*/

    function testInitialMinting() public view {
        uint256 expectedBalance = deployer.INITIAL_SUPPLY();

        assertEq(ozTokenTest.balanceOf(deployerAddress), expectedBalance, "Deployer should have the initial supply");
    }

    /*//////////////////////////////////////////////////////////////
                        APPROVAL AND ALLOWANCES
    //////////////////////////////////////////////////////////////*/

    function testAllowance() public {
        uint256 allowanceForBobToSpend = 10;

        vm.deal(alice, STARTING_BALANCE);
        vm.expectEmit(true, true, true, false);
        emit Approval(alice, bob, allowanceForBobToSpend);
        vm.prank(alice);
        ozTokenTest.approve(bob, allowanceForBobToSpend);

        uint256 approvedAllowance = ozTokenTest.allowance(alice, bob);

        assertEq(approvedAllowance, allowanceForBobToSpend);
    }

    /*//////////////////////////////////////////////////////////////
                                TRANSFER
    //////////////////////////////////////////////////////////////*/
    modifier transferTokensToBob {
        vm.startPrank(address(1));
        ozTokenTest.transfer(bob, STARTING_BALANCE);
        vm.stopPrank();
        _;
    }

    modifier transferTokensToAlice {
        vm.startPrank(address(1));
        ozTokenTest.transfer(alice, STARTING_BALANCE);
        vm.stopPrank();
        _;
    }

    function testTransfer() public transferTokensToBob {
        // Arrange
        uint256 amountToTransfer = 10;
        uint256 bobStartingBalance = ozTokenTest.balanceOf(bob);
        uint256 bobEndingBalance;
        uint256 aliceStartingBalance = ozTokenTest.balanceOf(alice);
        uint256 aliceEndingBalance;

        // Act
        hoax(bob, 1 ether);
        ozTokenTest.transfer(alice, amountToTransfer);
        bobEndingBalance = ozTokenTest.balanceOf(bob);
        aliceEndingBalance = ozTokenTest.balanceOf(alice);

        // Assert
        assertEq(bobStartingBalance, (bobEndingBalance + amountToTransfer));
        assertEq(aliceStartingBalance, (aliceEndingBalance - amountToTransfer));
    }

    function testTransferFrom() public transferTokensToAlice{
        // Arrange
        uint256 allowanceForBobToSpend = 10;
        uint256 bobStartingBalance = ozTokenTest.balanceOf(bob);
        uint256 bobEndingBalance;
        uint256 aliceStartingBalance = ozTokenTest.balanceOf(alice);
        uint256 aliceEndingBalance;

        // Act
        vm.startPrank(alice);
        ozTokenTest.approve(bob, allowanceForBobToSpend);
        vm.stopPrank();

        hoax(bob, 1 ether);
        ozTokenTest.transferFrom(alice, bob, allowanceForBobToSpend);
        bobEndingBalance = ozTokenTest.balanceOf(bob);
        aliceEndingBalance = ozTokenTest.balanceOf(alice);

        // Assert
        assertEq(bobStartingBalance, (bobEndingBalance - allowanceForBobToSpend));
        assertEq(aliceStartingBalance, (aliceEndingBalance + allowanceForBobToSpend));
    }

    /*//////////////////////////////////////////////////////////////
                                  BURN
    //////////////////////////////////////////////////////////////*/

    function testBurnWorksAsIntended() public {
        // Arange
        uint256 amountToBurn = 10;
        uint256 startingTotalBalance = ozTokenTest.totalSupply();
        uint256 endingTotalBalance;
        uint256 bobStartingBalance;
        uint256 bobEndingBalance;

        vm.startPrank(address(1));
        ozTokenTest.transfer(bob, amountToBurn);
        vm.stopPrank();
        bobStartingBalance = ozTokenTest.balanceOf(bob);

        vm.deal(bob, 1 ether);
        vm.expectEmit(true, true, true, false);
        emit Transfer(bob, address(0), amountToBurn);
        vm.prank(bob);

        // Act
        ozTokenTest.burn(bob, amountToBurn);
        bobEndingBalance = ozTokenTest.balanceOf(bob);
        endingTotalBalance = ozTokenTest.totalSupply();

        // Assert - burn mechanics
        assertEq(bobEndingBalance, (bobStartingBalance - 10));
        assertEq(endingTotalBalance, (startingTotalBalance - 10));
    }
}
