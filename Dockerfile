ARG DOTNET_SDK=mcr.microsoft.com/dotnet/sdk:6.0
FROM ${DOTNET_SDK} AS build
WORKDIR /src
EXPOSE 80
EXPOSE 443

COPY ["Migrations", "HiClass.Persistence/"]
RUN dotnet restore src/HiСlass.Backend.sln

WORKDIR "/src/HiClass.API"
RUN dotnet build "HiClass.API.csproj" -c Release -o /app/build

RUN dotnet tool install --global dotnet-ef --version 6.0.26

FROM build AS publish
RUN dotnet publish "HiClass.API.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HiClass.API.dll"]