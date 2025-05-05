// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleChangeUser} from "../src/MerkleChangeUser.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract MerkleChangeUserTest is Test {
    MerkleChangeUser merkleChangeUser;
    
    // 测试用地址
    address public constant USER = 0xD3acD226309D35c5c8f0f553b6dDbBE9d5553645;
    address public constant NOT_USER = address(1);
    address public constant NEW_USER = address(2);
    address public OWNER; // 不再使用常量，而是在setUp中设置为部署者地址

    // 初始化的Merkle Root
    bytes32 public constant INITIAL_ROOT = 
        0xe37716be2127d453afea9db70ca9f9603522de8aa30df3d5b29f9f2ff7727a13;
    
    // 有效的Merkle Proof（对应USER地址）
    bytes32 proofOne = 0xd791b4384f11048b2330e9ec924a5c80226526b5e9d7f65537637981af4d404f;
    bytes32 proofTwo = 0xa734766c7655875218b9cf7c55c995a5c996ca326e5f933e3793def3b14d12a1;
    bytes32[] validProof;

    // 新的Merkle Root（用于修改测试）
    bytes32 public constant NEW_ROOT = 
        0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;

    function setUp() public {
        // 使用当前测试合约地址作为部署者和所有者
        OWNER = address(this);
        
        // 直接部署合约
        merkleChangeUser = new MerkleChangeUser(INITIAL_ROOT);
        
        // 初始化validProof数组
        validProof = new bytes32[](2);
        validProof[0] = proofOne;
        validProof[1] = proofTwo;
    }

    // 测试1: 白名单用户能否成功修改latestUser
    function testUsersCanClaim() public {
        vm.prank(USER);
        merkleChangeUser.changeLatestUser(validProof);

        // 验证状态变更
        assertEq(merkleChangeUser.getLatestUser(), USER);
        assertEq(merkleChangeUser.s_latest_user_nounce(), 1);
    }

    // 测试2: 修改latestUser时触发正确事件
    function testClaimEmitsEvent() public {
        vm.prank(USER);
        vm.expectEmit(true, true, true, true);
        emit MerkleChangeUser.LatestUserChanged(USER, 1);
        merkleChangeUser.changeLatestUser(validProof);
    }

    // 测试3: 非白名单用户无法修改latestUser
    function testNotUserCannotClaim() public {
        vm.prank(NOT_USER);
        vm.expectRevert(MerkleChangeUser.Merkle_InvalidProof.selector);
        merkleChangeUser.changeLatestUser(validProof);
    }

    // 测试4: 使用无效证明无法修改
    function testInvalidProofFails() public {
        bytes32[] memory invalidProof = new bytes32[](1);
        invalidProof[0] = bytes32("invalid");

        vm.prank(USER);
        vm.expectRevert(MerkleChangeUser.Merkle_InvalidProof.selector);
        merkleChangeUser.changeLatestUser(invalidProof);
    }

    // 测试5: Owner可以修改Merkle Root
    function testOwnerCanChangeRoot() public {
        // 不需要prank，因为当前调用者(测试合约)已经是owner
        merkleChangeUser.changeMerkleRoot(NEW_ROOT);

        assertEq(merkleChangeUser.getMerkleRoot(), NEW_ROOT);
    }

    // 测试6: 修改Merkle Root触发事件
    function testChangeRootEmitsEvent() public {
        // 不需要prank，因为当前调用者(测试合约)已经是owner
        vm.expectEmit(true, true, true, true);
        emit MerkleChangeUser.MerkleRootUpdated(NEW_ROOT);
        merkleChangeUser.changeMerkleRoot(NEW_ROOT);
    }

    // 测试7: 非Owner无法修改Merkle Root
    function testNonOwnerCannotChangeRoot() public {
        vm.prank(NOT_USER);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", NOT_USER));
        merkleChangeUser.changeMerkleRoot(NEW_ROOT);
    }

    // 测试8: 修改Root后旧证明失效
    function testProofInvalidAfterRootChange() public {
        // 先修改Root，不需要prank
        merkleChangeUser.changeMerkleRoot(NEW_ROOT);

        // 尝试使用旧证明
        vm.prank(USER);
        vm.expectRevert(MerkleChangeUser.Merkle_InvalidProof.selector);
        merkleChangeUser.changeLatestUser(validProof);
    }
}