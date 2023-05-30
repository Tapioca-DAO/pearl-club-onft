import { task } from 'hardhat/config';
import { sendFrom__task } from './tasks/sendFrom';
import { deployStackTestnet__task } from './tasks/deploy/00-deployStackTestnet';
import { setClaim__task } from './tasks/execs/00-setClaim';
import { deployStack__task } from './tasks/deploy/00-deployStack';
import { setBulkClaim__task } from './tasks/execs/01-setBulkClaim';
import { rescueMint__task } from './tasks/execs/02-rescueMint';

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task);

task(
    'deployStackTestnet',
    'Deploy the stack on testnet',
    deployStackTestnet__task,
);
task('deployStack', 'Deploy the stack on mainnet', deployStack__task);
task('setClaim', 'Set a claim list', setClaim__task);
task('setBulkClaim', 'Set the claim list in bulk', setBulkClaim__task);
task('rescueMint', 'Rescue mint', rescueMint__task);
