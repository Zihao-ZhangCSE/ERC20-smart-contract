pragma solidity ^0.5.10;

contract ERC20Interface{
    function name() public view returns (string) // Token name
    function symbol() public view returns (string) // Token Symbol
    function decimals() public view returns (uint8) // Token decimals
    function totalSupply() public view returns (uint256) // Token TotalSupply
    function balanceOf(address _owner) public view returns (uint256 balance) // balance of account
    function transfer(address _to, uint256 _value) public returns (bool success) // transfer between accoutns
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) // transfer from .. to .. , associated with allowance
    function approve(address _spender, uint256 _value) public returns (bool success) // approve the allowance from one to another
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) // the balance of the allowance
    event Transfer(address indexed _from, address indexed _to, uint256 _value)
    event Approval(address indexed _owner, address indexed _spender, uint256 _value)
}