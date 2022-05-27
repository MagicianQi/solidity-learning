// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 当一个合约继承自其他合约时，区块链上只创建一个合约，所有基础合约的代码都编译到创建的合约中。
 * 这意味着对基础合约函数的所有内部调用也只使用内部函数调用 super.f(...) 将使用 JUMP 而不是消息调用。
 */
contract A {
    string public name = "Contract A";

    function foo() public pure virtual returns (string memory) {
        return "A.foo";
    }
}

// 继承的时候使用{is}关键字
contract B is A {
    // 覆盖父合约的状态变量，只能在构造器函数中，不能重新声明覆盖。
    constructor() {
        name = "Contract B";
    }

    // 函数装饰器也可以被继承
    modifier modFoo() virtual {_;}

    // 将会覆盖 A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B.foo";
    }
}

contract C is A {
    string public text = "Text C";

    constructor(string memory _text) {
        text = _text;
    }

    modifier modFoo() virtual {_;}

    // 将会覆盖 A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C.foo";
    }
}

/**
 * 合约可以继承多个父合约。
 * 当调用在不同合约中多次定义的函数时，父合约从右到左，深度优先搜索。
 */
contract D is B, C {
    // 可以继承多个构造函数。
    // B()、C(_text)的顺序无所谓，但是执行的顺序永远是按照继承的顺序，先是C(_text)，后是B()
    constructor(string memory _text) B() C(_text) {}

    // 函数装饰器也可以被覆盖，与函数相同
    modifier modFoo() override(B, C) {_;}

    // 这里将会返回{C.foo}。
    // 因为C合约是从右到左第一个拥有 foo() 的函数，所以 super.foo() 调用的是C合约的 foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

/**
 * 继承必须从最基类到最派生排序。交换{A}和{B}的顺序会引发编译错误。
 * 因为{B}是继承自{A}，所以必须是这样的顺序。
 */
contract F is A, B {
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}

/**
 * 合约可以声明为抽象合约
 * 当合约至少其中一个函数未实现时，需要将合约标记为抽象。
 */
abstract contract M {
    function foo() public pure virtual returns (bytes32);
}

contract N is M {
    function foo() public pure override returns (bytes32) { return "miaow"; }
}

// 如果合约继承自抽象合约，并且没有通过覆盖实现所有未实现的功能，则也需要将其标记为抽象。
abstract contract P is M {

}
