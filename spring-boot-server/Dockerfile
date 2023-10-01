FROM openjdk:8-jdk-alpine
ENV DB_NAME=${DB_NAME}
ENV DB_HOST=${DB_HOST}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG JAR_FILE=target/spring-boot-jpa-postgresql-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar", "-DDB_PASSWORD=${DB_PASSWORD}", "-DDB_HOST=${DB_HOST}", "-DDB_NAME=${DB_NAME}", "-DDB_USERNAME=${DB_USERNAME}", "/app.jar"]
