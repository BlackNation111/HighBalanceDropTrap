#  🧠 HighBalanceDropTrap

HighBalanceDropTrap is a Drosera trap that detects large token balance drops across one or more monitored holders.
It helps identify whales exiting positions, suspicious fund movements, or massive token sells.

⚙️ Overview

This trap maintains snapshots of tracked holders’ balances for a target ERC20 token.
Between two runs, it compares the new balances to the previous ones and triggers a response if the balance drop exceeds a configured threshold (absolute or relative).

---

## 📦 Prerequisites

1. Install sudo and other pre-requisites :
```bash
apt update && apt install -y sudo && sudo apt-get update && sudo apt-get upgrade -y && sudo apt install curl ufw iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```
3. Install environment requirements:
Drosera Cli
```bash
curl -L https://app.drosera.io/install | bash
source /root/.bashrc
droseraup
```
Foundry cli
```bash
curl -L https://foundry.paradigm.xyz | bash
source /root/.bashrc
foundryup
```
Bun
```bash
curl -fsSL https://bun.sh/install | bash
source /root/.bashrc
```
   

## ⚙️ Setup

Clone this repository

```bash
git clone https://github.com/staboi170/whale-sell-trap
cd whale-sell-trap
```
Compile contract

```bash
forge build
```
Whitelist wallet address
```bash
nano drosera.toml
# Put your EVM public address funded with hoodi ETH in whitelist
e.g ["0xedj..."]  
```
Deploy the trap
```bash
DROSERA_PRIVATE_KEY=xxx drosera apply
```
 Replace xxx with your EVM wallet privatekey (Ensure it's funded with Hoodi ETH, you can claim 1E from hoodifaucet.io)
