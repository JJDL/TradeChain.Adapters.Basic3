using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Ardalis.ApiEndpoints;
using Swashbuckle.AspNetCore.Annotations;
using TradeChain.Sdk;
using System.Text.RegularExpressions;
using System.Text;
using System.Xml.Linq;
using System.Xml.Xsl;
using System.Xml;
using System;
using Newtonsoft.Json.Linq;
using System.ServiceModel;
using CargoWise.eHub.Adapter;
using CargoWise.eHub.Common;
using System.IO;
using System;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Net;


namespace TradeChain.Adapters.Basic.TradeChain;

// You can also repurpose this endpoint template for creating external endpoints that forwards message to tradechain.

[Route("tradechaincargowise-withack")]
public class TradechainCargowiseWithAckEndpoint : EndpointBaseAsync
    .WithRequest<RecievedMessage>
    .WithoutResult
{
    private readonly ITradeChainClient _client;
    private readonly ILogger _logger;
    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    public TradechainCargowiseWithAckEndpoint(
        ILogger<TradechainCargowiseWithAckEndpoint> logger,
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

        if (request.ServiceCode == "ShipmentCW" && request.Action == "SendLogisysShipmentToCargoWise")
        {
            try
            {
                
                // ! Sending Reply/ACK to tradechain.
                RetrieveMessage retrieveMessage = new()
                {
                    Sender = request.Sender, // Use Adapter's LEID
                    MessageId = request.MessageId
                };

                var responseString = await _client.Retrieve(retrieveMessage, cancellationToken);
                var responseJson = System.Text.Json.JsonSerializer.Deserialize<GetResponse>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                var responseJsonData = System.Text.Json.JsonSerializer.Deserialize<GetResponse>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                // TODO: Write your logic here
                var folderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Payloads", DateTime.Today.ToString("yyyyMMdd"));

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                var fileName = $"{DateTime.UtcNow:yyyyMMdd_HHmmssfff}_{request.Sender}_{request.MessageId}_{request.ServiceCode}_{request.Action}.json";
                var filePath = Path.Combine(folderPath, fileName);

                await System.IO.File.WriteAllTextAsync(filePath, responseJson.Data, cancellationToken);

                _logger.LogInformation($"Payload saved to {filePath}");

                string archiveFolderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Archive", DateTime.Today.ToString("yyyyMMdd"));
                if (!Directory.Exists(archiveFolderPath))
                {
                    Directory.CreateDirectory(archiveFolderPath);
                }
                var fileName2 = $"{DateTime.UtcNow:yyyyMMdd_HHmmssfff}_archive_{request.Sender}_{request.MessageId}_{request.ServiceCode}_{request.Action}.json";
                var archiveFilePath = Path.Combine(archiveFolderPath, fileName2);


                // Copy the input file to the archive folder
                System.IO.File.Copy(filePath, archiveFilePath);

                await ProcessFileAsync(filePath, archiveFilePath);

                _logger.LogInformation("SendLogisysShipmentToCargoWise processed successfully for @{message}", request);

            }
            catch (Exception ex)
            {
                _logger.LogCritical(ex, "Failed to complete the request");
            }
            
        }
        else if (request.ServiceCode == "ShipmentCW" && request.Action == "SendCargoWiseShipmentToLogisys")
        {
            try
            {
                var payload = System.Text.Json.JsonSerializer.Deserialize<Payload>(request.Payload, SerializerOptions);

                // TODO: Write your logic here
                /*var folderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Payloads", DateTime.Today.ToString("yyyyMMdd"));

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                var fileName = $"{DateTime.UtcNow:yyyyMMdd_HHmmssfff}_{request.Sender}_{request.MessageId}_{request.ServiceCode}_{request.Action}.json";
                var filePath = Path.Combine(folderPath, fileName);

                await System.IO.File.WriteAllTextAsync(filePath, request.Payload);

                _logger.LogInformation($"Payload saved to {filePath}");

                string archiveFolderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Archive", DateTime.Today.ToString("yyyyMMdd"));
                if (!Directory.Exists(archiveFolderPath))
                {
                    Directory.CreateDirectory(archiveFolderPath);
                }
                var fileName2 = $"{DateTime.UtcNow:yyyyMMdd_HHmmssfff}_archive_{request.Sender}_{request.MessageId}_{request.ServiceCode}_{request.Action}.json";
                var archiveFilePath = Path.Combine(archiveFolderPath, fileName2);


                // Copy the input file to the archive folder
                System.IO.File.Copy(filePath, archiveFilePath);

                await ProcessFileAsync(filePath, archiveFilePath);*/

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
        else
        {
            _logger.LogInformation("Unknown request processed for @{message}", request);
        }

        
    }

    static async Task ProcessFileAsync(string inputFilePath, string archiveFilePath)
    {
        try
        {
            Console.WriteLine(); 
            Console.WriteLine();
            // Read the JSON file into a string

            string jsonString = System.IO.File.ReadAllText(inputFilePath);

            // parse the JSON string to a JObject
            JObject jsonObject = JObject.Parse(jsonString);

            // extract the Data field as a string
            string dataString = jsonObject["ContentData"] != null ? jsonObject["ContentData"].ToString() : jsonObject["Data"].ToString();

            // remove the <Data> or <ContentData> and </Data> or </ContentData> tags from the string
            dataString = dataString.Replace("<ContentData>", "").Replace("</ContentData>", "")
                                   .Replace("<Data>", "").Replace("</Data>", "");

            // parse the resulting string into a JObject
            JObject dataObject = JObject.Parse(dataString);

            // replace the Data field in the original JObject with the parsed JObject
            jsonObject = dataObject;

            JObject jsonObject3 = new JObject();

            // extract the Data field as a string
            string dataString3 = jsonObject["Data"].ToString();

            // remove the <Data> or <ContentData> and </Data> or </ContentData> tags from the string
            JObject dataObject3 = JObject.Parse(dataString3);

            jsonObject["Data"] = dataObject3;



            Guid guid = Guid.NewGuid();
            string guidString = guid.ToString();

            string inputFileName2 = Path.GetFileNameWithoutExtension(inputFilePath);
            inputFileName2 = Regex.Replace(inputFileName2, "[^0-9a-zA-Z]+", "");

            // get the current local date and time
            DateTime localDateTime = DateTime.UtcNow;

            // convert the local date and time to UTC
            DateTime utcDateTime = localDateTime.ToUniversalTime();

            // format the UTC date and time as a string
            string utcDateTimeString = utcDateTime.ToString("yyyyMMdd_HHmmss");

            // construct the prefix for the output file name
            string prefix = utcDateTimeString + "_" + inputFileName2 + "_";

            // output the modified JSON object to a file
            string outputJsonString = JsonConvert.SerializeObject(jsonObject, Newtonsoft.Json.Formatting.Indented);
            string fileName = prefix + "modifiedJson.json";
            System.IO.File.WriteAllText(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName), outputJsonString);

            // read the JSON file into a string
            string jsonString2 = System.IO.File.ReadAllText(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName));

            // parse the JSON string to a JObject
            JObject jsonObject2 = JObject.Parse(jsonString2);

            // Parse the JSON to a JObject
            var jsonObject2var = jsonObject2;

            // create an XmlDocument object
            XmlDocument xmlDoc = new XmlDocument();

            // create the root element
            XmlElement root = xmlDoc.CreateElement("root");

            // add the root element to the XmlDocument
            xmlDoc.AppendChild(root);

            // iterate through the JSON object and add each property as an element
            /*foreach (KeyValuePair<string, JToken> kvp in jsonObject)
            {
                XmlElement elem = xmlDoc.CreateElement(kvp.Key);
                elem.InnerText = kvp.Value.ToString();
                root.AppendChild(elem);
            }*/
            // iterate through the JSON object and add each property as an element
            foreach (KeyValuePair<string, JToken> kvp in jsonObject2var)
            {
                XmlElement elem = CreateXmlElement(kvp.Key, kvp.Value, xmlDoc);
                root.AppendChild(elem);
            }

            // Helper method to create an XML element from a JToken
            static XmlElement CreateXmlElement(string name, JToken token, XmlDocument xmlDoc)
            {
                XmlElement elem = xmlDoc.CreateElement(name);
                switch (token.Type)
                {
                    case JTokenType.Object:
                        foreach (var child in token.Children<JProperty>())
                        {
                            XmlElement childElem = CreateXmlElement(child.Name, child.Value, xmlDoc);
                            elem.AppendChild(childElem);
                        }
                        break;
                    case JTokenType.Array:
                        foreach (var child in token.Children())
                        {
                            XmlElement childElem = CreateXmlElement(name, child, xmlDoc);
                            elem.AppendChild(childElem);
                        }
                        break;
                    case JTokenType.Integer:
                        elem.InnerText = ((int)token).ToString();
                        break;
                    case JTokenType.Float:
                        elem.InnerText = ((float)token).ToString();
                        break;
                    case JTokenType.String:
                        elem.InnerText = (string)token;
                        break;
                    case JTokenType.Boolean:
                        elem.InnerText = ((bool)token).ToString();
                        break;
                    case JTokenType.Date:
                        var date = (DateTimeOffset)token;
                        elem.InnerText = date.ToString(date.ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss"));
                        break;
                    case JTokenType.Null:
                        elem.InnerText = "";
                        break;
                    default:
                        throw new ArgumentException(string.Format("Unsupported token type '{0}'", token.Type));
                }
                return elem;
            }


            // Load the JSON file
            var jsonText = System.IO.File.ReadAllText("CWPartnerIDLookup.json");
            var jsonRows = JsonConvert.DeserializeObject<JArray>(jsonText);

            // Convert the XmlDocument to XDocument
            XDocument xDoc = XDocument.Parse(xmlDoc.OuterXml);
            // Find the PartnerID element
            XElement partnerIdElement = xDoc.Root.Element("DeliveryOptions")
                .Element("Attributes")
                .Element("PartnerID");

            // Get the value of the PartnerID element
            string partnerId2 = partnerIdElement.Value;


            // Find all rows in the JSON file that match the specified LEID
            var matchingRows = jsonRows
                .Where(row =>
                    row.Value<string>("PartnerID") == partnerId2 // Check the PartnerID field
                );

            string fileNameInitial = Path.GetFileNameWithoutExtension(archiveFilePath);
            string[] fileNameParts = fileNameInitial.Split('_');
            string messageId = fileNameParts[4];

            // If any matching rows were found, create XML elements for them and add them to the JSON XML
            foreach (var matchingRow in matchingRows)
            {
                XElement jsonXml = new XElement("row",
                    new XElement("PartnerID", matchingRow.Value<string>("PartnerID")),
                    new XElement("EnterpriseID", matchingRow.Value<string>("EnterpriseID")),
                    new XElement("CompanyID", matchingRow.Value<string>("CompanyID")),
                    new XElement("ServerID", matchingRow.Value<string>("ServerID")),
                    new XElement("eAdaptorInboundURL", matchingRow.Value<string>("eAdaptorInboundURL")),
                    new XElement("User", matchingRow.Value<string>("User")),
                    new XElement("Password", matchingRow.Value<string>("Password")),
                    new XElement("RecipientID", matchingRow.Value<string>("RecipientID")),
                    new XElement("TargetSystem", matchingRow.Value<string>("TargetSystem")),
                    new XElement("FTPHost", matchingRow.Value<string>("FTPHost")),
                    new XElement("FTPUser", matchingRow.Value<string>("FTPUser")),
                    new XElement("FTPPass", matchingRow.Value<string>("FTPPass"))
                );
                // get the PartnerID and EnterpriseID values from the matching row
                string partnerID = matchingRow.Value<string>("PartnerID");
                string enterpriseID = matchingRow.Value<string>("EnterpriseID");
                string companyID = matchingRow.Value<string>("CompanyID");
                string serverID = matchingRow.Value<string>("ServerID");

                prefix += partnerID + "_" + enterpriseID + "_" + companyID + "_" + serverID + "_" + messageId + "_";

                xDoc.Element("root").Add(jsonXml);
            }


            Console.WriteLine();
            Console.WriteLine();

            string fileName4 = prefix + "JSONtoXMLoutput.xml";
            xDoc.Save(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName4));
            Console.WriteLine($"Logisys JSON file has been converted to XML and output file is in {fileName4}");
            string outputFilePath4 = Path.Combine(Path.GetDirectoryName(archiveFilePath), prefix + "JSONtoXMLoutput.xml");


            // Create an XmlResolver with default credentials
            XmlUrlResolver resolver = new XmlUrlResolver();
            resolver.Credentials = System.Net.CredentialCache.DefaultCredentials;

            // Create an XmlReaderSettings object with the resolver
            XmlReaderSettings readerSettings = new XmlReaderSettings();
            readerSettings.XmlResolver = resolver;
            readerSettings.ValidationType = ValidationType.None;
            readerSettings.DtdProcessing = DtdProcessing.Parse;

            // Create an XslCompiledTransform and load the XSLT file
            XslCompiledTransform xslt = new XslCompiledTransform();
            XsltSettings sets = new XsltSettings(true, true);
            using (XmlReader reader = XmlReader.Create(@"LSShipmentToCWCreateConsolShipment.xslt", readerSettings))
            {
                xslt.Load(reader, sets, resolver);
            }

            // Create a StringWriter to store the transformed XML
            StringWriter sw = new StringWriter();

            // Transform the XML using the XSLT stylesheet and write it to the StringWriter
            using (XmlReader reader = XmlReader.Create(outputFilePath4, readerSettings))
            {
                xslt.Transform(reader, null, sw);
            }

            // Create a new XDocument from the transformed XML
            XDocument transformedXml = XDocument.Parse(sw.ToString());

            // Save the transformed XML to a file
            string fileName3 = prefix + "XMLtoCargoWiseXMLoutput.xml";

            transformedXml.Save(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName3));
            Console.WriteLine($"Logisys XML file has been converted to a CargoWise XML and output file is in {fileName3}");

            XmlDocument doc = new XmlDocument();
            doc.Load(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName4));

            XmlNodeList rowList = doc.GetElementsByTagName("row");


            foreach (XmlNode row in rowList)
            {
                string partnerID = row["PartnerID"].InnerText;
                string companyID = row["CompanyID"].InnerText;
                string serverID = row["ServerID"].InnerText;
                string enterpriseID = row["EnterpriseID"].InnerText;
                string eAdaptorInboundURL = row["eAdaptorInboundURL"].InnerText;
                string user = row["User"].InnerText;
                string password = row["Password"].InnerText;
                string recipientID = row["RecipientID"].InnerText;
                string targetSystem = row["TargetSystem"].InnerText;
                string ftpHost = row["FTPHost"].InnerText;
                string ftpUser = row["FTPUser"].InnerText;
                string ftpPass = row["FTPPass"].InnerText;

                Console.WriteLine();

                Console.WriteLine($"PartnerID: {partnerID}");
                Console.WriteLine($"CompanyID: {companyID}");
                Console.WriteLine($"ServerID: {serverID}");
                Console.WriteLine($"EnterpriseID: {enterpriseID}");
                Console.WriteLine($"eAdaptorInboundURL: {eAdaptorInboundURL}");
                Console.WriteLine($"User: {user}");
                Console.WriteLine($"Password: {password}");
                Console.WriteLine($"RecipientID: {recipientID}");
                Console.WriteLine($"TargetSystem: {targetSystem}");
                Console.WriteLine($"FTPHost: {ftpHost}");
                Console.WriteLine($"FTPUser: {ftpUser}");
                Console.WriteLine($"FTPPass: {ftpPass}");

                Console.WriteLine();

                if (targetSystem == "CW")
                {

                    // Create a new HTTP client
                    HttpClient client = new HttpClient();

                    // Set up the request message with the XML body
                    HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, eAdaptorInboundURL);
                    // Update request content to read from the same file path as archiveFilePath
                    request.Content = new StringContent(System.IO.File.ReadAllText(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName3)), Encoding.UTF8, "application/xml");

                    // Add basic authentication header
                    string authHeader = $"{user}:{password}";
                    byte[] authHeaderBytes = Encoding.UTF8.GetBytes(authHeader);
                    authHeader = Convert.ToBase64String(authHeaderBytes);
                    request.Headers.Add("Authorization", $"Basic {authHeader}");

                    // Send the request and get the response
                    HttpResponseMessage response = await client.SendAsync(request);

                    // Check the response status code
                    if (response.IsSuccessStatusCode)
                    {
                        // Get the response content as a string
                        string responseContent = await response.Content.ReadAsStringAsync();

                        // Save the response to a file
                        string fileName2 = prefix + "CargoWiseResponse.xml";
                        // Write response content to the same file path as archiveFilePath
                        System.IO.File.WriteAllText(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName2), responseContent);

                        Console.WriteLine($"CargoWise XML file has been sent to CargoWise and the response is in {fileName2}");
                    }
                    else
                    {
                        Console.WriteLine($"Error sending request: {response.StatusCode} - {response.ReasonPhrase}");
                    }


                    string eAdaptorInboundURL2 = "https://example.com";
                    string user2 = "username";
                    string password2 = "password";
                    // Update xmlFilePath to use the same path as archiveFilePath
                    string xmlFilePath = Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName3);
                    string fileName5 = prefix + "CargoWiseResponseSummary.json";
                    // Update jsonFilePath to use the same path as archiveFilePath
                    string jsonFilePath = Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName5);

                    // Read the XML file into an XmlDocument
                    XmlDocument xml = new XmlDocument();
                    xml.Load(xmlFilePath);

                    // Set up the namespace manager for XPath queries
                    XmlNamespaceManager nsmgr = new XmlNamespaceManager(xml.NameTable);
                    nsmgr.AddNamespace("w", "http://www.cargowise.com/Schemas/Universal/2011/11");


                    // Extract the Consol number
                    string consolNumber = xml.SelectSingleNode("//w:UniversalEvent/w:Event/w:DataContext/w:DataSourceCollection/w:DataSource/w:Key", nsmgr)?.InnerText;

                    // Extract the status code and processing status code
                    string statusCode = xml.SelectSingleNode("//w:UniversalResponse/w:Status", nsmgr)?.InnerText;
                    string processingStatusCode = xml.SelectSingleNode("//w:UniversalResponse/w:Data/w:UniversalEvent/w:Event/w:ContextCollection/w:Context[w:Type='ProcessingStatusCode']/w:Value", nsmgr)?.InnerText;

                    // Extract the processing log messages
                    XmlNodeList logNodes = xml.SelectNodes("//w:UniversalResponse/w:ProcessingLog/text()", nsmgr);
                    JArray processingLog = new JArray();
                    foreach (XmlNode logNode in logNodes)
                    {
                        processingLog.Add(logNode.Value.Trim());
                    }

                    // Create the summary object
                    JObject summary = new JObject();
                    summary["ConsolNumber"] = consolNumber;
                    summary["StatusCode"] = statusCode;
                    summary["ProcessingStatusCode"] = processingStatusCode;
                    summary["ProcessingLog"] = processingLog;

                    // Write the summary to a JSON file
                    using (StreamWriter writer = new StreamWriter(Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName5)))
                    {
                        writer.Write(summary.ToString());
                    }

                    Console.WriteLine($"CargoWise Response Summary JSON file has been generated in {fileName5}");





                }
                else if (targetSystem == "FTP")
                {
                    Console.WriteLine($"Sending to FTP...");

                    string FTPprefix = utcDateTimeString + "_" + partnerId2  + "_" + enterpriseID + companyID + serverID;
                    string resultPath = Path.Combine(Path.GetDirectoryName(archiveFilePath), fileName3);

                    try
                    {
                        // Get the file name from the archive file path
                        string FTPfileName = FTPprefix + "_" + messageId;

                        // Create a WebClient object
                        using (WebClient client = new WebClient())
                        {
                            // Set the FTP credentials
                            client.Credentials = new NetworkCredential(ftpUser, ftpPass);

                            // Upload the file to the FTP server
                            client.UploadFile($"ftp://{ftpHost}/toCW/{FTPfileName}.xml", "STOR", resultPath);
                        }

                        Console.WriteLine($"File {FTPfileName} uploaded to FTP server.");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error uploading file to FTP server: {ex.Message}");
                    }



                }
                Console.WriteLine();
                Console.WriteLine();
            }

        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing file: {inputFilePath}. {ex.Message}");
        }
    }
    }

