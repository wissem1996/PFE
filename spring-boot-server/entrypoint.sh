#!/bin/sh
java -jar -DDBPASSWD=${DBPASSWD} -DDBHOST=${DBHOST} -DDBNAME=${DBNAME} -DDBUSERNAME=${DBUSERNAME} app.jar