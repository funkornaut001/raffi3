// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../lib/forge-std/src/console.sol";
import "../helper/CreateRaffleHelperERC20.sol";
import "../src/ManagerERC20.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC721.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC20.sol";

contract BuyTicketERC20 is Test, CreateRaffleHelperERC20 {


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

        // Fund wallets w/test erc20
        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");
        token.mint(address(this), 100);
        token.mint(alice, 100);
        token.mint(bob, 100);
        token.mint(charlie, 100);

        // Add token to approved list
        managerERC20.addTokenToApproved(address(token));

        // have alice bob and charlie approve the manager to spend their tokens
        vm.prank(alice);
        token.approve(address(managerERC20), 100);
        vm.prank(bob);
        token.approve(address(managerERC20), 100);
        vm.prank(charlie);
        token.approve(address(managerERC20), 100);

        // Fund Alice with test nft and approve it for the manager to transfer
        nft = new MockERC721("TestNFT", "TNFT");
        vm.label(address(nft), "TestNFT");
        nft.mint(alice, 1);
        vm.prank(alice);
        nft.approve(address(managerERC20), 1);

    }

    // will probaly want more tests to make sure raffle is created correctly
    function test_createRafflehelperERC20() public {

        createRaffleERC20();
        // nft has been transfered to the manager
        assertEq(nft.ownerOf(1), address(managerERC20));
        // test that the raffle state is Accepted
        assertEq(tRaffles[0].status == STATUS.CREATED, true);
    }

    function test_buyEntry() public {
        createRaffleERC20();

        uint256 bobStartBalance = token.balanceOf(bob);
        uint256 contractStartBalance = token.balanceOf(address(managerERC20));

        vm.startPrank(bob);
        uint256 ticketPrice = tRaffles[0].paymentInfo.pricePerTicketInWeis;
        uint256 numberOfTickets = 1;

        (bool success, ) = address(managerERC20).call{value: ticketPrice * numberOfTickets}(abi.encodeWithSignature("buyEntry(uint256,uint256)", 0, numberOfTickets));
        assertTrue(success);

        //console log bobs tickets
        console.log(numberOfTickets);
        // check the raffle entry length is 1
        assertEq(managerERC20.getNumberOfEntries(0), 1);
        // check the raffle entry list is 1
        assertEq(managerERC20.getEntriesSize(0), 1);
        // check the raffle entry is bob
        assertEq(managerERC20.getNumberOfEntriesForPlayer(0, bob), 1);
        // check that charlies balance decreased by the ticket price * number of tickets
        assertEq((bobStartBalance - (ticketPrice * numberOfTickets)), token.balanceOf(bob));
        // check that the contract balance increased by the ticket price * number of tickets
        assertEq((contractStartBalance + (ticketPrice * numberOfTickets)), token.balanceOf(address(managerERC20)));


        vm.stopPrank();

    }

    function test_buyEntryMulti() public {
        createRaffleERC20();

        uint256 charlieStartBalance = token.balanceOf(charlie);
        uint256 contractStartBalance = token.balanceOf(address(managerERC20));

        vm.startPrank(charlie);
        uint256 ticketPrice = tRaffles[0].paymentInfo.pricePerTicketInWeis;
        uint256 numberOfTickets = 10;

        (bool success, ) = address(managerERC20).call{value: ticketPrice * numberOfTickets}(abi.encodeWithSignature("buyEntry(uint256,uint256)", 0, numberOfTickets));
        assertTrue(success);

        //console log bobs tickets
        console.log(numberOfTickets);
        // check the raffle entry length is 1
        assertEq(managerERC20.getNumberOfEntries(0), 10);
        // check the raffle entry list is 1
        assertEq(managerERC20.getEntriesSize(0), 1);
        // check the raffle entry is bob
        assertEq(managerERC20.getNumberOfEntriesForPlayer(0, charlie), 10);
        // check that charlies balance decreased by the ticket price * number of tickets
        assertEq((charlieStartBalance - (ticketPrice * numberOfTickets)), token.balanceOf(charlie));
        // check that the contract balance increased by the ticket price * number of tickets
        assertEq((contractStartBalance + (ticketPrice * numberOfTickets)), token.balanceOf(address(managerERC20)));

        vm.stopPrank();

    }

    // TODO test it emits the event     
    
    // event EntrySold(
    //     uint256 indexed raffleId,
    //     address indexed buyer,
    //     uint256 currentSize
    // );

}