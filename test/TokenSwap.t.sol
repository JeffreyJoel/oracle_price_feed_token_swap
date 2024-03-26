// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import "../src/TokenSwap.sol";
import "../src/interfaces/IERC20.sol";

// interface IERC20 {
//     function balanceOf(address) external view returns (uint256);
//     function transfer(address, uint256) external returns (bool);
//     function decimals() external view returns (uint8);
// }

contract tokenSwapTest is Test {
    // Counter public counter;
    IERC20 dai;
    IERC20 link;
    IERC20 weth;

    TokenSwap tokenSwap;

    address daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address linkAddress = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
    address wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address feedRegistryAddress = 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;

    address prankAddress = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;

    function setUp() public {
        tokenSwap = new TokenSwap(
            wethAddress,
            linkAddress,
            daiAddress,
            feedRegistryAddress
        );

        dai = IERC20(daiAddress);
        link = IERC20(linkAddress);
        weth = IERC20(wethAddress);

        vm.startPrank(prankAddress);
    }

    function testSwapEthToLink() public {
        uint256 linkAmount = link.balanceOf(msg.sender);
        console.log("linkAmount: ", linkAmount);
        require(linkAmount > 0, "Insufficient LINK balance");
        link.approve(address(tokenSwap), linkAmount);
        tokenSwap.swapEthToLink(linkAmount);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
