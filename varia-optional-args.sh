#!/usr/bin/env bash

# Add optional parameters to compile command line, look in source for options:
# blank by default
optional_args=

# Example
# Controls order: Shoot,Jump,Dash,ItemSelect,ItemCancel,AngleUp,AngleDown
optional_args="--moonwalk --invert --controls A,B,X,Y,L,R,Select,None"