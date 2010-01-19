<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tz="urn:geo-schemas-xml-frafv:timezone" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tz e">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:template match="/tz:TimeZoneList">
	<xsl:for-each select="tz:TimeZone">
		<xsl:variable name="tzname" select="concat(' ',@Name,' ')"/>
		<xsl:if test="not(/tz:TimeZoneList/e:ExportList[not(e:Prefix)]/e:Export[contains(concat(' ',@Name,' '),$tzname)])">
			<xsl:message terminate="yes">Time zone <xsl:value-of select="$tzname"/> is lost</xsl:message>
		</xsl:if>
	</xsl:for-each>
	<xs:simpleType>
		<xs:restriction base="xs:string">
			<xsl:for-each select="e:ExportList[not(e:Prefix)]/e:Export">
				<xsl:variable name="export" select="@Name"/>
				<xsl:apply-templates select="/tz:TimeZoneList/tz:TimeZone[contains(concat(' ',$export,' '),concat(' ',@Name,' '))]"/>
			</xsl:for-each>
		</xs:restriction>
	</xs:simpleType>
</xsl:template>
<xsl:template match="tz:TimeZone">
	<xsl:variable name="name" select="concat(@Name,' ')"/>
	<xsl:variable name="export" select="/tz:TimeZoneList/e:ExportList[not(e:Prefix)]/e:Export[starts-with(concat(@Name,' '),$name)]"/>
	<xsl:variable name="group" select="/tz:TimeZoneList/tz:TimeZone[contains(concat(' ',$export/@Name,' '),concat(' ',@Name,' '))]"/>
	<xsl:if test="$export">
		<xs:enumeration>
			<xsl:attribute name="value">
				<xsl:call-template name="MakeUTC">
					<xsl:with-param name="Code" select="$export/e:Label[@Type='Abbr']"/>
				</xsl:call-template>
			</xsl:attribute>
			<xs:annotation>
				<xsl:for-each select="$export/e:Label[not(@Source) and not(@Type='Abbr')]">
					<xs:documentation xml:lang="{@xml:lang}">
						<xsl:value-of select="."/>
					</xs:documentation>
				</xsl:for-each>
				<xsl:choose>
					<xsl:when test="tz:Info[not(@Year) and tz:Date[@Type='Daylight']]">
						<xsl:if test="$group[not(tz:Info[not(@Year) and tz:Date[@Type='Daylight']])]">
							<xsl:message terminate="yes">Invalid grouping <xsl:value-of select="$export/@Name"/></xsl:message>
						</xsl:if>
						<xsl:variable name="dts">
							<xsl:apply-templates select="tz:Info[not(@Year) and tz:Date[@Type='Daylight']][1]"/>
						</xsl:variable>
						<xsl:for-each select="$group">
							<xsl:variable name="check">
								<xsl:apply-templates select="tz:Info[not(@Year) and tz:Date[@Type='Daylight']][1]"/>
							</xsl:variable>
							<xsl:if test="$dts!=$check">
								<xsl:message terminate="yes">Invalid grouping <xsl:value-of select="$name"/> with <xsl:value-of select="@Name"/> "<xsl:value-of select="$dts"/>"!="<xsl:value-of select="$check"/>"</xsl:message>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$group[tz:Info[not(@Year) and tz:Date[@Type='Daylight']]]">
							<xsl:message terminate="yes">Invalid grouping <xsl:value-of select="$export/@Name"/></xsl:message>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="tz:Info[not(@Year) and tz:Date[@Type='Daylight']][1]"/>
			</xs:annotation>
		</xs:enumeration>
	</xsl:if>
</xsl:template>
<xsl:template name="MakeUTC">
	<xsl:param name="Code"/>
	<xsl:text>UTC</xsl:text>
	<xsl:for-each select="tz:Info[not(@Year)][1]">
		<xsl:choose>
			<xsl:when test="@Bias = '00:00:00'"/>
			<xsl:when test="starts-with(@Bias, '-')">
				<xsl:text>+</xsl:text>
				<xsl:if test="not(starts-with(@Bias, '-0'))"><xsl:value-of select="substring(@Bias, 2, 1)"/></xsl:if>
				<xsl:value-of select="substring(@Bias, 3, 1)"/>
				<xsl:if test="substring(@Bias, 4) != ':00:00'"><xsl:value-of select="substring(@Bias, 4, 3)"/></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>-</xsl:text>
				<xsl:if test="not(starts-with(@Bias, '0'))"><xsl:value-of select="substring(@Bias, 1, 1)"/></xsl:if>
				<xsl:value-of select="substring(@Bias, 2, 1)"/>
				<xsl:if test="substring(@Bias, 3) != ':00:00'"><xsl:value-of select="substring(@Bias, 3, 3)"/></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="$Code">
		<xsl:text> </xsl:text>
		<xsl:value-of select="."/>
	</xsl:for-each>
</xsl:template>
<xsl:template match="tz:Info">
	<xs:appinfo source="DST">
		<xs:documentation xml:lang="en">
			<xsl:value-of select="tz:Date[@Type='Daylight']"/>
			<xsl:text> – </xsl:text>
			<xsl:value-of select="tz:Date[@Type='Standard']"/>
		</xs:documentation>
	</xs:appinfo>
</xsl:template>
</xsl:stylesheet>
