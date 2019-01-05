# Install chisel for debugging in lldb
brew install chisel

if [[ ! -e ~/.lldbinit ]]; then
    cp ~/.bootstrap/config/.lldbinit ~/.lldbinit
else
    if grep -q "/usr/local/opt/chisel/libexec/fblldb.py" "$HOME/.lldbinit"; then
        echo "Chisel is installed"
    else
        echo "command script import /usr/local/opt/chisel/libexec/fblldb.py" >> ~/.lldbinit
    fi

    echo "" >> ~/.lldbinit
    echo "# load lldb commmand alias and configuration provided by renfeng.zhang" >> ~/.lldbinit
    echo "command source ~/.bootstrap/zsh-config/zrf_lldb_extension" >> ~/.lldbinit
fi

# code runner
brew cask install coderunner