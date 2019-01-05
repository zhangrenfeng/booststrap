# Program:
#    用来保存常用路径, 支持tab键自动完成
# History:
#    2018/12/28     renfeng.zhang   0.1.0
# Usage:
#   使用小写字母表示时, 与系统命令冲突, 故都定义成大写形式
#   例如: 在终端中输入g会被快捷定位为git, 输入l会被定位为ls -l命令
#   解决办法: vim ~/.bashrc, 找到关于g, l的alias配置, 注释掉即可.
#            而本脚本的解决办法是直接使用大写形式定义命令
#       S <bookmark_name> - 保存当前路径, 名字为bookmark_name
#       G <bookmark_name> - 直接跳转到'bookmark_name'对应的路径
#       L                 - 列出所有的bookmark
#       D <bookmark_name> - 删除bookmark
#       P <bookmark_name> - 输出与"bookmark_name"关联的目录
#
# Reference:
#   https://github.com/huyng/bashmarks/blob/master/bashmarks.sh

source "$HOME/.bootstrap/colorful.sh"

# setup file to store bookmarks
if [[ ! -n "$SAVEDIRS" ]]; then
    SAVEDIRS=~/.sdirs
fi
touch $SAVEDIRS

# print out help for foregetful
function check_help
{
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        echo ""
        echo_yellow "S <bookmark_name> - Saves the current directory as 'bookmark_name'"
        echo_yellow "G <bookmark_name> - Goes (cd) to the directory associated with 'bookmark_name'"
        echo_yellow "P <bookmark_name> - Prints the directory associated with 'bookmark_name'"
        echo_yellow "D <bookmark_name> - Deletes the bookmark"
        echo_yellow "L                 - Lists all available bookmarks"
        kill -SIGINT $$
    fi
}

# validate bookmark name
function _bookmark_name_valid
{
    error_message=""
    if [[ -z "$1" ]]; then
        error_message="bookmark name required"
        echo_red $error_message
    elif [[ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]]; then
        error_message="bookmark name is not valid"
        echo_red $error_message
    fi
}

# safe delete line from sdirs
function _purge_line
{
    if [[ -s "$1" ]]; then
        # safely create a temp file
        t=$(mktemp -t bashmarks.XXXXXX) || exit 1
        # when current script completed, execute command "/bin/rm -f -- '$t'"
        trap "/bin/rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        /bin/mv "$t" "$1"

        # cleanup temp file
        /bin/rm -f -- "$t"
        trap - EXIT
    fi
}

# save current directory to bookmarks
function S
{
    check_help $1
    _bookmark_name_valid "$@"
    if [[ -z "$error_message" ]]; then
        # remove already bookmarks
        _purge_line "$SAVEDIRS" "export DIR_$1="
        CURDIR=$(echo $PWD | sed "s#^$HOME#\$HOME#g")
        echo "export DIR_$1=\"$CURDIR\"" >> $SAVEDIRS
    fi
}

# jump to bookmark
function G
{
    check_help $1
    source $SAVEDIRS
    target="$(eval $(echo echo $(echo \$DIR_$1)))"
    if [[ -d "$target" ]]; then
        cd "$target"
    elif [[ ! -n "$target" ]]; then
        echo_red "Warning: '${1}' bookmark does not exist"
    else
        echo_red "Warning: '${target} does not exit'"
    fi
}

# print bookmark
function P
{
    check_help $1
    source $SAVEDIRS
    target="$(eval $(echo echo $(echo \$DIR_$1)))"
    echo_green "$target"
}

# delete bookmark
function D
{
    check_help $1
    _bookmark_name_valid "$@"
    if [[ -z "$error_message" ]]; then
        _purge_line "$SAVEDIRS" "export DIR_$1="
        unset "$DIR_$1"
    fi
}

# list bookmarks with dirname
function L
{
    check_help $1
    source $SAVEDIRS

    # if color output is not working for you, comment out the line below '\033[1;32m' == "red"
    env | sort | awk '/^DIR_.+/{split(substr($0,5),parts,"="); printf("\033[0;33m%-20s\033[0m %s\n", parts[1], parts[2]);}'

    # uncomment this line if color output is not working with the line above
    # env | grep "^DIR_" | cut -c5- | sort | grep "^.*="
}

# list bookmarks without dirname
function _L
{
    source $SAVEDIRS
    env | grep "^DIR_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "="
}

# completion command
function _comp
{
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_L`' -- $curw))
    return 0
}

# ZSH completion command
function _compzsh
{
    reply=($(_L))
}

# bind completion command for G, P, D to _comp
if [[ $ZSH_VERSION ]]; then
    compctl -K _compzsh G
    compctl -K _compzsh P
    compctl -K _compzsh D
else
    shopt -s progcomp
    complete -F _comp G
    complete -F _comp P
    complete -F _comp D
fi
