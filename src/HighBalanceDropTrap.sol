// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

interface IERC20 { 
    function balanceOf(address) external view returns (uint256);
}

contract HighBalanceDropTrap is ITrap {
    // === CONFIGURATION ===
    address public constant TOKEN = 0x7728A33EBEBCfa852cf7f7Fc377BfC87C24a701A;

    // Threshold: alert if any tracked holder’s balance drops by >= 1,000,000 tokens
    uint256 public constant THRESHOLD = 1_000_000 * 1e18;

    address public constant HOLDER_1 = 0xA17187De490dB5F7160822dA197bcAc39d64baCb;
    address public constant HOLDER_2 = 0x1111111111111111111111111111111111111111;
    address public constant HOLDER_3 = 0x2222222222222222222222222222222222222222;

    // === DATA COLLECTION ===
    function collect() external view override returns (bytes memory) {
        uint256 b1; uint256 b2; uint256 b3;

        // try/catch so collect() never reverts — ensures safety in dryrun
        try IERC20(TOKEN).balanceOf(HOLDER_1) returns (uint256 v) { b1 = v; } catch {}
        try IERC20(TOKEN).balanceOf(HOLDER_2) returns (uint256 v) { b2 = v; } catch {}
        try IERC20(TOKEN).balanceOf(HOLDER_3) returns (uint256 v) { b3 = v; } catch {}

        // encode with context for responder usability
        return abi.encode(
            TOKEN,
            HOLDER_1, b1,
            HOLDER_2, b2,
            HOLDER_3, b3,
            uint64(block.timestamp),
            uint256(block.number)
        );
    }

    // === RESPONSE DECISION ===
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, "");

        (
            address token_new,
            address h1_new, uint256 b1_new,
            address h2_new, uint256 b2_new,
            address h3_new, uint256 b3_new,
            uint64 ts_new,
            uint256 blk_new
        ) = abi.decode(
            data[0],
            (address,address,uint256,address,uint256,address,uint256,uint64,uint256)
        );

        (
            address token_prev,
            address h1_prev, uint256 b1_prev,
            address h2_prev, uint256 b2_prev,
            address h3_prev, uint256 b3_prev,
            /* ts_prev */, /* blk_prev */
        ) = abi.decode(
            data[1],
            (address,address,uint256,address,uint256,address,uint256,uint64,uint256)
        );

        // sanity: token and holder set must match
        if (token_new != token_prev) return (false, "");
        if (h1_new != h1_prev || h2_new != h2_prev || h3_new != h3_prev) return (false, "");

        // detect largest balance drop and return alert payload
        if (b1_prev > b1_new && (b1_prev - b1_new) >= THRESHOLD) {
            return (true, abi.encode(token_new, h1_new, b1_prev, b1_new, b1_prev - b1_new, blk_new, ts_new));
        }
        if (b2_prev > b2_new && (b2_prev - b2_new) >= THRESHOLD) {
            return (true, abi.encode(token_new, h2_new, b2_prev, b2_new, b2_prev - b2_new, blk_new, ts_new));
        }
        if (b3_prev > b3_new && (b3_prev - b3_new) >= THRESHOLD) {
            return (true, abi.encode(token_new, h3_new, b3_prev, b3_new, b3_prev - b3_new, blk_new, ts_new));
        }

        return (false, "");
    }
}
