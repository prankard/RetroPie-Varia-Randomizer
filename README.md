# RetroPie-Varia-Randomizer

## Requirements

For the plugin to work, it searches for a game called 'Super Metroid' in your snes game lists. Ensure you have the Super Metroid rom and you have successfully scrapped or added the correct meta-data to RetroPie to have the name 'Super Metroid'.

## Installation

1. If you're on EmulationStation, press `F4` to go to the Command Line Interface.

2. Download the `install.sh` script, and launch it:

```bash
curl https://raw.githubusercontent.com/prankard/RetroPie-Varia-Randomizer/master/install-scriptmodule.sh -o varia-install.sh
bash varia-install.sh
```

3. The script will automatically download the joystick-selection scriptmodule and install everything you need. After installation you can safely delete the `install.sh` file:

```bash
rm varia-install.sh
```

4. **After that you are ready to use it via RetroPie menu in emulationstation:**

```bash
emulationstation
```

#### Thanks to

Of course, full credit to the [varia randomizer](https://randommetroidsolver.pythonanywhere.com/) which you can run on a web browser to generate roms, and full source found [here](https://github.com/theonlydude/RandomMetroidSolver). Down in that repo is where all the hard work is located.

Thanks to the source files of [RetroPie Joystick Selection](https://github.com/meleu/RetroPie-joystick-selection) for their decent plugin that is very useful to follow and basic blatent copying of installation technique and scriptmodule setup



## TODO

#### Manidtory

- [x] Make sure the initial copy of the file/original rom does not require root access to do so
  ~/.emulation ~/.varia-randomizer/rom.smc + remove old files directory
- [x] Settings preset to be added, which is overridden

#### Nice to have

- [x] Twoey mandatory suggestion, never use 777 
- [x] Change order of options to match python anywhere
- [ ] Save the user's params, and add default parameters
- [x] Add friendly names to parameter arguments
- [ ] Make progression speed and majors split optional (as it's set already in settings and skills preset) - maybe add all options to be optional
- [x] Another file to load in extra parameters for users who want to change controls etc