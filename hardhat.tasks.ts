import { task } from "hardhat/config";
import { setTreeRoot__task } from "./tasks/setTreeRoot";
import { setTrustedRemote__task } from "./tasks/setTrustedRemote";
import { sendFrom__task } from './tasks/sendFrom';
import { mint__task } from './tasks/mint';
import { getProof__task } from './tasks/getProof';

task('setTreeRoot', 'Updates whitelist', setTreeRoot__task);

task('setTrustedRemote', 'Enables contracts to interact using LayerZero', setTrustedRemote__task)
    .addParam('dstchain', 'Name of target chain').addOptionalParam('dstcontract', 'Address of target contract');

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task)
    .addParam('dstchain', 'Name of target chain').addOptionalParam('toaddress', 'Recipient Address').addParam('tokenid');

task('mint', 'mints an ONFT', mint__task)
    .addParam('proof', 'Merkle proof');

task('getProof', 'Generates a proof for current signer', getProof__task)
.addOptionalParam('foraddress', 'Address');