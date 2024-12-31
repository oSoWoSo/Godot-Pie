# Godot-Pie
A simple Pie Menu made in godot

# How it works
- on startup the program loads a config file from  ~/.config/godot-pie/config.cfg file (this is where you put what apps you want to launch)
- the program uses godots execute command to launch the given app

  Docs on what can be executed can be found on the godot Documentation for the execute command. It also provides info on what flags should be used to launch a program

  # Developer Notes
  I made this in 3, 2 hour sessions over a weekend. The phrase "it works on my machine" can't be over stated. This is not production ready and is just a proof of concept.
  **This is a demo and will probably never be updated**

  # Building / Running

  I have provided a release version for linux.

  there is nothing stopping you from trying to run this on windows though. It will just require you to change the config path manually but then it *should* (I haven't and won't be testing it) work on windows

  If you want to build from source simply clone the repo, open the project in godot 4.3 (any other 4.xx version might work as well) and then compile the project manually using the export tab in the godot editor

  Automatic launching on key press is not supported. Check your DE/WM documentation to launch the executable when a key is pressed.
