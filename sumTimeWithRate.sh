#!/bin/bash

# 解析每个参数
declare -A times
for arg in "$@"; do
    # 默认速率为1
    rate=1

    # 检查参数中是否包含逗号
    if [[ $arg == *","* ]]; then
        IFS=',' read -r time rate <<< "$arg"
    else
        time=$arg
    fi

    times+=([$time]=$rate)
done

# 计算总时长
total_seconds=0
for time in "${!times[@]}"; do
    rate=${times[$time]}
    
    # 分解时间为小时、分钟和秒
    IFS=":" read -r hour min sec <<< "$time"
    
    # 计算该时间段的秒数
    seconds=$((hour * 3600 + min * 60 + sec))

    # 应用速率，并使用 awk 进行浮点数除法
    adjusted_seconds=$(awk "BEGIN {print $seconds / $rate}")

    # 累加到总秒数，并使用 awk 进行浮点数加法
    total_seconds=$(awk "BEGIN {print $total_seconds + $adjusted_seconds}")
done

# 将总秒数转换回小时:分钟:秒格式
# 需要将浮点数转换为整数
total_seconds=$(echo "$total_seconds/1" | bc)
hours=$((total_seconds / 3600))
mins=$(((total_seconds % 3600) / 60))
secs=$((total_seconds % 60))

# 输出结果
printf "Total duration: %02d:%02d:%02d\n" $hours $mins $secs
