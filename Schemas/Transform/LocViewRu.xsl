<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt" xmlns:l="urn:geo-schemas-xml-frafv:location" exclude-result-prefixes="ms l">

<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:include href="LocViewEn.xsl"/>

<!-- Russian UI strings -->

<xsl:template match="*" mode="UILang">
	<xsl:text>ru-RU</xsl:text>
</xsl:template>

<xsl:template match="l:LocationList" mode="Title">
	<xsl:text>Список местоположений</xsl:text>
</xsl:template>
<xsl:template match="l:LocationList" mode="Header">
	<h1 id="main">Список местоположений</h1>
	<p>Ниже представлен список местоположений.</p>
</xsl:template>

<xsl:template match="l:LocationTypeList" mode="Header">
	<p>Ниже представлен список типов местоположения.</p>
</xsl:template>

<xsl:template match="l:Continent|l:LocationType|l:Country|l:Region|l:City|l:Street" mode="Footer">
	<p>
		<a href="main">Вверх</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Назад</a>
	</p>
</xsl:template>

<xsl:template match="l:Form" mode="Name">
	<xsl:text>Форма</xsl:text>
</xsl:template>

<xsl:template match="@StartPeriod" mode="Name">
	<xsl:text>Основание</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@StartPeriod" mode="Name">
	<xsl:text>с </xsl:text>
</xsl:template>

<xsl:template match="@EndPeriod" mode="Name">
	<xsl:text>Распад</xsl:text>
</xsl:template>
<xsl:template match="l:Reference/@EndPeriod" mode="Name">
	<xsl:choose>
		<xsl:when test=".='Unknown'">
			<xsl:text>по дату, о которой </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>по </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="@EndPeriod[.='Unknown']" mode="Format" priority="-1">
	<xsl:param name="UILang"/>
	<xsl:text>нет данных</xsl:text>
</xsl:template>

<xsl:template match="l:Country/l:Form[@Type]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">, союз стран </xsl:when>
		<xsl:when test="@Type='Join'">; данная страна присоединилась к стране </xsl:when>
		<xsl:when test="@Type='Split'">; данная страна распалась на страны </xsl:when>
		<xsl:when test="@Type='Secession'">; данная страна отделилась от страны </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Country/l:Form[not(@Type)]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">Союз стран </xsl:when>
		<xsl:when test="@Type='Join'">Страна присоединилась к стране </xsl:when>
		<xsl:when test="@Type='Split'">Страна распалась на страны </xsl:when>
		<xsl:when test="@Type='Secession'">Страна отделилась от страны </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Region/l:Form[@Type]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">, объединение регионов </xsl:when>
		<xsl:when test="@Type='Join'">; данный регион присоединился к региону </xsl:when>
		<xsl:when test="@Type='Split'">; данный регион распался на регионы </xsl:when>
		<xsl:when test="@Type='Secession'">; данный регион отделился от региона </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Region/l:Form[not(@Type)]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">Объединение регионов </xsl:when>
		<xsl:when test="@Type='Join'">Регион присоединился к региону </xsl:when>
		<xsl:when test="@Type='Split'">Регион распался на регионы </xsl:when>
		<xsl:when test="@Type='Secession'">Регион отделился от региона </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:City/l:Form[@Type]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">, объединение населённых пунктов </xsl:when>
		<xsl:when test="@Type='Join'">; данный населённый пункт присоединился к населённому пункту </xsl:when>
		<xsl:when test="@Type='Split'">; данный населённый пункт распался на населённые пункты </xsl:when>
		<xsl:when test="@Type='Secession'">; данный населённый пункт отделился от населённого пункта </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:City/l:Form[not(@Type)]/l:Reference" mode="Name">
	<xsl:choose>
		<xsl:when test="@Type='Union'">Объединение населённых пунктов </xsl:when>
		<xsl:when test="@Type='Join'">Населённый пункт присоединился к населённому пункту </xsl:when>
		<xsl:when test="@Type='Split'">Населённый пункт распался на населённые пункты </xsl:when>
		<xsl:when test="@Type='Secession'">Населённый пункт отделился от населённого пункта </xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Country and region form 'State' overriding -->

<xsl:template match="l:Country/l:Form/@Type" mode="Format">
	<xsl:variable name="Type" select="."/>
	<xsl:variable name="ExName">
		<xsl:apply-templates select="." mode="GetExternalName"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$ExName='loctypeState'">
			<xsl:text>Государство</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="FormatLink"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="l:Region/l:Form/@Type" mode="Format">
	<xsl:variable name="Type" select="."/>
	<xsl:variable name="ExName">
		<xsl:apply-templates select="." mode="GetExternalName"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$ExName='loctypeState'">
			<xsl:text>Штат</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="." mode="FormatLink"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
