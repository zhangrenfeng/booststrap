source "/Users/bytedance/people/booststrap/colorful.sh"

alias o='open'
alias oo='open .'
alias ll='ls -alhG'
alias src='source ~/.zshrc'

export ZRFTEMP='/private/tmp'

function current_networkservice()
{
    network=""
    if [ "$(networksetup -getnetworkserviceenabled Ethernet)" = 'Enabled' ]; then
       network="Ethernet"
    elif [ "$(networksetup -getnetworkserviceenabled Wi-Fi)" = 'Enabled' ]; then
       network="Wi-Fi"
    else
       network=""
    fi

    echo $network
}

function ip()
{
    network=`current_networkservice`
    result=$(networksetup -getinfo $network | grep '^IP address' | awk -F: '{print $2}' | sed 's/ //g')
    echo -e "${GREEN}${network}:${CLOSE}" $result
}

function proxy()
{
    network=$(current_networkservice)
    if [[ -z "$network" ]]; then
        echo_red "Unrecognized network"
        return 1
    fi

    case $1 in
        on )
            networksetup -setwebproxystate $network on;
            networksetup -setsecurewebproxystate $network on;
            networksetup -setwebproxy $network 127.0.0.1 8888;
            networksetup -setsecurewebproxy $network 127.0.0.1 8888;
            networksetup -setautoproxystate $network off;
            networksetup -setsocksfirewallproxystate $network off;
            ;;

        g)
            networksetup -setwebproxystate $network off;
            networksetup -setsecurewebproxystate  $network off;
            networksetup -setautoproxystate $network off;
            networksetup -setsocksfirewallproxy "$network" localhost 14179
            ;;

        off)
            networksetup -setwebproxystate $network off;
            networksetup -setsecurewebproxystate  $network off;
            networksetup -setautoproxystate $network off;
            networksetup -setsocksfirewallproxystate $network off;
            ;;

        s)
            socks_status=$(networksetup -getsocksfirewallproxy $network | head -n 3;)
            socks_enable=$(echo $socks_status | head -n 1 | awk '{print $2}')
            socks_ip=$(echo $socks_status | head -n 2 | tail -n 1 | awk '{print $2}')
            socks_port=$(echo $socks_status | tail -n 1 | awk '{print $2}')

            if [ "$socks_enable" = "Yes" ]; then
                echo -e "${GREEN}Socks: ✔${CLOSE}" $socks_ip ":" $socks_port
            else
                echo -e "${RED}Socks: ✘${CLOSE}" $socks_ip ":" $socks_port
            fi

            http_status=$(networksetup -getwebproxy $network | head -n 3)
            http_enable=$(echo $http_status | head -n 1 | awk '{print $2}')
            http_ip=$(echo $http_status | head -n 2 | tail -n 1 | awk '{print $2}')
            http_port=$(echo $http_status | tail -n 1 | awk '{print $2}')

            if [ "$http_enable" = "Yes" ]; then
                echo -e "${GREEN}HTTP : ✔${CLOSE}" $http_ip ":" $http_port
            else
                echo -e "${RED}HTTP : ✘${CLOSE}" $http_ip ":" $http_port
            fi

            https_status=$(networksetup -getsecurewebproxy $network | head -n 3)
            https_enable=$(echo $https_status | head -n 1 | awk '{print $2}')
            https_ip=$(echo $https_status | head -n 2 | tail -n 1 | awk '{print $2}')
            https_port=$(echo $https_status | tail -n 1 | awk '{print $2}')

            if [ "$https_enable" = "Yes" ]; then
                echo -e "${GREEN}HTTPS: ✔${CLOSE}" $https_ip ":" $https_port
            else
                echo -e "${RED}HTTPS: ✘${CLOSE}" $https_ip ":" $https_port
            fi
            ;;

        *)
            echo ""
            echo_blue "Usage: proxy {on|off|g|s}"
            echo_yellow "proxy on:  Set proxy to Charles (port 8888)"
            echo_yellow "proxy off: Reset proxy to system default"
            echo_yellow "proxy g:   Set proxy to GoAgentx (port 14179)"
            echo_yellow "proxy s:   Show current network proxy status"
            echo_yellow "proxy *:   Show usage"
            echo ""
            ;;
    esac
}

alias p=proxy

# 打开xcworkspace、xcodeproj工程
function ow()
{
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcworkspace > /dev/null 2>&1; then
            for i in *.xcworkspace;
            do
                open "$i"
            done
        elif ls *.xcodeproj > /dev/null 2>&1; then
            for i in *.xcodeproj;
            do
                open "$i"
            done
        else
            echo_red "ERROR: xcode project not exists in '$(pwd)' !"
            echo_blue "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

# 如果不指定文件名, 默认是在当前目录下递归搜索, 否则在指定文件名中搜索
function rgrep()
{
    if [[ "$#" -eq 1 ]]; then
        grep -rn "$1" .
    else
        grep -n "$1" "$pwd/$2"
    fi
}

# 历史命令
function h()
{
    # 移除zsh默认的数字别名
    if $(alias | grep -q '1='); then
        for i in {1..9}; do
            unalias $i
        done
    fi

    history | grep --color=always -i $1 | awk '{$1="";print $0}' | grep -v '^ h' | # 查找关键字，去掉左侧的数字和 h 命令自身 \
    sort | uniq -c | sort -rn | awk '{$1="";print NR " " $0}' | # 先去重（需要排序）然后根据次数排序，再去掉次数 \
    tee ~/.bootstrap/.histfile_color_result | gsed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" |  # 把带有颜色的结果写入临时文件，然后去除颜色 \
    awk '{$1="";print "function " NR "() {" $0 "; echo \": $(date +%s):0;"$0"\" >> ~/.histfile }"}' | # 构造 function，把 $0 写入到 histfile 中 \
    {while read line; do eval $line &>/dev/null; done}  # 调用 eval，让 function 生效
    cat ~/.bootstrap/.histfile_color_result | sed '1!G;h;$!d' # 倒序输出，更容易看到第一条
}

# 快速查看文件夹和文件大小
# 后面的参数可以是文件名,表示查看这个文件的大小. 也可以是文件夹名，表示查看文件夹大小和文件夹内各子目录的大小。
# epsize . 表示查看当前目录大小和子目录大小，epsize / 表示查看系统磁盘的使用情况。具体效果如图所示：
function epsize()
{
    location=$1
    if [ "${location}" = "/" ]; then
        /bin/df -gH
        return
    fi

    if [ -d "${location}" ]; then
        pushd $PWD > /dev/null
        cd ${location}
        du -d 1 -h -c
        if [ "${location}" != "." ]; then
            popd > /dev/null
        fi
    else
        if [ -f "${location}" ]; then
            du -h "${location}"
        else
            echo_red "No such file or directory"
            return
        fi
    fi
}

function autojump_with_fzf()
{
    local dir
    dir=$(cat ~/Library/autojump/autojump.txt | sort -nr | awk '{print $2}' | fzf +s) && cd "$dir"
}

# 默认的find命令并不支持表达式
# 而epfn函数接收一个参数, 可以精确匹配, 也可以写正则表达式
function epfn()
{
    find . \( -type f -or -type l \) | egrep --color=always $1
}

# 使用vscode打开目录或文件
function c()
{
    if [[ "$#" -eq 0 ]]; then
        code .
    elif [[ "$#" -eq 1 ]]; then
        if [[ -f "$1" ]]; then
            code $1
        elif [[ -d "$1" ]]; then
            (cd $1 && code .)
        else
            (j $1 && code .)
        fi
    else
        echo_red "Usage: c <path>"
    fi
}

# 检查端口占用
# 比如查看 redis 进程占用了哪些端口，可以输入 bsof redis，查看哪些进程占用了 80 端口可以输入 bsof :80
function epof()
{
    lsof -nP -i TCP | grep "$1"
}

function wifipassword()
{
    SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`
    PASSWD=$(security find-generic-password -D "AirPort network password" -a "$SSID" -gw)
    echo_cayan "$SSID: \c"
    echo_blue "$PASSWD"
}

# 显示图片的分辨率
function imageinfo()
{
    brew_install -q exiv2
    info=$(exiv2 $1 2> /dev/null)
    echo_cayan $info
}

function xcodepath()
{
    ps `pgrep -x Xcode` R 2 C -1
}



