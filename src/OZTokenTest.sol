// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title OpenZepplin ERC20 token standard implementation
 * @author CC
 * @notice This is the implementation of the ERC20 standard contract.
 * burn function with standard functionality has been implemented in this iteration.
 * @dev constructor requires uint256 initialSupplyOfToken, name of token and symbol
 */
import {ERC20} from "@OZ/contracts/token/ERC20/ERC20.sol";

contract OZTokenTest is ERC20 {
    string private S_NAME;
    string private S_SYMBOL;

    constructor(uint256 _initialSupply, string memory _name, string memory _symbol) ERC20(S_NAME, S_SYMBOL) {
        ERC20._mint(msg.sender, _initialSupply);
        S_NAME = _name;
        S_SYMBOL = _symbol;
    }

    function burn(address account, uint256 amount) public {
        ERC20._burn(account, amount);
    }
}
