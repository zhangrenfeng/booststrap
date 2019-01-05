#!/usr/bin/env bash
# Program:
#   echo命令的输出颜色控制
#
# History:
#   2018/12/17  renfeng.zhang   0.1.0
#
# Usage:
#


# 定义颜色
BLUE="\033[34m"             # 蓝色
GREEN="\033[32m"            # 绿色
BLACK="\033[30m"            # 黑色
RED="\033[31m"              # 红色
YELLOW="\033[33m"           # 黄色
PURPLE="\033[35m"           # 紫色
CAYAN="\033[36m"            # 深绿
WHITE="\033[37m"            # 白色

# 控制码
CLOSE="\033[0m"             # 关闭所有属性
HIGHLIGHT="\033[01m"        # 设置高亮度
UNDERLINE="\033[04m"        # 下划线
BLINK="\033[05m"            # 闪烁

# 输出蓝色
function echo_blue()
{
    echo -e ${BLUE}$1${CLOSE}
}

# 输出绿色
function echo_green()
{
    echo -e ${GREEN}$1${CLOSE}
}

function echo_black()
{
    echo -e ${BLACK}$1${CLOSE}
}

function echo_red()
{
    echo -e ${RED}$1${CLOSE}
}

function echo_yellow()
{
    echo -e ${YELLOW}$1${CLOSE}
}

function echo_purple()
{
    echo -e ${PURPLE}$1${CLOSE}
}

function echo_cayan()
{
    echo -e ${CAYAN}$1${CLOSE}
}

function echo_white()
{
    echo -e ${WHITE}$1${CLOSE}
}