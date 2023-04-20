import { task } from 'hardhat/config';
import { mint__task } from './tasks/mint';
import { sendFrom__task } from './tasks/sendFrom';

task('sendFrom', 'Sends ONFT to another chain', sendFrom__task);

task('mint', 'mints an ONFT', mint__task);
