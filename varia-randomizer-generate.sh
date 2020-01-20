#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

#OUTPUT=~/RetroPie/roms/snes/SuperMetroidRandomized.smc
SOURCE="${BASH_SOURCE[0]}"
TEMP=$SCRIPTPATH/TEMP
OUTPUT=$SCRIPTPATH/generated.smc
VANILLA=~/SuperMetroidRandomizer/SuperMetroidVanilla.smc
rm -r -f $TEMP
mkdir $TEMP
rm -f $OUTPUT
#echo "PRESET FILE: $1"
#PRESET_NAME=$(basename $1 .json)
#echo "PRESET NAME: $PRESET_NAME"
#~/RandomMetroidSolver/randomizer.py --rom $VANILLA --dir $TEMP --randoPreset $1 --preset $PRESET_NAME --param $1 --majorsSplit Major
#~/RandomMetroidSolver/randomizer.py --rom $VANILLA --dir $TEMP --param $1 --majorsSplit $2
cd varia
args_as_string="$*"
##echo "$str"
echo "python3 randomizer.py --rom $VANILLA --dir $TEMP $args_as_string"
#python3 randomizer.py --rom $VANILLA --dir $TEMP --majorsSplit Major --param standard_presets/casual.json
python3 randomizer.py --rom $VANILLA --dir $TEMP $args_as_string
cd ..

FILENAME=""
for f in $TEMP/*sfc
do
        FILENAME=$(basename $f .sfc)
        break
done
#echo $FILENAME

mv $TEMP/*.sfc $OUTPUT
rm -r -f $TEMP
#killall emulationstatio
#xmlstarlet edit --inplace --update "/gameList/game[path='./SuperMetroidRandomized.smc']/desc" --value "$FILENAME" ~/.emulationstation/gamelists/snes/gamelist.xml
#emulationstation &

