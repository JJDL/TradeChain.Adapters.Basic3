# TradeChain Adapter


## Code Snipper for sending a message to TradeChain Platform. 

```cs
using TradeChain.Sdk;

// code hidden for abbrevitity

Message message = new()
{
    Sender = "sender",
    Receiver = "reciever",
    DeliveryMethod = DeliveryMethods.Inbox, // Use DeliveryMethod.Direct if you want to send a direct message
    ServiceCode = "service_code",
    ServiceAction = "service_action",
    Payload = new MessagePayload()
    {
        ContentType = "content_type",
        ContentData = "content data",
    }
};

await _client.Send(message);

```

##  Web.config sample

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <location path="." inheritInChildApplications="false">
    <system.webServer>
      <handlers>
        <add name="aspNetCore" path="*" verb="*" modules="AspNetCoreModuleV2"
          resourceType="Unspecified" />
      </handlers>
      <aspNetCore processPath="dotnet" arguments=".\TradeChain.Adapters.Basic.dll"
        stdoutLogEnabled="true" stdoutLogFile=".\logs\stdout" hostingModel="inprocess">
        <environmentVariables>
          <environmentVariable name="ASPNETCORE_ENVIRONMENT" value="Development" />
          <environmentVariable name="PATH_BASE" value="/" />
        </environmentVariables>
      </aspNetCore>
    </system.webServer>
  </location>
</configuration>
```