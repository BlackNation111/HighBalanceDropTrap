High Transfer Trap
The HighTransferTrap is a Drosera Trap that monitors ERC20 token transfers on a specific token contract and triggers whenever a transfer exceeds a defined threshold — indicating a potential large whale movement or high-value transaction.

---

📖 Overview
This trap continuously checks recent token transfers for unusually large movements.
It’s useful for tracking whale activity, monitoring liquidity shifts, or detecting suspicious large sends.

---

⚙️ Contract Details
| Constant | Description | Example |
|-----------|--------------|----------|
| TOKEN | The ERC20 token to monitor | 0xB114f9632425aa6fD0F0415d218848Ec4EFA30C8 (Hoodi) |
| THRESHOLD | The minimum transfer amount to trigger an alert | 1,000,000 * 10**18 |

---

🧩 Functions
collect()
Fetches the most recent large transfer event from the token.
Encodes the sender, recipient, and amount into bytes for Drosera’s data aggregation.

shouldRespond()
Analyzes the collected transfer data to determine if any transaction exceeds the defined THRESHOLD.
If so, it signals that a response action should be triggered.
