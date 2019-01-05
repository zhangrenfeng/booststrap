#!/bin/bash
# Program:
#
# History:
#       2018/12/26  renfeng.zhang   0.1.0
# Usage:
#       curl https://raw.githubusercontent.com/zhangrenfeng/booststrap/master/booststrap.sh | sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export $PATH

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CLOSE="\033[0m"

echo -e ${GREEN}"=================================================================================="${CLOSE}
echo -e ${YELLOW}"                         Welcome to booststrap"${CLOSE}
echo -e ${GREEN}"=================================================================================="${CLOSE}

# 仓库地址
GIT_REPO_URL="https://github.com/zhangrenfeng/booststrap.git"

# 分支名称
[ -e "${BRANCH}"] && export BRANCH="master"

# 删除已经存在的目录
INSTALL_PATH=~/.booststrap
if [[ -e "${INSTALL_PATH}" ]]; then
    echo -e ${YELLOW}"Remove ${INSTALL_PATH}"${CLOSE}
    rm -rf ${INSTALL_PATH}
fi

# 安装 Homebrew
which brew > /dev/null 2>&1
if [[ "$?" -ne 0 ]]; then
    echo -e ${GREEN}"Install Homebrew ..."${CLOSE}

    # 修改install脚本中的"BREW_REPO"、"CORE_TAP_REPO"等变量, 修改为清华大学的镜像, 实现加速下载
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | \
                        sed 's/https:\/\/github.com\/Homebrew\/brew/git:\/\/mirrors.ustc.edu.cn\/brew.git/g' | \
                        sed 's/https:\/\/github.com\/Homebrew\/homebrew-core/git:\/\/mirrors.ustc.edu.cn\/homebrew-core.git/g' | \
                        sed 's/\"fetch\"/\"fetch\", \"-q\"/g')" < /dev/null > /dev/null

    # 修改源
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
else
    echo -e ${BLUE}"You have already installed Homebrew"${CLOSE}
fi

# 安装git
echo -e ${GREEN}"Install git ..."${CLOSE}
brew install git

git clone --depth=1 -b ${BRANCH} ${GIT_REPO_URL} ${INSTALL_PATH}
cd ${INSTALL_PATH}
bash install.sh