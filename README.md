# TARS Docker 测试开发环境

## 说明
基于openeuler系统，包含 DCache TarsGateway TarsBenchmark
## 使用方式
### 直接启动docker
docker-compose -f "docker-compose.yml" up -d
### 源码编译
docker-compose -f "docker-compose.build.yml" up -d --build
### 官方Docker
docker-compose -f "docker-compose-tars.yml" up -d
## 管理控制台
http://localhost:3000/ 首次登录需要设置管理员密码。
# tars-develop 容器说明
基于openeuler 系统， 用来测试编译源码，和 develop 目录同步。
### 进入容器：
```
docker exec -it tars-develop /bin/bash # 
```
### 创建项目：
```
cmake_http_server.sh App  Server  Servant
cmake_tars_server.sh App  Server  Servant
```
### 发布服务设置命令：
```
cmake .. -DTARS_WEB_HOST=${WEBHOST} -DTARS_TOKEN=${TARS_TOKEN} 
```
### 编译命令帮助
``` 
 make help 
```