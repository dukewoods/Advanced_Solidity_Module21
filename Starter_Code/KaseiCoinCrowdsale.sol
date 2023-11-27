
pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";

// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale {
    constructor(
        uint256 rate, // rate in TKNbits
        address payable wallet, // wallet to send Ether
        KaseiCoin token // the token
    ) public Crowdsale(rate, wallet, token) {
        // constructor can stay empty
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
        string memory name,
        string memory symbol,
        uint256 initial_supply,
        uint256 rate,
        address payable wallet
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin kaseiToken = new KaseiCoin(name, symbol, initial_supply);
        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(kaseiToken);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kaseiCrowdsale = new KaseiCoinCrowdsale(rate, wallet, kaseiToken);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseiCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        kaseiToken.addMinter(kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        kaseiToken.renounceMinter();
    }
}
