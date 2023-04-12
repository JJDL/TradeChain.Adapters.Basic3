namespace TradeChain.Sdk;

public sealed class DeliveryMethods
{
    public const string Direct = "Direct";
    public const string Inbox = "Inbox";
}

public sealed class Message
{
    public string Sender { get; set; } = string.Empty;
    public string Receiver { get; set; } = string.Empty;
    public string ServiceAction { get; set; } = string.Empty;
    public string DeliveryMethod { get; set; } = DeliveryMethods.Direct;
    public string ServiceCode { get; set; } = string.Empty;
    public bool Published { get; set; }
    public int MaxRetryCount { get; set; }
    public int TimeToLive { get; set; }
    public string Remark { get; set; } = string.Empty;
    public MessagePayload Payload { get; set; } = new();
}

public sealed class MessagePayload
{
    public string ContentType { get; set; } = string.Empty;
    public string ContentData { get; set; } = string.Empty;
}
