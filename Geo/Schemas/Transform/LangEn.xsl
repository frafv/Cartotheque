<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:p="urn:geo-schemas-xml-frafv:proxy" xmlns:e="urn:schemas-xml-frafv:proxy">

<xsl:include href="View.xsl"/>

<!-- UI strings -->

<xsl:template match="/c:CultureList" mode="Title">
	<xsl:text>Culture Information List</xsl:text>
</xsl:template>
<xsl:template match="c:CultureList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="Title">
			<xsl:apply-templates select="." mode="ID"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="c:LanguageList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTextParagraph">
		<xsl:with-param name="Text">This is a list of Languages.</xsl:with-param>
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

<xsl:template match="@StartPeriod" mode="Name">
	<xsl:text>Use beginning</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name">
	<xsl:text>Use end</xsl:text>
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

<xsl:template match="@Encoding" mode="Format">
	<xsl:choose>
		<xsl:when test=".='Hex'"> (Hex)</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Content index display -->

<xsl:template match="c:Language" mode="Index">
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

<xsl:template match="c:Language" mode="ViewIndexContent">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="c:Language" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="c:CultureList" mode="ID">
	<xsl:text>List of Culture Informations</xsl:text>
</xsl:template>

<!-- Code display -->

<xsl:template match="p:Company" mode="Name">
	<xsl:apply-templates select="." mode="LabelAbbr"/>
</xsl:template>

<!-- Elements display -->

<xsl:template match="c:Language">
	<xsl:variable name="lid">
		<xsl:apply-templates select="." mode="LabelID"/>
	</xsl:variable>
	<xsl:variable name="lang" select="c:Label[generate-id(.)=$lid]/@xml:lang"/>
	<xsl:variable name="org" select="c:Label[contains(concat(' ',@Type,' '),' Org ') and generate-id(.)!=$lid and not(starts-with(@xml:lang,$lang))]"/>
	<xsl:apply-templates select="." mode="ViewHeader">
		<xsl:with-param name="Subtitle">
			<xsl:apply-templates select="$org" mode="FormatList"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="Title"/>
	<xsl:apply-templates select="." mode="ViewList"/>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="c:Web"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="List" select="c:Code"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="Footer"/>
</xsl:template>

<xsl:template match="@Name">
</xsl:template>

<xsl:template match="c:Code">
	<xsl:variable name="Source" select="@Source"/>
	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Name">
			<xsl:apply-templates select="/c:CultureList/p:ExternalList/p:Company[@e:Name = $Source]" mode="Name"/>
			<i><xsl:apply-templates select="@Encoding" mode="Format"/></i>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="c:Web">
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
	<xsl:apply-templates select="c:CultureList" mode="ViewElement"/>
</xsl:template>
<xsl:template match="/c:CultureList" mode="ViewContent">
	<xsl:apply-templates select="." mode="ViewLanguages"/>
	<xsl:apply-templates select="." mode="Header"/>
	<xsl:apply-templates select="c:LanguageList" mode="Header"/>
	<xsl:apply-templates select="." mode="ViewIndexList">
		<xsl:with-param name="List" select="c:LanguageList/c:Language"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="c:LanguageList//c:Language"/>
</xsl:template>

<xsl:template match="/c:CultureList" mode="Languages">
	<xsl:apply-templates select="." mode="ViewLanguage">
		<xsl:with-param name="Lang">en-US</xsl:with-param>
		<xsl:with-param name="Stylesheet">LangEn.xsl</xsl:with-param>
		<xsl:with-param name="External" select="c:LanguageList//c:Language[@Name = 'en' or @Name = 'en-US']"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewLanguage">
		<xsl:with-param name="Lang">ru-RU</xsl:with-param>
		<xsl:with-param name="Stylesheet">LangRu.xsl</xsl:with-param>
		<xsl:with-param name="External" select="c:LanguageList//c:Language[@Name = 'ru' or @Name = 'ru-RU']"/>
	</xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
