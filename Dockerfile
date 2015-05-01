FROM java:openjdk-8u45-jdk
MAINTAINER ototadana@gmail.com

RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --force-yes sonar=5.1 \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-ldap-plugin/1.4/sonar-ldap-plugin-1.4.jar -P /opt/sonar/extensions/plugins
RUN wget http://repository.codehaus.org/org/codehaus/sonar-plugins/javascript/sonar-javascript-plugin/2.5/sonar-javascript-plugin-2.5.jar -P /opt/sonar/extensions/plugins

COPY ./config/. /config/
RUN chmod +x /config/*

VOLUME ["/opt/sonar/conf", "/opt/sonar/data", "/opt/sonar/extensions"]
EXPOSE 9000

ENTRYPOINT ["/config/entrypoint"]
CMD ["/opt/sonar/bin/linux-x86-64/sonar.sh", "console"]
