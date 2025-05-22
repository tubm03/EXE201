# ----------------------------
# Build Stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["PetStoreProject/PetStoreProject.csproj", "PetStoreProject/"]
RUN dotnet restore "PetStoreProject/PetStoreProject.csproj"

# Copy the remaining source code
COPY . .

WORKDIR "/src/PetStoreProject"
RUN dotnet publish "PetStoreProject.csproj" -c Release -o /app/publish

# ----------------------------
# Runtime Stage
# ----------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose port 80 for HTTP
EXPOSE 80

ENTRYPOINT ["dotnet", "PetStoreProject.dll"]
