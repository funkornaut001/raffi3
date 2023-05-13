// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../lib/forge-std/src/console.sol";
import "../helper/HelperRaffleEnded.sol";
import "../src/ManagerERC20.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC721.sol";
import "../lib/solmate/src/test/utils/mocks/MockERC20.sol";

contract TransferNFTAndFunds is Test, HelperRaffleEnded {
    
    function test_transferNFTAndFunds() public {
        createRaffleEnded();

        vm.startPrank(alice);
        managerERC20.transferNFTAndFunds(0);

        assertEq(nft.balanceOf(address(managerERC20)), 0);
        assertEq(address(managerERC20).balance, 0);
    }

}