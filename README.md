# 基本的なAWS環境の構築

## Usage
### Terraform
1.Terraformの実行用のコンテナを作成して、ログインする。
```
$ docker-compose build
$ docker-compose run --rm tf bash
```

2.ログインしたコンテナ内で、Terraformを実行する。
```
$ cd /tf
$ /var/tmp/terraform init
$ /var/tmp/terraform plan or apply
```
