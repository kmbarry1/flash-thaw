// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.11;

interface VatLike {
    function Line() external view returns (uint256);
    function debt() external view returns (uint256);
}
interface EndLike {
    function cage() external;
    function thaw() external;
    function wait() external returns (uint256);
    function debt() external returns (uint256);
}
interface IERC3156FlashBorrower {
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}
interface FlashLike {
    function dai() external view returns (address);
    function vat() external view returns (address);
    function maxFlashLoan(address) external view returns (uint256);
    function flashLoan(IERC3156FlashBorrower, address, uint256, bytes calldata) external returns (bool);
}
interface ERC20Like {
    function approve(address, uint256) external;
}

contract FlashThaw {
    EndLike immutable end;
    FlashLike immutable flash;
    bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");

    constructor(address _end, address _flash) {
        end = EndLike(_end);
        flash = FlashLike(_flash);
        ERC20Like(flash.dai()).approve(address(flash), type(uint256).max);
    }

    function flashAndThaw() external {
        address dai = flash.dai();
        uint256 max = flash.maxFlashLoan(dai);
        VatLike vat = VatLike(flash.vat());
        uint256 available = vat.Line() - vat.debt();
        max = available < max ? available : max;
        flash.flashLoan(IERC3156FlashBorrower(address(this)), dai, max, "");
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        initiator; token; amount; fee; data;
        end.thaw();
        return CALLBACK_SUCCESS;
    }
}
