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
    IERC20 usd;

    TokenSwap tokenSwap;
    address ETH_USD_FEED = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address DAI_USD_FEED = 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19;

    address USDAddress = 0xf08A50178dfcDe18524640EA6618a1f965821715;
    address DAIAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address LINKAddress = 0x514910771AF9Ca656af840dff83E8264EcF986CA;

    address prankAddress = 0x40ec5B33f54e0E8A33A975908C5BA1c14e5BbbDf;

    function setUp() public {
        tokenSwap = new TokenSwap(
            WETHAddress,
            LINKAddress,
            USDAddress,
            DAIAddress,
            DAI_USD_FEED,
            ETH_USD_FEED
        );

        dai = IERC20(DAIAddress);
        link = IERC20(LINKAddress);
        weth = IERC20(WETHAddress);
        usd = IERC20(USDAddress);

        vm.startPrank(prankAddress);
    }

    function testSwapDAIToUSD() public {
        uint256 daiBalance = dai.balanceOf(msg.sender);
        console.log("DAI balance: ", daiBalance);

        require(daiBalance > 0, "You have Insufficient DAI");
        dai.approve(address(tokenSwap), daiBalance);
        tokenSwap.swapDAIToUSD(daiBalance);
    }

    function testSwapETHForUSD() public {
        uint256 wethBalance = weth.balanceOf(msg.sender);
        console.log("initial ETH balance: ", wethBalance);

        require(wethBalance > 0, "You have Insufficient Weth");
        weth.approve(address(tokenSwap), wethBalance);
        tokenSwap.swapEthToUSD(wethBalance);
    }
}
