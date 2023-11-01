FROM wissemgh5/pfe_openjdk8nginx
ENV DBNAME=${DBNAME}
ENV DBHOST=${DBHOST}
ENV DBUSERNAME=${DBUSERNAME}
ENV DBPASSWD=${DBPASSWD}
ARG JAR_FILE=target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
COPY entrypoint.sh .
RUN chmod 775 entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
