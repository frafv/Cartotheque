<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tz="urn:geo-schemas-xml-frafv:timezone" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="tz c p xs">

<xsl:import href="../Schemas/Transform/External.xslt"/>
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="FindProxy" match="/tz:TimeZoneList/p:ExternalList/*[@e:Name]" use="@e:Name"/>
<xsl:variable name="root" select="/tz:TimeZoneList"/>

<xsl:template match="/tz:TimeZoneList">
	<TimeZoneList xmlns="urn:geo-schemas-xml-frafv:timezone">
		<ExportList xmlns="urn:schemas-xml-frafv:proxy">
			<Prefix External="timezone"/>
			<xsl:apply-templates select="tz:TimeZone" mode="MakeExport"/>
		</ExportList>
		<ExportList xmlns="urn:schemas-xml-frafv:proxy">
			<xsl:for-each select="e:ExportList[not(e:Prefix)]/e:Export">
				<xsl:variable name="exname" select="concat(' ',@Name,' ')"/>
				<xsl:variable name="tz" select="/tz:TimeZoneList/tz:TimeZone[contains($exname,concat(' ',@Name,' '))]"/>
				<xsl:if test="$tz">
					<xsl:apply-templates select="." mode="MakeExport">
						<xsl:with-param name="TZ" select="$tz"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="tz:TimeZone[not(starts-with(tz:Info[not(@Year)][1]/@Bias, '-'))]">
				<xsl:sort select="tz:Info[not(@Year)][1]/@Bias" order="descending"/>
				<xsl:variable name="tzname" select="concat(' ',@Name,' ')"/>
				<xsl:if test="not(/tz:TimeZoneList/e:ExportList[not(e:Prefix)]/e:Export[contains(concat(' ',@Name,' '),$tzname)])">
					<xsl:apply-templates select="." mode="MakeExportGroup"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="tz:TimeZone[starts-with(tz:Info[not(@Year)][1]/@Bias, '-')]">
				<xsl:sort select="tz:Info[not(@Year)][1]/@Bias" order="ascending"/>
				<xsl:variable name="tzname" select="concat(' ',@Name,' ')"/>
				<xsl:if test="not(/tz:TimeZoneList/e:ExportList[not(e:Prefix)]/e:Export[contains(concat(' ',@Name,' '),$tzname)])">
					<xsl:apply-templates select="." mode="MakeExportGroup"/>
				</xsl:if>
			</xsl:for-each>
		</ExportList>
		<ExternalList xmlns="urn:geo-schemas-xml-frafv:proxy">
			<xsl:call-template name="MakeLanguageProxy"/>
		</ExternalList>
	</TimeZoneList>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="MakeExport">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy"/>
</xsl:template>
<xsl:template match="e:Export" mode="MakeExport">
	<xsl:param name="TZ"/>
	<xsl:variable name="name">
		<xsl:for-each select="$TZ">
			<xsl:value-of select="concat(@Name, ' ')"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="label" select="$TZ/tz:Label[@xml:lang='en' and (@Type='Standard' or not(@Type))][last()]"/>
	<xsl:variable name="display">
		<xsl:for-each select="$label">
			<xsl:value-of select="concat(., ', ')"/>
		</xsl:for-each>
	</xsl:variable>
	<Export xmlns="urn:schemas-xml-frafv:proxy">
		<xsl:attribute name="Name">
			<xsl:value-of select="substring($name,1,string-length($name)-1)"/>
		</xsl:attribute>
		<xsl:copy-of select="@External"/>
		<Label>
			<xsl:copy-of select="$label[1]/@*[name()!='Type']"/>
			<xsl:value-of select="substring($display,1,string-length($display)-2)"/>
		</Label>
		<xsl:copy-of select="e:Label[@Type='Abbr']"/>
	</Export>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="MakeExportGroup">
	<Export Name="{@Name}" xmlns="urn:schemas-xml-frafv:proxy">
		<xsl:attribute name="External">
			<xsl:text>UTC</xsl:text>
			<xsl:for-each select="tz:Info[not(@Year)][1]">
				<xsl:choose>
					<xsl:when test="@Bias = '00:00:00'"/>
					<xsl:when test="starts-with(@Bias, '-')">
						<xsl:if test="not(starts-with(@Bias, '-0'))"><xsl:value-of select="substring(@Bias, 2, 1)"/></xsl:if>
						<xsl:value-of select="substring(@Bias, 3, 1)"/>
						<xsl:if test="substring(@Bias, 4) != ':00:00'"><xsl:value-of select="substring(@Bias, 5, 2)"/></xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
						<xsl:if test="not(starts-with(@Bias, '0'))"><xsl:value-of select="substring(@Bias, 1, 1)"/></xsl:if>
						<xsl:value-of select="substring(@Bias, 2, 1)"/>
						<xsl:if test="substring(@Bias, 3) != ':00:00'"><xsl:value-of select="substring(@Bias, 4, 2)"/></xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:value-of select="@Name"/>
		</xsl:attribute>
		<xsl:for-each select="tz:Label[@xml:lang='en' and (@Type='Standard' or not(@Type))][last()]">
			<Label>
				<xsl:copy-of select="@*[name()!='Type']"/>
				<xsl:value-of select="."/>
			</Label>
		</xsl:for-each>
	</Export>
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
	<xsl:variable name="lang" select="@Name"/>
	<xsl:variable name="parent" select="parent::c:Language/@Name"/>
	<xsl:variable name="ex">
		<xsl:choose>
			<xsl:when test="$parent and not($root/tz:TimeZone/tz:Label[starts-with(@xml:lang,concat($parent,'-')) and @xml:lang!=$lang]) and not($root/tz:TimeZone/tz:Label[@xml:lang=$parent])">
				<xsl:value-of select="$parent"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$lang"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$lang=$ex">
			<xsl:apply-templates select="c:Label" mode="CopyLang">
				<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="parent::c:Language/c:Label" mode="CopyLang">
				<xsl:with-param name="NS">urn:geo-schemas-xml-frafv:proxy</xsl:with-param>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
