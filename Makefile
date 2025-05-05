-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

install :; forge install cyfrin/foundry-devops --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit && forge install dmfxyz/murky --no-commit

