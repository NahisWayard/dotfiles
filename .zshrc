export TERM="xterm-256color"

if [ -z "$TMUX" ]; 
then
  if [[ $(tput lines) -gt 20 ]]; then # No tmux on quick terminal
    if tmux has-session 2>/dev/null; 
    then
      # exec tmux new-session -t main \; new-window
    else
      # exec tmux new-session -t main
    fi
  fi
fi

# if [ -z "$TMUX" ]; then
#   if [[ $(tput lines) -lt 20 ]]; then # No tmux on quick terminal
#     exec tmux new-session -t main \; new-window
#   fi
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git argocd command-not-found dotenv kubectl kubectx macos themes tmux z zsh-interactive-cd)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export PATH=$(brew --prefix openssh)/bin:$PATH
export PATH=$(brew --prefix podman)/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.dotnet/:$PATH"

export EDITOR=nano

bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

alias k='kubectl'
export do="-o yaml --dry-run=client"

alias docker="podman"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export EDITOR=nano
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias g="git"
alias gst="git status"
alias gc="git commit -m"
alias gp="git push"
alias gau="git add -u"
alias ga="git add"

alias kaf="kubectl apply -f"

alias fz='fzf --height=40% --reverse --border | xargs -I{} z {}'

function zf() {
  local dir dir=$(z | awk '{print $2}' | fzf --height=40% --reverse --border) 
  if [[ -n "$dir" ]];
  then
    cd "$dir" 
    z -r "$dir"
  fi
}

function kgy() {
	if [[ $1 == "secret" ]]; then
		kubectl get -o yaml "$@" | yq '.stringData = (.data | with_entries(.value |= @base64d))'
	else
		# we use yq instead of kubecolor to have the same color schema as above
		kubectl get -o yaml "$@" | yq
	fi
}

function _kgy() {
	words="kubectl get -o yaml ${words[@]:1}"
	_kubectl
}
compdef _kgy kgy