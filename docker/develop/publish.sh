#!/bin/bash
set -e
function checkStart() {
        local name=$1
        local cmd=$2
        local timeout=$3
        #隐藏光标
        printf "\e[?25l" 
        i=0
        str=""
        bgcolor=43
        space48="                       "    
        #echo "check $name ..."
        #echo "CMD: $cmd"
        isrun=0
        while [ $timeout -gt 0 ]
        do
                ST=`eval $cmd`
                if [ "$ST" -gt 0 ]; then
                        isrun=1
                        break
                else
                        percentstr=$(printf "%3s" $i)
                        totalstr="${space48}${percentstr}${space48}"
                        leadingstr="${totalstr:0:$i+1}"
                        trailingstr="${totalstr:$i+1}"
                        # 打印进度,#docker LOGS 中进度条不刷新
                        printf "\r\e[30;47m${leadingstr}\e[37;40m${trailingstr}\e[0m"
                        let i=$i+1
                        str="${str}="
                        sleep 1
                        let timeout=$timeout-1
                fi
        done
        echo ""
        if [ $isrun == 1 ]; then
                echo -e "\033[32m $name start successful \033[0m" 
        else
                echo -e "\033[31m $name start timeout \033[0m"
                exit 1;
        fi
        #显示光标
        printf "\e[?25h""\n"
}
# 自动添加 TARS_TOKEN 

function setup_token() {
        if [ "${TARS_BENCHMARK}" == true ] ||  [ "${TarsGateway}" == true ] || [ "${DCACHE}" == true  ];then
                if [ -z "${TARS_TOKEN}" ]; then 
                        echo -e "\033[31m TARS_TOKEN 必须设置,TarsWeb管理端的token，可以通过管理端获取http:\/\/webhost:3000\/auth.html#\/token \033[0m"
                        exit 1
                fi
                if [ -z "${MYSQL_HOST}" ];then
                        echo -e "\033[31m MYSQL_HOST 必须设置,tarsdb 所在的数据库服务器ip \033[0m" 
                        exit 1
                fi
                if [ -z "${MYSQL_USER}" ];then
                        echo -e "\033[31m MYSQL_USER 必须设置,tarsdb 用户名（需要有建库建表权限） \033[0m" 
                        exit 1
                fi
                if [ -z "${MYSQL_ROOT_PASSWORD}" ];then
                        echo -e "\033[31m MYSQL_ROOT_PASSWORD 必须设置,tarsdb 密码。 \033[0m" 
                        exit 1
                fi
                if [ -z "${MYSQL_PORT}" ];then
                        echo -e "\033[31m MYSQL_PORT 必须设置,tarsdb 端口。 \033[0m" 
                        exit 1
                fi
                if [ ! -f "/install/.TOKEN" ];then
                        checkStart "检查mysql是否启动..." "echo start | mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_ROOT_PASSWORD} -e 'SELECT uid FROM db_user_system.t_user_info;' | grep -c admin" 120
                        # 添加TOKEN
                        mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_ROOT_PASSWORD} -e "INSERT INTO db_user_system.t_token(uid,token,valid,expire_time,update_time)VALUES('admin','${TARS_TOKEN}',1,'2050-01-01',now());"
                        echo -e "\033[32m TOKEN 添加完成，删除文件，重启容器，可重新添加 \033[0m"
                        echo "TOKEN 添加完成，删除文件，重启容器，可重新添加" >/install/.TOKEN
                fi
        fi
}

function setup_benchmark() {
        if [ "${TARS_BENCHMARK}" == true ];then
                if [ ! -f "/install/.TarsBenchmark" ];then
                        echo -e "\033[32m 部署 TarsBenchmark ... \033[0m"
                        if [ -z "${TARS_TOKEN}" ]; then 
                                echo -e "\033[31m TARS_TOKEN 必须设置,TarsWeb管理端的token，可以通过管理端获取http:\/\/webhost:3000\/auth.html#\/token \033[0m"
                                exit 1
                        fi
                        if [ -z "${WEBHOST}" ];then
                                echo -e "\033[31m WEBHOST 必须设置, TarsWeb管理端的url, 例如: http:\/\/webhost:3000 (注意不要少了http地址) \033[0m"
                                exit 1
                        fi
                        if [ -z "${ADMINSIP}" ];then
                                echo -e "\033[31m ADMINSIP  必须设置,压测管理服务AdminServer部署的IP地址，AdminServer必须单点部署。 \033[0m" 
                                exit 1
                        fi
                        if [ -z "${NODEIP}" ];then
                                echo -e "\033[31m NODEIP 必须设置,压测节点服务NodeServer部署的IP地址，建议和AdminServer分开部署。 \033[0m" 
                                exit 1
                        fi
                        cd /develop
                        if [ ! -d "/develop/TarsBenchmark" ];then
                                git clone https://github.com/lsqtzj/TarsBenchmark.git
                        fi
                        cd /develop/TarsBenchmark
                        ./install.sh ${WEBHOST} ${TARS_TOKEN} ${ADMINSIP} ${NODEIP}
                        echo -e "\033[32m TarsBenchmark 发布完成，删除文件，重启容器，可重新编译发布 \033[0m"
                        echo "TarsBenchmark 发布完成，删除文件，重启容器，可重新编译发布" >/install/.TarsBenchmark
                fi
        fi
}

function setup_gateway() {
        if [ "${TarsGateway}" == true ];then
                if [ ! -f "/install/.TarsGateway" ];then
                        echo -e "\033[32m 部署 TarsGateway ... \033[0m"
                        if [ -z "${TARS_TOKEN}" ]; then 
                                echo -e "\033[31m TARS_TOKEN 必须设置,TarsWeb管理端的token，可以通过管理端获取http:\/\/webhost:3000\/auth.html#\/token \033[0m"
                                exit 1
                        fi
                        if [ -z "${WEBHOST}" ];then
                                echo -e "\033[31m WEBHOST 必须设置, TarsWeb管理端的url, 例如: http:\/\/webhost:3000 (注意不要少了http地址) \033[0m"
                                exit 1
                        fi
                        if [ -z "${GATEWAY_SERVER_IP}" ];then
                                echo -e "\033[31m GATEWAY_SERVER_IP  必须设置,GatewayServer部署的ip，目前这里只支持一个，如果需要更多，后面直接在平台上面扩容即可。 \033[0m" 
                                exit 1
                        fi

                        cd /develop
                        if [ ! -d "/develop/TarsGateway" ];then                        
                                git clone https://github.com/lsqtzj/TarsGateway.git
                        fi
                        cd /develop/TarsGateway/install;
                        ./install.sh ${WEBHOST} ${TARS_TOKEN} ${GATEWAY_SERVER_IP} ${MYSQL_HOST} ${MYSQL_PORT} ${MYSQL_USER} ${MYSQL_ROOT_PASSWORD}
                        echo -e "\033[32m TarsGateway 发布完成，删除文件，重启容器，可重新编译发布 \033[0m"
                        echo "TarsGateway 发布完成，删除文件，重启容器，可重新编译发布" >/install/.TarsGateway
                fi
        fi
}
function setup_dcache() {
        if [ "${DCACHE}" == true ];then
                if [ ! -f "/install/.DCache" ];then
                        echo -e "\033[32m 部署 DCache ... \033[0m"
                        if [ -z "${TARS_TOKEN}" ]; then 
                                echo -e "\033[31m TARS_TOKEN 必须设置,TarsWeb管理端的token，可以通过管理端获取http:\/\/webhost:3000\/auth.html#\/token \033[0m"
                                exit 1
                        fi
                        if [ -z "${WEBHOST}" ];then
                                echo -e "\033[31m WEBHOST 必须设置, TarsWeb管理端的url, 例如: http:\/\/webhost:3000 (注意不要少了http地址) \033[0m"
                                exit 1
                        fi
                        if [ -z "${GATEWAY_SERVER_IP}" ];then
                                echo -e "\033[31m GATEWAY_SERVER_IP  必须设置,GatewayServer部署的ip，目前这里只支持一个，如果需要更多，后面直接在平台上面扩容即可。 \033[0m" 
                                exit 1
                        fi           
                        if [ -z "${DCACHE_MYSQL_IP}" ];then
                                echo -e "\033[31m DCACHE_MYSQL_IP 必须设置,DCACHE MYSQL 所在的数据库服务器ip \033[0m" 
                                exit 1
                        fi
                        if [ -z "${DCACHE_MYSQL_USER}" ];then
                                echo -e "\033[31m DCACHE_MYSQL_USER 必须设置,DCACHE MYSQL 用户名（需要有建库建表权限） \033[0m" 
                                exit 1
                        fi
                        if [ -z "${DCACHE_MYSQL_PASSWORD}" ];then
                                echo -e "\033[31m DCACHE_MYSQL_PASSWORD 必须设置,DCACHE MYSQL 密码。 \033[0m" 
                                exit 1
                        fi
                        if [ -z "${DCACHE_MYSQL_PORT}" ];then
                                echo -e "\033[31m DCACHE_MYSQL_PORT 必须设置,DCACHE MYSQL 端口。 \033[0m" 
                                exit 1
                        fi
                        if [ -z "${DCACHE_NODE_IP}" ];then
                                echo -e "\033[31m DCACHE_NODE_IP 必须设置,公共服务部署节点IP, 部署完成后, 你可以在web平台扩容到多台节点机上 \033[0m" 
                                exit 1
                        fi
                        if [ -z "${DCACHE_CREATE}" ];then
                                local dbcacheweb=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_ROOT_PASSWORD} -e 'show databases;' | grep -c db_dcache_relation)
                                if [ "${dbcacheweb}" == "0" ];then
                                        export DCACHE_CREATE="true"
                                else
                                        export DCACHE_CREATE="false"
                                fi
                                echo "设置 DCACHE_CREATE 默认值：${DCACHE_CREATE}"
                        fi
                        cd /develop
                        if [ ! -d "/develop/DCache" ];then
                                git clone https://github.com/lsqtzj/DCache.git
                        fi
                        mkdir -p /develop/DCache/build
                        cd /develop/DCache/build
                        cmake .. && make -j4 && make release && make tar
                        ../deploy/install.sh ${MYSQL_HOST} ${MYSQL_PORT} ${MYSQL_USER} ${MYSQL_ROOT_PASSWORD} ${DCACHE_MYSQL_IP} ${DCACHE_MYSQL_PORT} ${DCACHE_MYSQL_USER} ${DCACHE_MYSQL_PASSWORD} ${DCACHE_CREATE} ${WEBHOST} ${TARS_TOKEN} ${DCACHE_NODE_IP}
                        {
                                echo "DCache 使用步骤"
                                echo "1、DCache->发布包管理中设置默认。"
                                echo "2、DCache->服务创建->地区->新增地区"
                                echo "3、DCache->服务创建->创建应用"
                                echo "具体参考 https://github.com/Tencent/DCache/blob/master/docs/install.md#4"
                                echo "删除文件，重启容器，可重新编译发布"
                        } >/install/.DCache                
                        echo -e "\033[32m DCache 发布完成 \033[0m"
                        cat /install/.DCache
                fi
        fi
}
if [ -z "${TARS_TOKEN}" ]; then 
        echo -e "\033[31m TARS_TOKEN 必须设置 \033[0m"
        exit 1
fi
if [ -z "${WEBHOST}" ];then
        echo -e "\033[31m WEBHOST 必须设置 \033[0m"
        exit 1
fi
setup_token
setup_benchmark
setup_gateway
setup_dcache