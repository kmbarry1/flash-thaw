// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.11;

import "ds-test/test.sol";

import "./FlashThaw.sol";

interface Hevm {
    function warp(uint256) external;
    function store(address,bytes32,bytes32) external;
    function load(address,bytes32) external view returns (bytes32);
}

contract FlashThawTest is DSTest {
    Hevm hevm;
    FlashThaw flashThawer;

    address constant END   = 0xBB856d1742fD182a90239D7AE85706C2FE4e5922;
    address constant FLASH = 0x1EB4CF3A948E7D72A198fe073cCb8C7a948cD853;
    address constant VAT   = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
    address constant VOW   = 0xA950524441892A31ebddF91d3cEEFa04Bf454466;

    uint256 when;  // cage timestamp

    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint256(keccak256('hevm cheat code'))));

    function setUp() public {
        hevm = Hevm(address(CHEAT_CODE));
        flashThawer = new FlashThaw(END, FLASH);

        // get End auth to allow us to call cage()
        hevm.store(
            END,
            keccak256(abi.encode(address(this), uint256(0))),
            bytes32(uint256(1)));
        EndLike(END).cage();
        when = block.timestamp;
    }

    function test_attack() public {
        hevm.warp(when + EndLike(END).wait());
        uint256 vatDebt = VatLike(VAT).debt();

        // Coerce system surplus to zero (we are just looking to prove a point,
        // it is always possible to reach this state through correct means).
        hevm.store(
            VAT,
            keccak256(abi.encode(address(VOW), uint256(5))),
            bytes32(uint256(0)));
        flashThawer.flashAndThaw();
        uint256 endDebt = EndLike(END).debt();
        assertTrue(endDebt > vatDebt);
    }
}
