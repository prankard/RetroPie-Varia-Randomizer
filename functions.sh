#!/bin/bash

###################################################
# hasRom
#
# Globals:
#   None
#
# Arguments:
#   $1  system folder (eg. "snes")
#   $2  game name (eg. "Super Metroid")
#   $3  backup rom name (eg. "Super Metroid [U].smc")
#
# Returns:
#   Nothing
#
function hasRom() {
    local call="getRomPath \"$1\" \"$2\" \"$3\""
    local romPath=$(eval $call)
    echo $romPath

    if [[ -f "$romPath" ]]; then
        echo "Found rom"
        return 1
    fi

    echo "not found rom"
    return 0
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
#   $3   backup rom filename (eg. 'Super Metroid.smc', will be used if no gamelist found)
#   $4   rom destination path  (eg. '~/MyFilePath/SuperMetroidCopy.smc' must include correct extension to find rom in zip folder)
#
# Returns:
#   Nothing
#
function copyRom() {

    call="getRomPath \"$1\" \"$2\" \"$3\""
    full_path=$(eval $call)

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
        line="mv /opt/retropie/supplementary/varia-randomizer/files/dump/'$FILENAME' $4"
        echo $line
        eval $line
        echo "unzipped"
        rm -r /opt/retropie/supplementary/varia-randomizer/files/dump
    else
        line="cp \"$full_path\" \"$4\""
        echo $line
        eval $line
        echo "copied"
    fi
} # end copyRom


###################################################
# getRomPath
#
# Globals:
#   None
#
# Arguments:
#   $1 Rom System Name (eg. "snes")
#   $2 Rom Game Name (eg. "Super Metroid")
#   $3 Backup rom filename (eg. "Super Metroid.smc")
#
# Returns:
#   "./path.rom"
#
function getRomPath() {
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    
    gamelistPath=$(eval getGamelistPath $1)
    if [[ -z $gamelistPath ]]; then
        path="./$3" 
    else
        call="xmlstarlet sel -t -v \"/gameList/game[name='$2']/path\" \"$gamelistPath\""
        path=$(eval  $call)
    fi
    echo "${home}/roms/$1/${path}"
} # end getRomPath

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
    gamelistPath=$(eval getGamelistPath $1)

    if [[ ! -f "$gamelistPath" ]]; then
        xml_command="xmlstarlet sel -t -c \"/gameList/game[name='${2}']\" $gamelistPath"
        #echo $xml_command
        xmlNode=$(eval $xml_command)
        #xmlNode=$(eval xmlstarlet sel -t -c "/gameList/game[name='${2}']" $gamelistPath)
        if [[ -z "$xmlNode" ]]; then
            # Copy new from original rom name
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/image\" $gamelistPath"
            image=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/rating\" $gamelistPath"
            rating=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/releasedate\" $gamelistPath"
            releasedate=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/developer\" $gamelistPath"
            developer=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/publisher\" $gamelistPath"
            publisher=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/genre\" $gamelistPath"
            genre=$(eval $xml_command)
            
            xml_command="xmlstarlet sel -t -v \"/gameList/game[name='${5}']/players\" $gamelistPath"
            players=$(eval $xml_command)

            # add a new elemnt for the game
            xml_command="xmlstarlet ed --inplace --subnode '/gameList' -type elem -n 'game' -s \"/gameList/game[last()]\" -type elem -n 'name' -v \"${2}\" -s \"/gameList/game[last()]\" -type elem -n 'path' -v \"${3}\" -s \"/gameList/game[last()]\" -type elem -n 'desc' -v \"${4}\" -s \"/gameList/game[last()]\" -type elem -n 'image' -v \"${image}\" -s \"/gameList/game[last()]\" -type elem -n 'rating' -v \"${rating}\" -s \"/gameList/game[last()]\" -type elem -n 'releasedate' -v \"${releasedate}\" -s \"/gameList/game[last()]\" -type elem -n 'developer' -v \"${developer}\" -s \"/gameList/game[last()]\" -type elem -n 'publisher' -v \"${publisher}\" -s \"/gameList/game[last()]\" -type elem -n 'genre' -v \"${genre}\" $gamelistPath"
            eval $xml_command
            
            echo "Made new node from original node"
        else
            # update old node element with new values
            xml_command="xmlstarlet ed --inplace -u \"/gameList/game[name='${2}']/path\" -v \"$3\" -u \"/gameList/game[name='${2}']/desc\" -v \"$4\" $gamelistPath"
            eval $xml_command
            echo "Updated old node"
        fi
    fi

    return 0
} # end addGameToXml

###################################################
# getGamelistPath
#
# Globals:
#   None
#
# Arguments:
#   $1 Rom Folder System    (eg. snes)
#
# Returns:
#   "/home/pi/gamelistPath.xml" or ""
#
function getGamelistPath()
{
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    gamelistPath="$home/roms/$1/gamelist.xml"
    if [[ ! -f "$gamelistPath" ]]; then
        gamelistPath="$home/../.emulationstation/gamelists/$1/gamelist.xml"
        if [[ ! -f "$gamelistPath" ]]; then
            gamelistPath=""
        fi
    fi
    echo $gamelistPath
}

#addGameToXML "snes" "Super Metroid Test" "./testromnew.smc" "new description a a a a" "Super Metroid"
