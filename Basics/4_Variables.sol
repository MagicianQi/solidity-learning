// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 变量可以按照以下方式区分：
 *  - 按照可改变性分为：默认、{constant}、{immutable}
 *  - 按照访问限制分为：{public}、{private}、{internal}
 *  - 按照作用范围分为：状态变量、局部变量、全局变量
 *  - 按照存储位置分为：{storage}、{memory}、{calldata}
 */
contract Variables {
    /**
    * {constant} 代表改变量是常量，不可更改
    * 它们的值是硬编码的，使用常量可以节省 gas 成本。
    * 常量在命名时，为了方便区分，通常使用全大写。
    */
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint public constant MY_UINT = 123;

    /**
    * {immutable}不可变变量就像常量。
    * 不可变变量的值可以在构造函数中设置，但之后不能修改。
    */
    address public immutable MY_IMM_ADDRESS;
    uint public immutable MY_IMM_UINT;

    // 构造函数，在部署合约的时候传参
    constructor(uint _myImmUint) {
        MY_IMM_ADDRESS = msg.sender;
        MY_IMM_UINT = _myImmUint;
    }

    /**
    * {public}类型在外部和内部可见，并且会为状态变量创建一个getter函数
    * {private}类型只在当前合约可见
    * {internal}只在内部可见(继承该合约的其他合约可见)
    */
    uint public numPublic = 1;
    uint private numPrivate = 2;
    uint internal numInternal = 3;

    /**
    * 声明在函数之外的叫做状态变量。
    * 状态变量存储在区块链上。
    */
    string public text = "Hello";
    uint public num = 123;

    function doSomething() public {
        /**
        * 声明在函数之内的叫做局部变量。
        * 局部变量不存储在区块链上，存储在内存中。
        */
        uint i = 456;

        /**
        * 全局变量提供区块链的信息等等
        * 详细有哪些全局变量，可见：
        *  - https://docs.soliditylang.org/en/v0.8.13/cheatsheet.html#global-variables
        *  - https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html#special-variables-and-functions
        */
        uint timestamp = block.timestamp; // 当前区块时间戳
        address sender = msg.sender; // 调用此函数的地址
    }

    // 定义在函数外的引用类型变量默认都是 {storage}，也是状态变量，存储在区块链上。
    uint[] public arr;

    /**
    * 定义在函数内或者函数参数的引用类型变量必须指定存储位置。
    * {memory}类型的变量存储在内存中，并且只有在函数调用时存在。
    */
    function makeArr(uint[] calldata arrCalldate) public {
        uint[] storage arrStorage;
        uint[] memory arrMemory;
    }

    /**
    * {memory} 类型可以函数返回。
    * 只有 {memory} 和 {calldata} 可以返回。
    */
    function modifyB() public pure returns (uint[] memory){
        uint[] memory b = new uint[](3);
        return b;
    }

    /**
    * 由于EVM不允许修改 {calldata}，因此无法在 {calldata} 变量中创建新值或将某些内容复制到 {calldata} 变量。
    * 使用 {calldata} 变量的好处是，它不用将 {calldata} 数据的副本保存到内存中，并确保不会修改数组或结构（{calldata} 位置是只读的）。
    */
    function exists(uint[] calldata _arrCalldata, uint val) public pure returns (bool) {
        return checkEqual(_arrCalldata, val);
    }
    // 内部函数可以遍历 {calldata} 的数组，而不用再复制到内存了。
    function checkEqual(uint[] calldata _arrCalldata, uint val) internal pure returns (bool){
        for (uint i = 0; i < _arrCalldata.length; i++) {
            if (_arrCalldata[i] == val) {
                return true;
            }
        }
        return false;
    }
}
