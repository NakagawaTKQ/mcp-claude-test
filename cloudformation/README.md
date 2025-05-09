# CloudFormation EC2インスタンス構築ガイド

このディレクトリにはAWS CloudFormationテンプレートが含まれており、基本的なEC2インスタンスを簡単にデプロイできます。

## テンプレートの概要

`ec2-template.yaml`は以下のリソースを作成します：

- EC2インスタンス（Amazon Linux 2）
- セキュリティグループ（SSH、HTTP、HTTPSを許可）
- Elastic IP（固定IPアドレス）

インスタンスは自動的に以下の設定を行います：
- システムアップデート
- Apache HTTPサーバーのインストールと起動
- シンプルなWebページの設定

## 前提条件

- AWSアカウント
- AWS CLIがインストールされていること
- 適切なIAM権限
- EC2キーペア（SSH接続用）

## デプロイ方法

### AWS Management Consoleを使用する場合

1. [AWS CloudFormation コンソール](https://console.aws.amazon.com/cloudformation) にアクセスします
2. 「スタックの作成」をクリックします
3. 「テンプレートの準備完了」を選択します
4. 「テンプレートファイルのアップロード」を選択し、`ec2-template.yaml`をアップロードします
5. ウィザードに従ってパラメータを設定します：
   - スタック名（任意の名前）
   - インスタンスタイプ（デフォルトは t2.micro）
   - キーペア名（既存のEC2キーペア）
   - SSHアクセス許可IPアドレス範囲（デフォルトは 0.0.0.0/0、すべてのIPからアクセス可能）
6. 「次へ」をクリックし、オプションのタグやアクセス許可を設定します
7. 「次へ」をクリックし、設定を確認して「スタックの作成」をクリックします

### AWS CLIを使用する場合

```bash
aws cloudformation create-stack \
  --stack-name my-ec2-stack \
  --template-body file://ec2-template.yaml \
  --parameters \
    ParameterKey=InstanceType,ParameterValue=t2.micro \
    ParameterKey=KeyName,ParameterValue=your-key-pair-name \
    ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0
```

## デプロイ後の操作

デプロイが完了すると、CloudFormationスタックの「出力」タブに以下の情報が表示されます：

- インスタンスID
- パブリックIPアドレス
- パブリックDNS名
- ElasticIPアドレス
- WebサイトURL

HTTPサーバーが正常に起動していれば、WebサイトURLにアクセスすると「Hello from CloudFormation」というメッセージが表示されます。

## SSHでの接続方法

```bash
ssh -i /path/to/your-key-pair.pem ec2-user@<パブリックIPアドレス>
```

## スタックの削除

不要になったリソースを削除するには：

### コンソールから削除する場合
1. CloudFormationコンソールで該当するスタックを選択します
2. 「削除」をクリックします
3. 削除を確認します

### CLIから削除する場合
```bash
aws cloudformation delete-stack --stack-name my-ec2-stack
```

## カスタマイズ

テンプレートをカスタマイズして、以下のようなリソースを追加することも可能です：

- 追加のセキュリティグループルール
- ボリューム（EBS）の追加
- 自動スケーリング
- ロードバランサー

## 注意事項

- このテンプレートはデフォルトで t2.micro インスタンスをデプロイします（AWS無料枠に対応）
- セキュリティ上の理由から、実運用環境では SSHLocation パラメータを特定のIPアドレスまたはCIDR範囲に制限することをお勧めします
