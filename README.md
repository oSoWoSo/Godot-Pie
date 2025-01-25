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

  ## Menu Features
  - press the centre icon to either exit a sub-menu or exit the launcher entirely.
  - you don't need to press the button to launch the app. by simply clicking anywhere on the launcher the nearest button will be automatically clicked for you, this allows for greater speed when launching apps.
  - to figure out what rotation you must change to, simply run the pie menu from the command line and then use the arrow keys. this will rotate the items and will output the amount they have been rotated by.

  ## Config
  **Settings**
  extract from config file:
```
  [Settings]

animate_speed=0.2
radius=250
global_rotation=1.2
centre_icon="res://icon.svg"
spawn_in_time=0

```
- animate_speed: refers to how fast the buttons move to position
- radius: is how far they are from the centre
- global_rotation: is how the buttons are rotated around the centre
- centre_icon: is self explainitory
- **spawn_in_time: is currently depricated! Must be 0 for the menu to work**

**Submenus**

```
[Submenu 1]

Name="SubMenuName"
Type="sub-menu"
IconPath="/path/to/icon"
rotation=0.0
```
- Submenu 1: is just a section name and can be anything you want so long as it's never repeated in the rest of the file
- Name: is what will be shown when you run the pie-menu
- Type: this identifies this section as either an item or a sub-menu. it has to be either of those or the menu won't know what to render
- IconPath: you get the idea
- rotation: allows you to change the rotation of items within the submenu

**Items**

```
[Button 1]

Name="NameOfItem"
Type="item"
IconPath="/path/to/icon"
parent="root"
Command=""
```
- Button 1: is a section name so same as with the previous submenu
- Name: display name for the item
- Type: see submenu for explaination. (in this case it has to be 'item')
- IconPath: again u get it
- parent: this is what the item belongs to. it must either be the Name of a submenu or it must be root
- command: the command that will be run when this item is clicked on
