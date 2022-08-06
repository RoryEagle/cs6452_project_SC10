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
