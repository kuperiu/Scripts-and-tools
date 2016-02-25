#!/bin/bash
<<COMMENT
Install aws cli
COMMENT
if [[ ! $(type aws 2> /dev/null) ]]; then
 if [[ ! $(type pip 2> /dev/null) ]]; then
   eazy_install pip
 fi
 pip install aws
fi
