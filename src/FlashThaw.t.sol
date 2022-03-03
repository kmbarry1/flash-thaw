// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./FlashThaw.sol";

contract FlashThawTest is DSTest {
    FlashThaw thaw;

    function setUp() public {
        thaw = new FlashThaw();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
