FROM openjdk:8-jdk-alpine
ENV DBNAME=${DBNAME}
ENV DBHOST=${DBHOST}
ENV DBUSERNAME=${DBUSERNAME}
ENV DBPASSWD=${DBPASSWD}
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG JAR_FILE=target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar", "-DDBPASSWD=${DBPASSWD}", "-DDBHOST=${DBHOST}", "-DDBNAME=${DBNAME}", "-DDBUSERNAME=${DBUSERNAME}", "/app.jar"]
