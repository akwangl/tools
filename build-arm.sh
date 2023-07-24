#!/bin/bash

# 清理目标目录
mvn clean

# 编译项目
mvn package

# 查找JAR文件
jar_file=$(find target -name "*.jar" | grep -v "sources" | grep -v "javadoc")
jar_file_name=$(basename "$jar_file")
echo "The JAR file is: $jar_file_name"

build_date=$(date +'%Y%m%d%-H%M%S')

image_name=voyah-image-store.tencentcloudcr.com/bigdata-center/db-ops:"$build_date"

# 在使用此脚本前请先装好必要环境 如`docker buildx`和一些cpu架构指令 参考文档https://dockerworld.cn/?id=316
docker buildx build --platform linux/amd64 -t "$image_name" --build-arg timestamp="$image_name" --build-arg JAR_FILE="$jar_file_name" --load .

docker push "$image_name"

# 删除目标目录
rm -rf target/

docker rmi "$image_name"
