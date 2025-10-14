// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

/// @notice Minimal ERC20 balanceOf
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract HighTransferTrap is ITrap {
    // === CONFIGURATION ===

    // ERC20 token to monitor (Hoodi example token, checksummed)
    address public constant TOKEN = 0x7728A33EBEBCfa852cf7f7Fc377BfC87C24a701A;

    // Trigger if balance drop ≥ 10,000 tokens (with 18 decimals)
    uint256 public constant THRESHOLD = 10_000 * 1e18;

    // Top holders we want to monitor
    address public constant HOLDER_1 = 0xA17187De490dB5F7160822dA197bcAc39d64baCb; // real whale
    address public constant HOLDER_2 = 0x1111111111111111111111111111111111111111; // placeholder
    address public constant HOLDER_3 = 0x2222222222222222222222222222222222222222; // placeholder

    // === COLLECT ===
    function collect() external view override returns (bytes memory) {
        uint256 b1 = IERC20(TOKEN).balanceOf(HOLDER_1);
        uint256 b2 = IERC20(TOKEN).balanceOf(HOLDER_2);
        uint256 b3 = IERC20(TOKEN).balanceOf(HOLDER_3);

        return abi.encode(HOLDER_1, b1, HOLDER_2, b2, HOLDER_3, b3);
    }

    // === RESPOND DECISION ===
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, bytes(""));

        // decode newest
        (address h1_new, uint256 b1_new, address h2_new, uint256 b2_new, address h3_new, uint256 b3_new) =
            abi.decode(data[0], (address, uint256, address, uint256, address, uint256));

        // decode previous
        (address h1_prev, uint256 b1_prev, address h2_prev, uint256 b2_prev, address h3_prev, uint256 b3_prev) =
            abi.decode(data[1], (address, uint256, address, uint256, address, uint256));

        // holder 1
        if (b1_prev > b1_new && (b1_prev - b1_new) >= THRESHOLD) {
            return (true, abi.encode(h1_new, b1_prev, b1_new, b1_prev - b1_new));
        }
        // holder 2
        if (b2_prev > b2_new && (b2_prev - b2_new) >= THRESHOLD) {
            return (true, abi.encode(h2_new, b2_prev, b2_new, b2_prev - b2_new));
        }
        // holder 3
        if (b3_prev > b3_new && (b3_prev - b3_new) >= THRESHOLD) {
            return (true, abi.encode(h3_new, b3_prev, b3_new, b3_prev - b3_new));
        }

        return (false, bytes(""));
    }
}
