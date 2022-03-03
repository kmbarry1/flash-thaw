// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.11;

import "ds-test/test.sol";

import "./FlashThaw.sol";

contract FlashThawTest is DSTest {
    FlashThaw flashThawer;

    address constant END   = 0xBB856d1742fD182a90239D7AE85706C2FE4e5922;
    address constant FLASH = 0x1EB4CF3A948E7D72A198fe073cCb8C7a948cD853;

    function setUp() public {
        flashThawer = new FlashThaw(END, FLASH);
    }

    function test_basic_sanity() public {
    }
}
