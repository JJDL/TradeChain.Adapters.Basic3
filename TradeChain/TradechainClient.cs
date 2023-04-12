using System.Text;
using System.Text.Json;

using Microsoft.Extensions.Options;

namespace TradeChain.Sdk;

public class TradeChainClient : ITradeChainClient
{
    private readonly HttpClient _client;

    public TradeChainClient(HttpClient client, IOptions<TradeChainOptions> config)
    {
        if (config?.Value is null)
        {
            throw new ArgumentNullException(nameof(config));
        }

        _client = client ?? throw new ArgumentNullException(nameof(client));
        _client.BaseAddress = new Uri(config.Value.BaseUrl);
    }

    public async Task Send(Message message, CancellationToken cancellationToken = default)
    {
        var json = JsonSerializer.Serialize(message);

        using HttpRequestMessage request = new(HttpMethod.Post, "Publisher/SendMessage")
        {
            Content = new StringContent(json, Encoding.UTF8, "application/json"),
        };

        using HttpResponseMessage response = await _client.SendAsync(request, cancellationToken);
        string errorMessage = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();
    }

    public async Task<string> Retrieve(RetrieveMessage retrieveMessage, CancellationToken cancellationToken = default)
    {
        var json = JsonSerializer.Serialize(retrieveMessage);

        using HttpRequestMessage request = new(HttpMethod.Post, "MessageExchange/GetMessagePayload")
        {
            Content = new StringContent(json, Encoding.UTF8, "application/json"),
        };

        using HttpResponseMessage response = await _client.SendAsync(request, cancellationToken);
        string responseContent = await response.Content.ReadAsStringAsync();
        response.EnsureSuccessStatusCode();

        return responseContent;
    }
}
