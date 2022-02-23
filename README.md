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