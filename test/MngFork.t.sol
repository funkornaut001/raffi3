//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Mng} from "../src/Mng.sol";

contract MngTest is Test {
    Mng public mng;
    uint256 mumbai;
    uint256 main;

    function setUp() public {
        mng = new Mng(4052);

        string memory mumbaiRpcUrl = vm.envString("MUMBAI_RPC_URL");
        string memory mainRpcUrl = vm.envString("POLYGON_RPC_URL");


       // mumbai = vm.envString("${MUMBAI_RPC_URL}");
        mumbai = vm.createFork(mumbaiRpcUrl);
        main = vm.createFork(mainRpcUrl);
    }

    function test_forkIdDiffer() public view {
        assert(mumbai != main);
    }

    function test_canSelectFork() public {
        vm.selectFork(main);
        assertEq(vm.activeFork(), main);
    }

    function test_canSwitchForks() public {
        vm.selectFork(main);
        assertEq(vm.activeFork(), main);
        vm.selectFork(mumbai);
        assertEq(vm.activeFork(), mumbai);
    }

    // function test_canCreateAndSelectForkInOneStep() public {
    //     uint256 anotherFork = vm.createSelectFork(main);
    //     assertEq(vm.activeFork(), anotherFork);
    // }
}