// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/** 
 * @notice This is just manually creating some ERC20 functionality.
 * Ignore contract
 */

contract ManualToken {
    mapping(address => uint256) private s_addressToBalance;

    string public constant TOKEN_NAME = "Test Token";
    string public constant TOKEN_TICKER = "TEST";

    function totalSupply() public pure returns (uint256) {
        return 1000000000 ether;
    }

    function decimals() public pure returns (uint256) {
        return 18;
    }

    function balanceOf(address _address) public view returns (uint256) {
        return s_addressToBalance[_address];
    }

    function transfer(address _to, uint256 _amount) public {
        // Get balance of address sending token
        uint256 previousSenderBalance = s_addressToBalance[msg.sender];
        uint256 previousReceiverBalance = s_addressToBalance[_to];
        // Send tokens <= Update the mapping
        s_addressToBalance[msg.sender] -= _amount;
        s_addressToBalance[_to] += _amount;
        // Check if before = after
        assert(
            (previousReceiverBalance + previousSenderBalance)
                == (s_addressToBalance[msg.sender] + s_addressToBalance[_to])
        );
    }
}
