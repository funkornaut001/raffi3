// pragma solidity ^0.8.18;

// import { Test } from "forge-std/Test.sol";
// import { Mng } from "../src/Mng.sol";

// contract MngInvariant is Test {
//     Mng public mng;

//     function setUp() public {
//         mng = new Mng(4052);
//     }

//     function invariant_approveTokenCaller() public {
//         // asser equal the msg sender of the approveToken function and the owner of the contract
//         assertEq(mng.addTokenToApproved(), msg.sender);
//     }
// }
// /**
//  * possible invariants:
//  * buyer can never buy more than the remaining tickets.
//  * seller can never enter their own rafffle.
//  * seller can never choose a ERC20 token that is not approved.
//  * 
//  * Use bound() to set the range of invariant/fuzz test.
//  * ex, amount = bound(amount, 0, weth.balanceOf(address(this)));
//  *  amount will never be higher than the balance of the this address - fuzz shouldl not have any reverts
//  * 
//  * vm.prank(msg.sender) will fuzz many diffrent addresses as msg.sender.
//  * deal(address, amount) - "prints ETH to an account"
//  * adding a pay(address, amount) helper function will sned "eth"
//  * 
//  */