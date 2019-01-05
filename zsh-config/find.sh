# 此处只是为了在本地测试而注释
source "$HOME/.bootstrap/colorful.sh"

# 通过名称来查找文件
function fn()
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "$1"
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "$2"
    else
        echo_yellow "Usage: fn [DIRECTORY] <pattern>"
    fi
}

# 根据扩展名来查找文件
function fe()
{
    if [[ "$#" -eq 1 ]]; then
        find . -name "*.$1"
    elif [[ "$#" -eq 2 ]]; then
        find "$1" -name "*.$2"
    else
        echo_yellow "Usage: fe [DIRECTORY] <extension>"
    fi
}