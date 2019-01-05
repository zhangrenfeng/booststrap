source "$HOME/.bootstrap/colorful.sh"

username="renfeng.zhang"

# write script you want to use in the 'if' block
if [[ "$username" == "$(whoami)" ]]; then
    brew cask install google-drive-file-stream

    # git config
    git config --global user.name "renfeng.zhang"
    git config --global user.email "zhangfang779797646@gmail.com"

    if [[ ! -d "$HOME/.ssh" ]]; then
        mkdir $HOME/.ssh
    fi

    if [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
        chmod 400 $HOME/.bootstrap/config/id_rsa
        ln -s $HOME/.bootstrap/config/id_rsa $HOME/.ssh/
    fi

    if [[ ! -f "$HOME/.ssh/id_rsa.pub" ]]; then
        ln -s $HOME/.bootstrap/config/id_rsa.pub $HOME/.ssh/
    fi

    ssh-add -K $HOME/.ssh/id_rsa

    if [[ -e "/Applications/MindNode 2.app" ]]; then
        echo_blue "You have installed MindNode"
    else
        echo_green "Install mindnode ..."
        if [[ ! -e "$HOME/Downloads/MindNode.app.zip" ]]; then
            download_url="http://app.bestswifter.com/MindNode501.app.zip"
            echo_green "Download mindnode from ${download_url}"
            curl "${download_url}" -o ~/Downloads/MindNode.app.zip
        fi

        echo_green "Unzip $HOME/Downloads/MindNode.app.zip"
        unzip -q "$HOME/Downloads/MindNode.app.zip" -d "/Applications/MindNode 2.app"
        echo_green "Remove $HOME/Downloads/MindNode.app.zip"
        rm $HOME/Downloads/MindNode.app.zip
    fi
fi