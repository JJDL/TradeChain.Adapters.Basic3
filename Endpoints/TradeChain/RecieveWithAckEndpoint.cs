using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Ardalis.ApiEndpoints;
using Swashbuckle.AspNetCore.Annotations;
using TradeChain.Sdk;

namespace TradeChain.Adapters.Basic.TradeChain;

// You can also repurpose this endpoint template for creating external endpoints that forwards message to tradechain.

[Route("tradechain-withack")]
public class RecieveWithAckEndpoint : EndpointBaseAsync
    .WithRequest<RecievedMessage>
    .WithoutResult
{
    private readonly ITradeChainClient _client;
    private readonly ILogger _logger;
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public RecieveWithAckEndpoint(
        ILogger<RecieveWithAckEndpoint> logger,
        ITradeChainClient client)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        _client = client ?? throw new ArgumentNullException(nameof(client));
    }

    [HttpPost]
    [SwaggerOperation(
        Summary = "Tradechain Request Handler with ACK",
        Description = "Handles request forwarded by tradechain on behalf of a product",
        OperationId = "TradeChain.Handle",
        Tags = new[] { "TradeChain" })]
    public override async Task HandleAsync([FromBody] RecievedMessage request, CancellationToken cancellationToken = default)
    {
        using var scope = _logger.BeginScope("Handling Message {messageId}", request.MessageId);

        if (!ModelState.IsValid)
        {
            _logger.LogInformation("Model Validation failed for @{message}", request);
        }

        try
        {
            var payload = JsonSerializer.Deserialize<Payload>(request.Payload, SerializerOptions);

            // TODO: Write your logic here

            // ! Sending Reply/ACK to tradechain.
            Message message = new()
            {
                Sender = request.Sender, // Use Adapter's LEID
                Receiver = "LE0000000000032", // Use Original Sender/Caller LEID
                DeliveryMethod = DeliveryMethods.Inbox, // Use DeliveryMethod.Direct if you want to send a direct message
                ServiceCode = request.ServiceCode,
                ServiceAction = request.Action,
                TimeToLive = 86400,
                Payload = new MessagePayload()
                {
                    ContentType = "content_type",
                    ContentData = request.Payload,
                }
            };

            await _client.Send(message, cancellationToken);

            _logger.LogInformation("Request completed successfully.");
        }
        catch (Exception ex)
        {
            _logger.LogCritical(ex, "Failed to complete the request");
        }
    }
}
