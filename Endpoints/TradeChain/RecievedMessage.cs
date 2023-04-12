namespace TradeChain.Adapters.Basic.TradeChain;

public sealed class RecievedMessage
{
    public string Action { get; set; } = string.Empty;
    public string Payload { get; set; } = string.Empty;
    public string Sender { get; set; } = string.Empty;
    public string ServiceCode { get; set; } = string.Empty;
    public string MessageId { get; set; } = string.Empty;
}

public sealed class Payload
{
    public string ContentType { get; set; } = string.Empty;

    // You can use a stronly typed data structure for ContentData, if needed
    public dynamic ContentData { get; set; } = string.Empty;
}

