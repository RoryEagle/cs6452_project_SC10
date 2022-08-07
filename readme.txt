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
3. Deploy Tree.sol and Carbon Credit.sol at address to check their status.

Use contracts after deployment:
1. ownRegistry.sol
- addTree(treeType, location): Adds tree with treeType and location.
- generateCredit(treeIndexes): Generate credit with list of verified tree.
- getTreeList(): Get list of owned trees.
- getCreditsList(): Get list of owned Carbon Credits.
- sellTree(treeIndex, price): Set the salePrice of the tree with treeIndex in treeAddr list. Add the tree to the tree's forSale list.
- sellCredit(creditIndex, price): Similar to sellTree.
- loadTreesForSale(): Load the current for Sale list for trees.
- loadCarbonCreditsForSale(): Similar to loadTreesForSale().
- buyTree(treeIndex): Buy tree with treeIndex in tree's forSale list.
- buyCredit(creditIndex): Similar to buyTree.
- useCredit(creditIndex): Use the Carbon Credit with creditIndex in _carbonCreditsAddr list, Carbon Credit expired after use. 

2. Tree.sol
Check the following status of the tree:
- CO2
- CO2 Used
- Creator
- ForSale
- Location
- Owner
- Plant Date (Block no.)
- Sale Price
- Tree type 
- Verified

3. CarbonCredit.sol
Check the following status of the Carbon Credit:
- Creator
- Expired
- ForSale
- Owner
- SalePrice

