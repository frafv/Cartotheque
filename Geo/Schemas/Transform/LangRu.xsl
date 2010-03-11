<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:c="urn:geo-schemas-xml-frafv:culture">

<xsl:include href="LangEn.xsl"/>

<!-- Russian UI strings -->

<xsl:template match="*" mode="UILang">
	<xsl:text>ru-RU</xsl:text>
</xsl:template>

<xsl:template match="/c:CultureList" mode="Title">
	<xsl:text>Список региональной информации</xsl:text>
</xsl:template>
<xsl:template match="c:CultureList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="Title">Список региональной информации</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="c:LanguageList" mode="Header">
	<xsl:apply-templates select="." mode="ViewTextParagraph">
		<xsl:with-param name="Text">Ниже представлен список языков.</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="FooterIndex">
	<xsl:text>Указатель</xsl:text>
</xsl:template>

<xsl:template match="*" mode="FooterUp">
	<xsl:text>Вверх</xsl:text>
</xsl:template>

<xsl:template match="*" mode="FooterBack">
	<xsl:text>Назад</xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name">
	<xsl:text>Начало использования</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name">
	<xsl:text>Не используется</xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod[.='Unknown']" mode="Format">
	<xsl:param name="UILang"/>
	<xsl:text>нет данных</xsl:text>
</xsl:template>

<xsl:template match="@Encoding" mode="Format">
	<xsl:choose>
		<xsl:when test=".='Hex'"> (шестнадцатеричный)</xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
