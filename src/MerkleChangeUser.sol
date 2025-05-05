// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Merkle Tree 应⽤合约
 * @author 付朝阳
 * @notice 1. Owner 有权修改 Merke Root
 * @notice 2. Merkle Tree 中的⽤⼾可以修改合约的属性 latest_user 的值为⾃⼰的钱包地址
 * 
 */
contract MerkleChangeUser is Ownable {

    error Merkle_InvalidProof();

    bytes32 public s_merkleRoot;
    address public s_latestUser;
    int256 public s_latest_user_nounce=0;

    event LatestUserChanged(address account, int256 nounce);
    event MerkleRootUpdated(bytes32 newMerkleRoot);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(bytes32 _merkleRoot) Ownable(msg.sender) {
        s_merkleRoot = _merkleRoot;
    }

    /// @notice Merkle Tree 中的⽤⼾可以修改合约的属性 latest_user 的值为⾃⼰的钱包地址
    /// @param _merkleProof The number of rings from dendrochronological sample
    function changeLatestUser(
        bytes32[] calldata _merkleProof
    )
        external
    {
        // calculate the leaf node hash
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
        // verify the merkle proof
        if (!MerkleProof.verify(_merkleProof, s_merkleRoot, leaf)) {
            revert Merkle_InvalidProof();
        }

        s_latestUser = msg.sender;
        s_latest_user_nounce++;
        emit LatestUserChanged(msg.sender, s_latest_user_nounce);
    }

    function changeMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner{
        s_merkleRoot = _newMerkleRoot;
        emit MerkleRootUpdated(_newMerkleRoot);
    }


    /*//////////////////////////////////////////////////////////////
                             VIEW AND PURE
    //////////////////////////////////////////////////////////////*/
    function getMerkleRoot() external view returns (bytes32) {
        return s_merkleRoot;
    }

    function getLatestUser() external view returns (address) {
        return s_latestUser;
    }



    /*//////////////////////////////////////////////////////////////
                             INTERNAL
    //////////////////////////////////////////////////////////////*/

       
}