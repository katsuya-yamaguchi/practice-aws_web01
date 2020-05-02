# 基本的なAWS環境の構築

## Usage
### docker imagesの作成
1.コンテナを作成する。
```
$ docker-compose build
$ docker-compose run --rm tf bash
```

### Packer & Ansible
1.AWSクレデンシャル情報を環境変数に設定する。
```
$ export AWS_ACCESS_KEY_ID=[アクセスキー]
$ export AWS_SECRET_KEY_ID=[シークレットキー]
```

2.PackerでAMIを作成する。
```
$ cd /tf/packer
$ /var/tmp/packer build goldenimage.web.json
```

### Terraform
1.ログインしたコンテナ内で、Terraformを実行する。
```
$ cd /tf/terraform/[対象のサービス]/env/[dev or prd]
$ /var/tmp/terraform init
$ /var/tmp/terraform plan or apply
-> AMI_IMAGE_ID を聞かれるので使用するAMIを入力する。
```
