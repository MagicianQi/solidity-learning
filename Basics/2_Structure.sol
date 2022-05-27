// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * Solidity中的合约类似于面向对象语言中的类。
 * 每个合约都可以包含状态变量、结构类型、枚举类型、函数、函数修饰符、事件和错误的声明。
 * 此外，合约可以继承自其他合约。
 */
contract Structure {
    // 声明在合约内部的变量叫做状态变量，状态变量存储在区块链上。
    string name;
    uint age = 20;
    address owner;

    // 可以定义枚举类型
    enum Status { Sleeping, Running, Working }

    // 可以定义结构类型
    struct Attributes {
        uint weight;
        uint height;
        address wallet;
        bool isMale;
    }

    // 可以定义函数，合约的可执行单元。
    function setOwner(address _addr) public {
        owner = _addr;
    }

    /**
    * 可以定义函数装饰器(函数修饰符)。
    * 用于以声明方式更改函数的行为。例如，您可以使用修饰符在执行函数之前自动检查条件。
    */
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner can call this."
        );
        _;
    }

    /// @dev 只有`owner`本人可以调用这个函数，其他人会报错。
    function setName(string memory _name) public onlyOwner {
        name = _name;
    }

    /**
    * 可以定义事件Event。
    * 事件是 EVM 日志记录工具的接口。事件在 EVM 的日志记录功能之上提供了一个抽象。(可以理解为埋点)
    */
    event ChangeStatusRecord(address modifiedBy, Status status);

    Status status;

    function setStatus(Status _status) public {
        status = _status;
        // 触发事件
        emit ChangeStatusRecord(msg.sender, _status);
    }

    /**
    * @dev 可以定义错误Error。错误允许您为故障情况定义描述性名称和数据。可以使用NatSpec描述错误。
    * @param availableAge 提供的年龄
    * @param requiredAge 要求的最小年龄
    *
    * Requirements:
    *
    * - 提供的年龄必须大于要求的年龄
    */
    error AgeLimit(uint availableAge, uint requiredAge);

    function setAge(uint _age) public {
        uint minimumAge = 18;
        if (_age < minimumAge)
            // 还原当前调用所有更改并返回错误
            revert AgeLimit({
                availableAge: _age,
                requiredAge: minimumAge
            });
        age = _age;
    }
}

/**
 * @dev 定义在合约之外的函数，也称为自由函数，具有{internal}可见性。
 * 它们的代码包含在调用它们的所有合约中，类似于内部库函数。
 * 与合约中定义的函数的主要区别在于，自由函数不能直接访问存储变量和不在其范围内的函数。
 */
function doWorkOutside(uint x) pure returns (uint) {
    return x + x;
}
