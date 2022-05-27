// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// 要被调用的合约
contract CallBase {
    uint public x;
    uint public balance;

    function setX(uint _x) public {
        x = _x;
    }

    function sendEther(uint _x) public payable {
        x = _x;
        balance = msg.value;
    }

    function add(uint _a, uint _b) public view returns (uint) {
        return _a + _b + x;
    }
}

/**
 * 有两种方法可以合约可以调用其他合约。最简单的方法就是直接调用它。
 * 代码参考：https://solidity-by-example.org/calling-contract
 */
contract CallDirectly {
    // 这里`_callbase`传入的是合约的地址
    function setX(CallBase _callbase, uint _x) public {
        _callbase.setX(_x);
    }
    // 调用的时候也可以传入Ether
    function sendEther(CallBase _callbase, uint _x) public payable {
        _callbase.sendEther{value: msg.value}(_x);
    }
}

/**
 * 第二种调用其他合约的方式是{call}。主要是为了与不遵守ABI的合约(不知道源码的合约)交互，或者更直接地控制编码。
 * address 类型有三种不同call函数：{call}、{delegatecall}和{staticcall}
 * 所有这些函数都是低级函数，应谨慎使用。任何未知的合约都可能是恶意的，我们在调用一个合约的同时就将控制权交给了它。
 */
contract CallLowLevel {
    // 通过{call}的方式调用{CallBase}合约
    function callSetX(address _contract, uint _x) public {
        /**
        * 在调用函数时，传入{call}函数的前4个字节叫做函数选择器，根据这个4个字节确定调用哪个函数。也就是 abi.encodeWithSignature(...) 返回的前4个字节。
        * 所以 abi.encodeWithSignature(string memory signature, ...) 与 abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...) 是等价的
        */
        (bool success, ) = _contract.call(abi.encodeWithSignature("setX(uint256)", _x));
        require(success);
    }
    // 通过{call}的方式调用的时候也可以传入Ether，同时可以指定gas费
    function callSendEther(address _contract, uint _x, uint _gas) public payable {
        (bool success, ) = _contract.call{value: msg.value, gas: _gas}(abi.encodeWithSignature("sendEther(uint256)", _x));
        require(success);
    }

    /**
    * {delegatecall}与{call}的语法完全相同。
    * {delegatecall}与{call}的不同点在于，提供自己合约{CallLowLevel}的存储、余额和地址提供给函数。
    * 也就是将合约{CallBase}中的函数用作库代码，并且把该函数将像合约{CallLowLevel}本身的函数一样运行。
    * {delegatecall}不接受`value`选项，但可以接受`gas`选项。通常用于可升级合约。
    * 下面的调用，会改变 CallLowLevel.x()，而不会改变 CallBase.x()
    */
    uint public x;
    function delegatecallSetX(address _contract, uint _x) public {
        (bool success, ) = _contract.delegatecall(abi.encodeWithSignature("setX(uint256)", _x));
        require(success);
    }

    /**
    * {staticcall}与{call}的用法基本相同，但是要求调用的合约函数需要是{view}或{pure}类型的。
    * 也就是 CallBase.add(uint, uint) 函数不能修改{CallBase}的状态变量。
    */
    function staticcallAdd(address _contract, uint _a, uint _b) public view returns (uint) {
        (bool success, bytes memory data) = _contract.staticcall(abi.encodeWithSignature("add(uint256,uint256)", _a, _b));
        require(success);
        // {bytes} 转 {uint}
        return abi.decode(data, (uint));
    }
}
