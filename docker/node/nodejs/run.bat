
docker run -tid --name openeuler_nodejs  --privileged=true lsqtzj/openeuler_tars_node:nodejs  /sbin/init
docker exec -it openeuler_nodejs /bin/bash