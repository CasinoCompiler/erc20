## OZTokenTest: An ERC20 Token Implementation

## Overview

OZTokenTest is a Solidity smart contract that implements the ERC20 token standard using OpenZeppelin libraries. This project includes a custom burn functionality and comprehensive test cases using the Foundry framework.

## Features

- Standard ERC20 functionality (transfer, approve, transferFrom)
- Custom burn function
- Comprehensive test suite

## Contract Structure

### OZTokenTest.sol

The main contract inherits from OpenZeppelin's ERC20 implementation and adds:

- Custom constructor for initial supply, name, and symbol
- Burn function

### DeployOZTokenTest.sol

Deployment script that:

- Sets initial supply, name, and symbol
- Deploys the OZTokenTest contract

## Burn Implementation

The burn function is implemented as follows:

```solidity
function burn(address account, uint256 amount) public {
    ERC20._burn(account, amount);
}