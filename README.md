## 合约地址（已验证）
0xb8bDF584499c1C706ddcEc111f92a6658799cC03
### 未交互的同代码合约地址
0x95ED3c3619598fBc79f506Fa50FA5ac83C77FE29

## Script
含merkle proof输入格式生成脚本，和merkle proof结果生成脚本，分别输出到子目录target下的input.json和output.json

## Test
测试覆盖率100%
![image](https://github.com/user-attachments/assets/e08521a0-8ce7-4ad3-99a9-1e424c7fa109)


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
