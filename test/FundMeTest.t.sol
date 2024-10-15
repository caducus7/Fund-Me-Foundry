//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant VALUE = 10e18;
    uint256 constant BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assert(fundMe.MINIMUM_USD() == 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.getOwner());
        console.log(msg.sender);
        console.log(address(this));
        assert(fundMe.getOwner() == msg.sender); // msg.sender -> FundMeTest -->> FundMe, but now its back to msg.sender since we deploy contract during script
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assert(version == 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund(); //send 0 value
    }

    function testFundUpdatesFundedAmount() public funded {
        assert(fundMe.getAddressToAmountFunded(USER) == VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFounder(0);
        assert(funder == USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        assert(
            fundMe.getOwner().balance ==
                startingFundMeBalance + startingOwnerBalance &&
                address(fundMe).balance == 0
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 2;
        uint160 startingFunderIndex = 1; // we start at 1, to make sure we dont send stuff to address(0), which usually gets edited a lot

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), VALUE);
            fundMe.fund{value: VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
        assert(address(fundMe).balance == 0);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        //Arrange
        uint160 numberOfFunders = 2;
        uint160 startingFunderIndex = 1; // we start at 1, to make sure we dont send stuff to address(0), which usually gets edited a lot

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), VALUE);
            fundMe.fund{value: VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdrawCheaper();

        //Assert
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
        assert(address(fundMe).balance == 0);
    }
}
