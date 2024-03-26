// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import {AggregatorV3Interface} from "lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {FeedRegistryInterface} from "lib/chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";

contract TokenSwap {
    address public ethToken;
    address public linkToken;
    address public daiToken;
    address public usd;

    address private feedRegistryAddress;

    FeedRegistryInterface private feedRegistry;

    event EthToUsdSwap(address indexed sender, uint256 ethAmount, uint256 usdAmount);
    event DaiToUsdSwap(address indexed sender, uint256 ethAmount, uint256 daiAmount);
    event LinkToEthSwap(address indexed sender, uint256 linkAmount, uint256 ethAmount);
    event LinkToDaiSwap(address indexed sender, uint256 linkAmount, uint256 daiAmount);
    event DaiToEthSwap(address indexed sender, uint256 daiAmount, uint256 ethAmount);
    event DaiToLinkSwap(address indexed sender, uint256 daiAmount, uint256 linkAmount);

    address public immutable eth_usd_address;
    address public immutable dai_usd_address;

    AggregatorV3Interface public immutable DAI_USD_FEED;
    AggregatorV3Interface public immutable ETH_USD_FEED;

    constructor(
        address _ethToken,
        address _linkToken,
        address _daiToken,
        address _usd,
        address _daiUsdFeed,
        address _ethUsdFeed
    ) {
        ethToken = _ethToken;
        linkToken = _linkToken;
        usd = _usd;
        daiToken = _daiToken;
        DAI_USD_FEED = AggregatorV3Interface(_daiUsdFeed);
        ETH_USD_FEED = AggregatorV3Interface(_ethUsdFeed);
    }

    function swapEthToUSD(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(ethToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(ETH_USD_FEED, amount);
        IERC20(usd).transfer(msg.sender, amountOut);

        emit EthToUsdSwap(msg.sender, amount, amountOut);
    }

    function swapDAIToUSD(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(daiToken).transferFrom(msg.sender, address(this), amount);
        uint256 amountOut = _handleAmountOut(DAI_USD_FEED, amount);
        IERC20(usd).transfer(msg.sender, amountOut);

        emit DaiToUsdSwap(msg.sender, amount, amountOut);
    }


    function _handleAmountOut(
         AggregatorV3Interface feed,
        uint256 amountIn
    ) internal view returns (uint256) {
        (, int256 priceIn, , , ) = feed.latestRoundData();
        require(priceIn > 0, "Price feed not available for base asset");
        return uint256(amountIn * uint256(priceIn));
    }
}
