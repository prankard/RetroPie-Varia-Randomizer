#!/bin/bash
source "/opt/retropie/supplementary/varia-randomizer/varia-optional-args.sh"

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
user="$SUDO_USER"
[[ -z "$user" ]] && user="$(id -un)"
home="$(eval echo ~$user)"
home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"


OUTPUT=$home/roms/snes/SuperMetroidRandomized.smc
#OUTPUT=~/RetroPie/roms/snes/SuperMetroidRandomized.smc
SOURCE="${BASH_SOURCE[0]}"
TMP_DIR="$home/tmp"

#TEMP=/opt/retropie/supplementary/varia-randomizer/files/TEMP
#OUTPUT=$SCRIPTPATH/generated.smc
VANILLA=$home/../.varia-randomizer/rom.smc
#OUTPUT=/opt/retropie/supplementary/varia-randomizer/files/generated.smc
#OUTPUT=/home/pi/RetroPie/roms/snes/varia-randomizer 
rm -r -f $TMP_DIR
mkdir $TMP_DIR
rm -f $OUTPUT
#echo "PRESET FILE: $1"
#PRESET_NAME=$(basename $1 .json)
#echo "PRESET NAME: $PRESET_NAME"
#~/RandomMetroidSolver/randomizer.py --rom $VANILLA --dir $TEMP --randoPreset $1 --preset $PRESET_NAME --param $1 --majorsSplit Major
#~/RandomMetroidSolver/randomizer.py --rom $VANILLA --dir $TEMP --param $1 --majorsSplit $2
cd /opt/retropie/supplementary/varia-randomizer/varia
args_as_string="$*"
##echo "$str"
#echo "python3 randomizer.py --rom $VANILLA --dir $TEMP --runtime 0 $args_as_string"
#python3 randomizer.py --rom $VANILLA --dir $TEMP --majorsSplit Major --param standard_presets/casual.json
python3 randomizer.py --rom $VANILLA --dir $TMP_DIR --runtime 999999999 $args_as_string $optional_args
cd ..

FILENAME=""
for f in $TMP_DIR/*sfc
do
        FILENAME=$(basename $f .sfc)
        break
done
#echo $FILENAME
DESC=$(echo "${FILENAME//_/ }")
echo $DESC

mv $TMP_DIR/*.sfc $OUTPUT
rm -r -f $TMP_DIR
#killall emulationstatio


source "/opt/retropie/supplementary/varia-randomizer/functions.sh"
addGameToXML "snes" "Super Metroid Randomized" "./SuperMetroidRandomized.smc" "$DESC" "Super Metroid"

#sleep 10

#xmlstarlet edit --inplace --update "/gameList/game[path='./SuperMetroidRandomized.smc']/desc" --value "$FILENAME" $home/../.emulationstation/gamelists/snes/gamelist.xml
#emulationstation &
