FROM lsqtzj/openeuler_tars_develop
WORKDIR /develop

COPY /docker/develop/main.sh /opt/main.sh
COPY /docker/develop/publish.sh /opt/publish.sh
RUN chmod +x /opt/main.sh && chmod +x /opt/publish.sh

VOLUME [ "/develop" ]

ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]