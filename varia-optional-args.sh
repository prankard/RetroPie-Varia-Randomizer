#!/usr/bin/env bash

# Add optional parameters to compile command line, look in source for options:
# blank by default
optional_args=

# Example
# Other args can be found in: https://github.com/theonlydude/RandomMetroidSolver/blob/master/randomizer.py
# Controls order: Shoot,Jump,Dash,ItemSelect,ItemCancel,AngleUp,AngleDown
# Controls options: A,B,X,Y,L,R,Select,None
# Setup for zoast controls

#optional_args="--moonwalk --controls Y,A,B,X,Select,R,L"