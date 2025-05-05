// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

contract GenerateInput is Script {
    string[] types = new string[](1);
    uint256 count;
    string[] whitelist = new string[](4);
    string private constant INPUT_PATH = "/script/target/input.json";

    function run() public {
        types[0] = "address";
        whitelist[0] = "0xD3acD226309D35c5c8f0f553b6dDbBE9d5553645";
        whitelist[1] = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
        whitelist[2] = "0x2ea3970Ed82D5b30be821FAAd4a731D35964F7dd";
        whitelist[3] = "0xf6dBa02C01AF48Cf926579F77C9f874Ca640D91D";
        count = whitelist.length;
        string memory input = _createJSON();
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);
        console.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count);
        string memory json = string.concat('{ "types": ["address"], "count":', countString, ',"values": {');
        for (uint256 i = 0; i < whitelist.length; i++) {
            string memory entry = string.concat(
                '"', vm.toString(i), '"', ':', '"', whitelist[i], '"'
            );
            json = string.concat(json, entry);
            if (i != whitelist.length - 1) json = string.concat(json, ",");
        }
        return string.concat(json, '} }');
    }
}