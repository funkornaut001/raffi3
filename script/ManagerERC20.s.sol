// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
//import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "../src/ManagerERC20.sol";

contract MngDeploymentScript is Script {
    address public managerERC20Address;

    function setUp() public {}
    function run() public {
        vm.startBroadcast();
        ManagerERC20 managerERC20 = new ManagerERC20(4052);
        managerERC20Address = address(managerERC20);
        vm.stopBroadcast();
    }
}
