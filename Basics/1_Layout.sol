/**
 * 开源协议，详细见：https://docs.soliditylang.org/en/v0.8.11/layout-of-source-files.html#spdx-license-identifier
 */
// SPDX-License-Identifier: MIT

/**
 * 编译器版本必须大于等于0.8.13，并且小于0.9.0。^指定了小于0.9.0的条件
 * 另一种写法：`pragma solidity >=0.8.13 <0.9.0;`
 */
pragma solidity ^0.8.13;


/**
 * 导入其他源文件，可以有很多方式。可以直接导入、链接导入等等...
 * 具体导入路径解析：https://docs.soliditylang.org/en/v0.8.11/path-resolution.html
 */
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title 概述合约
 * @author Araqi
 * @notice 向最终用户解释合约这是做什么的
 * @dev 向开发人员解释合约的细节
 */
contract HelloWorld {
    /// @dev 状态变量介绍
    string public greet = "Hello World!";

    /**
     * @notice 给最终用户的函数介绍
     * @dev 给开发人员的函数介绍
     * @param _greet 将要赋值给状态变量`greet`的输入参数
     * @return ......
     *
     * Requirements:
     *
     * - 对于函数的输入的要求细节
     * - ......
     */
    function setGreet(string memory _greet) public {
        greet = _greet;
    }
}

// 单行注释

/*
多行注释
多行注释
*/

/// NatSpec单行注释

/**
 * NatSpec多行注释
 * NatSpec多行注释
 */
