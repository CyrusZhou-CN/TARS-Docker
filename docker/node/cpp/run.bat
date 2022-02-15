
docker run -tid --name openeuler_cpp  --privileged=true lsqtzj/openeuler_tars_node:cpp  /sbin/init
docker exec -it openeuler_cpp /bin/bash