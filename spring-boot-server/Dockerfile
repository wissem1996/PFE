FROM wissemgh5/pfe_jdk8:40e5c3e145a3e0c6a20e9e4e817db0943316841c
WORKDIR /opt/backend
ENV DBNAME=${DBNAME}
ENV DBHOST=${DBHOST}
ENV DBUSERNAME=${DBUSERNAME}
ENV DBPASSWD=${DBPASSWD}
ARG JAR_FILE=./spring-boot-server/target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY --chown=pfe:pfe ${JAR_FILE} app.jar
RUN chmod 775  /opt/backend/entrypoint.sh
ENTRYPOINT ["/opt/backend/entrypoint.sh"]
