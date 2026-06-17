FROM maven:3.9.4-eclipse-temurin-21 AS builder
WORKDIR /app

# Copy only what we need for a clean Maven build
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src ./src

RUN chmod +x mvnw && ./mvnw -B -DskipTests package

FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar /app/app.jar

EXPOSE 8080

ENV JAVA_OPTS=""

CMD ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
