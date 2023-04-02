import './hardhat.tasks';
import conf from './hardhat.export';
import "hardhat-preprocessor";
import fs from "fs";

export default conf;

function getRemappings() {
    return fs
      .readFileSync("remappings.txt", "utf8")
      .split("\n")
      .filter(Boolean) // remove empty lines
      .map((line) => line.trim().split("="));
  }
  
