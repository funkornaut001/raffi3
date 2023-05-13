// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../helper/Mng20Internal.sol";
import "../src/ManagerERC20.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC721.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC20.sol";

contract ManagerERC20Test is Test, Mng20Harness {
    ManagerERC20 public managerERC20;
    
    address alice = address(0x1337);
    address bob = address(0x133702);
    address charlie = address(0x133703);

    MockERC721 nft;
    MockERC20 token;
    
    // event RaffleCreated(
    //     uint256 indexed raffleId,
    //     address indexed nftAddress,
    //     uint256 indexed nftId
    // );

    function setUp() public {

        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(charlie, "Charlie");
        //vm.label(address(this), "TestContract");
        managerERC20 = new ManagerERC20(4052);

        // Fund wallets w/test erc20
        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");
        token.mint(address(this), 100);
        token.mint(alice, 100);
        token.mint(bob, 100);
        token.mint(charlie, 100);

        // Fund Alice with test nft and approve it for the manager to transfer
        nft = new MockERC721("TestNFT", "TNFT");
        vm.label(address(nft), "TestNFT");
        nft.mint(alice, 1);
        vm.prank(alice);
        nft.approve(address(managerERC20), 1);
    }

    function test_checkSetUp() public {
        assertEq(nft.balanceOf(alice), 1);
        assertEq(token.balanceOf(address(this)), 100);
        assertEq(token.balanceOf(bob), 100);
        assertEq(token.balanceOf(address(this)), 100);
        assertEq(token.balanceOf(alice), 100);
        assertEq(nft.balanceOf(bob), 0);
    }



    ////////////
    // Events //
    ////////////
    /* TODO
Event testing
1. tell foundry which data to check
2. emit the expected event
3. call the function that should emit the event

*/
    // function test_emitRaffleCreatedEvent() public {

    //     vm.expectEmit(true, true, true, true);

    //     emit RaffleCreated(1, address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619), 1);
    //     managerERC20.createRaffle(
    //         10,
    //         [true, 0x0000000000000000000000000000000000001010, 1000000000000000, 0],
    //         0x60e6F7d2548835d92d0479CefA7eE96172FB6348
    //     );
    // }

    function test_addAndRemoveTokenToApproved() public {
        //address token = address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619); //WETH address

        managerERC20.addTokenToApproved(address(token));
        bool approved = managerERC20.isTokenApproved(address(token));

        assertTrue(approved);

        managerERC20.removeTokenFromApproved(address(token));
        approved = managerERC20.isTokenApproved(address(token));
        assertFalse(approved);
    }

    ///////////////
    // OnlyOwner //
    ///////////////

    function test_addTokenToApprovedOnlyOwner() public {
        // address token = address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619); //WETH address

        vm.startPrank(address(2));
        vm.expectRevert(bytes("Only callable by owner"));
        managerERC20.addTokenToApproved(address(token));
        vm.stopPrank();
    }

    function test_removeTokenFromApprovedOnlyOwner() public {
        //address token = address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619); //WETH address

        vm.startPrank(address(2));
        vm.expectRevert(bytes("Only callable by owner"));
        managerERC20.removeTokenFromApproved(address(token));
        vm.stopPrank();
    }

    function test_extractNFTOnlyOwner() public {
        vm.startPrank(address(2));
        vm.expectRevert(bytes("Only callable by owner"));
        managerERC20.extractNFT(1);
        vm.stopPrank();
    }

    // function test_transferNFTTrustedCaller() public {
    //     vm.startPrank(address(2));
    //     vm.expectRevert(bytes("Caller not authorized"));
    //     managerERC20.transferNFTAndFunds();
    //     vm.stopPrank();
    // }

    //////////////
    // Internal //
    //////////////

    // TODO test stakeNFT()
}
