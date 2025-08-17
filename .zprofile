if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :


# Added by Toolbox App
export PATH="$PATH:/Users/larago/Library/Application Support/JetBrains/Toolbox/scripts"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Added by `rbenv init` on Mar 19 nov 2024 15:32:31 CET
# eval "$(rbenv init - --no-rehash zsh)"
# Add .NET Core SDK tools
export PATH="$PATH:/Users/larago/.dotnet/tools"

export XDG_CONFIG_HOME="$HOME/.config"
