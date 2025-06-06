# 基于OpenZeppelin/Contracts的ERC-20智能合约编写
## <font color = "blue">1. 了解ERC-20智能合约</font> 
### 1.1 ERC-20标准核心要素
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // 状态变量
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    
    // 转账函数
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    // 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
```
### 1.2 标准功能说明
|  功能组件     | 作用        |
| ----------- | ----------- |
| totalSupply | 代币总供应量  |
| balanceOf   | 查询账户余额 |
| transfer    | 直接转账     |
| allowance   |查询授权额度余额  |
|approve      | 授权账户额度   |
|tranferFrom | 授权转账      |

## <font color = "blue">2. 了解OpenZeppelin/Contracts</font>
OpenZeppelin/Contracts 是一个用于安全智能合约开发的库。
它提供了 ERC20、 ERC721、ERC777、ERC1155 等标准的实现，还提供 Solidity 组件来构建自定义合同和更复杂的分散系统。
### 2.1 安装合约库
```bash
# 安装最新版合约库
forge install OpenZeppelin/openzeppelin-contracts
```
###  2.2 核心安全特性
- 审计保障​：经过专业安全团队审核
- ​模块化设计​：支持按需引入扩展
- ​防御性编程​：内置重入攻击防护等机制
## <font color = "blue">3. 使用OpenZeppelin/Contracts</font>
###  3.1 基础合约继承
``` bash
#这是一个继承了Openzeppelin-ERC-20库的最基础的ERC-20智能合约
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") 
    {}
}
# Token在该智能合约中的定义：
# name = “MyToken“
# symbol = "MTK"
# 该合约可以调用的功能： 
totalSupply(),
balanceOf(address account),
allowance(address owner, address spender) ,
approve(address spender, uint256 amount),
transferFrom(address sender, address recipient, uint256 amount) 
```
### 3.2 拓展合约功能——基于OpenZeppelin的模块化扩展
OpenZeppelin 提供了丰富的标准化扩展模块（如访问控制、铸造/销毁、费用机制等），可帮助开发者快速为 ERC-20 代币添加复杂功能。以下是常见扩展场景的实现方案：
#### 3.2.1 访问控制：限制关键操作权限
- ​需求场景​：仅允许合约管理员（如项目方）执行铸造（Mint）、销毁（Burn）或修改代币参数（如费率）等关键操作。
- ​实现方案​：使用 OpenZeppelin 的 AccessControl 模块，通过角色（Role）管理权限。
```bash
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {DefaultAdminRules} from "@openzeppelin/contracts/access/DefaultAdminRules.sol"; // 可选：简化管理员管理

contract AdvancedToken is ERC20, ERC20Permit, AccessControl {
    // 定义角色：ADMIN_ROLE 为管理员（可自定义角色名）
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    constructor() 
        ERC20("AdvancedToken", "ADVT") 
        ERC20Permit("AdvancedToken")
        DefaultAdminRules() // 自动设置部署者为初始管理员（可选）
    {
        // 授予部署者 ADMIN_ROLE（若未使用 DefaultAdminRules）
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    // 仅管理员可调用：铸造新代币
    function mint(address to, uint256 amount) external onlyRole(ADMIN_ROLE) {
        _mint(to, amount);
    }

    // 仅管理员可调用：销毁代币（需先授权）
    function burn(address from, uint256 amount) external onlyRole(ADMIN_ROLE) {
        _burn(from, amount);
    }

    // 重写 transfer 函数（可选）：添加额外逻辑（如日志）
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        emit TransferWithLog(msg.sender, recipient, amount); // 自定义事件
        return super.transfer(recipient, amount);
    }

    // 自定义事件（记录带日志的转账）
    event TransferWithLog(address indexed from, address indexed to, uint256 value);
}
```
#### 3.2.2 其它合约功能拓展
详见[Openzeppelin-ERC20-合约功能拓展](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20)
### 3.3 Foundry开发工具介绍
#### 3.3.1  安装指南
##### <font color = "brown">(1) 系统要求</font>
- ​**操作系统**: macOS、Linux 或 Windows(WSL/Git Bash)
- ​**依赖工具**: Git、Rust (≥1.68.0) 和 Cargo
- ​**磁盘空间**: 至少 2GB 可用空间

##### <font color = "brown">(2) 安装方法</font>
1. **通用安装脚本**
```bash
# 下载安装Foundry
curl -L https://foundry.paradigm.xyz | bash

# 将Foundry更新到最新版本
foundryup
```
2. **特定平台安装**
- macOS (Homebrew)
```bash
# 下载安装Foundry
brew install foundry

# 将Foundry更新到最新版本
foundryup
```
- Windows (WSL/Git Bash)

如果您使用的是 Windows，则需要安装并使用[Git BASH](https://gitforwindows.org/)或[WSL](https://learn.microsoft.com/en-us/windows/wsl/install)作为您的终端，因为 Foundryup 目前不支持 Powershell 或命令提示符 (Cmd)
```bash
在安装好Git Bash或WSL后，在终端中输入以下指令安装Foundry：
# 下载安装Foundry
curl -L https://foundry.paradigm.xyz | bash

# 将Foundry更新到最新版本
foundryup
```
3. **验证安装**
```bash
forge --version       # 示例输出: forge 1.2.2-stable
cast --version        # 示例输出: cast 1.2.2-stable
anvil --version       # 示例输出: anvil 1.2.2-Homebrew
chisel --version       # 示例输出: chisel 1.2.2-Homebrew
```
4. **更新安装**
```bash
# 更新到最新稳定版
foundryup

# 更新到nightly开发版
foundryup -v nightly
```
#### 3.3.2 核心工具
|  工具        | 功能定位        | 典型使用场景           |
| ----------- | -----------    | -----------          |
| forge       | 构建系统+测试框架 |forge build/forge test|
| cast        | 链上数据查询工具  | cast call/cast send  |
| anvil       |本地测试链模拟器   | anvil --fork         |
| chisel      |合约分析工具      |chisel analyze        |

#### 3.3.3 Cheatcodes
1. **常见虚拟机控制指令**
- 账户模拟
```bash
// 模拟账户操作
vm.prank(address(0x123)); // 切换msg.sender
```
- 期望验证
```bash
// 账户余额不足时验证错误信息是否正确返回
vm.prank(user1);
vm.expectRevert("Approve Account Balance Not Enough!");
counter.approve(user2, 150 * (10 ** 18));
```
2. **更多虚拟机控制指令**
- 详见[Foundry Cheatcodes Reference](https://getfoundry.sh/reference/cheatcodes/overview)
## <font color = "blue">4. 初始化ERC-20智能合约</font>
在了解上述有关ERC-20智能合约的背景知识后, 接下来是实操的部分：
**利用Foundry工具对编写的ERC-20合约进行构建、测试。**
### 4.1 构建(Build)
目标​：使用 Foundry 的 forge build 命令编译 ERC-20 合约，生成可部署的字节码和 ABI。
#### 4.1.1 项目结构准备
在开始构建前，需按照 Foundry 的标准项目结构组织代码，确保编译器能正确识别依赖和合约。推荐结构如下：
```bash
my-token-project/
├── src/                # 核心合约代码
│   ├── MyToken.sol     # ERC-20 主合约（继承 OpenZeppelin）
│   └── interfaces/     # 自定义接口（可选）
│       └── IMyToken.sol
├── test/               # 测试文件
│   ├── MyToken.t.sol   # 功能测试
│   └── utils/          # 测试工具（如 Fixture）
├── foundry.toml        # Foundry 配置文件（可选）
└── script/             # 部署/交互脚本（可选）
    └── deploy.ts       # 部署脚本（TypeScript）
```
#### 4.1.2 编写合约代码
以基础的 MyToken 合约为例（继承 OpenZeppelin 的 ERC20 和 ERC20Permit）：
```bash
// src/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}
}
```
#### 4.1.3 执行构建命令
在项目根目录运行以下命令，触发 Foundry 编译合约：
```bash
forge build

# 输出：
[⠊] Compiling...
[⠘] Compiling 23 files with Solc 0.8.29
[⠃] Solc 0.8.29 finished in 1.77s
Compiler run successful!
# 输出说明​：
编译成功后，生成的字节码和 ABI 会存储在 out/ 目录下（如 out/MyToken.sol/MyToken.json）。
输出日志会显示编译耗时、依赖版本等信息（如 Compiled 2 contracts (0.2s)）。
```
#### 4.1.4 常见构建问题与解决
|  问题现象           | 可能原因        | 解决方案           |
| -----------         | -----------    | -----------          |
| cannot find module| 未正确安装 OpenZeppelin 合约库 |运行 forge install OpenZeppelin/openzeppelin-contracts 安装依赖|
| TypeError: Invalid type       | Solidity 版本不兼容（如合约用 ^0.8.0，依赖用 0.8.20）  | 统一版本（如将合约 pragma 改为 ^0.8.20）  |
| Compilation failed      |代码语法错误（如缺少分号、括号不匹配）   | 检查合约代码，使用 Solhint 等工具校验语法         |
### 4.2 测试(Test)
目标​：使用 Foundry 的 forge test 命令验证合约功能，确保符合 ERC-20 标准且扩展逻辑正确。
#### 4.2.1 测试Openzeppelin内置测试用例
在初始化ERC-20Openzeppelin/Contracts 项目后, Openzappelin初始化自带的测试可在 test目录下找到MyERC20.t.sol，接下来输入以下指令，对内置测试用例进行测试：
``` bash
cd test
forge build
forge test
# 输出：
[⠊] Compiling...
No files changed, compilation skipped

Ran 2 tests for src/test/MyERC20.t.sol:WhenAliceHasInsufficientFunds
[PASS] testCannotTransferMoreThanAvailable() (gas: 15575)
[PASS] testCannotTransferToZero() (gas: 11150)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 12.37ms (2.63ms CPU time)

Ran 6 tests for src/test/MyERC20.t.sol:WhenAliceHasSufficientFunds
[PASS] testFindMapping() (gas: 143735)
[PASS] testTransferAllTokens() (gas: 37617)
[PASS] testTransferHalfTokens() (gas: 42619)
[PASS] testTransferOneToken() (gas: 40294)
[PASS] testTransferWithFuzzing(uint64) (runs: 256, μ: 43417, ~: 43417)
[PASS] testTransferWithMockedCall() (gas: 13363)
Suite result: ok. 6 passed; 0 failed; 0 skipped; finished in 34.85ms (30.49ms CPU time)

Ran 2 test suites in 399.22ms (47.22ms CPU time): 8 tests passed, 0 failed, 0 skipped (8 total tests)
```
#### 4.2.2 拓展测试用例
在 src/test/MyToken.t.sol 中拓展测试，覆盖 ERC-20 核心功能及扩展逻辑（如访问控制）：
##### <font color = "brown">(1)对拓展功能的测试</font>
可以使用CheatCodes(vm.prank(address))来模拟msg.sender（调用函数的人），从而判断自己的合约能否识别edge cases, 并且返回正确的错误信息(vm.expectRevert(" "))，测试用例如下：
```bash
// 1、转账的金额超过账户余额

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

// 2、非合约部署者铸造代币
    function testNotOwnerMint() public {
        address user1 = address(0x234);
        vm.prank(user1);
        vm.expectRevert("Only Owner Can Mint");
        counter.mint(user1, 100 * (10 ** 18));
    }
```
#### 4.2.3 高级测试技巧
- ​过滤测试用例​：使用 --match-contract 或 --match-test 运行特定测试：
``` bash
forge test --match-contract MyToken   # 仅运行 MyToken 合约的测试
forge test --match-test testTransfer  # 仅运行 testTransfer 测试
```
- ​使用 Fixture​：通过 setUp() 复用初始化逻辑，减少重复代码（如预铸造代币）。
- ​模拟时间​：使用 vm.warp(block.timestamp + 1 days) 测试时间相关的功能（如锁定期）。
### 4.3 其它工具
在上面对ERC-20的合约的操作中我们主要使用了forge中的forge build 和 forge test来编译和测试合约。
以下是Foundry中常见的工具介绍以及使用用例：





