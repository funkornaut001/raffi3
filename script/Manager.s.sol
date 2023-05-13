// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import {VRFv2Consumer} from "@chainlink/contracts";

contract ChainlinkScript is Script {
    function setUp() public {}
    function run() public {
        vm.startBroadcast();
        VRFv2Consumer VRFv2 = new VRFv2Consumer(1810);
        vm.stopBroadcast();
    }
}