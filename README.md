# RetroPie-Varia-Randomizer

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

Of course, full credit to the [varia randomizer](https://randommetroidsolver.pythonanywhere.com/) which you can run on a web browser to generate roms, and full source found [here](https://github.com/theonlydude/RandomMetroidSolver).

Thanks to the source files of [RetroPie Joystick Selection](https://github.com/meleu/RetroPie-joystick-selection) for their decent plugin that is very useful to follow and basic blatent copying of installation technique and scriptmodule setup
