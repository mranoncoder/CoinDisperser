// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TestToken is ERC20 {
    using SafeMath for uint256;

    constructor() ERC20("Test", "TEST") {
        _mint(msg.sender, 10000 ether);
        _mint(address(this), 10000 ether);
    }
}
