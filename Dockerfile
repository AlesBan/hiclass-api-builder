FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

RUN dotnet restore "HiClass.API/HiClass.API.csproj"
COPY . .

WORKDIR "/src/HiClass.API"
RUN dotnet build "HiClass.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HiClass.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY DefaultData /app/DefaultData

ENTRYPOINT ["dotnet", "HiClass.API.dll"]