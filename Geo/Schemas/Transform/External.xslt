<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="l c e xs">

<xsl:key name="ExternalContinent" match="l:ContinentList/l:Continent" use="@Name"/>
<xsl:key name="ExternalLocationType" match="l:LocationTypeList/l:LocationType" use="@Name"/>
<xsl:key name="ExternalLanguage" match="c:LanguageList//c:Language" use="@Name"/>

<!-- Copies proxy content by name as attribute -->
<xsl:template match="@*" mode="CopyProxyContent">
	<xsl:for-each select="key('FindProxy', .)[1]">
		<xsl:copy-of select="@*"/>
		<xsl:copy-of select="*"/>
	</xsl:for-each>
</xsl:template>

<!-- Returns external name of the element by proxy name as attribute -->
<xsl:template match="@*" mode="GetExternalName">
	<xsl:variable name="name" select="."/>
	<xsl:variable name="list" select="//*[*/@e:Name = $name][1]"/>
	<xsl:variable name="prefix" select="$list/e:Prefix[starts-with($name, @Local) or not(@Local)][1]"/>
	<xsl:variable name="ext" select="$list/*[@e:Name = $name][1]"/>
	<xsl:value-of select="$prefix/@External"/>
	<xsl:choose>
		<xsl:when test="$ext/@e:External">
			<xsl:value-of select="$ext/@e:External"/>
		</xsl:when>
		<xsl:when test="starts-with($ext/@e:Name, $prefix/@Local)">
			<xsl:value-of select="substring-after($ext/@e:Name, $prefix/@Local)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Returns export name of the element by external name (Name) and element's document holder -->
<xsl:template match="*" mode="GetExportName">
	<xsl:param name="Name"/>
	<xsl:for-each select="/*/e:ExportList[e:Prefix[starts-with($Name, @External)] or not(e:Prefix)]">
		<xsl:variable name="prefix" select="e:Prefix[starts-with($Name, @External)][1]"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$prefix">
					<xsl:value-of select="substring-after($Name, $prefix/@External)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="e:Export[@External = $suffix and ./*]">
				<xsl:text>*</xsl:text>
			</xsl:when>
			<xsl:when test="e:Export[@External = $suffix]">
				<xsl:value-of select="e:Export[@External = $suffix]/@Name"/>
			</xsl:when>
			<xsl:when test="e:Export[@Name = concat($prefix/@Local,$suffix) and ./*]">
				<xsl:text>*</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="e:Export[@Name = concat($prefix/@Local,$suffix)]/@Name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- Copies elements with unique languages -->
<xsl:template match="*" mode="CopyExport">
	<xsl:param name="Name"/>
	<xsl:for-each select="/*/e:ExportList[e:Prefix[starts-with($Name, @External)] or not(e:Prefix)]">
		<xsl:variable name="prefix" select="e:Prefix[starts-with($Name, @External)][1]"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$prefix">
					<xsl:value-of select="substring-after($Name, $prefix/@External)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="e:Export[@External = $suffix and ./*]">
				<xsl:apply-templates select="e:Export[@External = $suffix]/*" mode="CreateProxy"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="e:Export[@Name = concat($prefix/@Local,$suffix)]/*" mode="CreateProxy"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- Copies elements with unique languages -->
<xsl:template match="*" mode="CopyLang">
	<xsl:param name="NS" select="''"/>
	<xsl:variable name="name" select="name()"/>
	<xsl:variable name="lang" select="@xml:lang"/>
	<xsl:if test="not(preceding-sibling::*[name()=$name and @xml:lang = $lang])">
		<xsl:element name="{name()}" namespace="{$NS}">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- Copies external elements with unique languages -->
<xsl:template match="*" mode="CopyExternal">
	<xsl:param name="LocalName"/>
	<xsl:param name="ExPrefix"/>
	<xsl:param name="ExSelect"/>
	<xsl:attribute name="e:Name">
		<xsl:value-of select="$LocalName"/>
	</xsl:attribute>
	<xsl:variable name="ex">
		<xsl:apply-templates select="." mode="GetExportName">
			<xsl:with-param name="Name" select="concat($ExPrefix, $LocalName)"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$ex = ''">
			<xsl:message terminate="yes">External <xsl:value-of select="$ExPrefix"/><xsl:value-of select="$LocalName"/> not found.</xsl:message>
		</xsl:when>
		<xsl:when test="$ex = '*'">
			<xsl:apply-templates select="." mode="CopyExport">
				<xsl:with-param name="Name" select="concat($ExPrefix, $LocalName)"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="key($ExSelect,$ex)" mode="CreateProxy"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Default constructor of a proxy with labels -->
<xsl:template match="*" mode="CreateProxy" priority="-9">
	<xsl:choose>
		<xsl:when test="*[name() = 'Label']">
			<xsl:apply-templates select="*[name() = 'Label']" mode="CopyLang"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="{name()}">
				<xsl:copy-of select="@*"/>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Location proxy constructor (from LocationType.xml) -->
<xsl:template match="@*" mode="MakeLocationProxy">
	<xsl:param name="ExPrefix"/>
	<xsl:param name="ExSelect"/>
	<xsl:choose>
		<xsl:when test="key('FindProxy', .)">
			<xsl:apply-templates select="." mode="CopyProxyContent"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="document('..\Dic\LocationType.xml')/l:LocationList" mode="CopyExternal">
				<xsl:with-param name="LocalName" select="."/>
				<xsl:with-param name="ExPrefix" select="$ExPrefix"/>
				<xsl:with-param name="ExSelect" select="$ExSelect"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Culture proxy constructor (from Culture.xml) -->
<xsl:template match="@*" mode="MakeCultureProxy">
	<xsl:param name="ExPrefix"/>
	<xsl:param name="ExSelect"/>
	<xsl:param name="ProxyNS"/>
	<xsl:choose>
		<xsl:when test="key('FindProxy', .)">
			<xsl:apply-templates select="." mode="CopyProxyContent"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="document('..\Dic\Culture.xml')/c:CultureList" mode="CopyExternal">
				<xsl:with-param name="LocalName" select="."/>
				<xsl:with-param name="ExPrefix" select="$ExPrefix"/>
				<xsl:with-param name="ExSelect" select="$ExSelect"/>
				<xsl:with-param name="ProxyNS" select="$ProxyNS"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Language proxy list constructor by xml:lang attribute -->
<xsl:template name="MakeLanguageProxy">
	<e:Prefix External="lang"/>
	<xsl:variable name="deflang" select="document('..\Dic\Culture.xml')/c:CultureList/c:LanguageList/c:Language[1]/c:Label[not(@Type)]"/>
	<xsl:variable name="reflang" select="//*[@xml:lang]"/>
	<xsl:for-each select="$reflang|$deflang">
		<xsl:sort select="@xml:lang"/>
		<xsl:variable name="curlang" select="@xml:lang"/>
		<xsl:choose>
			<xsl:when test="parent::c:Language">
				<xsl:if test="not($reflang[@xml:lang = $curlang])">
					<xsl:apply-templates select="@xml:lang" mode="MakeProxy"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="not(preceding::*[@xml:lang = $curlang])">
				<xsl:apply-templates select="@xml:lang" mode="MakeProxy"/>
			</xsl:when>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
