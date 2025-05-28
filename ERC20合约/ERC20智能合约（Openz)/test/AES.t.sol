// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {AES} from "src/AES.sol";

contract AESTest is Test {
  AES public instance;
  address owner = address(0x1234);
  function setUp() public {
    instance = new AES(owner);
  }

  // 基本信息

  // 1、 测试ERC20合约发布的代币的名称（name）
  function testName() public view {
    assertEq(instance.name(), "AES");
  }

  // 2、 测试ERC20合约发布的代币的符号（symbol）
  function testSymbol() public view {
    assertEq(instance.symbol(),"ATK");
  }

  // 3、测试ERC20合约发布的代币的精确值（decimals）
  function testDecimals() public view{
    assertEq(instance.decimals(), 18);
  }

  // 4、 测试ERC20合约发布的代币的总发行量（TotalSupply）
  function testTotalSupply() public view{
    assertEq(instance.totalSupply(), 1000000 * (10 ** 18));
  }
  
  // 获取钱包余额
  
  // 5、(1)测试不同账户余额为0的情况

  function testBalanceof1() public {
    address user1 = address(0x234);
    assertEq(instance.balanceOf(owner), 1000000 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 0);
    address user2 = address(0x456);
    assertEq(instance.balanceOf(user2), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
  }


  // 6、（2）测试为不同账户新铸造不为0的货币数量并查询余额

  function testBalanceof2() public {
    address user1 = address(0x234);
    assertEq(instance.balanceOf(user1), 0);
    address user2 = address(0x456);
    assertEq(instance.balanceOf(user2), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    assertEq(instance.totalSupply(), 1000300 * (10 ** 18)); //测试再给两个账户新铸造代币后 总代币的数量
  }

  // 7、 （3）测试为余额不为0的账户铸造0个货币并查询余额

  function testBalanceof3() public {
    address user1 = address(0x3456);
    assertEq(instance.balanceOf(user1), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 8));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 8));
    vm.prank(owner);
    instance.mint(user1, 0);
    assertEq(instance.balanceOf(user1), 100 * (10 ** 8));
  }

  // ERC20的转账 

  // 8、 (1) 转账不为0的情况 user2 -> user1

  function testTransfer1() public {
    address user1 = address(0x3456);
    address user2 = address(0x4567);
    assertEq(instance.balanceOf(user1), 0);
    assertEq(instance.balanceOf(user2), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    vm.prank(user2);
    instance.transfer(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 100 * (10 ** 18));
  }

  // 9、（2）转账为0的情况 user2 -> user1

  function testTransfer2() public {
    address user1 = address(0x3456);
    address user2 = address(0x4567);
    assertEq(instance.balanceOf(user1), 0);
    assertEq(instance.balanceOf(user2), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    vm.prank(user2);
    instance.transfer(user1, 0);
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
  }
   
  // ERC20的授权转账

  // 10、 (1)查询授权金额数量不为0 allowance
  function testAllowance1() public {
    address user1 = address(0x3456);
    address user2 = address(0x4567);
    address user3 = address(0x6789);
    assertEq(instance.balanceOf(user1), 0);
    assertEq(instance.balanceOf(user2), 0);
    assertEq(instance.balanceOf(user3), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user3, 300 * (10 ** 18));
    assertEq(instance.balanceOf(user3), 300 * (10 ** 18));
    vm.prank(user1);
    instance.approve(user2, 50 * (10 ** 18));
    assertEq(instance.allowance(user1, user2), 50 * (10 ** 18));
  }

  // 11、（2）授权金额数量为0 查询 allowance

  function testAllowance2() public {
    address user1 = address(0x3456);
    address user2 = address(0x4567);
    address user3 = address(0x6789);
    assertEq(instance.balanceOf(user1), 0);
    assertEq(instance.balanceOf(user2), 0);
    assertEq(instance.balanceOf(user3), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user3, 300 * (10 ** 18));
    assertEq(instance.balanceOf(user3), 300 * (10 ** 18));
    vm.prank(user1);
    instance.approve(user2, 0);
    assertEq(instance.allowance(user1, user2), 0);
  }

  // 12、 (3)授权转账金额不为0结果查询 transferFrom

    function testAllowance3() public {
      address user1 = address(0x3456);
      address user2 = address(0x4567);
      address user3 = address(0x6789);
      assertEq(instance.balanceOf(user1), 0);
      assertEq(instance.balanceOf(user2), 0);
      assertEq(instance.balanceOf(user3), 0);
      vm.prank(owner);
      instance.mint(user1, 100 * (10 ** 18));
      assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
      vm.prank(owner);
      instance.mint(user2, 200 * (10 ** 18));
      assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
      vm.prank(owner);
      instance.mint(user3, 300 * (10 ** 18));
      assertEq(instance.balanceOf(user3), 300 * (10 ** 18));
      vm.prank(user1);
      instance.approve(user2, 50 * (10 ** 18));
      assertEq(instance.allowance(user1, user2), 50 * (10 ** 18));
      vm.prank(user2);
      instance.transferFrom(user1, user3, 50 * (10 ** 18));
      assertEq(instance.balanceOf(user1), 50 * (10 ** 18));
      assertEq(instance.balanceOf(user3), 350 * (10 ** 18));
    }

  // 13、 授权转账金额为0结果查询 tranferFrom

  function testAllowance4() public {
    address user1 = address(0x3456);
    address user2 = address(0x4567);
    address user3 = address(0x6789);
    assertEq(instance.balanceOf(user1), 0);
    assertEq(instance.balanceOf(user2), 0);
    assertEq(instance.balanceOf(user3), 0);
    vm.prank(owner);
    instance.mint(user1, 100 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user2, 200 * (10 ** 18));
    assertEq(instance.balanceOf(user2), 200 * (10 ** 18));
    vm.prank(owner);
    instance.mint(user3, 300 * (10 ** 18));
    assertEq(instance.balanceOf(user3), 300 * (10 ** 18));
    vm.prank(user1);
    instance.approve(user2, 0 * (10 ** 18));
    assertEq(instance.allowance(user1, user2), 0 * (10 ** 18));
    vm.prank(user2);
    instance.transferFrom(user1, user3, 0 * (10 ** 18));
    assertEq(instance.balanceOf(user1), 100 * (10 ** 18));
    assertEq(instance.balanceOf(user3), 300 * (10 ** 18));
  }

}