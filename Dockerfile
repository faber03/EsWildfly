FROM jboss/wildfly:19.0.0.Final
LABEL mantainer="Antonio De Iasio <antonio.deiasio@gmail.com>"

ENV MYSQL_DATABASE customer
ENV MYSQL_HOST 192.168.99.100:3306

USER root
ADD standalone.xml ${JBOSS_HOME}/standalone/configuration/
RUN mkdir -p /home/test/
ADD deployments/startup.sh /home/
RUN chmod +x /home/startup.sh
WORKDIR ${JBOSS_HOME}/modules/system/layers/base/com/mysql/main

ADD module.xml .
RUN curl -O https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.20/mysql-connector-java-8.0.20.jar && \
    chown -R jboss:0 ${JBOSS_HOME} && \
    chmod -R g+rw ${JBOSS_HOME}

EXPOSE 8080
EXPOSE 9990

USER jboss

ADD deployments/Customer-1.0.war /opt/jboss/wildfly/standalone/
ADD deployments/Monolith-1.0.war /opt/jboss/wildfly/standalone/
ADD deployments/Account-1.0.war /opt/jboss/wildfly/standalone/

ENV DEPLOYMENT Monolith-1.0.war

ENV MULTICONT no

WORKDIR /opt/jboss/wildfly/standalone/

RUN /opt/jboss/wildfly/bin/add-user.sh unisannio unisannio --silent

ENTRYPOINT ["/home/startup.sh"]