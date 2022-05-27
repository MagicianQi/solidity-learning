// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * 限制访问的用户是智能合约中非常常见并且重要的功能，同时使用{modifier}来实现
 */

contract TestOnlyOwner {
    address owner;

    /// @dev 指定创建合约的用户为`owner`
    constructor() {
        owner = msg.sender;
    }

    /// @dev 在执行函数前判断访问用户是不是`owner`
    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _;
    }

    /// @dev 任何用户都可以向合约中质押Ether
    function deposit() public payable {}

    /// @dev 只有`owner`可以提取合约中的Ether
    function withdraw() public onlyOwner {
        (bool res,) = payable(msg.sender).call{value: address(this).balance}("");
        require(res, "Failed to withdraw");
    }
}


contract TestOnlyManager {
    // 用于记录用户是否是`Manager`
    mapping(address => bool) managers;

    /// @dev 指定创建合约的用户为`Manager`
    constructor() {
        managers[msg.sender] = true;
    }

    /// @dev 在执行函数前判断访问用户是不是`Manager`
    modifier onlyManager() {
        require(managers[msg.sender], "Not the manager");
        _;
    }

    /// @dev  只有`Manager`可以设置`Manager`
    function setManager(address _manager) public onlyManager {
        managers[_manager] = true;
    }

    /// @dev 只有`Manager`可以撤销`Manager`
    function cancelManager(address _manager) public onlyManager {
        managers[_manager] = false;
    }

    /// @dev 任何用户都可以向合约中质押Ether
    function deposit() public payable {}

    /// @dev 只有`Manager`可以提取合约中的Ether
    function withdraw() public onlyManager {
        (bool res,) = payable(msg.sender).call{value: address(this).balance}("");
        require(res, "Failed to withdraw");
    }
}
