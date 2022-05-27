// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 可以通过声明接口来调用其他合约。
 * 接口需要：不能实现任何功能、可以从其他接口继承、所有声明的函数必须是外部的、不能声明构造函数、不能声明状态变量
 * 只要某个合约中有和接口相同的函数声明，就可以被该合约接受。
 * 代码来源：https://solidity-by-example.org/interface
 */
interface ICounter {
    // 接口中只能有函数声明，不能有函数实现
    function count() external view returns (uint);
    function increment() external;
}

// 这个合约的外部函数在接口{ICounter}中都有声明
contract Counter {
    uint public count;
    function increment() external {
        count += 1;
    }
}

// 可以利用接口{ICounter}来操作{Counter}合约
contract TestCounter {
    // 可以通过传入合约{Counter}的地址，来调用{Counter}合约
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}

// 接口可以继承其他接口
interface ICounterNew is ICounter {
    function decrement() external;
}

/**
 * 合约也可以继承接口，但是要实现全部函数。
 * 可以理解为继承了一个全部函数都没有实现的{abstract contract}
 */
contract CounterNew is ICounterNew {
    uint public count;
    function increment() external override {
        count += 1;
    }
    function decrement() external override {
        count -= 1;
    }
}

/**
 * 库类似于合约，但你不能声明任何状态变量，也不能发送以太币。
 * 如果所有库函数都是内部的，则将库嵌入到合约中。否则，必须先部署库，然后在部署合约之前进行链接。
 * 库是一段孤立的源代码，它只能访问调用合约的状态变量(msg.sender等)。
 * 代码来源：https://docs.soliditylang.org/en/v0.8.13/contracts.html#using-for
 */
 library Search {
    // 获取一个值在数组中的位置
    function indexOf(uint[] storage self, uint value) public view returns (uint) {
        for (uint i = 0; i < self.length; i++)
            if (self[i] == value) return i;
        return type(uint).max;
    }
}

contract TestSearch {
    /**
    * {using for}可以成员函数附加到任何类型，使该类型拥有新功能。
    * 这里使{uint[]}拥有{indexOf}功能
    */
    using Search for uint[];
    uint[] data;

    function append(uint value) public {
        data.push(value);
    }

    function replace(uint _old, uint _new) public {
        // 执行库{Search}中的函数调用{indexOf}
        // Search.indexOf(data, _old) 与 data.indexOf(_old) 是一样的
        uint index = data.indexOf(_old);
        if (index == type(uint).max)
            data.push(_new);
        else
            data[index] = _new;
    }
}

/**
* {using for}可以声明在合约外，也可以附加到自定义类型上
* 并且可以使用 { } 来单独将函数附加到类型上
* 代码来源：https://docs.soliditylang.org/en/v0.8.13/contracts.html#using-for
*/
using {insert, remove, contains} for Data;

// 自定义{Data}类型
struct Data {
    mapping(uint => bool) flags;
}

function insert(Data storage self, uint value) returns (bool) {
    if (self.flags[value])
        return false;
    self.flags[value] = true;
    return true;
}

function remove(Data storage self, uint value) returns (bool) {
    if (!self.flags[value])
        return false;
    self.flags[value] = false;
    return true;
}

function contains(Data storage self, uint value) view returns (bool) {
    return self.flags[value];
}

contract TestData {
    Data knownValues;
    // 若不报错，则注册成功
    function register(uint value) public {
        require(knownValues.insert(value));
    }
}
