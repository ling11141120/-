#!/bin/bash

author_line=$1
CI_COMMIT_MESSAGE=$2
CI_COMMIT_SHA=$3
CHANGED_FILES=$4



# 遍历数组
for file in "${CHANGED_FILES[@]}"; do
  # 转义变量中的特殊字符（如双引号）
  safe_commit_message=$(echo "$CI_COMMIT_MESSAGE" | sed 's/"/\\"/g')
  safe_file_content=$(cat "$file" | sed 's/"/\\"/g' | tr '\n' ' ')

echo 1
echo $author_line
echo 2
echo $safe_commit_message
echo 3
echo $CI_COMMIT_SHA
echo 4
echo $file
echo 5
echo $safe_file_content


  # 正确闭合 JSON 结构
  curl -X POST \
    http://192.168.21.192:8866/bigData/webhook/commit \
    -H "Content-Type: application/json" \
    -d "{
      \"commitBy\": \"$author_line\",
      \"commitInfo\": \"$safe_commit_message\",
      \"uuid\": \"$CI_COMMIT_SHA\",
      \"isEnd\": true,
      \"fileInfo\": {
      \"fileName\": \"$file\",
      \"content\": \"$safe_file_content\"
      }
    }"  # 闭合 JSON 和引号
  done