// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * Some gas saving techniques.
 * - Replacing memory with calldata
 * - Loading state variable to memory
 * - Replace for loop i++ with ++i
 * - Caching array elements
 * - Short circuit
 * 参考：https://solidity-by-example.org/gas-golf
 */
contract GasOptimization {

    uint public total;

    // 没有优化Gas的函数
    function sumIfEvenAndLessThan99WithoutOptimization(uint[] memory nums) external {
        for (uint i = 0; i < nums.length; i += 1) {
            if (nums[i] < 99 && nums[i] % 2) {
                total += nums[i];
            }
        }
    }

    // 优化Gas的函数
    // 1.输入参数改为{calldata}
    function sumIfEvenAndLessThan99WithOptimization(uint[] calldata nums) external {
        // 2.加载状态变量到内存
        uint _total = total;
        uint len = nums.length;
        // 3.循环改为{++i}
        for (uint i = 0; i < len; i=unchecked_inc(i)) {
            // 4.缓存数组元素
            uint num = nums[i];
            // 5.短路策略，{num % 2 == 0}的消耗更低，放在{&&}前面，判断是{false}后可以避免计算{num < 99}
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }

    function unchecked_inc(uint i) internal pure returns(uint){
      unchecked {
        ++i;
      }
      return i;
    }
}
