# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# constants
export TERMINAL="termite"
export EDITOR="nano"
export BROWSER="firefox"
export ZSH_CUSTOM="$HOME/.custom-oh-my-zsh"
export SCRIPT_FOLDER="$HOME/.scripts/"
export WALLPAPER_FOLDER="$HOME/Pictures/Wallpapers/"

PATH="$SCRIPT_FOLDER:$PATH"

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi