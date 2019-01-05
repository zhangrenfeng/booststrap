# Program:
#   一些工具方法
# History:
#   2018/12/27  renfeng.zhang   0.1.0

# 引入echo颜色输出控制
source colorful.sh

# 使用brew安装软件
function brew_install()
{
    # 静默安装
    quiet=false

    while getopts ":q" opt
    do
        case $opt in
            q )
                quiet=true
                ;;

            ? )
                echo_red "Unrecognized argument ..."
                echo_yellow "Usage: brew_install [-q] package_name ... "
                ;;
        esac
    done

    shift $(($OPTIND - 1))

    # 软件名称是否为空
    if [[ -z "$1" ]]; then
        echo_yellow "Usage: brew_install [-q] package_name ... "
    fi

    # 软件没有安装
    if [[ ! -e /usr/local/bin/$1 ]]; then
        if [[ false == "$quiet" ]]; then
            echo_green "Installing $1"
        fi
        brew install $1
    else
        if [[ false == "$quiet" ]]; then
            echo_blue "You have installed $1"
        fi
    fi
}

# 备份文件
function backup_file()
{
    if [[ $# -ne 1 ]]; then
        echo_yellow "Usage: backup_file path_to_file"
        exit 0
    fi

    if [[ -e $1 ]]; then
        mv $1 $1"_backup"
    fi
}