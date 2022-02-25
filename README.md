# TARS Docker 测试开发环境

## 说明
基于openeuler系统，包含 DCache TarsGateway TarsBenchmark 测试开发环境
## 使用方式
### 直接启动docker
docker-compose -f "docker-compose.yml" up -d
### 源码编译
docker-compose -f "docker-compose.build.yml" up -d --build
### 官方Docker
docker-compose -f "docker-compose-tars.yml" up -d
## 容器说明
![image](https://user-images.githubusercontent.com/4635861/155684352-2ea5e6ba-edba-4566-831c-75b71209c948.png)
### 首次开机需要些时间来编译安装DCache TarsGateway TarsBenchmark 项目，可以点击tars-develop容器查看进度
```
tars-develop                 ： 用来测试编译源码，持久化目录 develop
tars-mysql                   :  mysql 数据库，持久化目录 data\tars-mysql
tars-framework               ： tars管理主机，持久化目录 data\tars-framework 
tars-framework-slave         :  tars备用主机，DCache 主机，持久化目录 data\tars-framework-slave 
tars-node                    ： tars节点主机，持久化目录 data\tars-node 
tars-gateway-server          ： TarsGateway api 网关主机，持久化目录 data\tars-gateway-server 
tars-benchmark-admin-server  ： TarsBenchmark 压力测试管理主机，持久化目录 data\
tars-benchmark-node-server   ： TarsBenchmark 压力测试节点主机，持久化目录 data\tars-benchmark-node-server

```
## 管理控制台
http://localhost:3000/ 首次登录需要设置管理员密码。
![image](https://user-images.githubusercontent.com/4635861/155685132-bd7078d8-43d2-418b-8e9f-d59d5c7a8cfb.png)

### 碰到的问题
打开后页面是空白的，解决方法重新编译web
```
cd develop\TarsWeb\client
npm install 
npm run build 如果出现'.' 不是内部或外部命令，也不是可运行的程序
可以直接运行 ./node_modules/.bin/vue-cli-service build
重新 docker-compose -f "docker-compose.build.yml" up -d --build 编译容器
```
## 进入容器：
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
