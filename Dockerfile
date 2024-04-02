FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["HiClass.API/HiClass.API.csproj", "HiClass.API/"]
COPY ["HiClass.Application/HiClass.Application.csproj", "HiClass.Application/"]
COPY ["HiClass.Domain/HiClass.Domain.csproj", "HiClass.Domain/"]
COPY ["HiClass.Infrastructure/HiClass.Infrastructure.csproj", "HiClass.Infrastructure/"]
COPY ["HiClass.Persistence/HiClass.Persistence.csproj", "HiClass.Persistence/"]

RUN dotnet restore "HiClass.API/HiClass.API.csproj"
COPY . .
WORKDIR "/src/HiClass.API"
RUN dotnet build "HiClass.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HiClass.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

RUN dotnet tool install --global dotnet-ef --version 6.0.9
ENV PATH="$PATH:/root/.dotnet/tools"
ENTRYPOINT dotnet ef database update --project . --startup-project .
