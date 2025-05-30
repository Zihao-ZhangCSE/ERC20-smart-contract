// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address owner = address(this);

    function setUp() public {
        counter = new Counter();
    }


    // 功能测试

    // 基本信息

    // 1、 测试ERC20合约发布的代币的名称（name）
    function testName() public view {
        assertEq(counter.name(), "AESToken");
    }

    // 2、 测试ERC20合约发布的代币的符号（symbol）
    function testSymbol() public view {
        assertEq(counter.symbol(),"ATK");
    }

    // 3、测试ERC20合约发布的代币的精确值（decimals）
    function testDecimals() public view {
        assertEq(counter.decimals(), 18);
    }

    // 4、 测试ERC20合约发布的代币的总发行量（TotalSupply）
    function testTotalSupply() public view {
        assertEq(counter.totalSupply(), 1000000 * (10 ** 18));
    }
    
    // 获取钱包余额
    
    // 5、(1)测试不同账户余额为0的情况

    function testBalanceof1() public {
        address user1 = address(0x234);
        assertEq(counter.balanceOf(user1), 0);
        address user2 = address(0x456);
        assertEq(counter.balanceOf(user2), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
    }


    // 6、（2）测试为不同账户新铸造不为0的货币数量并查询余额

    function testBalanceof2() public {
        address user1 = address(0x234);
        assertEq(counter.balanceOf(user1), 0);
        address user2 = address(0x456);
        assertEq(counter.balanceOf(user2), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        assertEq(counter.totalSupply(), 1000300 * (10 ** 18)); //测试再给两个账户新铸造代币后 总代币的数量
    }

    // 7、 （3）测试为余额不为0的账户铸造0个货币并查询余额

    function testBalanceof3() public {
        address user1 = address(0x3456);
        assertEq(counter.balanceOf(user1), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 8));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 8));
        vm.prank(owner);
        counter.mint(user1, 0);
        assertEq(counter.balanceOf(user1), 100 * (10 ** 8));
    }

    // ERC20的转账 

    // 8、 (1) 转账不为0的情况 user2 -> user1

    function testTransfer1() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(user2);
        counter.transfer(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 100 * (10 ** 18));
    }

    // 9、（2）转账为0的情况 user2 -> user1

    function testTransfer2() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(user2);
        counter.transfer(user1, 0);
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
    }
    
    // ERC20的授权转账

    // 10、 (1)查询授权金额数量不为0 allowance
    function testAllowance1() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        address user3 = address(0x6789);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        assertEq(counter.balanceOf(user3), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user3, 300 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 300 * (10 ** 18));
        vm.prank(user1);
        counter.approve(user2, 50 * (10 ** 18));
        assertEq(counter.allowance(user1, user2), 50 * (10 ** 18));
    }

    // 11、（2）授权金额数量为0 查询 allowance

    function testAllowance2() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        address user3 = address(0x6789);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        assertEq(counter.balanceOf(user3), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user3, 300 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 300 * (10 ** 18));
        vm.prank(user1);
        counter.approve(user2, 0);
        assertEq(counter.allowance(user1, user2), 0);
    }

    // 12、 (3)授权转账金额不为0结果查询 transferFrom

    function testAllowance3() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        address user3 = address(0x6789);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        assertEq(counter.balanceOf(user3), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user3, 300 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 300 * (10 ** 18));
        vm.prank(user1);
        counter.approve(user2, 50 * (10 ** 18));
        assertEq(counter.allowance(user1, user2), 50 * (10 ** 18));
        vm.prank(user2);
        counter.transferFrom(user1, user3, 50 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 50 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 350 * (10 ** 18));
    }

    // 13、 授权转账金额为0结果查询 tranferFrom

    function testAllowance4() public {
        address user1 = address(0x3456);
        address user2 = address(0x4567);
        address user3 = address(0x6789);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        assertEq(counter.balanceOf(user3), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user2, 200 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 200 * (10 ** 18));
        vm.prank(owner);
        counter.mint(user3, 300 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 300 * (10 ** 18));
        vm.prank(user1);
        counter.approve(user2, 0 * (10 ** 18));
        assertEq(counter.allowance(user1, user2), 0 * (10 ** 18));
        vm.prank(user2);
        counter.transferFrom(user1, user3, 0);
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        assertEq(counter.balanceOf(user3), 300 * (10 ** 18));
    }

  // 安全测试

  // （1）和转账有关的安全测试

  // 14、账户余额为0时进行金额大于0的转账
  
      function testSecurityTransfer1() public {
        address user1 = address(0x234);
        address user2 = address(0x456);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);        
        // user2的余额为0，尝试转账100个代币给user1
        vm.prank(user2);
        vm.expectRevert("Account Balance Not Enough!");
        counter.transfer(user1, 100 * (10 ** 18));
        // 验证余额未变化
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
    }

  // 15、转账的金额超过账户余额

      function testSecurityTransfer2() public {
        address user1 = address(0x234);
        address user2 = address(0x456);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        vm.prank(user1);
        vm.expectRevert("Account Balance Not Enough!");
        counter.transfer(user2, 200 * (10 ** 18));
        // 验证余额未变化
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
        assertEq(counter.balanceOf(user2), 0);
    }

  // 16、转账的金额超过货币的总发行量

      function testSecurityTransfer3() public {
        address user1 = address(0x234);
        address user2 = address(0x456);
        vm.prank(user1);
        vm.expectRevert("Account Balance Not Enough!");
        counter.transfer(user2, 2000000 * (10 ** 18));
        // 验证余额未变化
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user2), 0);
    }

  // 17、转账0元

      function testSecurityTransfer4() public {
        address user1 = address(0x234);
        address user2 = address(0x456);
        vm.prank(user1);
        counter.transfer(user2, 0);
        assertEq(counter.balanceOf(user1), 0);
        assertEq(counter.balanceOf(user1), 0);
    }

  // 18、给自己转账

      function testSecurityTransfer5() public {
        address user1 = address(0x234);
        vm.prank(owner);
        counter.mint(user1, 100 * (10 ** 18));
        vm.prank(user1);
        counter.transfer(user1, 50 * (10 ** 18));
        assertEq(counter.balanceOf(user1), 100 * (10 ** 18));
    }
  
}
