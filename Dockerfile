FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS base
WORKDIR /src
COPY *.sln .
COPY DemoWebApplication2/*.csproj DemoWebApplication2/

RUN dotnet restore 

#Copy everything else
COPY . .

#Testing
#FROM base AS testing
#WORKDIR /src/SageraLoans.UI
#WORKDIR /src/SageraLoans.Core
#WORKDIR /src/SageraLoans.Models
WORKDIR /src/DemoWebApplication2

RUN dotnet build

#WORKDIR /src/SageraLoans.Core.Tests
#RUN dotnet test

#Publishing
FROM base AS publish
WORKDIR /src/DemoWebApplication2
RUN dotnet publish -c Release -o /src/publish

#Get the runtime into a folder called app
FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
#ENTRYPOINT ["dotnet", "DemoWebApplication2.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet DemoWebApplication2.dll