---
draft: false
date: 2024-02-24
categories:
  - PostgreSQL
  - Docker
  - ShanghaiTech
---

# Docker 下的 PostgreSQL 以及 Gin / Gorm 编写

最近有项目需要使用到 PostgreSQL，经学长指点最好使用 Docker 部署，由于本人是 Docker 新手，于是有了本篇踩坑日记

<!-- more -->

> [!Warning]
>
> 本文假设您使用的是 Windows 环境，阅读此文时 PostgreSQL 最新版本可能有所变化

## 部署

首先 Search 和 Pull 镜像

```bash
docker search postgres
```

```bash
NAME                                        DESCRIPTION                                      STARS     OFFICIAL   AUTOMATED
postgres                                    The PostgreSQL object-relational database sy…   13123     [OK]
...
```

可以看到官方的镜像在 `OFFICIAL` 栏中被标记了 `[OK]`

```bash
docker pull postgres:latest
```

等待下载完成即可

```bash
latest: Pulling from library/postgres
e1caac4eb9d2: Pull complete
7a2930f13d47: Pull complete
a6c49e965138: Pull complete
ed8dc94f857d: Pull complete
1f07b4807698: Pull complete
a776288d4030: Pull complete
7cbb4adb3448: Pull complete
b6dbd7317d5f: Pull complete
52814b5dc710: Pull complete
b68697689b55: Pull complete
6d80681e3923: Pull complete
4270a9f40aee: Pull complete
d28fa0286314: Pull complete
cb1ee5bc271e: Pull complete
Digest: sha256:0e564daae78c2eea56ba57c64711bb9c408a512ce73cf81f9c78623354dd6976
Status: Downloaded newer image for postgres:latest
docker.io/library/postgres:latest

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview postgres:latest
```

## 查看本地镜像

```bash
docker images
```

```bash
REPOSITORY   TAG              IMAGE ID       CREATED      SIZE
postgres     12.18-bullseye   dc1339e99752   3 days ago   387MB
postgres     latest           eb634efa7ee4   3 days ago   431MB
```

其中 12.18-bullseye 为笔者的老版本镜像

## 以后台模式运行容器

本部分将会运行一个 Postgres 示例

```bash
docker run --name postgres-test -e POSTGRES_PASSWORD=p@ssw0rd -d postgres
```

- `--name`: Container **Name**
- `-e`: **E**nviroment Variables0
  - POSTGRES_PASSWORD: 数据库密码
- `-d`: Docker 镜像名称，可以通过 Repo 名后加 `:[TAG NAME]` 的形式指定 TAG / 版本

> [!Warning] 
> 
> 如果此时卡在 `Unable to find image 'postgres:latest' locally`，说明您现有安装的不是最新版本
> 
> 如需要指定版本号，请手动添加对应 Docker Repository （使用 `docker images` 查询）中的 TAG 标识
>
> 如：`docker run --name postgres-test -e POSTGRES_PASSWORD=p@ssw0rd -d postgres:12.18-bullseye`

此时返回

```bash
55bc748371a501af958ca8106035ad2e6aec75f6e7dbe71d8df5a6de990ad2d9
```

这一长串字符是你的 **容器 ID**（对每个容器来说都是唯一的），由于 PostgreSQL 此时是后台运行的，所以不会返回一个交互式的命令行或者流输出

我们可以使用 `docker ps` 来查看容器的状态、创建时间、端口等信息

```bash
docker ps
```

```bash
CONTAINER ID   IMAGE      COMMAND                   CREATED         STATUS         PORTS      NAMES
55bc748371a5   postgres   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   5432/tcp   postgres-test
```

此时，你已经创建了一个名为 `postgres-test` 的容器实例

> [!Warning]
>
> 值得注意的是
>
> `postgres` 是 PostgreSQL 的默认用户名和数据库名称，默认密码为空，但此处我们指定了密码的环境变量

## 以交互模式运行容器

> 来自官网

```bash
docker run -it --rm --network some-network postgres psql -h some-postgres -U postgres
psql (14.3)
Type "help" for help.
 
postgres=# SELECT 1;
 ?column? 
----------
        1
(1 row)
```

## 停止服务和删除容器

停止服务

```bash
docker stop 55bc748371a5
```

删除容器

```bash
docker remove 55bc748371a5
```

## 环境变量

- `POSTGRES_USER` – Specifies a user with superuser privileges and a database with the same name. Postgres uses the default user when this is empty.
- `POSTGRES_DB` – Specifies a name for your database or defaults to the `POSTGRES_USER` value when left blank. 
- `POSTGRES_INITDB_ARGS` – Sends arguments to `postgres_initdb` and adds functionality
- `POSTGRES_INITDB_WALDIR` – Defines a specific directory for the Postgres transaction log. A transaction is an operation and usually describes a change to your database. 
- `POSTGRES_HOST_AUTH_METHOD` – Controls the `auth-method` for `host` connections to `all` databases, users, and addresses
- `PGDATA` – Defines another default location or subdirectory for database files

## Go 开发

### 启动 PostgreSQL Docker

这里我们将运行一个基于 `postgres:latest` 的名为 `postgres-test` 的容器实例，并且将 `5432` 的 PostgreSQL 端口映射到本地的 `5432` 端口，并且设置密码为 `123456`

```bash
docker run -id --name=postgres-test -v postgre-data:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=p@ssw0rd -e LANG=C.UTF-8 postgres
```

与此同时，我们还

- `-id` 为两个参数的组合
  - `-i` 表示交互模式 (Interactive)
  - `-d` 表示后台运行
- 将本地主机上名为 `postgre-data` 的卷挂载到容器中的 `/var/lib/postgresql/data` 目录
- 使用环境变量 `LANG` 来设置容器的语言环境为 `C.UTF-8`，以支持中文

> [!Note] `postgres` 是 PostgreSQL 的默认用户名和数据库名称

> [!Question] 挂载是如何进行的？

### 使用 Gin / Gorm 编写简单的后端

这里我们将在 `8080` 端口上运行服务，并且我们实现一些简单的功能

- GET
  - 访问 `/` 时的 Hello, World! 消息实现
  - 访问 `/users` 时返回用户列表

```go
package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
  // User Model
}

func main() {
  // Init Gin
  r := gin.Default()

  // Init Gorm
	dsn := "host=localhost user=postgres password=123456 dbname=postgres port=5432 sslmode=disable TimeZone=Asia/Shanghai"

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to database")
	}
	fmt.Println("Successfully connected to database")

	db.AutoMigrate(&User{})

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello, World!",
		})
	})

	r.GET("/users", func(c *gin.Context) {
		var users []User
		db.Find(&users)
		c.JSON(http.StatusOK, users)
	})
  
	err = r.Run(":8080")
	if err != nil {
		log.Fatal(err)
	}
}
```