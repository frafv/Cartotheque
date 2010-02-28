<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="c p xs">

<xsl:import href="External.xslt"/>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="FindProxy" match="/c:CultureList/p:ExternalList/*[@e:Name]" use="@e:Name"/>

<xsl:template match="/c:CultureList">
	<CultureList xmlns="urn:geo-schemas-xml-frafv:culture">
		<xsl:apply-templates select="c:LanguageList" mode="MakeExport"/>
		<xsl:variable name="CodeRef" select="//c:Code/@Source"/>
		<xsl:if test="$CodeRef">
			<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
				<e:Prefix External="org"/>
				<xsl:call-template name="MakeProxySimpleList">
					<xsl:with-param name="List" select="$CodeRef"/>
				</xsl:call-template>
			</ExternalList>
		</xsl:if>
	</CultureList>
</xsl:template>
<xsl:template match="c:LanguageList" mode="MakeExport">
	<ExportList xmlns="urn:schemas-xml-frafv:proxy">
		<Prefix External="lang"/>
		<xsl:apply-templates select=".//c:Language[c:Code]" mode="MakeExport"/>
	</ExportList>
</xsl:template>
<xsl:template match="c:Language" mode="MakeExport">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy"/>
</xsl:template>
<xsl:template match="c:Code/@Source" mode="MakeProxy">
	<Company xmlns="urn:geo-schemas-xml-frafv:proxy">
		<xsl:apply-templates select="." mode="CopyProxyContent"/>
	</Company>
</xsl:template>
</xsl:stylesheet>
