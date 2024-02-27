# Use a base image with Java installed
FROM openjdk:11.0.1-jre-slim-stretch

ARG WAR=/target/*.war

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged JAR file into the container at /app
COPY $WAR /app.war
# Command to run the application when the container starts

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app.war"]
