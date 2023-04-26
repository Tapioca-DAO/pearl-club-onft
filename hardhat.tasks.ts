import { task } from 'hardhat/config';
import { mint__task } from './tasks/mint';
import { sendFrom__task } from './tasks/sendFrom';
import { deployStackTestnet__task } from './tasks/deploy/00-deployStackTestnet';
import { setClaim__task } from './tasks/execs/00-setClaim';
import { deployStack__task } from './tasks/deploy/00-deployStack';
import { setBulkClaim__task } from './tasks/execs/01-setBulkClaim';
import { checkLost__task } from './tasks/execs/tsd';

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task);

task('mint', 'mints an ONFT', mint__task);

task(
    'deployStackTestnet',
    'Deploy the stack on testnet',
    deployStackTestnet__task,
);
task('deployStack', 'Deploy the stack on mainnet', deployStack__task);
task('setClaim', 'Set a claim list', setClaim__task);
task('setBulkClaim', 'Set the claim list in bulk', setBulkClaim__task);
task('checkLost', '', checkLost__task);
