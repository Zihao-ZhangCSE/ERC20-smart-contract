// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract AES is ERC20, ERC20Permit {
    address public owner;
    constructor(address owner_) ERC20("AES", "ATK") ERC20Permit("AES") {
        owner = owner_;
        _mint(owner, 1000000 * (10 ** 18));
    }
    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Only owner can mint");
        _mint(to, amount);
    }

}
