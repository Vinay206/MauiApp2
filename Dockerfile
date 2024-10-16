# Stage 1: Build the APK in a .NET 8 SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory inside the container
WORKDIR /app

# Install Android workload (for .NET MAUI Android)
RUN dotnet workload install maui-android

# Copy the project files into the container
COPY . ./

# Restore dependencies
RUN dotnet restore

# Build the project for Android
RUN dotnet build -f net8.0-android -c Release

# Publish the project to generate the APK
RUN dotnet publish -f net8.0-android -c Release -o /app/build-output

# Stage 2: Final stage for extracting the APK
FROM busybox:latest

# Set the working directory inside the final image
WORKDIR /app

# Copy the APK file(s) from the build-env stage
COPY --from=build-env /app/build-output .

# APK will be available in /app directory of the container
