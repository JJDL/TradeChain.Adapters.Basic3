using Serilog;

namespace TradeChain.Adapters.Basic
{
    public class Program
    {
        public static int Main(string[] args)
        {
            var assemblyName = typeof(Program).Assembly.GetName().Name;

            try
            {
                Log.Logger = new LoggerConfiguration()
                    .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level}] {SourceContext}{NewLine}{Message:lj}{NewLine}{Exception}{NewLine}")
                    .CreateBootstrapLogger();

                Log.Information("Starting {assembly} Host", assemblyName);

                Host.CreateDefaultBuilder(args)
                    .ConfigureAppConfiguration((host, config) => config.AddJsonFile("secrets/appsettings.json", optional: true, reloadOnChange: true)).ConfigureWebHostDefaults(webBuilder => webBuilder.UseStartup<Startup>()).UseSerilog((context, services, configuration) => configuration.ReadFrom.Configuration(context.Configuration)).Build().Run();
          
                return 0;
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "{assembly} Host terminated unexpectedly", assemblyName);
                return 1;
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }
    }
}