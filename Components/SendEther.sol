// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 1.有三种方式可以发送Ether，{send}、{transfer}、{call}。
 *   推荐{call} + 防重入攻击的组合来发送Ether。不建议使用{send}和{transfer}，主要因为固定了gas费，可能导致发送Ether失败。
 * 2.在发送Ether到合约时，该合约必须至少有{receive() external payable}和{fallback() external payable}其中一个
 *   如果调用的{msg.data}为空，则调用{receive() external payable}，否则调用{fallback() external payable}。
 *   如果不存在函数{receive() external payable}，则调用{fallback() external payable}
 * ---------------------
 * 代码参考：https://solidity-by-example.org/sending-ether
 * 防重入攻击参考：Hacks/
 */

 /// @dev 待接收Ether的合约
contract ReceiveEtherA {

    receive() external payable {}

    fallback() external payable {}

    /// @dev 查看合约内Ether值
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

 /// @dev 待接收Ether的合约，
contract ReceiveEtherB {
    uint public a;

    /// @dev 增加状态变量的赋值。一是为了增加函数的Gas消耗，二是为了确认调用的函数。
    receive() external payable {
        a = 1;
    }

    /// @dev 通过{a}的值可以确定调用的是{receive}还是{fallback}
    fallback() external payable{
        a = 2;
    }

    /// @dev 查看合约内Ether值
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

/**
 * @dev 用于验证不同的发送Ether函数，传入函数的地址可以为账户地址或合约地址。
 * 1.在往{ReceiveEtherA}中发送Ether时，会发现都会成功。
 * 2.在往{ReceiveEtherB}中发送Ether时，会发现{sendViaSend}、{sendViaTransfer}会失败。
 *   因为{send}、{transfer}是硬编码的只能传入2300 gas，但是当{ReceiveEtherB.receive}
 *   或者{ReceiveEtherB.fallback}消耗的Gas大于2300时，就会报错。
 * 3.{sendViaCall}在传入{ReceiveEtherB}地址时，调用的是{ReceiveEtherB.receive}函数。
 * 4.{sendViaCallWithData}在传入{ReceiveEtherB}地址时，调用的是{ReceiveEtherB.fallback}函数。
 */
contract SendEther {
    /// @dev {send}函数返回值为bool类型，所以发送失败只会返回`false`，但不会报错
    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    /// @dev {transfer}在发送失败时会抛出异常。
    ///      {require(_to.send(msg.value))}与{_to.transfer(msg.value)是等价的。
    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    /// @dev {call}的时候，data为空，会调用{receive}。
    ///      {send}、{transfer}底层也是使用{call}实现的，并且硬编码了 2300 gas。
    function sendViaCall(address payable _to, uint _gas) public payable {
        (bool sent, ) = _to.call{value: msg.value, gas: _gas}("");
        require(sent, "Failed to send Ether");
    }

    /// @dev {call}的时候，data不为空，会调用{fallback}
    function sendViaCallWithData(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("0xaabbccdd");
        require(sent, "Failed to send Ether");
    }
}
