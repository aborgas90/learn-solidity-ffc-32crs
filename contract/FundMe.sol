// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../node_modules/@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import "./PriceConverter.sol";

error isNotOwner();

// if u want do this seperate on another file
// interface AggregatorV3Interface {
// function decimals() external view returns (uint8);

// function description() external view returns (string memory);

// function version() external view returns (uint256);

// function getRoundData(
//     uint80 _roundId
// ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

// function latestRoundData()
//     external
//     view
//     returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
// }

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    //constant more cheaper than without using constant

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable i_owner;
    //gas fee without immutable is more expensive
    //gas fee with immutable is more cheaper

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        //want to able to set minimum fund amount in USD
        //1.How do we sent eth to this contract
        require(
            msg.value.getConversionRate() > MINIMUM_USD,
            "Didn't send enough"
        ); //1e18 => 1 * 10 ^ 18
        //18 decimals
        //for to gas fee we can calculate like => usd / price eth
        //=>50/3287 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset array
        funders = new address[](0);
        //actually withdraw the funds

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send Failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
        revert();
    }

    modifier onlyOwner() {
        if(msg.sender != i_owner){
            revert isNotOwner();
        }
        // require(msg.sender == i_owner, "Sender is not Owner!");
        _;
    }


    // what happens if someone send this contract ETH without calling the fund 

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
