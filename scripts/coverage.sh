#!/bin/bash

forge coverage --report lcov
genhtml -o report lcov.info