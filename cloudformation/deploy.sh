#!/bin/bash

# EC2インスタンスをデプロイするためのスクリプト

# 必要な変数を設定
STACK_NAME="mcp-claude-ec2-stack"
TEMPLATE_FILE="ec2-template.yaml"
REGION="ap-northeast-1"  # 東京リージョン
INSTANCE_TYPE="t2.micro"
SSH_LOCATION="0.0.0.0/0"

# キーペア名の設定
if [ -z "$1" ]; then
  echo "使用方法: $0 <キーペア名>"
  echo "例: $0 my-key-pair"
  exit 1
fi

KEY_NAME=$1

# スクリプトのディレクトリに移動
cd "$(dirname "$0")"

# スタックが存在するか確認
if aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION 2>&1 | grep -q 'does not exist'; then
  echo "スタック $STACK_NAME を作成します..."
  
  # スタックを作成
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
      ParameterKey=KeyName,ParameterValue=$KEY_NAME \
      ParameterKey=SSHLocation,ParameterValue=$SSH_LOCATION \
    --region $REGION

  echo "スタックの作成を開始しました。完了まで数分かかります..."
  
  # スタックの作成完了を待機
  aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION
  
  if [ $? -eq 0 ]; then
    echo "スタックの作成が完了しました。"
  else
    echo "スタックの作成に失敗しました。CloudFormationコンソールでエラーを確認してください。"
    exit 1
  fi
else
  echo "スタック $STACK_NAME を更新します..."
  
  # スタックを更新
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --parameters \
      ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
      ParameterKey=KeyName,ParameterValue=$KEY_NAME \
      ParameterKey=SSHLocation,ParameterValue=$SSH_LOCATION \
    --region $REGION

  # エラーチェック
  if [ $? -ne 0 ]; then
    echo "更新プロセス中にエラーが発生しました。変更がない場合は、このメッセージは無視できます。"
    exit 0
  fi

  echo "スタックの更新を開始しました。完了まで数分かかります..."
  
  # スタックの更新完了を待機
  aws cloudformation wait stack-update-complete --stack-name $STACK_NAME --region $REGION
  
  if [ $? -eq 0 ]; then
    echo "スタックの更新が完了しました。"
  else
    echo "スタックの更新に失敗しました。CloudFormationコンソールでエラーを確認してください。"
    exit 1
  fi
fi

# スタックの出力を表示
echo "-------------------------------------"
echo "デプロイ情報:"
echo "-------------------------------------"
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs' \
  --region $REGION \
  --output table

echo "-------------------------------------"
echo "EC2インスタンスへの接続方法:"
echo "ssh -i /path/to/$KEY_NAME.pem ec2-user@<PublicIP>"
echo "-------------------------------------"
