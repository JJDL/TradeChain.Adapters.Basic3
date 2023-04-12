namespace TradeChain.Adapters.Basic.TradeChain;

public sealed class GetResponse
{
    public string Status { get; set; } = string.Empty;

    // You can use a stronly typed data structure for ContentData, if needed
    public string StatusMsg { get; set; } = string.Empty;

    public string Data { get; set; } = string.Empty;
}

public sealed class GetResponseData
{
    public string Status { get; set; } = string.Empty;

    // You can use a stronly typed data structure for ContentData, if needed
    public string StatusMsg { get; set; } = string.Empty;

    public string Data { get; set; } = string.Empty;
}

