<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="l c p xs">

<xsl:import href="../Schemas/Transform/GeoExternal.xslt"/>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="FindProxy" match="/l:LocationList/p:ExternalList/*[@e:Name]" use="@e:Name"/>

<xsl:template match="/l:LocationList">
	<LocationList xmlns="urn:geo-schemas-xml-frafv:location">
		<ExportList xmlns="urn:schemas-xml-frafv:proxy">
			<Prefix External="loc"/>
			<xsl:apply-templates select="l:ContinentList/l:Continent|l:LocationTypeList/l:LocationType|l:CountryList/l:Country|l:RegionList/l:Region|l:CityList/l:City|l:StreetList/l:Street" mode="MakeExport"/>
		</ExportList>
		<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
			<xsl:call-template name="MakeLanguageProxy"/>
		</ExternalList>
		<xsl:variable name="Continent" select="l:ContinentList/l:Continent/@Name"/>
		<xsl:variable name="ContinentRef" select="l:CountryList/l:Location/@Continent"/>
		<xsl:if test="$ContinentRef">
			<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
				<e:Prefix External="loc"/>
				<xsl:call-template name="MakeProxySimpleList">
					<xsl:with-param name="List" select="$ContinentRef"/>
					<xsl:with-param name="Skip" select="$Continent"/>
				</xsl:call-template>
			</ExternalList>
		</xsl:if>
		<xsl:variable name="LocType" select="l:LocationTypeList/l:LocationType/@Name"/>
		<xsl:variable name="LocTypeRef" select="(l:CountryList/l:Country|l:RegionList/l:Region|l:CityList/l:City|l:StreetList/l:Street)/l:Form/@Type"/>
		<xsl:if test="$LocTypeRef">
			<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
				<e:Prefix External="loctype"/>
				<xsl:call-template name="MakeProxySimpleList">
					<xsl:with-param name="List" select="$LocTypeRef"/>
					<xsl:with-param name="Skip" select="$LocType"/>
				</xsl:call-template>
			</ExternalList>
		</xsl:if>
		<xsl:variable name="Country" select="l:CountryList/l:Country/@Name"/>
		<xsl:variable name="Region" select="l:RegionList/l:Region/@Name"/>
		<xsl:variable name="City" select="l:CityList/l:City/@Name"/>
		<xsl:variable name="CountryRef" select="(l:CountryList/l:Country/l:Form/l:Reference|l:RegionList/l:Location|l:RegionList/l:Region/l:Form/l:Reference|l:CityList/l:Location|l:CityList/l:City/l:Form/l:Reference)/@Country"/>
		<xsl:variable name="RegionRef" select="(l:RegionList/l:Location|l:RegionList/l:Region/l:Form/l:Reference|l:CityList/l:Location|l:CityList/l:City/l:Form/l:Reference)/@Region"/>
		<xsl:variable name="CityRef" select="(l:RegionList/l:Location|l:RegionList/l:Region/l:Form/l:Reference|l:CityList/l:City/l:Form/l:Reference|l:StreetList/l:Location)/@City"/>
		<xsl:if test="$CountryRef and not($Country) or $RegionRef and not($Region) or $CityRef and not($City)">
			<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
				<e:Prefix External="loc"/>
				<xsl:call-template name="MakeProxyList">
					<xsl:with-param name="List" select="$CountryRef"/>
					<xsl:with-param name="Skip" select="$Country"/>
				</xsl:call-template>
				<xsl:call-template name="MakeProxyList">
					<xsl:with-param name="List" select="$RegionRef"/>
					<xsl:with-param name="Skip" select="$Region"/>
				</xsl:call-template>
				<xsl:call-template name="MakeProxyList">
					<xsl:with-param name="List" select="$CityRef"/>
					<xsl:with-param name="Skip" select="$City"/>
				</xsl:call-template>
			</ExternalList>
		</xsl:if>
		<xsl:variable name="CodeRef" select="//l:Code/@Source"/>
		<xsl:if test="$CodeRef">
			<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
				<e:Prefix External="org"/>
				<xsl:call-template name="MakeProxySimpleList">
					<xsl:with-param name="List" select="$CodeRef"/>
					<xsl:with-param name="Skip" select="/l:LocationList/l:CountryList/l:Country/@Name"/>
				</xsl:call-template>
			</ExternalList>
		</xsl:if>
	</LocationList>
</xsl:template>
<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="MakeExport">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy"/>
</xsl:template>
<xsl:template match="@Continent" mode="MakeProxy">
	<Location Type="Continent" xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeLocationProxy">
			<xsl:with-param name="ExPrefix">loc</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalContinent</xsl:with-param>
		</xsl:apply-templates>
	</Location>
</xsl:template>
<xsl:template match="@Type" mode="MakeProxy">
	<LocationType xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeLocationProxy">
			<xsl:with-param name="ExPrefix">loctype</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalLocationType</xsl:with-param>
		</xsl:apply-templates>
	</LocationType>
</xsl:template>
<xsl:template match="l:Continent" mode="CreateProxy">
	<xsl:apply-templates select="l:Label" mode="CopyLang">
		<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="l:LocationType" mode="CreateProxy">
	<xsl:apply-templates select="l:Label[not(contains(concat(' ',@Type,' '),' Part '))]" mode="CopyLang">
		<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
	</xsl:apply-templates>
	<xsl:for-each select="l:Label[contains(concat(' ',@Type,' '),' Part ')]">
		<Label xmlns="urn:geo-schemas-xml-frafv:proxy">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="."/>
		</Label>
	</xsl:for-each>
</xsl:template>
<xsl:template match="@xml:lang" mode="MakeProxy">
	<Language xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeCultureProxy">
			<xsl:with-param name="ExPrefix">lang</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalLanguage</xsl:with-param>
		</xsl:apply-templates>
	</Language>
</xsl:template>
<xsl:template match="c:Language" mode="CreateProxy">
	<xsl:apply-templates select="c:Label" mode="CopyLang">
		<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="l:Code/@Source" mode="MakeProxy">
	<Company xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="CopyProxyContent"/>
	</Company>
</xsl:template>
<xsl:template match="@Country" mode="MakeProxyList">
	<xsl:param name="ID"/>
	<Location Type="Country" Name="{$ID}" xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeGeoLocationProxyList">
			<xsl:with-param name="ID" select="$ID"/>
			<xsl:with-param name="ExPrefix">loc</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalCountry</xsl:with-param>
		</xsl:apply-templates>
	</Location>
</xsl:template>
<xsl:template match="@Region" mode="MakeProxyList">
	<xsl:param name="ID"/>
	<Location Type="Region" Name="{$ID}" xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeGeoLocationProxyList">
			<xsl:with-param name="ID" select="$ID"/>
			<xsl:with-param name="ExPrefix">loc</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalRegion</xsl:with-param>
		</xsl:apply-templates>
	</Location>
</xsl:template>
<xsl:template match="@City" mode="MakeProxyList">
	<xsl:param name="ID"/>
	<Location Type="City" Name="{$ID}" xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="MakeGeoLocationProxyList">
			<xsl:with-param name="ID" select="$ID"/>
			<xsl:with-param name="ExPrefix">loc</xsl:with-param>
			<xsl:with-param name="ExSelect">ExternalCity</xsl:with-param>
		</xsl:apply-templates>
	</Location>
</xsl:template>
<xsl:template match="l:Country|l:Region|l:City" mode="CreateProxy">
	<xsl:variable name="Type" select="l:Form/@Type"/>
	<xsl:apply-templates select="l:Label" mode="CopyLocationLang">
		<xsl:with-param name="Type" select="key('FindProxy',$Type)|/l:LocationList/l:LocationTypeList/l:LocationType[@Name=$Type]"/>
		<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
