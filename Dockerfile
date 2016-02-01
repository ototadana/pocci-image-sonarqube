FROM java:openjdk-8u66-jdk
MAINTAINER ototadana@gmail.com

RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --force-yes logrotate sonar=5.3 \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-1.5.1.jar -P /opt/sonar/extensions/plugins
RUN wget https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-2.10.jar -P /opt/sonar/extensions/plugins
RUN wget https://sonarsource.bintray.com/Distribution/sonar-findbugs-plugin/sonar-findbugs-plugin-3.3.jar -P /opt/sonar/extensions/plugins

COPY ./config/. /config/
RUN mv /config/sonar.logrotate.conf /etc/logrotate.d/sonar
RUN chmod +x /config/*


VOLUME ["/opt/sonar/conf", "/opt/sonar/data", "/opt/sonar/extensions", "/opt/sonar/logs"]
EXPOSE 9000

ENTRYPOINT ["/config/entrypoint"]
CMD ["/opt/sonar/bin/linux-x86-64/sonar.sh", "console"]
