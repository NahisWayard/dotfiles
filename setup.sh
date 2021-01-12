#!/bin/sh

BASEDIR=$(dirname $(readlink -f "$0"))
DOTFILES="$BASEDIR/dotfiles"

cd

#Used to set constants
. "$DOTFILES/.zprofile"

echo "1" | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp -rf $DOTFILES/.* .

git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
echo "1" | polybar-themes/setup.sh

exec zsh