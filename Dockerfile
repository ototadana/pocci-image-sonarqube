FROM openjdk:8u102-jdk
MAINTAINER ototadana@gmail.com

ENV SONARQUBE_VERSION 6.0
ENV SONAR_LDAP_PLUGIN 2.0
ENV SONAR_JAVASCRIPT_PLUGIN 2.17.0.3154
ENV SONAR_FINDBUGS_PLUGIN 3.3
ENV SONAR_GITLAB_PLUGIN 1.7.0
ENV SONAR_L10N_JA_PLUGIN 1.4-SNAPSHOT

RUN echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --force-yes logrotate sonar=${SONARQUBE_VERSION} vim \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-${SONAR_LDAP_PLUGIN}.jar -P /opt/sonar/extensions/plugins
RUN wget https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-${SONAR_JAVASCRIPT_PLUGIN}.jar -P /opt/sonar/extensions/plugins
RUN wget https://sonarsource.bintray.com/Distribution/sonar-findbugs-plugin/sonar-findbugs-plugin-${SONAR_FINDBUGS_PLUGIN}.jar -P /opt/sonar/extensions/plugins
RUN wget http://nexus.talanlabs.com/content/groups/public_release/com/synaptix/sonar-gitlab-plugin/${SONAR_GITLAB_PLUGIN}/sonar-gitlab-plugin-${SONAR_GITLAB_PLUGIN}.jar -P /opt/sonar/extensions/plugins
RUN wget http://xpfriend.com/files/sonar-l10n-ja-plugin-${SONAR_L10N_JA_PLUGIN}.jar -P /opt/sonar/extensions/plugins

COPY ./config/. /config/
RUN mv /config/sonar.logrotate.conf /etc/logrotate.d/sonar
RUN chmod +x /config/*


VOLUME ["/opt/sonar/conf", "/opt/sonar/data", "/opt/sonar/extensions", "/opt/sonar/logs"]
EXPOSE 9000

ENTRYPOINT ["/config/entrypoint"]
CMD ["/opt/sonar/bin/linux-x86-64/sonar.sh", "console"]
