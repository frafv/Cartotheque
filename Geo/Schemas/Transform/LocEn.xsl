<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:e="urn:schemas-xml-frafv:proxy">

<xsl:include href="View.xsl"/>

<!-- UI strings -->

<xsl:template match="/l:LocationList" mode="Title">
	<xsl:text>Location List</xsl:text>
</xsl:template>
<xsl:template match="l:LocationList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="Title">
			<xsl:apply-templates select="." mode="ID"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewTextParagraph">
		<xsl:with-param name="Text">This is a list of Locations.</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:LocationTypeList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTextParagraph">
		<xsl:with-param name="Text">This is a list of Location types.</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="Title">
	<xsl:apply-templates select="." mode="ViewSingleHeader"/>
</xsl:template>
<xsl:template match="*" mode="Footer">
	<xsl:apply-templates select="." mode="ViewSingleFooter"/>
</xsl:template>

<xsl:template match="*" mode="FooterIndex">
	<xsl:text>Index</xsl:text>
</xsl:template>

<xsl:template match="*" mode="FooterUp">
	<xsl:text>Up</xsl:text>
</xsl:template>

<xsl:template match="*" mode="FooterBack">
	<xsl:text>Back</xsl:text>
</xsl:template>

<xsl:template match="l:Form" mode="Name">
	<xsl:text>Form</xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name">
	<xsl:text>Established</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@StartPeriod" mode="Name">
	<xsl:text>from </xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name">
	<xsl:text>Disestablished</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@EndPeriod" mode="Name">
	<xsl:text>to </xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod|@EndPeriod[.!='Unknown']" mode="Format">
	<xsl:param name="UILang">
		<xsl:apply-templates select="/*" mode="UILang"/>
	</xsl:param>

	<xsl:apply-templates select="." mode="FormatLongDate">
		<xsl:with-param name="UILang" select="$UILang"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="@EndPeriod[.='Unknown']" mode="Format">
	<xsl:param name="UILang"/>
	<xsl:text>unknown</xsl:text>
</xsl:template>

<xsl:template match="l:Form[@Type]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'"> is union of </xsl:when>
		<xsl:when test="@Type='Join'"> has joined </xsl:when>
		<xsl:when test="@Type='Split'"> has split into </xsl:when>
		<xsl:when test="@Type='Secession'"> was separated from </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Form[not(@Type)]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">Union of </xsl:when>
		<xsl:when test="@Type='Join'">Has joined </xsl:when>
		<xsl:when test="@Type='Split'">Has split into </xsl:when>
		<xsl:when test="@Type='Secession'">Secession from </xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Content index display -->

<xsl:template match="p:Location" mode="Index">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewIndex">
		<xsl:with-param name="Name"/>
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="LabelHint"/>
		</xsl:with-param>
		<xsl:with-param name="Label">
			<xsl:apply-templates select="." mode="LabelText"/>
		</xsl:with-param>
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="Index">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewIndex">
		<xsl:with-param name="Link">
			<xsl:text>#</xsl:text>
			<xsl:apply-templates select="." mode="ID"/>
		</xsl:with-param>
		<xsl:with-param name="Name"/>
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="LabelHint"/>
		</xsl:with-param>
		<xsl:with-param name="Label">
			<xsl:apply-templates select="." mode="LabelText"/>
		</xsl:with-param>
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="p:Location[@Type='Continent']|l:Continent" mode="ViewIndexContent">
	<xsl:param name="Ident"/>

	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:CountryList[l:Location/@Continent = $Name]/l:Country" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="p:Location[@Type='Country']|l:Country" mode="ViewIndexContent">
	<xsl:param name="Ident"/>

	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[not(l:Location/@City) and not(l:Location/@Region) and l:Location/@Country = $Name]/l:Region" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="/l:LocationList/l:CityList[not(l:Location/@Region) and l:Location/@Country = $Name]/l:City" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="p:Location[@Type='Region']|l:Region" mode="ViewIndexContent">
	<xsl:param name="Ident"/>

	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[not(l:Location/@City) and l:Location/@Region = $Name]/l:Region" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="/l:LocationList/l:CityList[l:Location/@Region = $Name]/l:City" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="p:Location[@Type='City']|l:City" mode="ViewIndexContent">
	<xsl:param name="Ident"/>

	<xsl:variable name="Name" select="@e:Name|@Name"/>
	<xsl:apply-templates select="/l:LocationList/l:RegionList[l:Location/@City = $Name]/l:Region" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="/l:LocationList/l:StreetList[l:Location/@City = $Name]/l:Street" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="p:Location[@Type='Street']|l:LocationType|l:Street" mode="ViewIndexContent">
</xsl:template>

<!-- Code display -->

<xsl:template match="p:Company|p:Location[@Type = 'Country']|l:Country" mode="Name">
	<xsl:apply-templates select="." mode="LabelAbbr"/>
</xsl:template>

<!-- Form display -->

<xsl:template match="l:Form[l:Reference]">
	<xsl:apply-templates select="l:Reference"/>
</xsl:template>
<xsl:template match="l:Form[not(l:Reference)]">
	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Value">
			<xsl:apply-templates select="@Type" mode="Format"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:Reference">
	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Name">
			<xsl:apply-templates select="parent::l:Form" mode="Name"/>
		</xsl:with-param>
		<xsl:with-param name="Value">
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
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:Reference" mode="Format">
	<xsl:apply-templates select="@*[name()!='Type' and name()!='StartPeriod' and name()!='EndPeriod']" mode="FormatList"/>
</xsl:template>
<xsl:template match="l:City/l:Form/l:Reference[@Region or @Country]" mode="Format">
	<xsl:apply-templates select="@City" mode="FormatLink"/>
	<xsl:text> (</xsl:text>
	<xsl:apply-templates select="@Region|@Country" mode="FormatLink"/>
	<xsl:text>)</xsl:text>
</xsl:template>
<xsl:template match="l:Region/l:Form/l:Reference[@City or @Country]" mode="Format">
	<xsl:apply-templates select="@Region" mode="FormatLink"/>
	<xsl:text> (</xsl:text>
	<xsl:apply-templates select="@City|@Country" mode="FormatLink"/>
	<xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="@Continent|l:Form/@Type|@Country|@Region|@City|@Street" mode="Format">
	<xsl:apply-templates select="." mode="FormatLink"/>
</xsl:template>

<xsl:template match="@Continent" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Continent']/@e:Name|/l:LocationList/l:ContinentList/l:Continent/@Name)[. = $link]" mode="Format"/>
</xsl:template>
<xsl:template match="l:Form/@Type" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:LocationType/@e:Name|/l:LocationList/l:LocationTypeList/l:LocationType/@Name)[. = $link]" mode="Format"/>
</xsl:template>
<xsl:template match="@Country" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Country']/@e:Name|/l:LocationList/l:CountryList/l:Country/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@Region" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Region']/@e:Name|/l:LocationList/l:RegionList/l:Region/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@City" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='City']/@e:Name|/l:LocationList/l:CityList/l:City/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>
<xsl:template match="@Street" mode="FormatLink">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="(/l:LocationList/p:ExternalList/p:Location[@Type='Street']/@e:Name|/l:LocationList/l:StreetList/l:Street/@Name)[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>

<xsl:template match="l:Country/@Name|l:Region/@Name|l:City/@Name" mode="Format">
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link">#<xsl:apply-templates select="parent::*" mode="ID"/></xsl:with-param>
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="parent::*" mode="LabelAbbrHint"/>
		</xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="parent::*" mode="LabelAbbrText"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="l:Continent/@Name|l:LocationType/@Name|l:Street/@Name" mode="Format">
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link">#<xsl:apply-templates select="parent::*" mode="ID"/></xsl:with-param>
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="parent::*" mode="LabelHint"/>
		</xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="parent::*" mode="LabelText"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="ID">
	<xsl:variable name="label" select="*[local-name() = 'Label'][@xml:lang='en' or starts-with(@xml:lang,'en-')][1]"/>

	<xsl:choose>
		<xsl:when test="$label">
			<xsl:apply-templates select="$label" mode="FormatText">
				<xsl:with-param name="UILang" select="$label/@xml:lang"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@Name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="l:LocationList" mode="ID">
	<xsl:text>List of Locations</xsl:text>
</xsl:template>

<!-- Elements display -->

<xsl:template match="l:Country|l:Region|l:City|l:Street">
	<xsl:variable name="lid">
		<xsl:apply-templates select="." mode="LabelID"/>
	</xsl:variable>
	<xsl:variable name="lang" select="l:Label[generate-id(.)=$lid]/@xml:lang"/>
	<xsl:variable name="org" select="l:Label[contains(concat(' ',@Type,' '),' Org ') and generate-id(.)!=$lid and not(starts-with(@xml:lang,$lang))]"/>
	<xsl:apply-templates select="." mode="ViewHeader">
		<xsl:with-param name="Subtitle">
			<xsl:apply-templates select="$org" mode="FormatList"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="Title"/>
	<xsl:apply-templates select="." mode="ViewList"/>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="l:Web"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="l:Code"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="l:Form"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="l:Continent|l:LocationType">
	<xsl:apply-templates select="." mode="ViewHeader"/>
	<xsl:apply-templates select="." mode="Title"/>
	<xsl:apply-templates select="." mode="ViewList"/>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="l:Web"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="@Name">
</xsl:template>

<xsl:template match="l:Code">
	<xsl:variable name="Source" select="@Source"/>
	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Name">
			<xsl:apply-templates select="/l:LocationList/p:ExternalList/*[self::p:Company or self::p:Location[@Type = 'Country']][@e:Name = $Source]|/l:LocationList/l:CountryList/l:Country[@Name = $Source]" mode="Name"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="l:Web">
	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Name"/>
		<xsl:with-param name="Value">
			<xsl:apply-templates select="@URL" mode="ViewLink">
				<xsl:with-param name="Text">
					<xsl:value-of select="@URL"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="/">
	<xsl:apply-templates select="l:LocationList" mode="ViewElement"/>
</xsl:template>
<xsl:template match="/l:LocationList" mode="ViewContent">
	<xsl:apply-templates select="." mode="ViewLanguages"/>
	<xsl:apply-templates select="." mode="Header"/>
	<xsl:apply-templates select="." mode="ViewIndexList">
		<xsl:with-param name="List" select="p:ExternalList/p:Location|l:ContinentList/l:Continent"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="l:LocationTypeList" mode="Header"/>
	<xsl:apply-templates select="." mode="ViewIndexList">
		<xsl:with-param name="List" select="l:LocationTypeList/l:LocationType"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="l:ContinentList/l:Continent|l:LocationTypeList/l:LocationType|l:CountryList/l:Country|l:RegionList/l:Region|l:CityList/l:City|l:StreetList/l:Street"/>
</xsl:template>

<xsl:template match="/l:LocationList" mode="Languages">
	<xsl:apply-templates select="." mode="ViewLanguage">
		<xsl:with-param name="Lang">en-US</xsl:with-param>
		<xsl:with-param name="Stylesheet">LocEn.xsl</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewLanguage">
		<xsl:with-param name="Lang">ru-RU</xsl:with-param>
		<xsl:with-param name="Stylesheet">LocRu.xsl</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<!-- Labels display -->

<xsl:template match="l:Label|p:Label" mode="FormatHint">
	<xsl:apply-templates select="." mode="ForeignHint"/>
</xsl:template>

<xsl:template match="l:Country/l:Label|l:Region/l:Label|l:City/l:Label|l:Street/l:Label" mode="FormatText">
	<xsl:variable name="Lang" select="@xml:lang"/>

	<xsl:choose>
		<xsl:when test="contains(concat(' ',@Type,' '),' Part ')">
			<xsl:variable name="LocTypeName" select="parent::*/l:Form/@Type"/>
			<xsl:variable name="LocType" select="/l:LocationList/p:ExternalList/p:LocationType[@e:Name = $LocTypeName]|/l:LocationList/l:LocationTypeList/l:LocationType[@Name=$LocTypeName]"/>
			<xsl:variable name="TypeLabel" select="$LocType/p:Label[@xml:lang = $Lang or contains($Lang, '-') and @xml:lang = substring-before($Lang, '-')][contains(concat(' ',@Type,' '), ' Part ')][1]"/>
			<xsl:choose>
				<xsl:when test="@Pos = 'Suffix' or not(@Pos) and $TypeLabel/@Pos = 'Prefix'">
					<xsl:apply-templates select="$TypeLabel" mode="FormatText"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="@Pos = 'Prefix' or not(@Pos) and $TypeLabel/@Pos = 'Suffix'">
					<xsl:value-of select="."/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="$TypeLabel" mode="FormatText"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="p:Language/p:Label" mode="FormatText">
	<xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
