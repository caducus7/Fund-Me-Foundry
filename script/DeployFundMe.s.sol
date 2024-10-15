//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig config = new HelperConfig();

        //before broadcast, not real TX
        vm.startBroadcast();
        FundMe fundMe = new FundMe(config.activeNetworkConfig());
        vm.stopBroadcast();
        return fundMe;
    }
}
