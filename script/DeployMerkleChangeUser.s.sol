// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { MerkleChangeUser} from "../src/MerkleChangeUser.sol";
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract DeployMerkleChangeUser is Script {
    bytes32 public ROOT = 0xe37716be2127d453afea9db70ca9f9603522de8aa30df3d5b29f9f2ff7727a13;

    // Deploy the MerkleChangeUser contract 
    function deployMerkleChangeUser() public returns (MerkleChangeUser) {
        vm.startBroadcast();
        MerkleChangeUser merkleChangeUser = new MerkleChangeUser(ROOT);
        vm.stopBroadcast();
        return merkleChangeUser;
    }

    function run() external returns (MerkleChangeUser) {
        return deployMerkleChangeUser();
    }

}