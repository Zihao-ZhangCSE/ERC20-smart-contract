// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {AES} from "src/AES.sol";

contract AESScript is Script {
  function setUp() public {}

  function run() public {
    // TODO: Set addresses for the variables below, then uncomment the following section:
    /*
    vm.startBroadcast();
    address recipient = <Set recipient address here>;
    AES instance = new AES(recipient);
    console.log("Contract deployed to %s", address(instance));
    vm.stopBroadcast();
    */
  }
}
