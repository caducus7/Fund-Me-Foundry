# Fund Me Contract - Foundry

This project is a Solidity smart contract built for funding purposes. It allows users to send and manage funds securely. The project is developed using the [Foundry](https://book.getfoundry.sh/) framework for testing, deploying, and managing smart contracts.

## Features

- **Funding**: Allows users to fund the contract.
- **Withdrawals**: The contract owner can withdraw the accumulated funds.
- **Chainlink Price Feeds**: Implements Chainlink to get real-time ETH price data.

## Prerequisites

- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.js](https://nodejs.org/)
- [Git](https://git-scm.com/)

## Installation

1. Clone the repository:

   ````bash
   git clone https://github.com/caducus7/Fund-Me-Foundry.git
   cd Fund-Me-Foundry```

   ````

2. Install dependencies:

   ```bash
        forge install
   ```

3. Compile the contracts:

   ```bash
   forge compile
   ```

4. Run the tests:

   ```bash
        forge test
   ```

## Deployment

Deploy the contract to your desired Ethereum network:

```bash
    forge script script/DeployFundMe.s.sol --broadcast --rpc-url <NETWORK_RPC_URL>
```

## Usage

1.  Fund the contrat: Any user can call the fund() function to send ETH to the contract.
2.  Withdraw the funds: The owner of the contract can call the withdraw() function to withdraw the funds.

## Testing

Tests are written in Solidity and can be run using Foundry:

```bash
    forge test
```

## License

This project is offered under [MIT](LICENSE-MIT).
