import Web3 from "web3";
import { Contract, DeployOptions } from "web3-eth-contract";

(async () => {
    const web3Provider = new Web3.providers.WebsocketProvider("ws://localhost:7545");
    const web3 = new Web3(web3Provider);
    const axios = require("axios").default

    //console.log(web3);

    // account_pri_key is an account generated by Ganache
let account = web3.eth.accounts.wallet.add("0x" + "41ec4e5f1bb959030c9e59cb514a88c15a2226f671aedaaf63e69ba19b219326");

//console.log(account);

const fs = require("fs");
const solc = require("solc");
function findImports(importPath: string) {
    try {
        return {

            contents: fs.readFileSync(`smart_contracts/ ${importPath}`, "utf8")
        };
    } catch (e: any) {
        return {
            error: e.message
        };
    }
}
function compileSols(solNames: string[]): any {
    interface SolCollection { [key: string]: any };
    let sources: SolCollection = {};
    solNames.forEach((value: string, index: number, array: string[]) => {
        let sol_file = fs.readFileSync(`smart_contracts/${value}.sol`, "utf8");
        sources[value] = {
            content: sol_file
        };
    });
    let input = {
        language: "Solidity",
        sources: sources,
        settings: {
            outputSelection: {
                "*": {
                    "*": ["*"]
                }
            }
        }
    };
    let compiler_output = solc.compile(JSON.stringify(input), {
        import: findImports
    });
    let output = JSON.parse(compiler_output);
    return output;
}
    let compiled = compileSols(["example"]);

    //DEPLOY
    
    let contract_instance: Contract;
    let gasPrice: string;
    let contract = new web3.eth.Contract(compiled.contracts["example"]["CoatIndicator"].abi,
    undefined, {
        data: "0x" + compiled.contracts["example"]["CoatIndicator"].evm.bytecode.object
    });
    await web3.eth.getGasPrice().then((averageGasPrice) => {
        gasPrice = averageGasPrice;
    }).catch(console.error);
    // assume account balance is sufficient
    await contract.deploy({
        data: contract.options.data,
        arguments: [account.address]
    } as DeployOptions).send({
        from: account.address,
        gasPrice: gasPrice!,
        gas: Math.ceil(1.2 * await contract.deploy({
        data: contract.options.data,
        arguments: [account.address]
        } as DeployOptions).estimateGas({
            from: account.address
        })),
    }).then((instance) => {
        contract_instance = instance;
    }).catch(console.error);
    console.log(contract_instance!.options.address);

    //Listen
    contract_instance!.events["temperatureRequest(string)"]()
    .on("connected", function (subscriptionId: any) {
        console.log("listening on event temperatureRequest");
    })
        .on("data", async function (event: any) {
        let city = event.returnValues.city;
        /// TODO respond with temperature by calling responsePhase(int256)
        let temperature = await axios.get(`http://localhost:8080/test`)
            .then(async function (response: any) {
                console.log("set temp");
            return response?.data?.temperature?.replace(/[^0-9-\.]/g, "");
            })
            .catch(function (error: any) {
            console.log(error);
            });
            if (!parseInt(temperature)) {
            console.log("invalid temperature");
            return;
            }
// assume account balance is sufficient
        try {
            contract_instance.methods["responsePhase(int256)"](temperature).send({
                from: account.address,
                gasPrice: gasPrice!,
                gas: Math.ceil(1.2 * await contract_instance.methods["responsePhase(int256)"]
                (temperature).estimateGas({ from: account.address })),
            }).then(function (receipt: any) {
            
                return receipt;
            }).catch((err: any) => {
                console.error(err);
            });
        } catch (e) {
        console.log(e);
        }

    })
    .on("error", function (error: any, receipt: any) {
        console.log(error);
        console.log(receipt);
        console.log("error listening on event temperatureRequest");
    });
})();
