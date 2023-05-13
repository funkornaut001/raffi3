pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/Manager.sol";

contract ManagerTest is Test {
    Manager public manager;


    function setUp() public {
        manager = new Manager(4052);
    }
}