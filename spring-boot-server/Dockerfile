FROM wissemgh5/pfe_jdk8:b07b8c0aaa397484733c71b90cbc37d5f944a9c0
WORKDIR /opt/backend
ENV DBNAME=${DBNAME}
ENV DBHOST=${DBHOST}
ENV DBUSERNAME=${DBUSERNAME}
ENV DBPASSWD=${DBPASSWD}
ARG JAR_FILE=./spring-boot-server/target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY --chown=pfe:pfe ${JAR_FILE} app.jar
RUN chmod 775  /opt/backend/entrypoint.sh
ENTRYPOINT ["/opt/backend/entrypoint.sh"]
