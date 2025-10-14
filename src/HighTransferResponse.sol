// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HighTransferResponse {
    event HighTransferDetected(address indexed holder, uint256 prevBalance, uint256 latestBalance, uint256 delta);

    function respondToHighTransfer(address holder, uint256 prevBalance, uint256 latestBalance, uint256 delta) external {
        emit HighTransferDetected(holder, prevBalance, latestBalance, delta);
    }
}
