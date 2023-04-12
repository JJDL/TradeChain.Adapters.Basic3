using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Ardalis.ApiEndpoints;
using Swashbuckle.AspNetCore.Annotations;

namespace TradeChain.Adapters.Basic.TradeChain;

[Route("tradechain")]
public class RecieveWithNoAckEndpoint : EndpointBaseAsync
    .WithRequest<RecievedMessage>
    .WithoutResult
{
    private readonly ILogger _logger;
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public RecieveWithNoAckEndpoint(ILogger<RecieveWithNoAckEndpoint> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    [HttpPost]
    [SwaggerOperation(
        Summary = "Tradechain Request Handler with no-ack",
        Description = "Handles request forwarded by tradechain on behalf of a product",
        OperationId = "TradeChain.Handle",
        Tags = new[] { "TradeChain" })]
    public override Task HandleAsync([FromBody] RecievedMessage request, CancellationToken cancellationToken = default)
    {
        using var scope = _logger.BeginScope("Handling Message {messageId}", request.MessageId);

        if (ModelState.IsValid)
        {
            _logger.LogInformation("Model Validation failed for @{message}", request);
        }

        try
        {
            var payload = JsonSerializer.Deserialize<Payload>(request.Payload, SerializerOptions);

            // TODO: Write your logic here

            _logger.LogInformation("Request completed successfully.");
        }
        catch (Exception ex)
        {
            _logger.LogCritical(ex, "Failed to complete the request");
        }

        return Task.CompletedTask;
    }
}
