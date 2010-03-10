<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:e="urn:schemas-xml-frafv:proxy" exclude-result-prefixes="ms l p e">

<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:include href="View.xsl"/>

<!-- UI strings -->

<xsl:template match="l:LocationList" mode="Title" priority="-1">
	<xsl:text>Location List</xsl:text>
</xsl:template>
<xsl:template match="l:LocationList" mode="Header" priority="-1">
	<h1 id="main">List of Locations</h1>
	<p>This is a list of Locations.</p>
</xsl:template>

<xsl:template match="l:LocationTypeList" mode="Header" priority="-1">
	<p>This is a list of Location types.</p>
</xsl:template>

<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="Title" priority="-1">
</xsl:template>
<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="Footer" priority="-1">
	<p>
		<a href="#main">Up</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Back</a>
	</p>
</xsl:template>

<xsl:template match="l:Form" mode="Name" priority="-1">
	<xsl:text>Form</xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name" priority="-1">
	<xsl:text>Established</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@StartPeriod" mode="Name" priority="-1">
	<xsl:text>from </xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name" priority="-1">
	<xsl:text>Disestablished</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@EndPeriod" mode="Name" priority="-1">
	<xsl:text>to </xsl:text>
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

<xsl:template match="l:Form[@Type]/l:Reference" mode="Name" priority="-1">
	<xsl:choose>
		<xsl:when test="@Type='Union'"> is union of </xsl:when>
		<xsl:when test="@Type='Join'"> has joined </xsl:when>
		<xsl:when test="@Type='Split'"> has split into </xsl:when>
		<xsl:when test="@Type='Secession'"> was separated from </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Form[not(@Type)]/l:Reference" mode="Name" priority="-1">
	<xsl:choose>
		<xsl:when test="@Type='Union'">Union of </xsl:when>
		<xsl:when test="@Type='Join'">Has joined </xsl:when>
		<xsl:when test="@Type='Split'">Has split into </xsl:when>
		<xsl:when test="@Type='Secession'">Secession from </xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Content index display -->

<xsl:template match="p:Location" mode="Index">
	<li type="circle">
		<xsl:apply-templates select="." mode="Label"/>
		<ul>
			<xsl:apply-templates select="." mode="Header"/>
		</ul>
	</li>
</xsl:template>
<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="Index">
	<li type="circle">
		<a href="#{@Name}">
			<xsl:apply-templates select="." mode="Label"/>
		</a>
		<ul>
			<xsl:apply-templates select="." mode="Header"/>
		</ul>
	</li>
</xsl:template>

<xsl:template match="p:Location[@Type='Continent']|l:Continent" mode="Header">
	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:CountryList[l:Location/@Continent = $Name]/l:Country" mode="Index"/>
</xsl:template>
<xsl:template match="p:Location[@Type='Country']|l:Country" mode="Header">
	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[not(l:Location/@City) and not(l:Location/@Region) and l:Location/@Country = $Name]/l:Region" mode="Index"/>
	<xsl:apply-templates select="/l:LocationList/l:CityList[not(l:Location/@Region) and l:Location/@Country = $Name]/l:City" mode="Index"/>
</xsl:template>
<xsl:template match="p:Location[@Type='Region']|l:Region" mode="Header">
	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[not(l:Location/@City) and l:Location/@Region = $Name]/l:Region" mode="Index"/>
	<xsl:apply-templates select="/l:LocationList/l:CityList[l:Location/@Region = $Name]/l:City" mode="Index"/>
</xsl:template>
<xsl:template match="p:Location[@Type='City']|l:City" mode="Header">
	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[l:Location/@City = $Name]/l:Region" mode="Index"/>
	<xsl:apply-templates select="/l:LocationList/l:StreetList[l:Location/@City = $Name]/l:Street" mode="Index"/>
</xsl:template>
<xsl:template match="p:Location[@Type='Street']|l:LocationType|l:Street" mode="Header">
</xsl:template>

<!-- Code display -->

<xsl:template match="p:Company|p:Location[@Type = 'Country']|l:Country" mode="Name" priority="-1">
	<xsl:apply-templates select="." mode="LabelAbbr"/>
</xsl:template>

<!-- Form display -->

<xsl:template match="l:Reference" priority="-1">
	<li>
		<b><xsl:apply-templates select="parent::l:Form" mode="Name"/>: </b>
		<xsl:apply-templates select="parent::l:Form/@Type" mode="Format"/>
		<xsl:apply-templates select="." mode="Name"/>
		<xsl:apply-templates select="." mode="Format"/>
		<xsl:if test="@StartPeriod or @EndPeriod">
			<xsl:text> (</xsl:text>
			<xsl:apply-templates select="@StartPeriod" mode="Name"/>
			<xsl:apply-templates select="@StartPeriod" mode="Format"/>
			<xsl:if test="@StartPeriod and @EndPeriod">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="@EndPeriod" mode="Name"/>
			<xsl:apply-templates select="@EndPeriod" mode="Format"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="l:Reference" mode="Format" priority="-1">
	<xsl:apply-templates select="@*[name()!='Type' and name()!='StartPeriod' and name()!='EndPeriod']" mode="FormatList"/>
</xsl:template>
<xsl:template match="l:City/l:Form/l:Reference[@Region or @Country]" mode="Format" priority="-1">
	<xsl:apply-templates select="@City" mode="FormatLink"/>
	<xsl:text> (</xsl:text>
	<xsl:apply-templates select="@Region|@Country" mode="FormatLink"/>
	<xsl:text>)</xsl:text>
</xsl:template>
<xsl:template match="l:Region/l:Form/l:Reference[@City or @Country]" mode="Format" priority="-1">
	<xsl:apply-templates select="@Region" mode="FormatLink"/>
	<xsl:text> (</xsl:text>
	<xsl:apply-templates select="@City|@Country" mode="FormatLink"/>
	<xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="@Continent|l:Form/@Type|@Country|@Region|@City|@Street" mode="Format" priority="-1">
	<xsl:apply-templates select="." mode="FormatLink"/>
</xsl:template>

<xsl:template match="@Continent" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Continent']/@e:Name|/l:LocationList/l:ContinentList/l:Continent/@Name)[. = $link]" mode="Format"/>
</xsl:template>
<xsl:template match="l:Form/@Type" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:LocationType/@e:Name|/l:LocationList/l:LocationTypeList/l:LocationType/@Name)[. = $link]" mode="Format"/>
</xsl:template>
<xsl:template match="@Country" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Country']/@e:Name|/l:LocationList/l:CountryList/l:Country/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@Region" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Region']/@e:Name|/l:LocationList/l:RegionList/l:Region/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@City" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='City']/@e:Name|/l:LocationList/l:CityList/l:City/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@Street" mode="FormatLink" priority="-1">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Street']/@e:Name|/l:LocationList/l:StreetList/l:Street/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>

<xsl:template match="l:Country/@Name|l:Region/@Name|l:City/@Name" mode="Format" priority="-1">
	<a href="#{.}">
		<xsl:apply-templates select="parent::*" mode="LabelAbbr"/>
	</a>
</xsl:template>
<xsl:template match="l:Continent/@Name|l:LocationType/@Name|l:Street/@Name" mode="Format" priority="-1">
	<a href="#{.}">
		<xsl:apply-templates select="parent::*" mode="Label"/>
	</a>
</xsl:template>

<!-- Elements display -->

<xsl:template match="l:Country|l:Region|l:City|l:Street">
	<hr/>
	<h1 id="{@Name}">
		<xsl:apply-templates select="." mode="Label"/>
	</h1>
	<xsl:variable name="lid">
		<xsl:apply-templates select="." mode="LabelID"/>
	</xsl:variable>
	<xsl:variable name="lang" select="l:Label[generate-id(.)=$lid]/@xml:lang"/>
	<xsl:variable name="org" select="l:Label[contains(concat(' ',@Type,' '),' Org ') and generate-id(.)!=$lid and not(starts-with(@xml:lang,$lang))]"/>
	<xsl:if test="$org">
		<h2>(<xsl:apply-templates select="$org" mode="FormatList"/>)</h2>
	</xsl:if>
	<xsl:apply-templates select="." mode="Title"/>
	<ul>
		<xsl:apply-templates select="@*"/>
	</ul>
	<ul>
		<xsl:apply-templates select="l:Web"/>
	</ul>
	<ul>
		<xsl:apply-templates select="l:Code"/>
	</ul>
	<ul>
		<xsl:for-each select="l:Form">
			<xsl:choose>
				<xsl:when test="l:Reference">
					<xsl:apply-templates select="l:Reference"/>
				</xsl:when>
				<xsl:otherwise>
					<li>
						<b><xsl:apply-templates select="." mode="Name"/>: </b>
						<xsl:apply-templates select="@Type" mode="Format"/>
					</li>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</ul>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="l:Continent|l:LocationType">
	<hr/>
	<h1 id="{@Name}">
		<xsl:apply-templates select="." mode="Label"/>
	</h1>
	<xsl:apply-templates select="." mode="Title"/>
	<ul>
		<xsl:apply-templates select="@*"/>
	</ul>
	<ul>
		<xsl:apply-templates select="l:Web"/>
	</ul>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="@Name">
</xsl:template>

<xsl:template match="l:Code">
	<xsl:variable name="Source" select="@Source"/>
	<li><b><xsl:apply-templates select="/l:LocationList/p:ExternalList/*[self::p:Company or self::p:Location[@Type = 'Country']][@e:Name = $Source]|/l:LocationList/l:CountryList/l:Country[@Name = $Source]" mode="Name"/>: </b>
	<xsl:apply-templates select="." mode="Format"/></li>
</xsl:template>

<xsl:template match="l:Web">
	<li><a href="{@URL}"><xsl:value-of select="@URL"/></a></li>
</xsl:template>

<xsl:template match="/l:LocationList">
	<html>
		<head>
			<title><xsl:apply-templates select="." mode="Title"/></title>
			<meta http-equiv="Expires" content="0"/>
		</head>
		<body>
			<xsl:apply-templates select="." mode="Header"/>
			<ul>
				<xsl:apply-templates select="p:ExternalList/p:Location|l:ContinentList/l:Continent" mode="Index"/>
			</ul>
			<xsl:apply-templates select="l:LocationTypeList" mode="Header"/>
			<ul>
				<xsl:apply-templates select="l:LocationTypeList/l:LocationType" mode="Index"/>
			</ul>
			<xsl:apply-templates select="l:ContinentList/l:Continent|l:LocationTypeList/l:LocationType|l:CountryList/l:Country|l:RegionList/l:Region|l:CityList/l:City|l:StreetList/l:Street"/>
		</body>
	</html>
</xsl:template>

<!-- Labels display -->

<xsl:template match="l:Country|l:Region|l:City|l:Street" mode="Label">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="ID">
		<xsl:apply-templates select="." mode="LabelID">
			<xsl:with-param name="Lang" select="$Lang"/>
			<xsl:with-param name="Type" select="$Type"/>
			<xsl:with-param name="Name" select="$Name"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="LocTypeName" select="l:Form/@Type"/>
	<xsl:for-each select="*[local-name() = $Name][generate-id(.) = $ID]">
		<xsl:choose>
			<xsl:when test="$Name='Label' and contains(concat(' ',@Type,' '),' Part ')">
				<xsl:variable name="LocType" select="/l:LocationList/p:ExternalList/p:LocationType[@e:Name = $LocTypeName]|/l:LocationList/l:LocationTypeList/l:LocationType[@Name=$LocTypeName]"/>
				<xsl:variable name="TypeLabel" select="$LocType/p:Label[@xml:lang = $Lang or contains($Lang, '-') and @xml:lang = substring-before($Lang, '-')][contains(concat(' ',@Type,' '), ' Part ')][1]"/>
				<xsl:choose>
					<xsl:when test="@Pos = 'Suffix' or not(@Pos) and $TypeLabel/@Pos = 'Prefix'">							
						<xsl:apply-templates select="." mode="Foreign">
							<xsl:with-param name="Prefix" select="concat($TypeLabel,' ')"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@Pos = 'Prefix' or not(@Pos) and $TypeLabel/@Pos = 'Suffix'">
						<xsl:apply-templates select="." mode="Foreign">
							<xsl:with-param name="Suffix" select="concat(' ',$TypeLabel)"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="Foreign"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="Format"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="l:Label|p:Label" mode="Format">
	<xsl:param name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>

	<xsl:apply-templates select="." mode="Foreign">
		<xsl:with-param name="UILang" select="$UILang"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:Country/l:Label|l:Region/l:Label|l:City/l:Label|l:Street/l:Label" mode="Format">
	<xsl:param name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:variable name="Lang" select="@xml:lang"/>

	<xsl:choose>
		<xsl:when test="contains(concat(' ',@Type,' '),' Part ')">
			<xsl:variable name="LocTypeName" select="parent::*/l:Form/@Type"/>
			<xsl:variable name="LocType" select="/l:LocationList/p:ExternalList/p:LocationType[@e:Name = $LocTypeName]|/l:LocationList/l:LocationTypeList/l:LocationType[@Name=$LocTypeName]"/>
			<xsl:variable name="TypeLabel" select="$LocType/p:Label[@xml:lang = $Lang or contains($Lang, '-') and @xml:lang = substring-before($Lang, '-')][contains(concat(' ',@Type,' '), ' Part ')][1]"/>
			<xsl:choose>
				<xsl:when test="@Pos = 'Suffix' or not(@Pos) and $TypeLabel/@Pos = 'Prefix'">
					<xsl:apply-templates select="." mode="Foreign">
						<xsl:with-param name="UILang" select="$UILang"/>
						<xsl:with-param name="Prefix" select="concat($TypeLabel,' ')"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="@Pos = 'Prefix' or not(@Pos) and $TypeLabel/@Pos = 'Suffix'">
					<xsl:apply-templates select="." mode="Foreign">
						<xsl:with-param name="UILang" select="$UILang"/>
						<xsl:with-param name="Suffix" select="concat(' ',$TypeLabel)"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="Foreign">
						<xsl:with-param name="UILang" select="$UILang"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="Foreign">
				<xsl:with-param name="UILang" select="$UILang"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="p:Language/p:Label" mode="Format">
	<xsl:param name="UILang"/>
	<xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
