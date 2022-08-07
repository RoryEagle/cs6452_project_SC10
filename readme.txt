To run the offchain API
1. ensure JDK 16 is downloaded and added to the system path
2. from root directory, execute the following command 
    java -jar offchain-api/offchain-api.jar

To execute the oracle for listening in on events
0. prequesites include the initial setup commands involved in the tutorial to initialise environment
    npm install typescript --save-dev

    npm install @types/node --save-dev

    npx tsc --init --rootDir src --outDir build \
    --esModuleInterop --resolveJsonModule --lib es6 \
    --module commonjs --allowJs true --noImplicitAny true

    npm install web3 && npm install solc && npm install axios
1. change the "account" variable to a valid ganashe private key value
2. run the following command from the root directory
    npx tsc && node oracle-smart-contract/build/index.js
    
Smart Contracts:
1. ownerRegistry.sol
2. Tree.sol
3. CarbonCredit.sol

To deploy smart contracts on remix:
1. Compile ownerRegistry.sol
2. Deploy ownerRegistry.sol (with value if transaction is needed)

Use contracts after deployment:
1. ownRegistry.sol
- addTree(string treeType, string location): Calls the constructor of Tree contractor to create    new tree, feed the constructor with two information (i.e. treeType and location) for tree     verification.
    - sellTree(treeIndex,price): Calls the sell function in tree which sets forSale to true and set                                 
