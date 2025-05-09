# mcp-claude-test

Claude APIを使用したテストリポジトリです。

## 概要
このリポジトリはClaudeを使用したGitHub操作のテスト用に作成されました。TypeScriptでHello Worldを出力する簡単なプログラムと、AWS EC2インスタンスを構築するCloudFormationテンプレートを含んでいます。

## 機能
- TypeScript実装
  - 基本的な「Hello, World!」の出力
  - 名前を指定して挨拶するカスタマイズ機能
- AWS CloudFormation
  - EC2インスタンス構築テンプレート
  - デプロイ用スクリプト
  - リソース削除スクリプト

## TypeScriptのセットアップと使用方法

### 必要条件
- Node.js (v14以上)
- npm または yarn

### インストール
```bash
# リポジトリをクローン
git clone https://github.com/NakagawaTKQ/mcp-claude-test.git
cd mcp-claude-test

# 依存パッケージのインストール
npm install
# または
yarn install
```

### 使い方

#### 開発モード
```bash
npm run dev
# または
yarn dev
```

#### ビルドと実行
```bash
# TypeScriptのコンパイル
npm run build
# または
yarn build

# コンパイルされたJavaScriptの実行
npm start
# または
yarn start
```

## AWS CloudFormationの使用方法

### 必要条件
- AWSアカウント
- AWS CLI（設定済み）
- EC2キーペア

### EC2インスタンスのデプロイ
```bash
cd cloudformation
chmod +x deploy.sh
./deploy.sh <キーペア名>
```

### EC2インスタンスの削除
```bash
cd cloudformation
chmod +x cleanup.sh
./cleanup.sh
```

詳しい情報は [cloudformation/README.md](cloudformation/README.md) を参照してください。

## ブランチ構成
- main: 本番環境用ブランチ
- dev: 開発用ブランチ（現在のブランチ、TypeScriptコードとCloudFormationテンプレート含む）

## ライセンス
MIT
