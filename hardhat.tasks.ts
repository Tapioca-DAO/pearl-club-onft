import { task } from 'hardhat/config';
import { mint__task } from './tasks/mint';
import { sendFrom__task } from './tasks/sendFrom';
import { deployStack__task } from './tasks/deploy/00-deployStack';
import { setClaim__task } from './tasks/execs/00-setClaim';
import { jumpPhase__task } from './tasks/execs/01-jumpPhase';

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task);

task('mint', 'mints an ONFT', mint__task);

task('deployStack', 'Deploy the stack', deployStack__task);
task('setClaim', 'Set a claim list', setClaim__task);
task('jumpPhase', 'Activate the next phase of the NFT', jumpPhase__task);
