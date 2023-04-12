namespace TradeChain.Sdk;
public sealed class TargetSystem
{
    public const string FTP = "FTP";
    public const string CW = "CW";
}
public sealed class RetrieveMessage
{
    public string Sender { get; set; } = string.Empty;
    public string MessageId { get; set; } = string.Empty;
    public string ServiceAction { get; set; } = string.Empty;
    public string DeliveryMethod { get; set; } = TargetSystem.FTP;
    public string ServiceCode { get; set; } = string.Empty;
}