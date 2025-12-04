# ====== BUILD STAGE ======
FROM gradle:8.7-jdk17 AS builder

# Work inside this directory in the container
WORKDIR /home/gradle/src

# Copy the whole repo into the container
COPY . .

# Move into the Spring Boot project folder
WORKDIR /home/gradle/src/HanoverCollegeMarketplace

# Build the jar (skip tests to keep it fast)
RUN ./gradlew bootJar --no-daemon

# ====== RUNTIME STAGE ======
FROM eclipse-temurin:17-jre

# Workdir for the final container
WORKDIR /app

# Copy the built jar from the builder image
COPY --from=builder /home/gradle/src/HanoverCollegeMarketplace/build/libs/*.jar app.jar

# Render will set PORT; we just make sure Spring respects it
ENV PORT=8080
EXPOSE 8080

# Start the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
