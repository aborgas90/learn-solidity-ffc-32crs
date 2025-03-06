// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '../node_modules/@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';

library  PriceConverter {

    function getPrice() internal view returns (uint256){
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // ETH in terms USD
        //3000.00000000
        return uint256(price * 1e10); //1*10 == 10000000000
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        //3000_000000000000000000 = Eth / usd price
        //1_000000000000000000 Eth
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/ 1e18;
        //299.9999999999
        return ethAmountInUsd;
    }
}