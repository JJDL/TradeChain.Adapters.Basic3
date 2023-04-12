namespace TradeChain.Sdk;

public interface ITradeChainClient
{
    public Task Send(Message message, CancellationToken cancellationToken = default);
    public Task<string> Retrieve(RetrieveMessage retrieveMessage, CancellationToken cancellationToken = default);
}
