// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter{
    
    string public name_;
    string public symbol_;
    uint8 public decimals_;
    uint256 public initSupply_;
    uint256 public totalSupply_; 
    address public owner;
    
    // 余额存储
    mapping(address => uint256) private balances;
    
    // 授权存储
    mapping(address => mapping(address => uint256)) private allowances;

    // 必须的事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TransferFrom(address indexed owner, address indexed receiver, uint256 value);
    event Mint(address indexed account, uint256 value);

    constructor() {
    // 定义合约基础参数
        name_ = "AESToken";
        symbol_ = "ATK";
        decimals_ = 18;
        initSupply_ = 1000000 * (10 ** 18);
        totalSupply_ = initSupply_;
        owner = msg.sender;
        balances[owner] = initSupply_;
    }
        function name() public view returns(string memory){
            return name_;
        }

        function symbol() public view returns(string memory) {
            return symbol_;
        }

        function decimals() public pure returns (uint8){
            return 18;
        }

        function initSupply() public view returns (uint256){
            return initSupply_;
        }

        function totalSupply() public view returns(uint256){
            return totalSupply_;
        }

        // 基础余额查询
        function balanceOf(address account) public view returns(uint256){
            uint256 balanceOfAccount = balances[account];
            return balanceOfAccount;
        }

        // 转账函数
        function transfer(address toAddr, uint256 amount) public{
            address fromAddr;
            fromAddr = msg.sender;
            require(toAddr != address(0), "Transfer to 0 address");
            require(fromAddr != address(0), "Transfer from 0 address");
            require(balances[fromAddr] >= amount, "Account Balance Not Enough!");
            balances[fromAddr] -= amount;
            balances[toAddr] += amount;
            emit Transfer(fromAddr, toAddr, amount);
        }

       

        // 授权额度查询
        function allowance(address ownerAddr, address spenderAddr) public view returns(uint256){
            uint256 amount = allowances[ownerAddr][spenderAddr];
            return amount;
        }

        // 授权函数
        function approve(address spenderAddr, uint256 amount) public {
            address ownerAddr = msg.sender;
            require(ownerAddr != address(0), "Owner Address cannot be 0!");
            require(spenderAddr != address(0), "Spender Address cannot be 0!");
            require(balances[ownerAddr] >= amount, "Account Balance Not Enough!");
            allowances[ownerAddr][spenderAddr] = amount;
            emit Approval(ownerAddr, spenderAddr, amount);
        }

        // 授权转账函数
        function transferFrom(address fromAddr, address toAddr, uint256 amount) public{
            address spenderAddr = msg.sender;
            require(fromAddr != address(0), "Owner Address cannot be 0!");
            require(toAddr != address(0), "Receiver Address cannot be 0!");
            require(spenderAddr != address(0), "Spender Address cannnot be 0!");
            require(allowances[fromAddr][spenderAddr] >= amount);
            balances[fromAddr] -= amount;
            allowances[fromAddr][spenderAddr] -= amount;
            balances[toAddr] += amount;
            emit TransferFrom(fromAddr, toAddr, amount);
        }

        function mint(address account, uint256 amount) public {
            require(msg.sender == owner, "Only Owner Can Mint");
            require(account != address(0), "Receiver address cannot be 0!");
            balances[account] += amount;
            totalSupply_ += amount;
            emit Mint(account, amount);
        }
        }