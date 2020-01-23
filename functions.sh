#!/bin/bash

###################################################
# Test
#
# Globals:
#   None
#
# Arguments:
#   $1  system-name (eg. "snes")
#   $2  rom filename (eg. "SuperMetroidRandomized.smc")
#   $3  image (eg. "image.png")
#
# Returns:
#   Nothing
#
function addGameToXml() 
{
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    xmlstarlet edit --inplace --update "/gameList/game[path='./$2']/desc" --value "$FILENAME" "$home/../.emulationstation/gamelists/$1/gamelist.xml"
} 

# end test

###################################################
# hasRom
#
# Globals:
#   None
#
# Arguments:
#   $1  system folder
#   $2  rom name
#
# Returns:
#   Nothing
#
function hasRom() {
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    xml_command="xmlstarlet sel -t -c \"count(/gameList/game[name='$2'])\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
    count=$(eval $xml_command)
    if [[ "$count" == "0" ]]; then
        return 0
    fi
    return 1
} # end hasRom

###################################################
# copyAndExtractRom
#
# Globals:
#   None
#
# Arguments:
#   $1   system folder (eg. 'snes')
#   $2   rom name (eg. 'Super Metroid', will find filepath from gamelist)
#   $3   rom destination path  (eg. '~/MyFilePath/SuperMetroidCopy.smc' must include correct extension to find rom in zip folder)
#
# Returns:
#   Nothing
#
function copyRom() {
    user="$SUDO_USER"
    [[ -z "$user" ]] && user="$(id -un)"
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"

    xml_command="xmlstarlet sel -t -v \"/gameList/game[name='$2']/path\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
    echo $xml_command
    rom_filename=$(eval $xml_command)
    echo $rom_filename
    full_path="$home/roms/$1/'$rom_filename'"
    source_rom_ext="${rom_filename##*.}"
    dest_rom_ext="${3#*.}"
    echo $source_rom_ext
    echo $dest_rom_ext
    if [[ "$source_rom_ext" == "zip" ]]; then
        line="unzip -d /opt/retropie/supplementary/varia-randomizer/files/dump $full_path"
        eval $line
        for f in "/opt/retropie/supplementary/varia-randomizer/files/dump/*.$dest_rom_ext"
        do
            FILENAME=$(basename $f .$des_trom_ext)
            break
        done
        line="mv /opt/retropie/supplementary/varia-randomizer/files/dump/'$FILENAME' $3"
        echo $line
        eval $line
        echo "unzipped"
        rm -r /opt/retropie/supplementary/varia-randomizer/files/dump
    else
        line="cp \"$full_path\" \"$3\""
        echo $line
        eval $line
        echo "copied"
    fi
    ## Logic to extract here if a zip file
    #cp $full_path $3
} # end test


###################################################
# getRomPathFromName
#
# Globals:
#   None
#
# Arguments:
#   $1 Rom Game Name (eg. "Super Metroid")
#
# Returns:
#   "./path.rom"
#
function getRomPathFromName() {
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    path=$(eval  xmlstarlet sel -t -v "/gameList/game[name='$1']/path" $home/../.emulationstation/gamelists/snes/gamelist.xml)
    return $path
} # end test

###################################################
# addGameToXML
#
# Globals:
#   None
#
# Arguments:
#   $1 Rom Folder System    (eg. snes)
#   $2 Rom Game Name        (eg. "Super Metroid Randomized")
#   $3 Rom Game Path        (eg. "./SuperMetroidRandomized.smc")
#   $4 Rom Description      (eg. "Randomized Seed 12345")
#   $5 Original Rom Name    (eg. "Super Metroid") used to copy all other nodes, eg. image etc
#
# Returns:
#   1 Success
#   0 Fail
#
function addGameToXML() {
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"

    xml_command="xmlstarlet sel -t -c \"/gameList/game[name='${2}']\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
    #echo $xml_command
    xmlNode=$(eval $xml_command)
    #xmlNode=$(eval xmlstarlet sel -t -c "/gameList/game[name='${2}']" $home/../.emulationstation/gamelists/$1/gamelist.xml)
    if [[ -z "$xmlNode" ]]; then
        # Copy new from original rom name
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/image\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        image=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/rating\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        rating=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/releasedate\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        releasedate=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/developer\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        developer=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/publisher\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        publisher=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/genre\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        genre=$(eval $xml_command)
        
        xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/players\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        players=$(eval $xml_command)

        # add a new elemnt for the game
        xml_command="xmlstarlet ed --inplace --subnode '/gameList' -type elem -n 'game' -s \"/gameList/game[last()]\" -type elem -n 'name' -v \"${2}\" -s \"/gameList/game[last()]\" -type elem -n 'path' -v \"${3}\" -s \"/gameList/game[last()]\" -type elem -n 'desc' -v \"${4}\" -s \"/gameList/game[last()]\" -type elem -n 'image' -v \"${image}\" -s \"/gameList/game[last()]\" -type elem -n 'rating' -v \"${rating}\" -s \"/gameList/game[last()]\" -type elem -n 'releasedate' -v \"${releasedate}\" -s \"/gameList/game[last()]\" -type elem -n 'developer' -v \"${developer}\" -s \"/gameList/game[last()]\" -type elem -n 'publisher' -v \"${publisher}\" -s \"/gameList/game[last()]\" -type elem -n 'genre' -v \"${genre}\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        eval $xml_command
        
        echo "Made new node from original node"
    else
        # update old node element with new values
        xml_command="xmlstarlet ed --inplace -u \"/gameList/game[name='${2}']/path\" -v \"$3\" -u \"/gameList/game[name='${2}']/desc\" -v \"$4\" $home/../.emulationstation/gamelists/$1/gamelist.xml"
        eval $xml_command
        echo "Updated old node"
    fi

    return 0
    exit 1
} # end test

#addGameToXML "snes" "Super Metroid Test" "./testromnew.smc" "new description a a a a" "Super Metroid"

# $1    plugin_name
function installPlugin()
{
    #hasRom "snes" "Super Metroid"
    hasRom "$systemname" "$gamename"
    if [[ "$?" == "1" ]]; then
    #    copyRom "snes" "Super Metroid" "rom.smc"
        copyRom "$systemname" "$gamename" "$romdestination"
        
    #    rm -r -f varia
    #    mkdir varia
    #    git clone --depth 1 "git@github.com:theonlydude/RandomMetroidSolver.git" varia
        rm -r -f "$name"
        mkdir "$name"
        git clone --depth 1 "$git" "$name"
    fi
}
