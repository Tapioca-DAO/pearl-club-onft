const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const { merkleWhitelistAddresses1, merkleWhitelistAddresses2 } = require('../merkle-root-config');
var fs = require('fs');
import { HardhatRuntimeEnvironment } from "hardhat/types";


export const generateMerkleTree__task = async (
    taskArgs: { phase: string },
    hre: HardhatRuntimeEnvironment,
) => {
  const { ethers } = hre;
  const merkleWhitelistAddresses = taskArgs.phase === "2" ? merkleWhitelistAddresses2 : merkleWhitelistAddresses1;
  console.log("Generating merkle tree for accounts:", merkleWhitelistAddresses);

  for (let i = 0; i < merkleWhitelistAddresses.length; i++) {
    merkleWhitelistAddresses[i] = ethers.utils.getAddress(merkleWhitelistAddresses[i]);
  }

  const leafNodes = merkleWhitelistAddresses.map(address => padBuffer(address));
  console.log(leafNodes)

    const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
    let merkleJson = {};

    for(let i = 0; i < merkleWhitelistAddresses.length; i++) {
      //@ts-ignore
        merkleJson[merkleWhitelistAddresses[i]] = {
            "proof": merkleTree.getHexProof(padBuffer(merkleWhitelistAddresses[i]))
        }
    }

    console.log();
    console.log("======== MERKLE TREE ========");
    console.log();
    console.log(`ROOT: ${merkleTree.getHexRoot()}`)
    console.log(JSON.stringify(merkleJson, null, 3));


      const merkleTreeInfo = {
        root: merkleTree.getHexRoot(),
        tree: merkleJson
      };

      const merkleString = JSON.stringify(merkleTreeInfo, null, 2);

      //@ts-ignore
      fs.writeFileSync(`merkleTree-${taskArgs.phase}.txt`, merkleString, 'utf8', err=>{
        if(err){
          console.log("Error writing file" ,err)
        } else {
          console.log('JSON data is written to the file successfully')
        }
      });

      return merkleTreeInfo;
}

const padBuffer = (addr: string) => {
  return Buffer.from(addr.substr(2).padStart(32*2, '0'), 'hex')
}