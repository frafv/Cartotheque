<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="l c p xs">

<xsl:import href="External.xslt"/>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="FindProxy" match="/l:LocationList/p:ExternalList/*[@e:Name]" use="@e:Name"/>

<xsl:template match="/l:LocationList">
	<LocationList xmlns="urn:geo-schemas-xml-frafv:location">
		<xsl:apply-templates select="l:ContinentList|l:LocationTypeList" mode="MakeExport"/>
		<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
			<xsl:call-template name="MakeLanguageProxy"/>
		</ExternalList>
	</LocationList>
</xsl:template>
<xsl:template match="l:ContinentList" mode="MakeExport">
	<ExportList xmlns="urn:schemas-xml-frafv:proxy">
		<Prefix External="locEarth"/>
		<xsl:apply-templates select="l:Continent" mode="MakeExport"/>
	</ExportList>
</xsl:template>
<xsl:template match="l:Continent" mode="MakeExport">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy"/>
</xsl:template>
<xsl:template match="l:LocationTypeList" mode="MakeExport">
	<ExportList xmlns="urn:schemas-xml-frafv:proxy">
		<Prefix External="loctype"/>
		<xsl:apply-templates select="l:LocationType" mode="MakeExport"/>
	</ExportList>
</xsl:template>
<xsl:template match="l:LocationType" mode="MakeExport">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy"/>
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
</xsl:stylesheet>
