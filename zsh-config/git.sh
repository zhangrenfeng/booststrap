source "/Users/bytedance/people/booststrap/colorful.sh"

# git add系列别名
alias ga='git add'
alias gaa='git add -A'
alias gai='git add -i'              # 查看所有修改过或已删除文件但没有提交的文件
alias gan='git_add_new_files'       # 添加所有新增的文件
alias gap='git add -p'
alias gau='git add -u'

# git log 系列别名
alias gg='git lg'                   # 查看提交记录, 单行展示提交历史, 也支持展示分支的关系

# git diff 系列别名
alias gd='git diff'
alias gdc='git diff HEAD~ HEAD'     # 查看最近一次提交的变动
alias gds='git diff --staged'       # 查看暂存区的变动, 即查看那些被git add了的文件的变动
alias gdr='git_recursive_diff'

# git branch 系列别名
alias gb='git branch'
alias gcb='git checkout -b'

# git commit 系列别名
alias gc='git ci'
alias gcm='git commit -m'


# gs为"git status"的别名
function gs()
{
    # scmpuff 是一个git扩展, 支持数字快捷键的操作
    # ref: https://github.com/mroth/scmpuff
    # 如: git add 2-3 5
    #     git checkout 4
    if brew ls --versions scmpuff > /dev/null 2>&1; then
        scmpuff_status
    else
        echo_yellow "You have not install scmpuff, use default 'git status' instead"
        echo_yellow "Strongly recommend you to install scmpuff, you can just: brew install scmpuff"
        echo_yellow 'And then add this line to you .zshrc: eval "$(scmpuff init -s --aliases=false)"'
        echo ""

        git status
    fi
}

# gdt为使用icdiff进行diff的"git diff"别名
function gdt()
{
    params="$@"
    if brew ls --versions scmpuff > /dev/null; then
        params=$(scmpuff expand "$@" 2> /dev/null)
    fi

    # ref: https://github.com/jeffkaufman/icdiff
    # icdiff是一个左右水平显示的diff工具
    if [[ "$#" -eq 0 ]]; then
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" | less
    elif [[ "${#params}" -eq 0 ]]; then
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$@" | less
    else
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$params" | less
    fi
}

# git checkout 所有已经修改的文件
function gom()
{
    # 获取已修改的文件
    git ls-files -m $* | while read -r file;
    do
        git checkout "$file"
    done
}

# git push 远程分支
function gpush()
{
    branch=$(git symbolic-ref --short -q HEAD)
    git push origin $branch
}

# git pull 远程分支
function gpull()
{
    branch=$(git symbolic-ref --short -q HEAD)
    git pull origin $branch --rebase
}

# git add 所有新增的文件
function git_add_new_files()
{
    it status --short "$*" | grep '^??' | cut -c 4- | while read -r file;
    do
        git add "$file"
    done
}

function git_recursive_diff()
{
    current=$(git status --short)
    if [[ -n "$current" ]]; then
        pwd
        if [[ -n "$*" ]]; then
            git diff "$*"
        else
            git diff
        fi
    fi

    if [[ -f .gitmodules ]]; then
        cat .gitmodules | awk -F= '/path = /{print $2}' | while read dir;
        do
            (cd $dir; git_recursive_diff "$*")
        done
    fi
}

# gdcr命令查看工作目录同git仓库指定commit内容的差异
# 使用:  gdcr
#       gdcr <SHA-1>
#       gdcr <SHA-1> <file_name>
# 取消某一次commit: gbcr <SHA-1> <file_name> | git apply
#
function gdcr()
{
    commit="$1"
    if [[ -z "$1" ]]; then
        commit="HEAD"
    fi

    if [[ -z "$2" ]]; then
        command="git diff "$commit" "$commit"~"
        eval $command
    else
        command="git diff "$commit" "$commit"~ "$2""
        eval $command
    fi
}

fzf-down()
{
    fzf --height 80% "$@" --border
}

_fzf_complete_gbdr()
{
    # 把origin/branch转换成branch
    local temp
    temp=$(git branch --remote | awk -F / '{ $1=""; print $0}' OFS="/" | cut -c2- | fzf-down --multi --preview-window right:70% --preview 'git show --color=always origin/{1} | head -'$LINES)
    LBUFFER="$1$temp"
    zle redisplay
}

gbdr()
{
    git push origin :$1
}

function when {
    ts '[%H:%M:%.S]'
}

