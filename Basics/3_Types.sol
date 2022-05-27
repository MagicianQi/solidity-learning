// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/**
 * Solidity是一种静态类型语言，这意味着需要指定每个变量（状态和位置）的类型。
 * Solidity提供了几种基本类型，它们可以组合成复杂类型。
 */
contract Types {
    /**
    * Solidity的原始数据类型有：{bool}、{int}、{uint}、{address}等
    * 原始数据类型都是数值类型，直接存储变量的值。
    */
    bool public boo = true; // 二值类型
    uint public u = 123;    // 正整数类型
    int public i = -123;    // 整数类型
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;   // 地址类型

    /**
    * 定长的 {bytes1} 到 {bytes16} 是数值类型。
    * 变长的 {bytes} (也可以写为 {byte[]})是引用类型，实际上是一个 {byte} 的Array。
    */
    bytes1 b1 = 0xb5; //  [10110101]
    bytes6 b6 = 0xA3B4C6458736;

    /**
    * 自定义的枚举类型 {enum} 也是数值类型。
    * 枚举可以显式转换为所有整数类型。
    * 枚举至少需要一个成员，声明时它的默认值是第一个成员。枚举不能有超过256个成员。
    */
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choice; // 默认值为：`GoLeft`，也是0

    /**
    * 以 {uint} 为例：有关键字 {uint8} 到 {uint256} (每隔8都是关键字)
    * 其中：
    *   {uint8}   范围： 0 ～ 2 ** 8 - 1
    *   {uint16}  范围： 0 ～ 2 ** 16 - 1
    *   ...
    *   {uint256} 范围： 0 ～ 2 ** 256 - 1
    */
    uint8 public u8 = 1;
    uint256 public u256 = 456; // {uint} 与 {uint256} 是等价的
    int8 public i8 = -1;
    int256 public i256 = -123; // {int} 与 {int256} 是等价的

    /**
    * 我们可以通过以下方式获取一种类型的最大值与最小值
    */
    int public minInt = type(int).min;
    int public maxInt = type(int).max;
    ActionChoices minChoice =  type(ActionChoices).min;
    ActionChoices maxChoice =  type(ActionChoices).max;

    /**
    * 未赋值的变量有一个默认值
    */
    bool public defaultBoo; // 默认值为：false
    uint public defaultUint; // 默认值为：0
    int public defaultInt; // 默认值为：0
    address public defaultAddr; // 默认值为：0x0000000000000000000000000000000000000000

    /**
    * {address payable} 与 {address}相同，但具有附加成员{transfer}和{send}
    * 你可以将Ether发送到一个{address payable}地址
    */
    address payable payableAddr = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    /**
    * 强制类型转换时
    * {uint}转换成更小的类型，会丢失高位。转换成更大的类型，将向左侧添加填充位。
    */
    uint32 public con_a = 0x12345678;
    uint16 public con_b = uint16(con_a);        // con_b = 0x5678

    uint16 public con_c = 0x1234;
    uint32 public con_d = uint32(con_c);        // con_d = 0x00001234

    /**
    * 强制类型转换时
    * {bytes}转换到更小的字节类型，会丢失后面数据。转换为更大的字节类型时，向右添加填充位。
    */
    bytes2 public con_e = 0x1234;
    bytes1 public con_f = bytes1(con_e);        // con_f = 0x12

    bytes2 public con_g = 0x1234;
    bytes4 public con_h = bytes4(con_g);        // con_h = 0x12340000

    /**
    * 强制类型转换时
    * 只有当{bytes}类型和{uint}类型大小相同时，才可以进行转换。
    */
    bytes2 public con_i = 0x1234;
    uint32 public con_j = uint16(con_i);            // con_j = 0x00001234
    uint32 public con_k = uint32(bytes4(con_i));    // con_k = 0x12340000
    uint8 public con_m = uint8(uint16(con_i));      // con_m = 0x34
    uint8 public con_n = uint8(bytes1(con_i));      // con_n = 0x12

    /**
    * Solidity的引用类型变量有三种：{Array}、{Struct}、{Mapping}
    * 引用类型变量存储的是地址，引用类型的值可以通过多个不同的名称进行修改，但使用值类型的变量，您就会获得一个独立的副本。
    * 如果使用引用类型，则始终必须显式提供存储类型的数据区域：{memory}、{storage}、{calldata}
    * 下面的引用类型例子没有显式指定存储类型，是因为在合约里定义的变量为状态变量，所以这里定义的引用类型默认为 {storage} 类型
    */
    // 数组有多种声明方式，可以定长或者变长。数组有length、push()、push(x)、pop()几个成员
    uint[] public arr;
    uint[3] public arr2 = [1, 2, 3];

    /// @dev 根据索引获取数组内的值
    function getArrByIndex(uint _index) public view returns (uint) {
        return arr[_index];
    }

    // @dev 可以返回整个数组，但是这个数组不能无限长
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    /// @dev 在数组最后添加一个元素，并且数组长度会加一
    function pushArr(uint _index) public {
        arr.push(_index);
    }

    /// @dev 删除数组最后一个元素，并且数组长度会减一
    function popArr() public {
        arr.pop();
    }

    /// @dev 获取数组长度
    function getArrLength() public view returns (uint) {
        return arr.length;
    }

    /// @dev 删除数组某个元素，不会改变数组长度，只是把该位置改为默认值
    function removeArrByIndex(uint _index) public {
        delete arr[_index];
    }

    /// @dev 可以自定义结构类型，但是不能包含自己。
    struct Funder {
        address addr;
        uint amount;
    }
    Funder funder;

    /// @dev 修改对象`funder`的值
    function setFunder(address _addr, uint _amount) public {
        funder.addr = _addr;
        funder.amount = _amount;
    }

    /**
    * 映射将数据存储在键值对中，可以视为任何语言中的哈希表或字典。
    * keyType 可以为任何内置值类型、{bytes}、{string}或合约。
    * valueType 可以是任何类型，包括另一个映射或数组。
    * 不能迭代映射，也就是不能枚举它们的键，但是可以自己设计数据结构实现。
    * {mapping}必须是 {storage} 类型
    */
    mapping(address => uint) public balances;
    mapping(address => Funder[]) public funderBalances;

    /// @dev 获取`balances`中该地址的值。如果从来没有添加过该地址，那么会返回默认值。
    function getBalances(address _addr) public view returns (uint) {
        return balances[_addr];
    }

    /// @dev 更新`balances`中该地址的值
    function setBalances(address _addr, uint _i) public {
        balances[_addr] = _i;
    }

    /// @dev 将`balances`中该地址的值改为默认值
    function removeBalances(address _addr) public {
        delete balances[_addr];
    }

    /**
    * 引用类型的值可以通过多个不同的名称进行修改。使用值类型的变量会获得一个独立的副本。
    * 在调用函数 modify() 后，`valArr`会被修改变成[100, 2, 3]
    * 在调用函数 modify() 后，`val`不会被修改，还是0
    * (引用类型：由{memory}到{memory}是引用，由{storage}到{storage}也是引用，剩下的都是复制)
    */
    uint[] public valArr = [1, 2, 3];
    uint public val = 0;

    function modify() public {
        uint[] storage modifyArr = valArr; // 实际创建了指针，指向`valArr`的地址
        uint modifyVal = val;   // 创建了副本
        modifyArr[0] = 100;
        modifyVal = 100;
    }

    /**
    * 可以使用{new}运算符创建具有动态长度的内存数组。
    * 与存储数组相反，无法调整内存数组的大小（例如，.push()成员函数不可用）。
    * 您要么必须提前计算所需的大小，要么创建一个新的内存数组并复制每个元素。
    */
    function memoryAllocating(uint len) public pure {
        uint[] memory a = new uint[](7);
        bytes memory b = new bytes(len);
        assert(a.length == 7);
        assert(b.length == len);
        a[6] = 8;
    }

}
