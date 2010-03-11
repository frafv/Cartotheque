<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:e="urn:schemas-xml-frafv:proxy" exclude-result-prefixes="ms c p e">

<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:include href="View.xsl"/>

<!-- UI strings -->

<xsl:template match="c:CultureList" mode="Title" priority="-1">
	<xsl:text>Culture Information List</xsl:text>
</xsl:template>
<xsl:template match="c:CultureList" mode="Header" priority="-1">
	<h1 id="main">List of Culture Informations</h1>
</xsl:template>

<xsl:template match="c:LanguageList" mode="Header" priority="-1">
	<p>This is a list of Languages.</p>
</xsl:template>

<xsl:template match="c:Language" mode="Title" priority="-1">
</xsl:template>
<xsl:template match="c:Language" mode="Footer" priority="-1">
	<p>
		<a href="#main">Up</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Back</a>
	</p>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name" priority="-1">
	<xsl:text>Use beginning</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name" priority="-1">
	<xsl:text>Use end</xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod|@EndPeriod[.!='Unknown']" mode="Format" priority="-1">
	<xsl:param name="UILang">
		<xsl:apply-templates select="/*" mode="UILang"/>
	</xsl:param>

	<xsl:apply-templates select="." mode="FormatLongDate">
		<xsl:with-param name="UILang" select="$UILang"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="@EndPeriod[.='Unknown']" mode="Format" priority="-1">
	<xsl:param name="UILang"/>
	<xsl:text>unknown</xsl:text>
</xsl:template>

<xsl:template match="@Encoding" mode="Format" priority="-1">
	<xsl:choose>
		<xsl:when test=".='Hex'"> (Hex)</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Content index display -->

<xsl:template match="c:Language" mode="Index">
	<li type="circle">
		<a href="#{@Name}">
			<xsl:apply-templates select="." mode="Label"/>
		</a>
		<ul>
			<xsl:apply-templates select="c:Language" mode="Index"/>
		</ul>
	</li>
</xsl:template>

<!-- Code display -->

<xsl:template match="p:Company" mode="Name" priority="-1">
	<xsl:apply-templates select="." mode="LabelAbbr"/>
</xsl:template>

<!-- Elements display -->

<xsl:template match="c:Language">
	<hr/>
	<h1 id="{@Name}">
		<xsl:apply-templates select="." mode="Label"/>
	</h1>
	<xsl:variable name="lid">
		<xsl:apply-templates select="." mode="LabelID"/>
	</xsl:variable>
	<xsl:variable name="lang" select="c:Label[generate-id(.)=$lid]/@xml:lang"/>
	<xsl:variable name="org" select="c:Label[contains(concat(' ',@Type,' '),' Org ') and generate-id(.)!=$lid and not(starts-with(@xml:lang,$lang))]"/>
	<xsl:if test="$org">
		<h2>(<xsl:apply-templates select="$org" mode="FormatList"/>)</h2>
	</xsl:if>
	<xsl:apply-templates select="." mode="Title"/>
	<ul>
		<xsl:apply-templates select="@*"/>
	</ul>
	<ul>
		<xsl:apply-templates select="c:Web"/>
	</ul>
	<ul>
		<xsl:apply-templates select="c:Code"/>
	</ul>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="@Name">
</xsl:template>

<xsl:template match="c:Code">
	<xsl:variable name="Source" select="@Source"/>
	<li>
		<b><xsl:apply-templates select="/c:CultureList/p:ExternalList/p:Company[@e:Name = $Source]" mode="Name"/></b>
		<i><xsl:apply-templates select="@Encoding" mode="Format"/></i>
		<b>: </b>
		<xsl:apply-templates select="." mode="Format"/>
	</li>
</xsl:template>

<xsl:template match="c:Web">
	<li><a href="{@URL}"><xsl:value-of select="@URL"/></a></li>
</xsl:template>

<xsl:template match="/c:CultureList">
	<html>
		<head>
			<title><xsl:apply-templates select="." mode="Title"/></title>
		</head>
		<body>
			<xsl:apply-templates select="." mode="Header"/>
			<xsl:apply-templates select="c:LanguageList" mode="Header"/>
			<ul>
				<xsl:apply-templates select="c:LanguageList/c:Language" mode="Index"/>
			</ul>
			<xsl:apply-templates select="c:LanguageList//c:Language"/>
		</body>
	</html>
</xsl:template>

</xsl:stylesheet>
