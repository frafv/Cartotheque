<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="urn:geo-schemas-xml-frafv:location" xmlns:c="urn:geo-schemas-xml-frafv:culture" xmlns:e="urn:schemas-xml-frafv:proxy" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ms="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="l c e xs ms">

<xsl:key name="ExternalContinent" match="l:ContinentList/l:Continent" use="@Name"/>
<xsl:key name="ExternalLocationType" match="l:LocationTypeList/l:LocationType" use="@Name"/>
<xsl:key name="ExternalLanguage" match="c:LanguageList//c:Language" use="@Name"/>
<xsl:key name="ExternalCountry" match="l:CountryList/l:Country" use="@Name"/>
<xsl:key name="ExternalRegion" match="l:RegionList/l:Region" use="@Name"/>
<xsl:key name="ExternalCity" match="l:CityList/l:City" use="@Name"/>
<xsl:key name="ExternalStreet" match="l:StreetList/l:Street" use="@Name"/>

<!-- Copies proxy content by name as attribute. -->
<xsl:template match="@*" mode="CopyProxyContent">
	<xsl:for-each select="key('FindProxy', .)[1]">
		<xsl:copy-of select="@*"/>
		<xsl:copy-of select="*"/>
	</xsl:for-each>
</xsl:template>

<!-- Returns external name of the element by proxy name as attribute. -->
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

<!-- Returns export name of the element by external name (Name) and element's
     document holder or '*' for labeled export. -->
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

<!-- Copies export by external name (Name). -->
<xsl:template name="CopyExport">
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

<!-- Copies elements (into namespace NS) with unique languages. -->
<xsl:template match="*" mode="CopyLang">
	<xsl:param name="NS" select="''"/>
	<xsl:variable name="name" select="local-name()"/>
	<xsl:variable name="lang" select="@xml:lang"/>

	<xsl:if test="not(preceding-sibling::*[local-name()=$name and @xml:lang = $lang])">
		<xsl:element name="{local-name()}" namespace="{$NS}">
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- Copies external elements (local name as LocalName, external prefix as ExPrefix
     and key selection name as ExSelect) with unique languages. -->
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
			<xsl:call-template name="CopyExport">
				<xsl:with-param name="Name" select="concat($ExPrefix, $LocalName)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="key($ExSelect,$ex)" mode="CreateProxy"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Default constructor of a proxy with labels -->
<xsl:template match="*" mode="CreateProxy" priority="-9">
	<xsl:choose>
		<xsl:when test="*[local-name() = 'Label']">
			<xsl:apply-templates select="*[local-name() = 'Label']" mode="CopyLang"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="{local-name()}">
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

	<xsl:choose>
		<xsl:when test="key('FindProxy', .)">
			<xsl:apply-templates select="." mode="CopyProxyContent"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="document('..\Dic\Culture.xml')/c:CultureList" mode="CopyExternal">
				<xsl:with-param name="LocalName" select="."/>
				<xsl:with-param name="ExPrefix" select="$ExPrefix"/>
				<xsl:with-param name="ExSelect" select="$ExSelect"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Language proxy list constructor by xml:lang attribute -->
<xsl:template name="MakeLanguageProxy">
	<e:Prefix xmlns="urn:schemas-xml-frafv:proxy" External="lang"/>
	<xsl:variable name="deflang" select="document('..\Dic\Culture.xml')/c:CultureList/c:LanguageList/c:Language[1]/c:Label[not(@Type)]/@xml:lang"/>
	<xsl:variable name="reflang" select="//@xml:lang|$deflang"/>
	<xsl:for-each select="$reflang">
		<xsl:sort/>
		<xsl:variable name="curlang" select="."/>
		<xsl:if test="generate-id(.) = generate-id($reflang[. = $curlang])">
			<xsl:apply-templates select="." mode="MakeProxy"/>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- Makes ID list by attributes (RefList). -->
<xsl:template name="MakeIDList">
	<xsl:param name="RefList"/>
	<xsl:variable name="SimpleList" select="$RefList[not(contains(., ' '))]"/>
	<xsl:variable name="MultiList" select="$RefList[contains(., ' ')]"/>

	<xsl:call-template name="MergeList">
		<xsl:with-param name="List">
			<xsl:for-each select="$SimpleList">
				<xsl:sort/>
				<xsl:variable name="cur" select="."/>
				<xsl:if test="generate-id(.) = generate-id($SimpleList[. = $cur])">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:with-param>
		<xsl:with-param name="Append">
			<xsl:for-each select="$MultiList">
				<xsl:variable name="cur" select="."/>
				<xsl:if test="generate-id(.) = generate-id($MultiList[. = $cur])">
					<xsl:value-of select="concat(., ' ')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- Merges unique ID list (List) with another ID list (Append). -->
<xsl:template name="MergeList">
	<xsl:param name="List"/>
	<xsl:param name="Append"/>

	<xsl:choose>
		<xsl:when test="$Append != ''">
			<xsl:variable name="ID" select="concat(substring-before($Append, ' '), ' ')"/>
			<xsl:call-template name="MergeList">
				<xsl:with-param name="List">
					<xsl:choose>
						<xsl:when test="contains(concat(' ', $List),concat(' ', $ID))">
							<xsl:value-of select="$List"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="ListInsert">
								<xsl:with-param name="List" select="$List"/>
								<xsl:with-param name="Insert" select="$ID"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="Append" select="substring-after($Append, ' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="substring($List, string-length($List)) = ' '">
			<xsl:value-of select="substring($List, 1, string-length($List)-1)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$List"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Insert value (Insert) into the list (List) in sort order. -->
<xsl:template name="ListInsert">
	<xsl:param name="Prefix" select="''"/>
	<xsl:param name="List"/>
	<xsl:param name="Insert"/>

	<xsl:choose>
		<xsl:when test="$List = '' or not(function-available('ms:string-compare'))">
			<xsl:value-of select="concat($Prefix, $List, $Insert)"/>
		</xsl:when>
		<xsl:when test="ms:string-compare($List, $Insert) = 1">
			<xsl:value-of select="concat($Prefix, $Insert, $List)"/>
		</xsl:when>
		<xsl:when test="contains($List, ' ')">
			<xsl:call-template name="ListInsert">
				<xsl:with-param name="Prefix" select="concat($Prefix, substring-before($List, ' '), ' ')"/>
				<xsl:with-param name="List" select="substring-after($List, ' ')"/>
				<xsl:with-param name="Insert" select="$Insert"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat($Prefix, $Insert)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Makes proxy list (from elements List without Skip) with references
     as ID list (optional IDList). -->
<xsl:template name="MakeProxyList">
	<xsl:param name="List"/>
	<xsl:param name="Skip"/>
	<xsl:param name="IDList">
		<xsl:call-template name="MakeIDList">
			<xsl:with-param name="RefList" select="$List"/>
		</xsl:call-template>
	</xsl:param>

	<xsl:if test="$IDList != ''">
		<xsl:variable name="Name" select="substring-before(concat($IDList, ' '), ' ')"/>
		<xsl:if test="not($Skip[. = $Name])">
			<xsl:apply-templates select="$List[contains(concat(' ', ., ' '),concat(' ', $Name, ' '))][1]" mode="MakeProxyList">
				<xsl:with-param name="ID" select="$Name"/>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:call-template name="MakeProxyList">
			<xsl:with-param name="List" select="$List"/>
			<xsl:with-param name="Skip" select="$Skip"/>
			<xsl:with-param name="IDList" select="substring-after($IDList, ' ')"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- Default proxy constructor by ID. -->
<xsl:template match="*|@*" priority="-9" mode="MakeProxyList">
	<xsl:param name="ID"/>

	<xsl:apply-templates select="." mode="MakeProxy"/>
</xsl:template>

<!-- Makes proxy list (from elements List without Skip) with references as single ID. -->
<xsl:template name="MakeProxySimpleList">
	<xsl:param name="List"/>
	<xsl:param name="Skip" select="''"/>

	<xsl:for-each select="$List[not(. = $Skip)]">
		<xsl:sort/>
		<xsl:variable name="cur" select="."/>
		<xsl:if test="generate-id(.) = generate-id($List[. = $cur])">
			<xsl:apply-templates select="." mode="MakeProxyList">
				<xsl:with-param name="ID" select="."/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- Excludes Value from the list as attribute. -->
<xsl:template match="@*" mode="ExcludeValue">
	<xsl:param name="Value"/>

	<xsl:choose>
		<xsl:when test="contains(.,concat(' ',$Value,' '))">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="substring-before(.,concat(' ',$Value,' '))"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring-after(.,concat(' ',$Value,' '))"/>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="starts-with(.,concat($Value,' '))">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="substring(.,string-length($Value)+2)"/>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="substring(.,string-length(.)-string-length($Value))=concat(' ',$Value)">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="substring(.,1,string-length(.)-string-length($Value)-1)"/>
			</xsl:attribute>
		</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
