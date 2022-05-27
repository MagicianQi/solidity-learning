// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 变量可以按照以下方式区分：
 *  - 按照访问限制分为：{public}、{private}、{internal}、{external}
 *  - Getter函数按照作用范围分为：{view}、{pure}
 *  - 按照是否能接受Ether：{payable}
 *  - 与继承相关：{virtual}、{override}
 */
contract Functions {
    // 外部可以访问
    function publicUint() public pure returns (uint) {
        return 100;
    }

    // 只有本合约可以访问
    function privateUint() private pure returns (uint) {
        return 100;
    }
    uint public privateA = privateUint();

    // 只能从当前合约或从它派生的合约中访问。
    function internalUint() internal pure returns (uint) {
        return 100;
    }

    // 只有外部可以访问。externalUint() 不可以，但是 this.externalUint() 可以
    function externalUint() external pure returns (uint) {
        return 100;
    }

    /**
    * {view} 函数声明不会更改任何状态。
    * {pure} 函数声明不会更改或读取任何状态变量。
    */
    uint public x = 1;
    // 只读状态变量，不写状态变量
    function addToX(uint y) public view returns (uint) {
        return x + y;
    }
    // 不读状态变量，也不写状态变量
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }

    /**
    * 带有{payable}的函数可以接受Ether到这个合约内
    * 构造函数同样可以。
    */
    constructor() payable {}
    function deposit() public payable {}

    /**
    * 将被子合同覆盖的函数必须声明为{virtual}
    * 将要覆盖父函数的函数必须使用关键字{override}
    */
    function inheritFoo() public pure virtual returns (string memory) {
        return "A";
    }

    /**
    * 编译器会自动为所有公共状态变量创建Getter函数
    * 部署后可以看到 getterA() 和 getterB() 两个函数
    */
    uint public getterA = 100;
    uint[] public getterB = [1, 2, 3];

    // 可以在返回参数中指定变量
    function arithmetic(uint a, uint b) public pure returns (uint sum, uint product) {
        sum = a + b;
        product = a * b;
    }

    /**
    * fallback() 是一个不接受任何参数且不返回任何内容的函数，每个合约只能有一个 fallback() 函数
    * 调用不存在的函数时执行
    * Ether直接发送到合约但 receive() 不存在或 msg.data 不为空时执行
    * 在由{transfer}或者{send}调用时有 2300 gaslimit
    */
    uint public countFallbacks = 0;
    fallback() external {
        countFallbacks += 1;
    }

    /**
    * 函数装饰器是可以在函数调用之前和/或之后运行的代码。
    * 函数装饰器通常可用于：限制访问、验证输入、防范重入攻击等等
    */
    address owner = msg.sender;

    /// @dev 判断函数调用是不是owner
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        // 特殊符号{_;}代表这里是函数体插入的地方。可以存在多个，代表可以插入多次。
        // 在这个符号前的会在函数调用之前执行，在这个符号后的会在函数调用之后执行。
        _;
    }
    /// @dev 验证地址是不是有效地址
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }
    /// @dev 只有`owner`可以调用这个函数，并且会验证`_newOwner`是否有效
    function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }
}

contract InheritFunctions is Functions{
    // 可以继承{internal}类型的函数
    uint public internalA = internalUint();

    /// @dev 覆盖父函数的函数必须使用关键字{override}
    function inheritFoo() public pure override returns (string memory) {
        return "B";
    }

    /**
    * @dev 传入合约{Functions}的地址，会调用一个该合约不存在的函数
    * 此时可以看到合约{Functions}中的 countFallbacks() 会加一
    */
    function callFunctions(Functions test) public {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
    }

}
