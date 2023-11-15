FROM wissemgh5/pfe_jdk8:d5243d71a621e3b4c1c2a0d0ead849dd7d633556
WORKDIR /opt/backend
ENV DBNAME=${DBNAME}
ENV DBHOST=${DBHOST}
ENV DBUSERNAME=${DBUSERNAME}
ENV DBPASSWD=${DBPASSWD}
ARG JAR_FILE=./spring-boot-server/target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY --chown=pfe:pfe ${JAR_FILE} app.jar
RUN chmod 775  /opt/backend/entrypoint.sh
ENTRYPOINT ["/opt/backend/entrypoint.sh"]
