# Build stage
FROM eclipse-temurin:17-jdk as builder
WORKDIR /app

# First copy only the wrapper files
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Make mvnw executable
RUN chmod +x mvnw

# Download dependencies (cache them in Docker layer)
RUN ./mvnw dependency:go-offline

# Copy source files
COPY src ./src

# Build the application
RUN ./mvnw clean package

# Run stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
