source "$HOME/.bootstrap/colorful.sh"

EXTENSIONS_DIR=$HOME/.vscode/extensions

if [[ ! -d "$EXTENSIONS_DIR" ]]; then
    echo_blue "No vscode extensions"

    echo_green "Installing vscode plugins"
    git clone --depth=1 https://git.coding.net/bestswifter/VSCodeExtension.git $EXTENSIONS_DIR
else
    echo_green "Update vscode plugins"
    cd $EXTENSIONS_DIR
    git fetch
    git reset --hard master
fi