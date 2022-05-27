// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * Solidity中可以嵌入内联汇编的语言Yul，一种更低级的更接近机器的语言。
 * 更多详细的Yul语法可见：https://docs.soliditylang.org/en/v0.8.13/yul.html
 * 主要有以下几个优势：
 *  1.可以使用操作码直接与EVM进行交互，这使的可以对程序智能合约要执行的操作进行更精细控制。
 *  2.在完成相同功能的前提下，会消耗更少的Gas。
 *  3.可以完成一些Solidity中无法实现的功能。详细见：https://ethereum.stackexchange.com/a/3174
 */
contract Assembly {

    function example(uint _x) public pure returns (uint) {
        // assembly{} 来嵌入汇编代码段，并且不同代码块中不能通信
        assembly {
            // {let}实际上创建一个新的堆栈槽位，为变量保留该槽位，并且当到达代码块结束时自动销毁该槽位。
            // 在Yul中，使用{let}关键字定义变量。赋值符号为{:=}。
            let a := 10

            // 可以使用函数的局部变量
            let x := _x

            // 可以使用表达式来赋值
            let y := add(x, 3)

            // Yul中没有类型的说法，可以认为都是{uint}类型，并且不能超过32个字节。字符串也不能超过32。
            let z := "hello world"

            // 这个代码块结束的时候`m`就会被销毁
            {
                let m := x
            }

            // 循环的格式{lt}操作码代表 i < y
            for { let i := 0 } lt(i, y) { i := add(i, 1) } {
                x := mul(2, x)
            }

            // 判断的格式{eq}操作码代表 x == 0
            if eq(x, 0) {
                x := add(x, 2)
            }

            // 函数定义格式
            function assembly_function(param) -> result {
                result := add(param, 5)
            }

            // 调用函数
            x := assembly_function(x)
            mstore(0x0, x)
            return(0x0, 32)
        }
    }

    // 这里的 addAssembly() 会比下面的 add() 消耗更少的Gas
    function addAssembly(uint x, uint y) public pure returns (uint) {
        assembly {
            // 使用 {add} 操作码计算 x + y，并且存入`result`
            let result := add(x, y)
            // 使用 {mstore} 操作码将`result`存到内存中的 0x0 地址
            mstore(0x0, result)
            // 从内存的 0x0 地址返回32个字节
            return(0x0, 32)
        }
    }

    // Solidity的 add()
    function add(uint x, uint y) public pure returns (uint) {
        return x + y;
    }
}
