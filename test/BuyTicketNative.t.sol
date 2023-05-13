// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../lib/forge-std/src/console.sol";
import "../helper/CreateRaffleHelper.sol";
import "../src/ManagerERC20.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC721.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC20.sol";

contract BuyTicketNative is Test, CreateRaffleHelper {

    MockERC20 token;
    //MockERC721 nft;

function setUp() public {

        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(charlie, "Charlie");
        //vm.label(address(this), "TestContract");
        managerERC20 = new ManagerERC20(4052);

        // Fund wallets w/ETH
        vm.deal(alice, 1 ether);
        vm.deal(bob, 1 ether);
        vm.deal(charlie, 1 ether);

        // Fund Alice with test nft and approve it for the manager to transfer
        nft = new MockERC721("TestNFT", "TNFT");
        vm.label(address(nft), "TestNFT");
        nft.mint(alice, 1);
        vm.prank(alice);
        nft.approve(address(managerERC20), 1);

    
    }

    // will probaly want more tests to make sure raffle is created correctly
    function test_createRafflehelper() public {

        createRaffle();

        // nft has been transfered to the manager -> this kinda of tests the stakeNFT function
        assertEq(nft.ownerOf(1), address(managerERC20));
        // test that the raffle state is Accepted
        assertEq(tRaffles[0].status == STATUS.CREATED, true);
        
    }

    function test_buyEntry() public {
        uint256 bobStartBalance = address(bob).balance;
        uint256 contractStartBalance = address(managerERC20).balance;
                console.log(address(managerERC20).balance);

        
        createRaffle();

        vm.startPrank(bob);
        uint256 ticketPrice = tRaffles[0].paymentInfo.pricePerTicketInWeis;
        uint256 numberOfTickets = 1;
        (bool success, ) = address(managerERC20).call{value: ticketPrice * numberOfTickets}(abi.encodeWithSignature("buyEntry(uint256,uint256)", 0, numberOfTickets));
        assertTrue(success);

        //console log bobs tickets
        console.log(numberOfTickets);
        //console.log(address(managerERC20).balance);
        // check the raffle entry length is 1
        assertEq(managerERC20.getNumberOfEntries(0), 1);
        // check the raffle entry list is 1
        assertEq(managerERC20.getEntriesSize(0), 1);
        // check the raffle entry is bob
        assertEq(managerERC20.getNumberOfEntriesForPlayer(0, bob), 1);
        
        // check that charlies balance decreased by the ticket price * number of tickets
        assertEq((bobStartBalance - (ticketPrice * numberOfTickets)), address(bob).balance);
        // check that the contract balance increased by the ticket price * number of tickets
        assertEq((contractStartBalance + (ticketPrice * numberOfTickets)), address(managerERC20).balance);

        vm.stopPrank();

    }

function test_buyEntryMulti() public {
        uint256 bobStartBalance = address(bob).balance;
        uint256 contractStartBalance = address(managerERC20).balance;
        
        console.log(address(managerERC20).balance);

        
        createRaffle();

        vm.startPrank(bob);
        uint256 ticketPrice = tRaffles[0].paymentInfo.pricePerTicketInWeis;
        uint256 numberOfTickets = 10;
        (bool success, ) = address(managerERC20).call{value: ticketPrice * numberOfTickets}(abi.encodeWithSignature("buyEntry(uint256,uint256)", 0, numberOfTickets));
        assertTrue(success);

        //console log bobs tickets
        console.log(numberOfTickets);
        //console.log(address(managerERC20).balance);
        // check the raffle entry length is 1
        assertEq(managerERC20.getNumberOfEntries(0), 10);
        // check the raffle entry list is 1
        assertEq(managerERC20.getEntriesSize(0), 1);
        // check the raffle entry is bob
        assertEq(managerERC20.getNumberOfEntriesForPlayer(0, bob), 10);
        
        // check that charlies balance decreased by the ticket price * number of tickets
        assertEq((bobStartBalance - (ticketPrice * numberOfTickets)), address(bob).balance);
        // check that the contract balance increased by the ticket price * number of tickets
        assertEq((contractStartBalance + (ticketPrice * numberOfTickets)), address(managerERC20).balance);

        vm.stopPrank();

    }


}