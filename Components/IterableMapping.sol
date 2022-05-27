// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * Solidity中的{mapping}是不可以迭代的，但是我们可以自己设计一种可迭代的{mapping}
 * 代码参考：
 *  - https://medium.com/rayonprotocol/creating-a-smart-contract-having-iterable-mapping-9b117a461115
 *. - https://solidity-by-example.org/app/iterable-mapping
 */

contract IterableMap {
    // Solidity中的{Array}是可以迭代的，所以用{Array}中存储{mapping}中的键。
    // 就可以实现遍历{mapping}。
    address[] internal keyList;
    mapping(address => uint) internal map;

    /// @dev 向`map`中增加元素
    function add(address _key, uint _value) public {
        map[_key] = _value;
        keyList.push(_key);
    }

    /// @dev 判断元素是否在`map`中
    function contains(address _key) public view returns (bool) {
        return map[_key] != 0;
    }

    /// @dev 根据`_key`获取在`map`中的值
    function getByKey(address _key) public view returns (uint) {
        return map[_key];
    }

    /// @dev 获取`map`的大小
    function size() public view returns (uint) {
        return uint(keyList.length);
    }

    /// @dev 获取`map`的所有键
    function getKeys() public view returns (address[] memory) {
        return keyList;
    }

    /// @dev 测试遍历
    function testIterableMap() public view returns (bool){
        for (uint i = 0; i < size(); i++) {
            address key = keyList[i];
            assert(getByKey(key) >= 0);
        }
        return true;
    }
}
