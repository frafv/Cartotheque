<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tz="urn:geo-schemas-xml-frafv:timezone" xmlns:p="urn:geo-schemas-xml-frafv:proxy">
<xsl:import href="TZViewEn.xsl"/>
<xsl:output encoding="UTF-8" method="text"/>
<xsl:param name="UTC" select="'Index'"/>
<xsl:template match="tz:TimeZoneList" mode="Header">
	<xsl:text>#summary List of Time Zones</xsl:text>
	<xsl:text>&#10;&#10;This is a list of Time Zones from Microsoft Windows.&#10;</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZoneList" mode="UTCHeader">
	<xsl:param name="Label"/>
	<xsl:text>#summary List of Time Zones </xsl:text>
	<xsl:value-of select="$Label"/>
	<xsl:text>&#10;&#10;This is a list of Time Zones from Microsoft Windows.</xsl:text>
	<xsl:text>&#10;&#10;&lt;wiki:toc max_depth="1" /&gt;</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Header">
	<xsl:text>&#10;  * [TimeZoneListUTC</xsl:text>
	<xsl:choose>
		<xsl:when test="starts-with(tz:Info[not(@Year)]/@Bias,'-')">
			<xsl:text>p</xsl:text>
			<xsl:value-of select="-number(substring-before(tz:Info[not(@Year)]/@Bias,':'))"/>
		</xsl:when>
		<xsl:when test="starts-with(tz:Info[not(@Year)]/@Bias,'00:')"></xsl:when>
		<xsl:otherwise>
			<xsl:text>m</xsl:text>
			<xsl:value-of select="number(substring-before(tz:Info[not(@Year)]/@Bias,':'))"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>#</xsl:text>
	<xsl:variable name="Link">
		<xsl:apply-templates select="." mode="Index"/>
	</xsl:variable>
	<xsl:value-of select="translate($Link,' \/','___')"/>
	<xsl:text>&#32;</xsl:text>
	<xsl:apply-templates select="." mode="Label"/>
	<xsl:text>]</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="LabelHeader">
	<xsl:text>&#10;&#10;=== Different languages ===</xsl:text>
	<xsl:text>&#10;|| *Language* || *Time Zone Name* || *Daylight Saving Time* || *Standard Time* ||</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Footer">
	<xsl:text>&#10;&#10;[TimeZoneList Index]</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="UTCTitle">
	<xsl:param name="Position"/>
	<xsl:if test="$Position!=1">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:text>GMT</xsl:text>
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
</xsl:template>
<xsl:template match="*" mode="DateLabelNoDST">
	<xsl:text>&#10;  * *Daylight Saving Time:* not set</xsl:text>
</xsl:template>
<xsl:template match="tz:Info" mode="Header">
	<xsl:text>&#10;</xsl:text>
	<xsl:if test="@Year">
		<xsl:text>&#10;*</xsl:text>
		<xsl:value-of select="@Year"/>
		<xsl:text> year only*</xsl:text>
	</xsl:if>
</xsl:template>
<xsl:template match="tz:Date[@Time]">
	<xsl:text>&#10;  * *</xsl:text>
	<xsl:apply-templates select="." mode="Label"/>
	<xsl:text>:* </xsl:text>
	<xsl:if test="@Bias and @Time">
		<xsl:choose>
			<xsl:when test="@Bias = '-01:00:00'">add 1 hour </xsl:when>
			<xsl:when test="@Bias = '01:00:00'">subtract 1 hour </xsl:when>
			<xsl:otherwise><xsl:value-of select="@Bias"/></xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="@Date and @Day">(</xsl:if>
	<xsl:if test="@Week and @Day">
		<xsl:text>on </xsl:text>
		<xsl:value-of select="@Week"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@Day"/>
		<xsl:text> of </xsl:text>
	</xsl:if>
	<xsl:if test="@Date">
		<xsl:if test="@Day">) </xsl:if>
		<xsl:if test="substring(@Date, 9, 1)!='0'"><xsl:value-of select="substring(@Date, 9, 1)"/></xsl:if>
		<xsl:value-of select="substring(@Date, 10, 1)"/>
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="@Month = 'January' or substring(@Date, 6, 2) = '01'">January</xsl:when>
		<xsl:when test="@Month = 'February' or substring(@Date, 6, 2) = '02'">February</xsl:when>
		<xsl:when test="@Month = 'March' or substring(@Date, 6, 2) = '03'">March</xsl:when>
		<xsl:when test="@Month = 'April' or substring(@Date, 6, 2) = '04'">April</xsl:when>
		<xsl:when test="@Month = 'May' or substring(@Date, 6, 2) = '05'">May</xsl:when>
		<xsl:when test="@Month = 'June' or substring(@Date, 6, 2) = '06'">June</xsl:when>
		<xsl:when test="@Month = 'July' or substring(@Date, 6, 2) = '07'">July</xsl:when>
		<xsl:when test="@Month = 'August' or substring(@Date, 6, 2) = '08'">August</xsl:when>
		<xsl:when test="@Month = 'September' or substring(@Date, 6, 2) = '09'">September</xsl:when>
		<xsl:when test="@Month = 'October' or substring(@Date, 6, 2) = '10'">October</xsl:when>
		<xsl:when test="@Month = 'November' or substring(@Date, 6, 2) = '11'">November</xsl:when>
		<xsl:when test="@Month = 'December' or substring(@Date, 6, 2) = '12'">December</xsl:when>
	</xsl:choose>
	<xsl:if test="not(parent::tz:Info/@Year) and @Date">
		 <xsl:text> </xsl:text>
		 <xsl:value-of select="substring(@Date, 1, 4)"/>
	</xsl:if>
	<xsl:if test="@Time">
		<xsl:text> at </xsl:text>
		<xsl:if test="substring(@Time, 1, 1)!='0'"><xsl:value-of select="substring(@Time, 1, 1)"/></xsl:if>
		<xsl:value-of select="substring(@Time, 2, 4)"/>
		<xsl:if test="substring(@Time, 7, 2)!='00'"><xsl:value-of select="substring(@Time, 6, 3)"/></xsl:if>
	</xsl:if>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Index">
	<xsl:choose>
		<xsl:when test="tz:Link[@Type='WindowsRegistry'] and contains(tz:Link[@Type='WindowsRegistry']/@URL,'Time Zones\')">
			<xsl:value-of select="substring-after(tz:Link[@Type='WindowsRegistry']/@URL,'Time Zones\')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@Name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Details">
	<xsl:text>&#10;&#10;----</xsl:text>
	<xsl:text>&#10;=== </xsl:text>
	<xsl:apply-templates select="." mode="Index"/>
	<xsl:text> ===</xsl:text>
	<xsl:text>&#10;= </xsl:text>
	<xsl:apply-templates select="." mode="Label"/>
	<xsl:text> =</xsl:text>
	<xsl:text>&#10;  * `</xsl:text>
	<xsl:value-of select="tz:Link[@Type='WindowsRegistry']/@URL"/>
	<xsl:text>`&#10;</xsl:text>
	<xsl:apply-templates select="." mode="Title"/>
	<xsl:for-each select="tz:Info[not(@Year)]">
		<xsl:text>&#10;  * *</xsl:text>
		<xsl:apply-templates select="." mode="BiasLabel"/>
		<xsl:text>:* </xsl:text>
		<xsl:choose>
			<xsl:when test="@Bias = '00:00:00'"><xsl:value-of select="substring(@Bias, 1, 5)"/></xsl:when>
			<xsl:when test="starts-with(@Bias, '-')">+<xsl:value-of select="substring(@Bias, 2, 5)"/></xsl:when>
			<xsl:otherwise>-<xsl:value-of select="substring(@Bias, 1, 5)"/></xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:apply-templates select="tz:Info"/>
	<xsl:apply-templates select="." mode="LabelHeader"/>
	<xsl:for-each select="tz:Label">
		<xsl:variable name="Lang" select="@xml:lang"/>
		<xsl:if test="not(preceding-sibling::tz:Label[@xml:lang = $Lang])">
			<xsl:for-each select="parent::tz:TimeZone">
				<xsl:text>&#10;|| </xsl:text>
				<xsl:apply-templates select="$Lang" mode="LangLabel"/>
				<xsl:text> || </xsl:text>
				<xsl:value-of select="tz:Label[not(@Type) and @xml:lang=$Lang]"/>
				<xsl:text> || </xsl:text>
				<xsl:value-of select="tz:Label[@Type='Daylight' and @xml:lang=$Lang]"/>
				<xsl:text> || </xsl:text>
				<xsl:value-of select="tz:Label[@Type='Standard' and @xml:lang=$Lang]"/>
				<xsl:text> ||</xsl:text>
			</xsl:for-each>
		</xsl:if>
	</xsl:for-each>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>
<xsl:template match="/tz:TimeZoneList">
	<xsl:choose>
		<xsl:when test="$UTC='Index'">
			<xsl:apply-templates select="." mode="Header"/>
			<xsl:apply-templates select="tz:TimeZone[tz:Link/@Type='WindowsRegistry' and not(starts-with(tz:Info[not(@Year)]/@Bias, '-'))]" mode="Header">
				<xsl:sort select="tz:Info[not(@Year)]/@Bias" order="descending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="tz:TimeZone[tz:Link/@Type='WindowsRegistry' and starts-with(tz:Info[not(@Year)]/@Bias, '-')]" mode="Header">
				<xsl:sort select="tz:Info[not(@Year)]/@Bias"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="List" select="tz:TimeZone[tz:Link/@Type='WindowsRegistry' and tz:Info[not(@Year) and number(substring-before(@Bias,':'))=-number($UTC)]]"/>
			<xsl:variable name="UTCList">
				<xsl:for-each select="$List">
					<xsl:variable name="Bias" select="tz:Info[not(@Year)]/@Bias"/>
					<xsl:if test="generate-id(.) = generate-id($List[tz:Info[not(@Year) and @Bias = $Bias]])">
						<xsl:apply-templates select="." mode="UTCTitle">
							<xsl:with-param name="Position" select="position()"/>
						</xsl:apply-templates>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:apply-templates select="." mode="UTCHeader">
				<xsl:with-param name="Label" select="$UTCList"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="$List" mode="Details">
				<xsl:sort select="tz:Info[not(@Year)]/@Bias"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#10;</xsl:text>
</xsl:template>
<xsl:template match="tz:Info">
	<xsl:apply-templates select="." mode="Header"/>
	<xsl:choose>
		<xsl:when test="tz:Date">
			<xsl:apply-templates select="tz:Date[@Type='Daylight']"/>
			<xsl:if test="tz:Date[@Type='Standard']/@Time">
				<xsl:apply-templates select="tz:Date[@Type='Standard']"/>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="DateLabelNoDST"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="p:Label">
	<xsl:choose>
		<xsl:when test="@xml:lang='en' or @xml:lang='en-US'">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&lt;span title="</xsl:text>
			<xsl:apply-templates select="parent::p:Language" mode="Label"/>
			<xsl:text>"&gt;</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>&lt;/span&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
