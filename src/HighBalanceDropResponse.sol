// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HighBalanceDropResponse
/// @notice Receives alerts from HighBalanceDropTrap and emits detailed logs.
contract HighBalanceDropResponse {
    /// @notice Emitted when a large balance drop is detected
    /// @param token The token address being monitored
    /// @param holder The address whose balance dropped
    /// @param prevBalance The previous balance
    /// @param newBalance The new balance
    /// @param delta The drop amount (prev - new)
    /// @param blockNumber The block at which the event was detected
    /// @param timestamp The timestamp at which it occurred
    event HighBalanceDropDetected(
        address indexed token,
        address indexed holder,
        uint256 prevBalance,
        uint256 newBalance,
        uint256 delta,
        uint256 blockNumber,
        uint64 timestamp
    );

    /// @notice Called by Drosera when an alert triggers in the trap
    /// @dev Payload must match the structure encoded by HighBalanceDropTrap
    /// (token, holder, prevBalance, newBalance, delta, blockNumber, timestamp)
    function respondToBalanceDrop(bytes calldata payload) external {
        (
            address token,
            address holder,
            uint256 prevBalance,
            uint256 newBalance,
            uint256 delta,
            uint256 blockNumber,
            uint64 timestamp
        ) = abi.decode(payload, (address, address, uint256, uint256, uint256, uint256, uint64));

        emit HighBalanceDropDetected(
            token,
            holder,
            prevBalance,
            newBalance,
            delta,
            blockNumber,
            timestamp
        );
    }
}
