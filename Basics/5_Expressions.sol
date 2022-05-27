// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


// 介绍一些solidity中的单位、全局变量、通用函数、控制结构和表达式等
contract Expressions {
    /**
    * 数字可以采用后缀{wei}、{gwei}或{ether}指定Ether面额。
    * 其中不带后缀的{ether}数字被假定为{wei}。
    */
    bool public isOneWei = 1 wei == 1;
    bool public isOneEther = 1 ether == 1e18;

    // 数字也可以采用后缀{seconds}、{minutes}、{hours}、{days}和{weeks}
    bool public isOneSecond = 1 seconds == 1;
    bool public isOneMinute = 1 minutes == 60 seconds;

    /**
    * 与区块和交易相关, 更多见：
    *  - https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html#block-and-transaction-properties
    */
    uint gasLimit = block.gaslimit; // 当前Gas费最大限制
    address owner = msg.sender; // 消息的发送者
    uint gasPrice = tx.gasprice; // 当前交易的Gas费

    /**
    * 拼接函数：{string.concat}和{bytes.concat}
    * 拼接前要保证类型一致，如果参数为空那么返回空数组。
    */
    string s = "abc";
    function concat(bytes calldata bc, string memory sm) public view returns (string memory){
        string memory concatString = string.concat(s, string(bc), "DEF", sm);
        return concatString;
    }

    /**
    * 错误处理，错误将撤消事务期间对状态所做的所有更改。
    * {assert} 用于检查不应该为假的代码。断言失败可能意味着存在错误。
    * {require} 用于在执行前验证输入和条件。
    * {revert} 类似于 {require}。
    */
    function errorHandling(uint _i) public pure {
        assert(1 == 1 wei);
        require(_i > 10, "Input must be greater than 10");
        if (_i <= 15) {
            revert("Input must be greater than 15");
        }
    }

    /**
    * 一些基础数学函数和密码学函数
    *  - https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html#mathematical-and-cryptographic-functions
    */
    uint public modVal = addmod(2, 3, 4); // 计算(x + y) % k
    bytes32 public hashVal = keccak256("abc"); // 计算Keccak-256哈希值

    /**
    * 地址类型的成员，地址可以获取一些与该地址相关的信息。
    * {payable} 类型的地址会额外有 {transfer} 和 {send}
    *  - https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html#members-of-address-types
    */
    address testOwner = msg.sender;
    uint public balanceOfOwner = testOwner.balance;

    /// @dev 存Ether到合约中
    function deposit() external payable {}

    /// @dev 从合约中提取Ether
    function withdraw(uint _amount) public {
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Failed to withdraw");
    }

    /**
    * 合约相关：{this}指向当前合约
    *  - https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html#contract-related
    */
    function balanceOfContract() public view returns (uint256) {
        return address(this).balance;
    }

    /**
    * 控制结构：
    * 与大多数语言一样，存在{if}、{else}、{while}、{do}、{for}、{break}、{continue}、{return}这些关键字，语法与C语言或JavaScript是一样的。
    * 但是类似 if (1) { ... } 的使用方式是不允许的。
    * 存在 {try/catch} 关键字，但是只能在外部函数调用和合约创建调用时使用
    */
    function doSomething(uint _a, uint[] memory _b) public view returns (uint) {
        for (uint i = 0; i < _b.length; i++) {
            if (_b[i] == _a) {
                return _a;
            }
        }
        return 0;
    }

    mapping(uint => uint) data;

    // 函数调用的时候，可以使用 { } 来给出变量名称。
    function setData() public {
        // 可以按照python字典的方式调用函数
        set({value: 2, key: 3});
    }

    function set(uint key, uint value) public {
        data[key] = value;
    }

    /**
    * 函数调用允许以元组的形式返回多个参数，也允许解构多个函数返回值。
    * 但是元组在solidity中不是一种合法的类型，它只能用于形成表达式的句法分组。
    */
    uint index;

    function multiReturn() public pure returns (uint, bool, uint) {
        return (7, true, 2);
    }

    function multiAssign() public {
        // 可以返回给新声明的变量，可以不匹配所有返回值，但是要匹配返回值的个数。
        (uint x, , uint y) = f();
        // 也可以返回值给已经声明的变量
        (index, , ) = f();
        // 一个简单的交换值的方式
        (x, y) = (y, x);
    }

    // {unchecked} 取消代码块中的上溢下溢检查，可以节省Gas费，但是要谨慎使用。
    function unCheck(uint[] memory arr) public pure {
        uint256 length = arr.length;
        // 标准的循环
        for(uint256 i = 0; i < length; i++) {
        }
        // uncheck {i++} 的循环
        for(uint256 i = 0; i < length;) {
            unchecked{ i++; }
        }
    }
}
