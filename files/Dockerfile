# ----------- Stage 1: Build Stage -----------
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy dependency descriptor first → cache optimization
COPY pom.xml .
RUN mvn dependency:go-offline

# Now copy source code
COPY src ./src

# Build the app
RUN mvn package -DskipTests


# ----------- Stage 2: Runtime Stage -----------
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Run container as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy only the final JAR from builder
COPY --from=builder /app/target/*.jar /app/app.jar

# Add health check
HEALTHCHECK CMD curl -f http://<server_ip>:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
