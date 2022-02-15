
docker run -tid --name openeuler_tars_node_php  --privileged=true lsqtzj/openeuler_tars_node:php /sbin/init
docker exec -it openeuler_tars_node_php /bin/bash