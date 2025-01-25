# Godot-Pie
A simple Pie Menu made in godot

# How it works
- when opened the program loads a config file from  ~/.config/godot-pie/config.cfg file (edit the config file to launch your own apps)
- the program uses a daemon  to launch the given app (its just a python file and you should have it run on PC startup or else no apps will be launched)
- I am reasonably certain it can launch most apps (basically it just runs any command u give it) and it seems successful on my machine so far

  # Developer Notes
  "it works on my machine"

  # How to install
  1) download the binary or compile a binary yourself (see building section)
  2) go into your DE/WM config file (for me this is i3wm) and do 2 things
     i) set the godot-pie-daemon.py to run on startup
     ii) bind the binary to execute when a key is pressed
  3) thats it. just restart your PC (or restart your x-server by loging out and in again) and it will work (if it doesn't than idk you're on your own  :) see Developers Notes for my response to you)

  # Building

  I have provided a release version for linux.
  there is nothing stopping you from trying to run this on windows though. It will just require you to change the config path manually but then it *should* (I haven't and won't be testing it) work on windows
  If you want to build from source simply clone the repo, open the project in godot 4.3 (any other 4.xx version will probably work as well) and then compile the project manually using the export tab in the godot editor

  Automatic launching on key press is not supported. Check your DE/WM documentation to launch the executable when a key is pressed.

# Docs

Im too lazy to write docs so just look at my reference config and figure it out (its really not that complicated you'll manage I promise :)
