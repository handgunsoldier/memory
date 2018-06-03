#!/bin/bash


# 清理指定日志文件, 保留最后100行
clean() {
    echo $1
    temp=$(tail -100 $1)
    echo "$temp" > $1
}


file='/var/log/shadowsocks.log/'
clean $file
