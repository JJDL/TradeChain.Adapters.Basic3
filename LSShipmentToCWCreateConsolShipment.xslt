<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" exclude-result-prefixes="msxsl var userCSharp" version="1.0" xmlns:ns0="http://IntegrationAccount.Ouput" xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp">
	<!--xsl:import href="functoidsscript.xslt"/-->
	<xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
	<xsl:template match="/">
    <xsl:apply-templates select="/root/Data" />
  </xsl:template>
  <xsl:template match="/root/Data">
	  <!--xsl:variable name="FirstFieldArray2" select="userCSharp:InitCumulativeConcat(41)" />
		<xsl:variable name="LineCount21" select="userCSharp:InitCumulativeSum(51)" /

		<xsl:variable name="ConsolTotalWeight" select="ConsolidatedData/XMLInput/ParsedPDF[mbl_number!='']/table//chargeable_weight" /-->
		<UniversalShipment xmlns="http://www.cargowise.com/Schemas/Universal/2011/11" version="1.1">
			<Shipment>
				<DataContext>
					<DataTargetCollection>
						<DataTarget>
							<Type>ForwardingConsol</Type>
							<Key></Key>
						</DataTarget>
					</DataTargetCollection>

					<Company>
						<Code>
							<xsl:value-of select="string(row/CompanyID/text())" />
						</Code>
					</Company>
					<DataProvider>TRDCHN</DataProvider>
					<EnterpriseID>
						<xsl:value-of select="string(row/EnterpriseID/text())" />
					</EnterpriseID>
					<ServerID>
						<xsl:value-of select="string(row/ServerID/text())" />
					</ServerID>
				</DataContext>

				<ContainerMode>
					<Code>
						<xsl:choose>
							<xsl:when test="JobHeader/TransMode/text()='A' and JobHeader/CargoType/text()='Loose'">
								<xsl:text>LSE</xsl:text>
							</xsl:when>
							<xsl:when test="JobHeader/TransMode/text()='A' and JobHeader/CargoType/text()='ULD'">
								<xsl:text>ULD</xsl:text>
							</xsl:when>
							<xsl:when test="JobHeader/TransMode/text()='S' and string-length(JobHeader/CargoType/text()) = 3">
								<xsl:value-of select="string(JobHeader/CargoType/text())" />
							</xsl:when>
							<xsl:when test="JobHeader/TransMode/text()='L' and string-length(JobHeader/CargoType/text()) = 3">
								<xsl:value-of select="string(JobHeader/CargoType/text())" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>OTH</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</Code>
				</ContainerMode>
				<OuterPacks></OuterPacks>
				<PaymentMethod>
					<Code>
						<!--xsl:choose>
							<xsl:when test="contains(string(ConsolidatedData/XMLInput/ParsedPDF[mbl_number!='']/payment/text()),'PREPAID')">
								<xsl:text>PPD</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>CCX</xsl:text>
							</xsl:otherwise>
						</xsl:choose-->
					</Code>
				</PaymentMethod>
				<PlaceOfDelivery>
					<Code>
						<xsl:value-of select="string(ShippingDetails/Dischargeport/Code/text())" />
					</Code>
					<Name></Name>
				</PlaceOfDelivery>
				<PlaceOfIssue>
					<Code></Code>
					<Name></Name>
				</PlaceOfIssue>
				<PlaceOfReceipt>
					<Code>
						<xsl:value-of select="string(ShippingDetails/LoadPort/Code/text())" />
					</Code>
					<Name></Name>
				</PlaceOfReceipt>
				<PortFirstForeign>
					<Code></Code>
				</PortFirstForeign>
				<PortLastForeign>
					<Code></Code>
				</PortLastForeign>
				<PortOfDischarge>
					<Code>
						<xsl:value-of select="string(ShippingDetails/Dischargeport/Code/text())" />
					</Code>
					<Name></Name>
				</PortOfDischarge>
				<PortOfFirstArrival>
					<Code></Code>
				</PortOfFirstArrival>
				<PortOfLoading>
					<Code>
						<xsl:value-of select="string(ShippingDetails/LoadPort/Code/text())" />
					</Code>
					<Name></Name>
				</PortOfLoading>
				<ReceivingForwarderHandlingType>
					<Code></Code>
				</ReceivingForwarderHandlingType>
				<ReleaseType>
					<Code></Code>
				</ReleaseType>
				<RequiresTemperatureControl>
					<xsl:choose>
						<xsl:when test="ContainerInfo/ContainerInfo/IsTempControlled/text()='Y'">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:when test="ContainerInfo/ContainerInfo/IsTempControlled/text()='N'">
							<xsl:text>false</xsl:text>
						</xsl:when>
					</xsl:choose>
				</RequiresTemperatureControl>
				<ScreeningStatus>
					<Code></Code>
					<Description></Description>
				</ScreeningStatus>
				<SendingForwarderHandlingType>
					<Code></Code>
				</SendingForwarderHandlingType>
				<ShipmentType>
					<Code>AGT</Code>
					<Description>Agent</Description>
				</ShipmentType>
				<TotalNoOfPacks>
					<xsl:value-of select="ShippingDetails/NoOfPackages/Value/text()" />
				</TotalNoOfPacks>
				<TotalNoOfPacksPackageType>
					<Code><xsl:value-of select="ShippingDetails/NoOfPackages/Value/text()" /></Code>
					<Description></Description>
				</TotalNoOfPacksPackageType>
				<TotalPreallocatedChargeable>0.000</TotalPreallocatedChargeable>
				<TotalPreallocatedVolume>0.000</TotalPreallocatedVolume>
				<TotalPreallocatedVolumeUnit>
					<Code></Code>
				</TotalPreallocatedVolumeUnit>
				<TotalPreallocatedWeight>0.000</TotalPreallocatedWeight>
				<TotalPreallocatedWeightUnit>
					<Code></Code>
				</TotalPreallocatedWeightUnit>
				<TotalVolume>
					<xsl:value-of select="ShippingDetails/Volume/Value/text()" />
				</TotalVolume>
				<TotalVolumeUnit>
					<Code><xsl:if test="ShippingDetails/Volume/Unit/text()='CBM'">M3</xsl:if></Code>
				</TotalVolumeUnit>
				<TotalWeight><xsl:value-of select="ShippingDetails/GrossWeight/Value/text()" /></TotalWeight>
				<TotalWeightUnit>
					<Code><xsl:if test="ShippingDetails/Volume/Unit/text()='KGS'">KG</xsl:if></Code>
				</TotalWeightUnit>
				<TransportMode>
					<Code><xsl:if test="JobHeader/TransMode/text()='S'">SEA</xsl:if><xsl:if test="JobHeader/TransMode/text()='A'">AIR</xsl:if></Code>
				</TransportMode>
				<VesselName><xsl:value-of select="ShippingDetails/CarrierVessel/text()" /></VesselName>
				<VoyageFlightNo><xsl:value-of select="ShippingDetails/FlightVoyageNo/text()" /></VoyageFlightNo>
				<WayBillNumber>
					<xsl:value-of select="ShippingDetails/MasterNumber/text()" />
				</WayBillNumber>
				<WayBillType>
					<Code>MWB</Code>
					<Description>Master Waybill</Description>
				</WayBillType>

				<ContainerCollection Content="Complete">
					<!--xsl:for-each select="ConsolidatedData/XMLInput/ParsedPDF[mbl_number!='']/table/*[position()=1]">
						<xsl:variable name="AddFirstFieldName2" select="userCSharp:AddToCumulativeConcat(4,string(name(.)),'')" />
					</xsl:for-each>
					<xsl:variable name="GetFirstFieldName2" select="userCSharp:GetCumulativeConcat(41)" />
					<xsl:for-each select="ConsolidatedData/XMLInput/ParsedPDF[mbl_number!='']/table/*[contains($GetFirstFieldName2,name(.))]">
						<xsl:variable name="AddLineCount21" select="userCSharp:AddToCumulativeSum(51,1,'')" />
					</xsl:for-each>
					<xsl:variable name="GetLineCount21" select="userCSharp:GetCumulativeSum(51)" />
					<xsl:call-template name="generatepdflinetable2"/-->
					<xsl:for-each select="ContainerInfo/ContainerInfo">
					<Container>
						<MarksAndNos><xsl:value-of select="../../BLInfo/MarksNos/text()" /></MarksAndNos>
						<GoodsDescription>
							<xsl:value-of select="../../BLInfo/GoodsDesc/text()" />
						</GoodsDescription>
							<ContainerNumber>
								<xsl:value-of select="string(ContNo/text())" />
							</ContainerNumber>
							<ContainerType>
								<Code><xsl:value-of select="string(ContType/text())" /></Code>
							</ContainerType>
						<!--xsl:for-each select="../table/package_count[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
							<PackQty>
								<xsl:value-of select="substring-before(string(./text()),' ')" />
								<xsl:variable name="AddPackage" select="userCSharp:AddToCumulativeSum(6,number(substring-before(string(./text()),' ')),'')" />
							</PackQty>
						</xsl:for-each-->
							<Seal>
								<xsl:value-of select="string(CarrierSealNo/text())" />
							</Seal>
							<!--VolumeCapacity>
								<xsl:value-of select="substring-before(string(./text()),' ')" />
								<xsl:variable name="AddVolume" select="userCSharp:AddToCumulativeSum(7,number(substring-before(string(./text()),' ')),'')" />
							</VolumeCapacity-->
							<WeightCapacity>
								<xsl:value-of select="string(TareWeight/text())" />
							</WeightCapacity>
						<PackType>
							<Code>PKG</Code>
							<Description>Package</Description>
						</PackType>
						<VolumeUnit>
							<Code>M3</Code>
							<Description>Cubic Meters</Description>
						</VolumeUnit>
						<WeightUnit>
							<Code>KG</Code>
							<Description>Kilograms</Description>
						</WeightUnit>

					</Container>
						</xsl:for-each>
				</ContainerCollection>



				<OrganizationAddressCollection>
					<xsl:for-each select="Entities/Entities">
					<xsl:if test="Type/text()='MasterShipper'">
					<OrganizationAddress>
						<AddressType>ShippingLineAddress</AddressType><AddressOverride>true</AddressOverride>
						<Address1>
							<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
						</Address1>
						<CompanyName>
							<xsl:value-of select="string(Name/text())" />
						</CompanyName>
						<Country>
						  <Code><xsl:value-of select="string(Country/text())" /></Code>
						</Country>
						<State><xsl:value-of select="string(State/text())" /></State>
					</OrganizationAddress>
					</xsl:if>
					<xsl:if test="Type/text()='MasterConsignee'">
					<OrganizationAddress>
						<AddressType>ConsigneeDocumentaryAddress</AddressType><AddressOverride>true</AddressOverride>
						<Address1>
							<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
						</Address1>
						<CompanyName>
							<xsl:value-of select="string(Name/text())" />
						</CompanyName>
						<Country>
						  <Code><xsl:value-of select="string(Country/text())" /></Code>
						</Country>
						<State><xsl:value-of select="string(State/text())" /></State>
					</OrganizationAddress>
					</xsl:if>
					<xsl:if test="Type/text()='MasterConsignee'">
					<OrganizationAddress>
						<AddressType>ReceivingForwarderAddress</AddressType><AddressOverride>true</AddressOverride>
						<Address1>
							<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
						</Address1>
						<CompanyName>
							<xsl:value-of select="string(Name/text())" />
						</CompanyName>
						<Country>
						  <Code><xsl:value-of select="string(Country/text())" /></Code>
						</Country>
						<State><xsl:value-of select="string(State/text())" /></State>
					</OrganizationAddress>
					</xsl:if>
					<xsl:if test="Type/text()='OriginAgent'">
					<OrganizationAddress>
						<AddressType>SendersOverseasAgent</AddressType><AddressOverride>true</AddressOverride>
						<Address1>
							<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
						</Address1>
						<CompanyName>
							<xsl:value-of select="string(Name/text())" />
						</CompanyName>
						<Country>
						  <Code><xsl:value-of select="string(Country/text())" /></Code>
						</Country>
						<State><xsl:value-of select="string(State/text())" /></State>
					</OrganizationAddress>
					</xsl:if>
					<xsl:if test="Type/text()='Notify'">
					<OrganizationAddress>
						<AddressType>NotifyParty</AddressType><AddressOverride>true</AddressOverride>
						<Address1>
							<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
						</Address1>
						<CompanyName>
							<xsl:value-of select="string(Name/text())" />
						</CompanyName>
						<Country>
						  <Code><xsl:value-of select="string(Country/text())" /></Code>
						</Country>
						<State><xsl:value-of select="string(State/text())" /></State>
					</OrganizationAddress>
					</xsl:if>
					</xsl:for-each>
				</OrganizationAddressCollection>
				<NoteCollection>
					<xsl:for-each select="Entities/Entities">
						<Note>
							<Description>
								<xsl:value-of select="string(Type/text())" />
							</Description>
							<IsCustomDescription>true</IsCustomDescription>
							<NoteText>
								<xsl:value-of select="string(Address/text())" />
							</NoteText>
							<NoteContext>
								<Code>AAA</Code>
								<Description>Module: A - All, Direction: A - All, Freight: A - All</Description>
							</NoteContext>
							<Visibility>
								<Code>INT</Code>
								<Description>INTERNAL</Description>
							</Visibility>
						</Note>
					</xsl:for-each>
				</NoteCollection>

				<TransportLegCollection Content="Complete">
					<xsl:for-each select="Routings/Routings">
				  <TransportLeg>
					  <PortOfDischarge>
						  <Code>
							  <xsl:value-of select="string(DestPort/Code/text())" />
						  </Code>
						  <Name></Name>
					  </PortOfDischarge>
					  <PortOfLoading>
						  <Code>
							  <xsl:value-of select="string(DeptPort/Code/text())" />
						  </Code>
						  <Name></Name>
					  </PortOfLoading>
					  <LegOrder>
						  <xsl:value-of select="string(position())" />
					  </LegOrder>
					  <ActualArrival>
						  <xsl:value-of select="string(ATADest/text())" />
					  </ActualArrival>
					  <ActualDeparture>
						  <xsl:value-of select="string(ATDDept/text())" />
					  </ActualDeparture>
					  <AircraftType>
						  <Code></Code>
					  </AircraftType>
					  <BookingStatus>
						  <Code>CNF</Code>
						  <Description></Description>
					  </BookingStatus>
					  <CarrierBookingReference></CarrierBookingReference>
					  <CarrierServiceLevel>
						  <Code></Code>
					  </CarrierServiceLevel>
					  <DocumentCutOff></DocumentCutOff>
					  <EstimatedArrival>
						  <xsl:value-of select="string(ETADest/text())" />
					  </EstimatedArrival>
					  <EstimatedDeparture>
						  <xsl:value-of select="string(ETADept/text())" />
					  </EstimatedDeparture>
					  <FCLAvailability></FCLAvailability>
					  <FCLCutOff></FCLCutOff>
					  <FCLReceivalCommences></FCLReceivalCommences>
					  <FCLStorage></FCLStorage>
					  <IsCargoOnly>true</IsCargoOnly>
					  <LCLAvailability></LCLAvailability>
					  <LCLCutOff></LCLCutOff>
					  <LCLReceivalCommences></LCLReceivalCommences>
					  <LCLStorageDate></LCLStorageDate>
					  <LegNotes></LegNotes>
					  <LegType>Other</LegType>
					  <ScheduledArrival>
						  <xsl:value-of select="string(ETADest/text())" />
					  </ScheduledArrival>
					  <ScheduledDeparture>
						  <xsl:value-of select="string(ETADept/text())" />
					  </ScheduledDeparture>
					  <TransportMode>
						  <xsl:if test="Mode/text()='S'">SEA</xsl:if>
						  <xsl:if test="Mode/text()='A'">AIR</xsl:if>
					  </TransportMode>
					  <VesselLloydsIMO></VesselLloydsIMO>
					  <VesselName>
						  <xsl:value-of select="string(CarrierVessel/text())" />
					  </VesselName>
					  <VGMCutOff></VGMCutOff>
					  <VoyageFlightNo>
						  <xsl:value-of select="substring-after(string(Remarks/text()), ':')" />
					  </VoyageFlightNo>
				  </TransportLeg>
				</xsl:for-each>
			  </TransportLegCollection>
				

				<SubShipmentCollection>

					<xsl:for-each select="AtachedHouse/AtachedHouse">
						<SubShipment>
							<!--xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
							<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
							<xsl:variable name="PackageArray" select="//package_count" />
							<xsl:variable name="PackageArrayCharactersRemoved" select="translate(translate($PackageArray,$lowercase,''),$uppercase,'')" />
							<xsl:variable name="LineCount" select="userCSharp:InitCumulativeSum(1)" />
							<xsl:variable name="FirstFieldArray" select="userCSharp:InitCumulativeConcat(4)" />
							<xsl:variable name="LineCount2" select="userCSharp:InitCumulativeSum(5)" />
							<xsl:variable name="InitPackageSum" select="userCSharp:InitCumulativeSum(6)" />
							<xsl:variable name="InitVolumeSum" select="userCSharp:InitCumulativeSum(7)" />
							<xsl:variable name="InitWeightSum" select="userCSharp:InitCumulativeSum(8)" /-->

							<DataContext>
								<DataTargetCollection>
									<DataTarget>
										<Type>ForwardingShipment</Type>
										<Key></Key>
									</DataTarget>
								</DataTargetCollection>
								<Company>
									<Code>
										<xsl:value-of select="string(../../row/CompanyID/text())" />
									</Code>
								</Company>
								<DataProvider>TRDCHN</DataProvider>
								<EnterpriseID>
									<xsl:value-of select="string(../../row/EnterpriseID/text())" />
								</EnterpriseID>
								<ServerID>
									<xsl:value-of select="string(../../row/ServerID/text())" />
								</ServerID>
							</DataContext>
							<TransportMode>
								<Code><xsl:if test="JobHeader/TransMode/text()='S'">SEA</xsl:if><xsl:if test="JobHeader/TransMode/text()='A'">AIR</xsl:if></Code>
							</TransportMode>
							<ContainerMode>
								<Code>
									<xsl:choose>
										<xsl:when test="JobHeader/TransMode/text()='A' and JobHeader/CargoType/text()='Loose'">
											<xsl:text>LSE</xsl:text>
										</xsl:when>
										<xsl:when test="JobHeader/TransMode/text()='A' and JobHeader/CargoType/text()='ULD'">
											<xsl:text>ULD</xsl:text>
										</xsl:when>
										<xsl:when test="JobHeader/TransMode/text()='S' and string-length(JobHeader/CargoType/text()) = 3">
											<xsl:value-of select="string(JobHeader/CargoType/text())" />
										</xsl:when>
										<xsl:when test="JobHeader/TransMode/text()='L' and string-length(JobHeader/CargoType/text()) = 3">
											<xsl:value-of select="string(JobHeader/CargoType/text())" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>OTH</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</Code>
							</ContainerMode>
							<GoodsDescription>
								<xsl:value-of select="../../BLInfo/GoodsDesc/text()" />
							</GoodsDescription>

							<!--OuterPacks>
					<xsl:value-of select="string($PackageArrayCharactersRemoved)" />
					
				</OuterPacks>
				<OuterPacksPackageType>
					<Code>PKG</Code>
					<Description>Package</Description>
				</OuterPacksPackageType-->

							<PortOfDestination>
								<Code><xsl:value-of select="string(Routings/Routings/DestPort/Code/text())" /></Code>
							</PortOfDestination>
							<PortOfOrigin>
								<Code><xsl:value-of select="string(Routings/Routings/DeptPort/Code/text())" /></Code>
							</PortOfOrigin>
							<ReleaseType>
								<Code></Code>
								<Description></Description>
							</ReleaseType>

							<ShipmentIncoTerm>
								<Code>
									<!--xsl:if test="contains(string(../payment/text(),'COLLECT')">
										<xsl:text>FOB</xsl:text>
									</xsl:if>
									<xsl:if test="contains(string(../payment/text(),'PREPAID')">
										<xsl:text>CFR</xsl:text>
									</xsl:if-->
								</Code>
								<Description></Description>
							</ShipmentIncoTerm>
							<ShipmentType>
								<Code>STD</Code>
								<Description>Standard House</Description>
							</ShipmentType>
							<ShippedOnBoard>
								<Code></Code>
								<Description></Description>
							</ShippedOnBoard>
							<WayBillNumber>
								<xsl:value-of select="ShippingDetail/ShipperRefNo/text()" />
							</WayBillNumber>
							<WayBillType>
								<Code>HWB</Code>
								<Description>House Waybill</Description>
							</WayBillType>

							<PackingLineCollection Content="Complete">
								<!--xsl:for-each select="..[hbl_number!='']/table/*[position()=1]">
									<xsl:variable name="AddFirstFieldName" select="userCSharp:AddToCumulativeConcat(4,string(name(.)),'')" />
								</xsl:for-each>
								<xsl:variable name="GetFirstFieldName" select="userCSharp:GetCumulativeConcat(4)" />
								<xsl:for-each select="..[hbl_number!='']/table/*[contains($GetFirstFieldName,name(.))]">
									<xsl:variable name="AddLineCount" select="userCSharp:AddToCumulativeSum(5,1,'')" />
								</xsl:for-each>
								<xsl:variable name="GetLineCount" select="userCSharp:GetCumulativeSum(5)" />
								<xsl:call-template name="generatepdflinetable"/-->
								<xsl:for-each select="Items/Items">
									<PackingLine>
										<Commodity>
											<Code>GEN</Code>
											<Description>General</Description>
										</Commodity>
										<MarksAndNos><xsl:value-of select="string(ProdName/text())" /></MarksAndNos>
										<GoodsDescription>
											<xsl:value-of select="string(ProdName/text())" />
										</GoodsDescription>
											<ContainerNumber>
												<xsl:value-of select="string(../../ContainerInfo/ContainerInfo[1]/ContNo/text())" />
											</ContainerNumber>
											<PackQty>
												<xsl:value-of select="string(Qty/text())" />										
											</PackQty>
											<ReferenceNumber>
												<xsl:value-of select="string(HSCode/text())" />
											</ReferenceNumber>
											<Volume>
												<!--xsl:value-of select="string(Volume/Value/text())" /-->
											</Volume>
											<Weight>
												<xsl:value-of select="string(GrossWt/Value/text())" />
											</Weight>
										<PackType>
											<Code>PKG</Code>
											<Description>Package</Description>
										</PackType>
										<VolumeUnit>
											<Code>M3</Code>
											<Description>Cubic Meters</Description>
										</VolumeUnit>
										<WeightUnit>
											<Code>KG</Code>
											<Description>Kilograms</Description>
										</WeightUnit>
									</PackingLine>
								</xsl:for-each>
							</PackingLineCollection>

							<!--xsl:variable name="GetPackageSum" select="userCSharp:GetCumulativeSum(6)" />
							<xsl:variable name="GetVolumeSum" select="userCSharp:GetCumulativeSum(7)" />
							<xsl:variable name="GetWeightSum" select="userCSharp:GetCumulativeSum(8)" /-->
							<xsl:for-each select="GoodsDetails/GoodsDetails[position()=last()]">
									<TotalNoOfPacks>
										<xsl:value-of select="string(NoOfPkgs/Value/text())" />	
									</TotalNoOfPacks>
									<TotalNoOfPacksPackageType>
										<Code>
											<xsl:value-of select="string(NoOfPkgs/Unit/text())" />
										</Code>
									</TotalNoOfPacksPackageType>
									<TotalVolume>
										<xsl:value-of select="string(Volume/Value/text())" />
									</TotalVolume>
									<TotalVolumeUnit>
										<Code>M3</Code>
									</TotalVolumeUnit>
									<TotalWeight>
										<xsl:value-of select="string(GrossWt/Value/text())" />
									</TotalWeight>
									<TotalWeightUnit>
										<Code>KG</Code>
									</TotalWeightUnit>
								</xsl:for-each>
							

							<OrganizationAddressCollection>
								<xsl:for-each select="Entities/Entities">
									<xsl:if test="Type/text()='Consignee'">
									<OrganizationAddress>
										<AddressType>ConsigneeDocumentaryAddress</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
									<xsl:if test="Type/text()='Shipper'">
									<OrganizationAddress>
										<AddressType>ConsignorDocumentaryAddress</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
									<xsl:if test="Type/text()='Consignee'">
									<OrganizationAddress>
										<AddressType>SendersLocalClient</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
									<xsl:if test="Type/text()='Customer'">
									<OrganizationAddress>
										<AddressType>NotifyParty</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
									<xsl:if test="Type/text()='DestinationAgent'">
									<OrganizationAddress>
										<AddressType>PickupAgent</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
									<xsl:if test="Type/text()='OriginAgent'">
									<OrganizationAddress>
										<AddressType>SendersOverseasAgent</AddressType><AddressOverride>true</AddressOverride>
										<Address1>
											<xsl:value-of select="substring(string(Address/text()), 1, 49)" />
										</Address1>
										<CompanyName>
											<xsl:value-of select="string(Name/text())" />
										</CompanyName>
										<Country>
										  <Code><xsl:value-of select="string(Country/text())" /></Code>
										</Country>
										<State><xsl:value-of select="string(State/text())" /></State>
									</OrganizationAddress>
									</xsl:if>
								</xsl:for-each>
							</OrganizationAddressCollection>
							<NoteCollection>
							<xsl:for-each select="Entities/Entities">
								<Note>
									<Description>
										<xsl:value-of select="string(Type/text())" />
									</Description>
									<IsCustomDescription>true</IsCustomDescription>
									<NoteText>
										<xsl:value-of select="string(Address/text())" />
									</NoteText>
									<NoteContext>
										<Code>AAA</Code>
										<Description>Module: A - All, Direction: A - All, Freight: A - All</Description>
									</NoteContext>
									<Visibility>
										<Code>INT</Code>
										<Description>INTERNAL</Description>
									</Visibility>
								</Note>
							</xsl:for-each>
						</NoteCollection>
							<TransportLegCollection Content="Complete">
								<xsl:for-each select="Routings/Routings">
									<TransportLeg>
										<PortOfDischarge>
											<Code>
												<xsl:value-of select="string(DestPort/Code/text())" />
											</Code>
											<Name></Name>
										</PortOfDischarge>
										<PortOfLoading>
											<Code>
												<xsl:value-of select="string(DeptPort/Code/text())" />
											</Code>
											<Name></Name>
										</PortOfLoading>
										<LegOrder>
											<xsl:value-of select="string(position())" />
										</LegOrder>
										<ActualArrival>
											<xsl:value-of select="string(ATADest/text())" />
										</ActualArrival>
										<ActualDeparture>
											<xsl:value-of select="string(ATDDept/text())" />
										</ActualDeparture>
										<AircraftType>
											<Code></Code>
										</AircraftType>
										<BookingStatus>
											<Code>CNF</Code>
											<Description></Description>
										</BookingStatus>
										<CarrierBookingReference></CarrierBookingReference>
										<CarrierServiceLevel>
											<Code></Code>
										</CarrierServiceLevel>
										<DocumentCutOff></DocumentCutOff>
										<EstimatedArrival>
											<xsl:value-of select="string(ETADest/text())" />
										</EstimatedArrival>
										<EstimatedDeparture>
											<xsl:value-of select="string(ETADept/text())" />
										</EstimatedDeparture>
										<FCLAvailability></FCLAvailability>
										<FCLCutOff></FCLCutOff>
										<FCLReceivalCommences></FCLReceivalCommences>
										<FCLStorage></FCLStorage>
										<IsCargoOnly>true</IsCargoOnly>
										<LCLAvailability></LCLAvailability>
										<LCLCutOff></LCLCutOff>
										<LCLReceivalCommences></LCLReceivalCommences>
										<LCLStorageDate></LCLStorageDate>
										<LegNotes></LegNotes>
										<LegType>Other</LegType>
										<ScheduledArrival>
											<xsl:value-of select="string(ETADest/text())" />
										</ScheduledArrival>
										<ScheduledDeparture>
											<xsl:value-of select="string(ETADept/text())" />
										</ScheduledDeparture>
										<TransportMode>
											<xsl:if test="Mode/text()='S'">SEA</xsl:if>
											<xsl:if test="Mode/text()='A'">AIR</xsl:if>
										</TransportMode>
										<VesselLloydsIMO></VesselLloydsIMO>
										<VesselName>
											<xsl:value-of select="string(CarrierVessel/text())" />
										</VesselName>
										<VGMCutOff></VGMCutOff>
										<VoyageFlightNo>
											<xsl:value-of select="substring-after(string(Remarks/text()), ':')" />
										</VoyageFlightNo>
									</TransportLeg>
								</xsl:for-each>
							</TransportLegCollection>	
						</SubShipment>
					</xsl:for-each>
					

				</SubShipmentCollection>
			</Shipment>
		</UniversalShipment>
	</xsl:template>

	<!--xsl:template name="generatepdflinetable">
		<xsl:param name="ptr" select="1" />
		<xsl:param name="total" select="userCSharp:GetCumulativeSum(5)" />
		<xsl:variable name="lcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="ucase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<PackingLine>
			<Commodity>
				<Code>GEN</Code>
				<Description>General</Description>
			</Commodity>
			<MarksAndNos></MarksAndNos>
			<GoodsDescription>
				<xsl:value-of select="string(../goods_description/text())" />
			</GoodsDescription>
			<xsl:for-each select="../table/container_number[(position(  ) + $total - $ptr)  mod $total = 0]">
				<ContainerNumber>
					<xsl:value-of select="string(./text())" />
				</ContainerNumber>
			</xsl:for-each>
			<xsl:for-each select="../table/package_count[(position(  ) + $total - $ptr)  mod $total = 0]">
				<PackQty>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddPackage" select="userCSharp:AddToCumulativeSum(6,number(substring-before(string(./text()),' ')),'')" />
				</PackQty>
			</xsl:for-each>
			<xsl:for-each select="../table/seal[(position(  ) + $total - $ptr)  mod $total = 0]">
				<ReferenceNumber>
					<xsl:value-of select="string(./text())" />
				</ReferenceNumber>
			</xsl:for-each>
			<xsl:for-each select="../table/volume[(position(  ) + $total - $ptr)  mod $total = 0]">
				<Volume>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddVolume" select="userCSharp:AddToCumulativeSum(7,number(substring-before(string(./text()),' ')),'')" />
				</Volume>
			</xsl:for-each>
			<xsl:for-each select="../table/chargeable_weight[(position(  ) + $total - $ptr)  mod $total = 0]">
				<Weight>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddWeight" select="userCSharp:AddToCumulativeSum(8,number(substring-before(string(./text()),' ')),'')" />
				</Weight>
			</xsl:for-each>
			<PackType>
				<Code>PKG</Code>
				<Description>Package</Description>
			</PackType>
			<VolumeUnit>
				<Code>M3</Code>
				<Description>Cubic Meters</Description>
			</VolumeUnit>
			<WeightUnit>
				<Code>KG</Code>
				<Description>Kilograms</Description>
			</WeightUnit>
		</PackingLine>
		<xsl:if test="not($ptr = $total)">
			<xsl:call-template name="generatepdflinetable">
				<xsl:with-param name="ptr" select="$ptr + 1" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<xsl:template name="generatepdflinetable2">
		<xsl:param name="ptr2" select="1" />
		<xsl:param name="total2" select="userCSharp:GetCumulativeSum(51)" />
		<xsl:variable name="lcase2" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="ucase2" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<Container>
			<MarksAndNos></MarksAndNos>
			<GoodsDescription>
				<xsl:value-of select="string(../goods_description/text())" />
			</GoodsDescription>
			<xsl:for-each select="../table/container_number[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<ContainerNumber>
					<xsl:value-of select="string(./text())" />
				</ContainerNumber>
			</xsl:for-each>
			<xsl:for-each select="../table/container_type[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<ContainerType>
					<Code>40OT</Code>
				</ContainerType>
			</xsl:for-each>
			<xsl:for-each select="../table/package_count[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<PackQty>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddPackage" select="userCSharp:AddToCumulativeSum(6,number(substring-before(string(./text()),' ')),'')" />
				</PackQty>
			</xsl:for-each
			<xsl:for-each select="../table/seal[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<Seal>
					<xsl:value-of select="string(./text())" />
				</Seal>
			</xsl:for-each>
			<xsl:for-each select="../table/volume[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<VolumeCapacity>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddVolume" select="userCSharp:AddToCumulativeSum(7,number(substring-before(string(./text()),' ')),'')" />
				</VolumeCapacity>
			</xsl:for-each>
			<xsl:for-each select="../table/chargeable_weight[(position(  ) + $total2 - $ptr2)  mod $total2 = 0]">
				<WeightCapacity>
					<xsl:value-of select="substring-before(string(./text()),' ')" />
					<xsl:variable name="AddWeight" select="userCSharp:AddToCumulativeSum(8,number(substring-before(string(./text()),' ')),'')" />
				</WeightCapacity>
			</xsl:for-each>
			<PackType>
				<Code>PKG</Code>
				<Description>Package</Description>
			</PackType>
			<VolumeUnit>
				<Code>M3</Code>
				<Description>Cubic Meters</Description>
			</VolumeUnit>
			<WeightUnit>
				<Code>KG</Code>
				<Description>Kilograms</Description>
			</WeightUnit>

		</Container>
		<xsl:if test="not($ptr2 = $total2)">
			<xsl:call-template name="generatepdflinetable">
				<xsl:with-param name="ptr2" select="$ptr2 + 1" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template-->

	<!--msxsl:script language="C#" implements-prefix="userCSharp">
		<![CDATA[
public string SAM_IVC_DT()
{
     return DateTime.Now.ToString("yyyyMMdd");
}

public string FOOT_FILE_NAME()
{
     return "H" + DateTime.Now.ToString("yyMMdd") + "1";
}

public string FOOT_DATE()
{
     return DateTime.Now.ToString("yyyyMMdd");
}

public string FOOT_TIME()
{
     return DateTime.Now.ToString("hhssmm");
}

public string SAM_D_HS_CODE()
{
     return "000000<>";
}


]]>
	</msxsl:script-->
</xsl:stylesheet>