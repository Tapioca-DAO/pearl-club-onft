import { task } from 'hardhat/config';
import { mint__task } from './tasks/mint';
import { sendFrom__task } from './tasks/sendFrom';
import { deployStack__task } from './tasks/deploy/00-deployStack';
import { jumpPhase__task } from './tasks/deploy/setups/01-jumpPhase';
import { setClaim__task } from './tasks/deploy/setups/00-setClaim';

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task);

task('mint', 'mints an ONFT', mint__task);

task('deployStack', 'Deploy the stack', deployStack__task);
task('setClaim', 'Set a claim list', setClaim__task);
task('jumpPhase', 'Activate the next phase of the NFT', jumpPhase__task);
