# syntax=docker/dockerfile:experimental
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /workspace/app

# Copy the Maven configuration and source code
COPY pom.xml .
COPY src src

# Pre-download dependencies for caching
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline

# Build the project, skipping tests
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
VOLUME /tmp

# Copy the fat JAR (adjust the wildcard if needed)
COPY --from=build /workspace/app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
