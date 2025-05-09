#!/bin/bash

# CloudFormationスタックを削除するスクリプト

# スタック名とリージョンを設定
STACK_NAME="mcp-claude-ec2-stack"
REGION="ap-northeast-1"  # 東京リージョン

# 確認メッセージ
echo "警告: スタック $STACK_NAME とそのすべてのリソースを削除します"
read -p "続行しますか？ (y/n): " confirm

if [[ $confirm != "y" && $confirm != "Y" ]]; then
  echo "操作をキャンセルしました"
  exit 0
fi

# スタックが存在するか確認
if aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION 2>&1 | grep -q 'does not exist'; then
  echo "スタック $STACK_NAME は存在しません"
  exit 0
fi

# スタックを削除
echo "スタック $STACK_NAME を削除しています..."
aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION

# 削除完了を待機
echo "スタックの削除を開始しました。完了まで数分かかります..."
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION

if [ $? -eq 0 ]; then
  echo "スタック $STACK_NAME の削除が完了しました"
else
  echo "スタックの削除に失敗しました。CloudFormationコンソールでエラーを確認してください"
  exit 1
fi
