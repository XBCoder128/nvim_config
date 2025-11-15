#!/bin/zsh

# 检查是否提供了路径参数
if [ -z "$1" ]; then
    echo "please provide the path of the gif"
    echo "example: ../image/gif_1"
    exit 1
fi

GIF_PATH="$1"

# 检查是否提供了路径参数
if [ -z "$2" ]; then
    echo "please provide the delay of the gif"
    echo "example: 0.1"
    exit 1
fi

DELAY="$2"

# 检查路径是否存在
if [ ! -d "$GIF_PATH" ]; then
    echo "错误: 路径 '$GIF_PATH' 不存在"
    exit 1
fi

IMAGES=($GIF_PATH/*)

i=1

IMAGE_VALUES=()

for image in $IMAGES; do
    IMAGE_VALUES+=$(chafa $image --format symbols --symbols vhalf --size 56x25 --stretch)
    # 循环体
done

while true
do
    for img_value in $IMAGE_VALUES; do
        echo $img_value
        sleep $DELAY
        clear
    done
done
