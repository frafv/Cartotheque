<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="l c e xs">

<xsl:import href="External.xslt"/>

<!-- Location proxy constructor (from LocationType.xml) by ID. -->
<xsl:template match="@*" mode="MakeGeoLocationProxyList">
	<xsl:param name="ID" select="."/>
	<xsl:param name="ExPrefix"/>
	<xsl:param name="ExSelect"/>

	<xsl:choose>
		<xsl:when test="key('FindProxy', $ID)">
			<xsl:apply-templates select="." mode="CopyProxyContent"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="document('..\..\..\Geo\Locations.xml')/l:LocationList" mode="CopyExternal">
				<xsl:with-param name="LocalName" select="$ID"/>
				<xsl:with-param name="ExPrefix" select="$ExPrefix"/>
				<xsl:with-param name="ExSelect" select="$ExSelect"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Copies location elements (into namespace NS) with unique languages
     and expand Part labels by location type (Type). -->
<xsl:template match="*" mode="CopyLocationLang">
	<xsl:param name="NS" select="''"/>
	<xsl:param name="Type"/>
	<xsl:variable name="name" select="local-name()"/>
	<xsl:variable name="lang" select="@xml:lang"/>

	<xsl:if test="not(preceding-sibling::*[local-name() = $name and @xml:lang = $lang])">
		<xsl:element name="{$name}" namespace="{$NS}">
			<xsl:choose>
				<xsl:when test="contains(concat(' ',@Type,' '),' Part ') and $Type">
					<xsl:apply-templates select="@Type" mode="ExcludeValue">
						<xsl:with-param name="Value">Part</xsl:with-param>
					</xsl:apply-templates>
					<xsl:copy-of select="@*[name()!='Type']"/>
					<xsl:variable name="TypeLabel" select="$Type/*[local-name() = $name and (@xml:lang = $lang or contains($lang, '-') and @xml:lang = substring-before($lang, '-')) and contains(concat(' ',@Type,' '), ' Part ')][1]"/>
					<xsl:if test="not($TypeLabel)">
						<xsl:message terminate="yes">Location type <xsl:value-of select="$Type/@e:Name"/> label part for language <xsl:value-of select="$lang"/> not found.</xsl:message>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@Pos = 'Suffix' or not(@Pos) and $TypeLabel/@Pos = 'Prefix'">							
							<xsl:value-of select="concat($TypeLabel,' ',.)"/>
						</xsl:when>
						<xsl:when test="@Pos = 'Prefix' or not(@Pos) and $TypeLabel/@Pos = 'Suffix'">
							<xsl:value-of select="concat(.,' ',$TypeLabel)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:message terminate="yes">Location type <xsl:value-of select="$Type/@e:Name"/> label part position for language <xsl:value-of select="$lang"/> not found.</xsl:message>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
