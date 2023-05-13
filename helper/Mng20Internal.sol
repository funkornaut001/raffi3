// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/ManagerERC20.sol";

//this is needed to grab internal functions for testing

contract Mng20Harness is ManagerERC20 {
    //exposing internal functions for testing
    constructor() ManagerERC20(4052) {}
    
    function exposed_stakeNFT(uint256 _raffleId) external {
        return stakeNFT(_raffleId);
    }

    // function exposed_requestRandomWords(uint256 _id, uint256 _entriesSize) external {
    //     return requestRandomWords(requestId);
    // }

    function exposed_fulfillRandomWords(uint256 _id, uint256[] memory _randomWords) external {
        return fulfillRandomWords(_id, _randomWords);
    }



}