#!/bin/bash

## Grab ini-reading functions from retropie
#readonly rootdir="/opt/retropie"
#source "$rootdir/lib/inifuncs.sh"
source "/opt/retropie/supplementary/varia-randomizer/functions.sh"
PARAMS_FILE=/opt/retropie/supplementary/varia-randomizer/varia-parameters.ini

parameter_names=()
parameter_values=()
parameter_default_values=()
parameter_friendly_values=()

arguments=()

myarray=()
let i=0
while IFS=$'\n' read -r line_data; do
    echo $line_data
    IFS='=' read -ra EQUAL_SPLIT <<< "$line_data"
    IFS='|' read -ra PIPE_SPLIT <<< "${EQUAL_SPLIT[0]}"
    parameter_names+=("${PIPE_SPLIT[0]}")
    parameter_friendly_names+=("${PIPE_SPLIT[1]}")
    IFS='|' read -ra PIPE_SPLIT <<< "${EQUAL_SPLIT[1]}"
    parameter_default_values+=("${PIPE_SPLIT[0]}")
    parameter_values+=("${PIPE_SPLIT[0]}")

    echo "${PIPE_SPLIT[0]}"

    # Parse “${line_data}” to produce content 
    # that will be stored in the array.
    # (Assume content is stored in a variable 
    # named 'array_element'.)
    # ...
    myarray[i]="${array_element}" # Populate array.
    ((++i))
done < $PARAMS_FILE

# Docuemnt this to include 1 param
function generate_sub_menu()
{
    [[ "$1" ]] || fatalError "js_select: missing argument: \"index\""

    index=$1
    line_data2=$(sed "${index}q;d" $PARAMS_FILE)
    IFS='=' read -ra EQUAL_SPLIT2 <<< "$line_data2"
    IFS='|' read -ra PIPE_SPLIT2 <<< "${EQUAL_SPLIT2[1]}"
    sub_options=()
    for i in "${!PIPE_SPLIT2[@]}"
    do
        sub_options+=($i "${PIPE_SPLIT2[$i]}")
    done

    cmd=(dialog \
         --title " Submenu " \
         --menu "Submenu description" 19 80 12
    )
    choice=$("${cmd[@]}" "${sub_options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        parameter_values[$((index-1))]="${sub_options[$((choice*2+1))]}"
    fi
} #end sub_menu

## Copys and checks the local rom
function check_rom() {
    user="$SUDO_USER"
    [[ -z "$user" ]] && user="$(id -un)"
    local home="$(eval echo ~$user)"
    home="$(find /home -type d -name RetroPie -print -quit 2> /dev/null)"
    mkdir -p $home/../.varia-randomizer
    #chmod 777 $home/../.varia-randomizer
    local romPath="$home/../.varia-randomizer/rom.smc"

    if [ ! -f "$romPath" ]; then
	    dialog --infobox "Searching for Super Metroid Rom..." 19 80
        hasRom "snes" "Super Metroid" "SuperMetroid.smc"

        if [[ "$?" == "1" ]]; then
	    dialog --infobox "Copying Original Super Metroid Rom..." 19 80
	    sleep 1
            copyRom "snes" "Super Metroid" "SuperMetroid.smc" "$romPath"
        else
            dialog --title "Error" --msgbox "Cannot find 'Super Metroid' in xml gamelist" 19 80
            exit
        fi

    	if [ ! -f "$romPath" ]; then
	    dialog --title "Error" --msgbox "Failed to copy super metroid source rom" 19 80
	    exit
    	fi
    fi
}

# Choose between global config, system specific config, toggle byname
function generate_menu() {

    while true; do
	    # Remake options
	    options=()
	    for i in "${!parameter_names[@]}"
	    do
        	newIndex=$((i+1))
        	options+=($newIndex "${parameter_friendly_names[$i]} - ${parameter_values[$i]}")
	    done
    	options+=("G" "Generate")

    	# Show dialog
	cmd=(dialog --title " Generate Rom " --menu "Varia Randomizer Rom. Randomize your rom with the varia randomizer" 19 80 12)
    	choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    	if [[ -n "$choice" ]]; then
    	    if [[ "$choice" == "G" ]]; then
    	        generate
		dialog --title "Generated" --msgbox "Good Luck!\n\nMay the odds be ever in your favour!\n\nYou may want to restart EmulationStation to update description metadata" 19 80
		exit
    	    else
    	        generate_sub_menu $choice
    	    fi
    	else
    	    break
    	fi
    done
} # end of main_menu()

function generate() {

    dialog --infobox "Generating Random Rom..." 19 80

    # Generate single argument string
    string_args=""
    for i in "${!parameter_names[@]}"
    do
        string_args="${string_args} ${parameter_names[$i]} ${parameter_values[$i]}"
    done

    # Generate
    /bin/bash /opt/retropie/supplementary/varia-randomizer/varia-randomizer-generate.sh $string_args
}

function main_menu() {
    ## check file exists for install

    while true; do
        generate_menu
    done
}

function install_menu() {
    local options_games=()
    
    local randomizer_ids=()
    local systems=()
    local file_extensions=()
    local game_names=()
    local randomizer_names=()
    
    let i=0
    while IFS=$'\n' read -r line_data; do
        echo $line_data
        IFS='|' read -ra PIPE_SPLIT <<< "$line_data"

        randomizer_ids+=("${PIPE_SPLIT[0]}")
        systems+=("${PIPE_SPLIT[1]}")
        file_extensions+=("${PIPE_SPLIT[2]}")
        game_names+=("${PIPE_SPLIT[3]}")
        randomizer_names+=("${PIPE_SPLIT[4]}")
        
        options_games+=($i "${PIPE_SPLIT[4]} - ${PIPE_SPLIT[3]}")

        ((++i))
    done < $CONFIG_FILE

    # Show dialog
    cmd=(dialog \
            --title " Select an option " \
            --menu "Ranomizer Menu" 19 80 12)
    choice=$("${cmd[@]}" "${options_games[@]}" 2>&1 >/dev/tty)
}

check_rom
generate_menu
