// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {OZTokenTest} from "../src/OZTokenTest.sol";

contract DeployOZTokenTest is Script {
    uint256 public constant INITIAL_SUPPLY = 1000000000 ether;
    string public NAME = "ozTestToken";
    string public SYMBOL = "TEST";
    // address public constant DEPLOYER_ADDRESS = address(1);

    function run() external returns (OZTokenTest) {
        vm.startBroadcast();
        OZTokenTest ozTokenTest = new OZTokenTest(INITIAL_SUPPLY, NAME, SYMBOL);
        vm.stopBroadcast();
        return ozTokenTest;
    }
}
