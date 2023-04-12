
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY "TradeChain.Adapters.Basic.csproj" .
RUN dotnet restore "TradeChain.Adapters.Basic.csproj"
COPY . .    
RUN dotnet build "TradeChain.Adapters.Basic.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TradeChain.Adapters.Basic.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Invoyce.India.Web.dll"]