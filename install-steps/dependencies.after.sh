# Program:
#
# History:
#   2018/12/27      renfeng.zhang   0.1.0

source helper.sh

# 安装搜狗输入法
echo_green "Install sogouinput ... "
brew cask install sogouinput
sogou_base="/usr/local/Caskroom/sogouinput"
sogou_version="$sogou_base/"`ls "$sogou_base"`
sogou_app="$sogou_version/"`ls $sogou_version | grep .app | tail -n 1`
open "$sogou_app"

# 扩展预览程序
# 对于一些文本文件, 按下空格键就可以调用系统的预览程序, 快速浏览文件内容.
# 但如果想获得更好的阅读体验, 或支持更多类型的快速浏览, 就需要通过插件来完成
#   1. qlcolorcode 代码高亮插件
#   2. qlstephen 预览没有后缀的文本文件
#   3. qlmarkdown 预览 markdown 文件的渲染效果
#   4. quicklook-json 提供对 JSON 文件的格式化和高亮支持
#   5. qlimagesize 展示图片的分辨率和大小
#   6. webpquicklook 预览 WebP 格式的图片
#   7. qlvideo 预览更多格式的视频文件
#   8. provisionql 预览 .app 或者 .ipa后缀的程序
echo_green "Install quick look plugins ... "
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook provisionql
brew cask install --appdir='/usr/local/bin' qlimagesize qlvideo

# 安装解压工具
brew cask install the-unarchiver

# 1. 安装 Charles
echo_green "Install charles ... "
if [[ -e "/Applications/Charles.app" ]]; then
    echo_blue "You have installed Charles"
else
    if [[ ! -e "$HOME/Downloads/Charles.app.zip" ]]; then
        download_url="http://p2w4johvr.bkt.clouddn.com/Charles.app.zip"
        echo_green "Download charles from ${download_url}"
        curl "${download_url}" -o ~/Downloads/Charles.app.zip
    fi

    echo_green "Unzip $HOME/Downloads/Charles.app.zip"
    unzip -q $HOME/Downloads/Charles.app.zip -d /Applications
    echo_green "Remove $HOME/Downloads/Charles.app.zip"
    rm $HOME/Downloads/Charles.app.zip
fi

# 2. 安装 Dash
if [[ -e "/Applications/Dash.app" ]]; then
    echo_blue "You have installed Dash"
else
    if [[ ! -e $HOME/Downloads/Dash.app.zip ]]; then
        download_url="http://p2w4johvr.bkt.clouddn.com/Dash.app.zip"
        echo_green "Download Dash from ${download_url}"
        curl "${download_url}" -o ~/Downloads/Dash.app.zip
    fi

    echo_green "Unzip $HOME/Downloads/Dash.app.zip"
    unzip -q $HOME/Downloads/Dash.app.zip -d /Applications
    echo_green "Remove $HOME/Downloads/Dash.app.zip"
    rm $HOME/Downloads/Dash.app.zip
fi

# 3. 安装 Alfred 3.app
if [[ -e "/Applications/Alfred 3.app" ]]; then
    echo_blue "You have installed Alfred"
else
    if [[ ! -e "$HOME/Library/Application Support/Alfred 3" ]]; then
        mkdir -p "$HOME/Library/Application Support/Alfred 3"
    fi

    # patch
    brew cask install alfred
    sudo codesign -f -d -s - "/Applications/Alfred 3.app/Contents/Frameworks/Alfred Framework.framework/Versions/A/Alfred Framework"
    cp ~/.bootstrap/tools/alfred.license.plist "$HOME/Library/Application Support/Alfred 3/license.plist"

    # 同步配置
    rm -rf "$HOME/Library/Application Support/Alfred 3/Alfred.alfredpreferences"
    curl http://p2w4johvr.bkt.clouddn.com/Alfred.alfredpreferences2.zip -o "$HOME/Downloads/Alfred.alfredpreferences.zip"
    unzip -q "$HOME/Downloads/Alfred.alfredpreferences.zip" -d "$HOME/Library/Application Support/Alfred 3"
    rm "$HOME/Downloads/Alfred.alfredpreferences.zip"
fi

# Powerline-font
git clone --depth=1 https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# 下载solarized配色
git clone git://github.com/altercation/solarized.git
cd solarized/iterm2-colors-solarized
for file in $(ls $PWD); do
    open $file
done
cd -
rm -rf solarized


# python
pip3 install --trusted-host pypi.python.org neovim jedi ipython
pip3 install --user --upgrade --trusted-host pypi.python.org PyYAML

# gen update
sudo gem update --system 2.7.6
sudo gem install -n /usr/local/bin cocoapods
sudo gem install -n /usr/local/bin cocoapods-plugins
sudo gem install colored

# nvm & npm install
if [[ ! -d $HOME/.nvm ]]; then
    mkdir $HOME/.nvm
fi
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
nvm install 9.11.0
./install-steps/node_global.sh

