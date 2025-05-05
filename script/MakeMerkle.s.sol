// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {ScriptHelper} from "murky/script/common/ScriptHelper.sol";

contract MakeMerkle is Script, ScriptHelper {
    using stdJson for string;

    Merkle private m = new Merkle();

    string private inputPath = "/script/target/input.json";
    string private outputPath = "/script/target/output.json";

    string private elements = vm.readFile(string.concat(vm.projectRoot(), inputPath));
    string[] private types = elements.readStringArray(".types");
    uint256 private count = elements.readUint(".count");

    bytes32[] private leafs = new bytes32[](count);
    string[] private inputs = new string[](count);
    string[] private outputs = new string[](count);
    string private output;

    function getValuesByIndex(uint256 i) internal pure returns (string memory) {
        return string.concat(".values.", vm.toString(i));
    }

    function generateJsonEntries(
        string memory _input,
        string memory _proof,
        string memory _root,
        string memory _leaf
    ) internal pure returns (string memory) {
        return string.concat(
            "{",
            "\"input\":", _input, ",",
            "\"proof\":", _proof, ",",
            "\"root\":\"", _root, "\",",
            "\"leaf\":\"", _leaf, "\"",
            "}"
        );
    }

    function run() public {
        console.log("Generating Merkle Proof for %s", inputPath);

        // Generate leaves
        for (uint256 i = 0; i < count; ++i) {
            // 修复点1：保持数组编码逻辑
            bytes32[] memory data = new bytes32[](1);
            address value = elements.readAddress(getValuesByIndex(i));
            data[0] = bytes32(uint256(uint160(value)));
            
            // 修复点2：恢复完整哈希流程
            bytes memory encoded = abi.encode(data);
            bytes memory trimmed = ltrim64(encoded);
            leafs[i] = keccak256(bytes.concat(keccak256(trimmed)));

            // 修复点3：保持输入数组结构
            string[] memory inputArr = new string[](1);
            inputArr[0] = vm.toString(value);
            inputs[i] = stringArrayToString(inputArr);
        }

        bytes32 root = m.getRoot(leafs);

        // Generate proofs
        for (uint256 i = 0; i < count; ++i) {
            bytes32[] memory proof = m.getProof(leafs, i);
            outputs[i] = generateJsonEntries(
                inputs[i],                  // 保持数组格式 ["0x..."]
                bytes32ArrayToString(proof),
                vm.toString(root),
                vm.toString(leafs[i])
            );
        }

        output = stringArrayToArrayString(outputs);
        vm.writeFile(string.concat(vm.projectRoot(), outputPath), output);
        console.log("DONE: The output is found at %s", outputPath);
    }
}