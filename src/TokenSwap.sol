// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

contract TokenSwap {
    address public ethToken;
    address public linkToken;
    address public daiToken;

    constructor(address _ethToken, address _linkToken, address _daiToken) {
        ethToken = _ethToken;
        linkToken = _linkToken;
        daiToken = _daiToken;
    }

    function swapEthToLink(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(ethToken).transferFrom(msg.sender, address(this), amount);
        IERC20(linkToken).transfer(msg.sender, amount);
    }

    function swapEthToDai(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(ethToken).transferFrom(msg.sender, address(this), amount);
        IERC20(daiToken).transfer(msg.sender, amount);
    }

    function swapLinkToEth(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(linkToken).transferFrom(msg.sender, address(this), amount);
        IERC20(ethToken).transfer(msg.sender, amount);
    }

    function swapLinkToDai(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(linkToken).transferFrom(msg.sender, address(this), amount);
        IERC20(daiToken).transfer(msg.sender, amount);
    }

    function swapDaiToEth(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(daiToken).transferFrom(msg.sender, address(this), amount);
        IERC20(ethToken).transfer(msg.sender, amount);
    }

    function swapDaiToLink(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(daiToken).transferFrom(msg.sender, address(this), amount);
        IERC20(linkToken).transfer(msg.sender, amount);
    }
}