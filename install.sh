#!/bin/bash
# Program:
#   安装配置
# History:
#   2018/12/27      renfeng.zhang       0.1.0
#

# 加载工具方法
source helper.sh
source colorful.sh

# 进行一些系统配置
sudo ./install-steps/macos.sh

# 安装python3
# echo_green "Install python3 ..."
# brew install python3

# 安装 iTerm2
if [[ ! -e "/Applications/iTerm.app" ]]; then
    echo_green "Install iTerm2 ... "
    brew cask install iterm2
    defaults delete com.googlecode.iterm2
    cp config/com.googlecode.iterm2.plist $HOME/Library/Preferences
    command="set :New\ Bookmarks:0:Background\ Image\ Location /Users/""$(whoami)""/.booststrap/assets/iTerm2-background.jpg"
    /usr/libexec/PlistBuddy -c "$command" $HOME/Library/Preferences/com.googlecode.iterm2.plist
    defaults read -app iTerm >/dev/null
else
    echo_blue "You have installed iTerm2"
fi

# 安装 SourceTree
if [[ ! -e "/Applications/SourceTree.app" ]]; then
    echo_green "Install SourceTree ..."
    brew cask install sourcetree
else
    echo_blue "You have installed SourceTree"
fi

# 安装微信
if [[ ! -e "/Applications/WeChat.app" ]]; then
    echo_green "Install WeChat ..."
    brew cask install wechat
else
    echo_blue "You have installed WeChat"
fi

# 安装Chrome
if [[ ! -e "/Applications/Google Chrome.app" ]]; then
    echo_green "Install google chrome ..."
    brew cask install google-chrome

    echo_green "Set chrome as default browser"
    git clone https://github.com/kerma/defaultbrowser ./tools/defaultbrowser
    (cd ./tools/defaultbrowser && make && make install)
    defaultbrowser chrome
else
    echo_blue "You have installed chrome"
fi

# 安装 VSCode
if [[ ! -e "/Applications/Visual Studio Code.app" ]]; then
    echo_green "Install Visual Studio Code ..."
    brew cask install visual-studio-code
    sh ./vscode/setup.sh
else
    echo_blue "You have installed vscode"
fi

# 安装gnu-sed
if brew ls --versions gnu-sed > /dev/null; then
    echo_blue "You have installed gsed"
else
    echo_green "Install gnu-sed"
    brew install gnu-sed
fi

if [[ ! -e "/usr/local/opt/coreutils" ]]; then
    echo_green "Install coreutils ... "
    brew install coreutils
    mv /usr/local/opt/coreutils/libexec/gnubin/ls /usr/local/opt/coreutils/libexec/gnubin/gls
else
    echo_blue "You have installed coreutils"
fi

# 安装vim插件
echo_green "Install universal-ctags ..."
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
#brew_install redis
brew_install cmake
brew_install gawk
brew_install autojump
brew_install wget
brew_install nvm
brew_install exiv2
brew_install ssh-copy-id
brew_install imagemagick
brew_install catimg
brew_install gpg
brew_install icdiff
brew_install scmpuff
brew_install fzf
brew_install fd
brew_install the_silver_searcher
brew_install nvim
brew_install exiftool
brew_install archey
brew_install ranger
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
$(brew --prefix)/opt/fzf/install --all

echo_green "Backup git configuration file"
mv ~/.gitconfig ~/.gitconfig_backup
backup_file ~/.gitattributes
ln -s ~/.booststrap/git-config/.gitconfig ~/.gitconfig
ln -s ~/.booststrap/git-config/.gitattributes ~/.gitattributes

# 安装 oh-my-zsh
if [[ ! -e "~/.oh-my-zsh" ]]; then
    echo_green "Install oh-my-zsh ..."
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
else
    echo_blue "You have installed oh-my-zsh"
fi

# zsh配置
echo_green "Configure oh-my-zsh"
backup_file ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s ~/.bootstrap/zsh-config/.zshrc ~/.zshrc
eval "$(scmpuff init -s --aliases=false)"

# vim配置
echo_green "Configure vim"
backup_file ~/.vim
backup_file ~/.config/nvim/
git clone https://github.com/bestswifter/vim-config.git ~/.config/nvim
ln -s ~/.config/nvim ~/.vim

# ESLint配置
echo_green "Configure ESLint"
backup_file ~/.eslintrc.js
backup_file ~/.eslintrc
ln -s ~/.bootstrap/.eslintrc.js ~/.eslintrc.js

echo_green "Configure ranger"
if [[ ! -e "$HOME/.config/ranger" ]]; then
    mkdir -p "$HOME/.config/ranger"
fi
old_commands_py=$HOME/.config/ranger/commands.py
old_rc_conf=$HOME/.config/ranger/rc.conf
backup_file "$old_commands_py"
backup_file "$old_rc_conf"
ln -s ~/.bootstrap/config/ranger/commands.py "$old_commands_py"
ln -s ~/.bootstrap/config/ranger/rc.conf "$old_rc_conf"

./install-steps/dependencies.before.sh

unset ALL_PROXY
./install-steps/dependencies.after.sh
./install-steps/sogou_sync.sh

# ssh配置
echo_green "Configure ssh"
backup_file ~/.ssh/config
if [[ ! -e ~/.ssh ]]; then
    mkdir ~/.ssh
fi
ln -s ~/.bootstrap/zsh-config/ssh_config ~/.ssh/config

# 个人配置
./install-steps/personal.sh
./personal.sh

# curl -fsSL https://raw.githubusercontent.com/zhangrenfeng/aptkit/master/git/install.sh | sh

echo -e ${GREEN}"================================= done ==========================================="${CLOSE}
echo ""
