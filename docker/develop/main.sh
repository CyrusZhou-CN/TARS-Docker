#!/bin/bash
set -e
source /opt/publish.sh
echo -e "\033[32m ==> START SUCCESSFUL ... \033[0m"
echo -e "\033[32m 创建项目脚手架命令 \033[0m"
/usr/local/tars/cpp/script/cmake_http_server.sh
/usr/local/tars/cpp/script/cmake_tars_server.sh
/usr/local/tars/cpp/script/create_tars_server.sh
/usr/local/tars/cpp/script/create_http_server.sh
echo -e "\033[32m 发布服务设置命令 \033[0m"
echo -e "\033[32m cd project/build  \033[0m"
echo -e "\033[32m cmake .. -DTARS_WEB_HOST=\${WEBHOST} -DTARS_TOKEN=\${TARS_TOKEN} \033[0m"
echo -e "\033[32m 编译命令帮助 \033[0m"
echo -e "\033[32m make help \033[0m"
waitterm() {
        local PID
        # any process to block
        tail -f /dev/null &
        PID="$!"
        # setup trap, could do nothing, or just kill the blocker
        trap "kill -TERM ${PID}" TERM INT
        # wait for signal, ignore wait exit code
        wait "${PID}" || true
        # clear trap
        trap - TERM INT
        # wait blocker, ignore blocker exit code
        wait "${PID}" 2>/dev/null || true
}
waitterm

echo "==> STOP"

echo "==> STOP SUCCESSFUL ..."