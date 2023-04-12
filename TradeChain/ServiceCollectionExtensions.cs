namespace TradeChain.Sdk;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddTradeChainClient(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<TradeChainOptions>(configuration.GetSection(TradeChainOptions.ConfigKey));
        services.AddHttpClient<ITradeChainClient, TradeChainClient>();

        return services;
    }
}