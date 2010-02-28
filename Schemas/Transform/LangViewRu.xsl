<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt" xmlns:c="urn:geo-schemas-xml-frafv:culture" exclude-result-prefixes="ms c">

<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:include href="LangViewEn.xsl"/>

<!-- Russian UI strings -->

<xsl:template match="*" mode="UILang">
	<xsl:text>ru-RU</xsl:text>
</xsl:template>

<xsl:template match="c:CultureList" mode="Title" priority="-1">
	<xsl:text>Список региональной информации</xsl:text>
</xsl:template>
<xsl:template match="c:CultureList" mode="Header" priority="-1">
	<h1 id="main">Список региональной информации</h1>
</xsl:template>

<xsl:template match="c:LanguageList" mode="Header" priority="-1">
	<p>Ниже представлен список языков.</p>
</xsl:template>

<xsl:template match="c:Language" mode="Footer" priority="-1">
	<p>
		<a href="#main">Вверх</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Назад</a>
	</p>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name" priority="-1">
	<xsl:text>Начало использования</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name" priority="-1">
	<xsl:text>Не используется</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod[.='Unknown']" mode="Format" priority="-1">
	<xsl:param name="UILang"/>
	<xsl:text>нет данных</xsl:text>
</xsl:template>

<xsl:template match="@Encoding" mode="Format" priority="-1">
	<xsl:choose>
		<xsl:when test=".='Hex'"> (шестнадцатеричный)</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
