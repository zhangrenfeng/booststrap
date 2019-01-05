source "$HOME/.bootstrap/helper.sh"
source "$HOME/.bootstrap/colorful.sh"

CUR_DIR="$HOME/.bootstrap/vscode"
VSCODE_PATH="/Users/""$(whoami)""/Library/Application Support/Code/User"

function link()
{
    if [[ -e "$VSCODE_PATH/$1" ]]; then
        backup_file "$VSCODE_PATH/$1"
    fi

    ln -s "$CUR_DIR"/$1 "$VSCODE_PATH"
}

if [[ ! -d "$VSCODE_PATH" ]]; then
    mkdir -p "$VSCODE_PATH"
fi

# 配置
echo_green "Configuring vscode ..."
link keybindings.json
link locale.json
link settings.json
link vsicons.settings.json
link snippets

# 同步插件
sh "$CUR_DIR"/sync_plugin.sh