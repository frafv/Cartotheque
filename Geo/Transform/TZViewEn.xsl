<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tz="urn:geo-schemas-xml-frafv:timezone" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:e="urn:schemas-xml-frafv:proxy" exclude-result-prefixes="tz p e">
<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:template match="tz:TimeZoneList" mode="Title" priority="-9">
	<xsl:text>Time Zone List</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZoneList" mode="Header" priority="-9">
	<h1 id="main">List of Time Zones</h1>
	<p>This is a list of Time Zones from Microsoft Windows.</p>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Title" priority="-9">
</xsl:template>
<xsl:template match="tz:Info" mode="BiasLabel" priority="-9">
	<xsl:text>Offset from GMT (UTC bias)</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="LabelHeader" priority="-9">
	<tr>
		<th colspan="4">Different languages</th>
	</tr>
	<tr>
		<th>Lang.</th>
		<th>Time Zone Name</th>
		<th>Daylight Saving Time</th>
		<th>Standard Time</th>
	</tr>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Footer" priority="-9">
	<p>
		<a href="#main">Up</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Back</a>
	</p>
</xsl:template>
<xsl:template match="tz:Date" mode="Label" priority="-8">
	<xsl:choose>
		<xsl:when test="@Type = 'Daylight'">Daylight Saving Time starts</xsl:when>
		<xsl:when test="@Type = 'Standard'">Standard Time starts</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="*" mode="DateLabelNoDST" priority="-9">
	<li><b>Daylight Saving Time: </b>
	<xsl:text>not set</xsl:text></li>
</xsl:template>
<xsl:template match="tz:Info" mode="Header" priority="-9">
	<xsl:if test="@Year">
		<b><xsl:value-of select="@Year"/> year only</b>
	</xsl:if>
</xsl:template>
<xsl:template match="tz:Date[@Time]" priority="-9">
	<li>
	<b><xsl:apply-templates select="." mode="Label"/>: </b>
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
	</li>
</xsl:template>
<xsl:template match="tz:Date[not(@Time)]" priority="-9">
	<xsl:apply-templates select="." mode="DateLabelNoDST"/>
</xsl:template>
<xsl:template match="*" mode="Label" priority="-9">
	<xsl:call-template name="LabelEnLang"/>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Header">
	<li type="circle">
	<a href="#{@Name}">
		<xsl:apply-templates select="." mode="Label"/>
	</a>
	</li>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Details">
	<hr/>
	<h1 id="{@Name}">
		<xsl:apply-templates select="." mode="Label"/>
	</h1>
	<ul><li><code><xsl:value-of select="tz:Link[@Type='WindowsRegistry']/@URL"/></code></li></ul>
	<xsl:apply-templates select="." mode="Title"/>
	<ul>
		<xsl:for-each select="tz:Info[not(@Year)]">
			<li>
				<b><xsl:apply-templates select="." mode="BiasLabel"/>: </b>
				<xsl:choose>
					<xsl:when test="@Bias = '00:00:00'"><xsl:value-of select="substring(@Bias, 1, 5)"/></xsl:when>
					<xsl:when test="starts-with(@Bias, '-')">+<xsl:value-of select="substring(@Bias, 2, 5)"/></xsl:when>
					<xsl:otherwise>-<xsl:value-of select="substring(@Bias, 1, 5)"/></xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:for-each>
	</ul>
	<xsl:apply-templates select="tz:Info"/>
	<table>
		<thead>
			<xsl:apply-templates select="." mode="LabelHeader"/>
		</thead>
		<tbody>
			<xsl:for-each select="tz:Label">
				<xsl:variable name="Lang" select="@xml:lang"/>
				<xsl:if test="not(preceding-sibling::tz:Label[@xml:lang = $Lang])">
					<xsl:for-each select="parent::tz:TimeZone">
						<tr>
							<td><xsl:apply-templates select="$Lang" mode="LangLabel"/></td>
							<td><xsl:value-of select="tz:Label[not(@Type) and @xml:lang=$Lang]"/></td>
							<td><xsl:value-of select="tz:Label[@Type='Daylight' and @xml:lang=$Lang]"/></td>
							<td><xsl:value-of select="tz:Label[@Type='Standard' and @xml:lang=$Lang]"/></td>
						</tr>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</tbody>
	</table>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>
<xsl:template match="/tz:TimeZoneList">
	<html>
		<head>
			<title><xsl:apply-templates select="." mode="Title"/></title>
			<meta http-equiv="Expires" content="0"/>
		</head>
		<body>
			<xsl:apply-templates select="." mode="Header"/>
			<ul>
				<xsl:apply-templates select="tz:TimeZone[tz:Link/@Type='WindowsRegistry' and not(starts-with(tz:Info[not(@Year)]/@Bias, '-'))]" mode="Header">
					<xsl:sort select="tz:Info[not(@Year)]/@Bias" order="descending"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="tz:TimeZone[tz:Link/@Type='WindowsRegistry' and starts-with(tz:Info[not(@Year)]/@Bias, '-')]" mode="Header">
					<xsl:sort select="tz:Info[not(@Year)]/@Bias"/>
				</xsl:apply-templates>
			</ul>
			<xsl:apply-templates select="tz:TimeZone[tz:Link/@Type='WindowsRegistry']" mode="Details"/>
		</body>
	</html>
</xsl:template>
<xsl:template match="tz:Info">
	<ul>
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
	</ul>
</xsl:template>
<xsl:template name="LabelEnLang">
	<xsl:choose>
		<xsl:when test="(tz:Label|p:Label)[@xml:lang='en' or @xml:lang='en-US']"><xsl:value-of select="(tz:Label|p:Label)[@xml:lang='en' or @xml:lang='en-US'][1]"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="(tz:Label|p:Label)[1]"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="@xml:lang" mode="LangLabel">
	<xsl:variable name="lang" select="."/>
	<xsl:variable name="info" select="/tz:TimeZoneList/p:ExternalList/p:Language[@e:Name = $lang]"/>
	<xsl:apply-templates select="$info/p:Label[@Type='Org']"/>
</xsl:template>
<xsl:template match="p:Label" priority="-9">
	<xsl:choose>
		<xsl:when test="@xml:lang='en' or @xml:lang='en-US'">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:otherwise>
			<span>
				<xsl:attribute name="title">
					<xsl:apply-templates select="parent::p:Language" mode="Label"/>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
