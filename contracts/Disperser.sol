// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * @dev IERC20 ABI
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

/**
 * @dev A token Disperser which helps users to send distribute ether or tokens to multiple addresses
 */
contract Disperser {
    address public constant feeReceiverAddress =
        0x4036425D2A0A99Ff89e8B12B012544493B619bf0;

    /**
     * @notice sending Coins to multiple addresses
     * @param recipients[]: Address of recipes
     * @param values[]: Value to user should be sent (in WEI)
     */
    function disperseCoin(address[] memory recipients, uint256[] memory values)
        external
        payable
    {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) total += values[i];
        uint256 calcFees = (total * 1) / 1000; // 0.1% of the Value which user send.
        require(msg.value >= total + calcFees, "VALUE_TO_LOW");
        for (uint256 i = 0; i < recipients.length; i++)
            payable(recipients[i]).transfer(values[i]);

        payable(feeReceiverAddress).transfer(calcFees);

        uint256 balance = address(this).balance;
        if (balance > 0) payable(msg.sender).transfer(balance); //pay the rest back
    }

    /**
     * @notice sending Tokens to multiple addresses
     * @param token: Contract address of the ERC20 Token
     * @param recipients[]: Address of recipes
     * @param values[]: Value to user should be sent (in WEI)
     */
    function disperseToken(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) total += values[i];
        uint256 calcFees = (total * 1) / 1000; // 0.1% of the Value which user send.
        require(
            token.transferFrom(msg.sender, address(this), total + calcFees),
            "PROBLEM_TRANSFER_TOKENS_TO_CONTRACT"
        );
        for (uint256 b = 0; b < recipients.length; b++)
            require(
                token.transfer(recipients[b], values[b]),
                "PROBLEM_TRANSFER_TOKENS_FROM_CONTRACT"
            );

        require(
            token.transfer(feeReceiverAddress, calcFees),
            "ERROR_SENDING_FEES"
        );
    }
}
