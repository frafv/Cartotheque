<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:e="urn:schemas-xml-frafv:proxy" exclude-result-prefixes="e">
<xsl:output encoding="UTF-16" indent="yes" method="html"/>

<!-- UI language code for overriding (long format always). -->
<xsl:template match="*" priority="-9" mode="UILang">
	<xsl:text>en-US</xsl:text>
</xsl:template>

<!-- Default file title. -->
<xsl:template match="/*" mode="Title" priority="-9">
	<xsl:value-of select="local-name()"/>
</xsl:template>

<!-- Default element display. -->
<xsl:template match="*" priority="-9">
	<li type="circle">
	<xsl:choose>
		<xsl:when test="*[local-name() = 'Label']">
			<b><xsl:apply-templates select="." mode="Name"/>: </b>
			<xsl:apply-templates select="." mode="Label"/>
		</xsl:when>
		<xsl:otherwise>
			<b><xsl:apply-templates select="." mode="Name"/></b>
		</xsl:otherwise>
	</xsl:choose>
	<ul>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="." mode="Table">
			<xsl:with-param name="Name">Label</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="*[local-name() != 'Label']"/>
		<xsl:if test="text()">
			<li type="circle">
				<xsl:apply-templates select="." mode="Format"/>
			</li>
		</xsl:if>
	</ul>
	</li>
</xsl:template>

<!-- Default empty element display. -->
<xsl:template match="*[not(*) and not(@*) and text()]" priority="-9">
	<li type="circle"><b><xsl:apply-templates select="." mode="Name"/>: </b>
	<xsl:apply-templates select="." mode="Format"/></li>
</xsl:template>

<!-- Default attribute display. -->
<xsl:template match="@*" priority="-9">
	<li type="disc"><b><xsl:apply-templates select="." mode="Name"/>: </b>
	<xsl:apply-templates select="." mode="Format"/></li>
</xsl:template>

<!-- Default element and attribute name resolving. -->
<xsl:template match="@*|*" mode="Name" priority="-9">
	<xsl:value-of select="local-name()"/>
</xsl:template>

<!-- Default element and attribute content display. -->
<xsl:template match="@*|*" priority="-9" mode="Format">
	<xsl:value-of select="."/>
</xsl:template>

<!-- Element and attribute content display in a list. -->
<xsl:template match="@*|*" priority="-9" mode="FormatList">
	<xsl:if test="position()!=1">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="." mode="Format"/>
</xsl:template>

<!-- Default file display. -->
<xsl:template match="/*" priority="-9">
	<html>
		<head>
			<title><xsl:apply-templates select="." mode="Title"/></title>
			<meta http-equiv="Expires" content="0"/>
		</head>
		<body>
			<h1><xsl:apply-templates select="." mode="Title"/></h1>
			<ul>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates select="*"/>
			</ul>
		</body>
	</html>
</xsl:template>

<!-- Elements list display by name (Name) as table. -->
<xsl:template match="*" mode="Table">
	<xsl:param name="Name"/>
	<xsl:variable name="Rows" select="*[local-name() = $Name]"/>

	<xsl:if test="$Rows">
		<li type="circle"/>
		<b><xsl:value-of select="$Name"/>: </b>
		<table border="solid">
			<tr>
				<xsl:for-each select="$Rows/@*">
					<xsl:sort select="local-name()"/>
					<xsl:variable name="attr" select="name()"/>
					<xsl:if test="generate-id(.) = generate-id($Rows/@*[name() = $attr])">
						<th>
							<xsl:value-of select="local-name()"/>
						</th>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="$Rows/text()">
					<th>
						<xsl:value-of select="$Name"/>
					</th>
				</xsl:if>
			</tr>
			<xsl:for-each select="$Rows">
				<xsl:variable name="Row" select="."/>
				<tr>
					<xsl:for-each select="$Rows/@*">
						<xsl:sort select="local-name()"/>
						<xsl:variable name="attr" select="name()"/>
						<xsl:if test="generate-id(.) = generate-id($Rows/@*[name() = $attr])">
							<td>
								<xsl:apply-templates select="$Row/@*[name() = $attr]" mode="Format"/>
							</td>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="$Rows/text()">
						<td>
							<xsl:apply-templates select="$Row" mode="Format"/>
						</td>
					</xsl:if>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:if>
</xsl:template>

<!-- Generates ID of element label by language (Lang), type (Type) and label element name (Name). -->
<xsl:template match="*" mode="LabelID" priority="-9">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="Label" select="*[local-name() = $Name]"/>
	<xsl:variable name="LangLabel" select="$Label[@xml:lang = substring-before($Lang,'-') or @xml:lang = $Lang]"/>

	<xsl:choose>
		<xsl:when test="$Type != '' and $LangLabel[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))]">
			<xsl:value-of select="generate-id($LangLabel[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))])"/>
		</xsl:when>
		<xsl:when test="$LangLabel">
			<xsl:value-of select="generate-id($LangLabel)"/>
		</xsl:when>
		<xsl:when test="$Label[contains(concat(' ',@Type,' '),' Org ')]">
			<xsl:value-of select="generate-id($Label[contains(concat(' ',@Type,' '),' Org ')])"/>
		</xsl:when>
		<xsl:when test="$Type != '' and $Label[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))]">
			<xsl:value-of select="generate-id($Label[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))])"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="generate-id($Label)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element label display by language (Lang), type (Type) and label element name (Name). -->
<xsl:template match="*" mode="Label" priority="-9">
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

	<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $ID]" mode="Format"/>
</xsl:template>

<!-- Element abbreviation label (with full hint) display by language (Lang) and label element name (Name). -->
<xsl:template match="*" mode="LabelAbbr">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="aid">
		<xsl:apply-templates select="." mode="LabelID">
			<xsl:with-param name="Lang" select="$Lang"/>
			<xsl:with-param name="Type">Abbr</xsl:with-param>
			<xsl:with-param name="Name" select="$Name"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="lid">
		<xsl:apply-templates select="." mode="LabelID">
			<xsl:with-param name="Lang" select="$Lang"/>
			<xsl:with-param name="Name" select="$Name"/>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$aid = $lid">
			<xsl:for-each select="*[local-name() = $Name][generate-id(.) = $lid]">
				<xsl:apply-templates select="." mode="Format">
					<xsl:with-param name="UILang" select="@xml:lang"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<span>
				<xsl:attribute name="title">
					<xsl:for-each select="*[local-name() = $Name][generate-id(.) = $lid]">
						<xsl:apply-templates select="." mode="Format">
							<xsl:with-param name="UILang" select="@xml:lang"/>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:attribute>
				<xsl:for-each select="*[local-name() = $Name][generate-id(.) = $aid]">
					<xsl:apply-templates select="." mode="Format">
						<xsl:with-param name="UILang" select="@xml:lang"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element content display with foreign language hint. -->
<xsl:template match="*" mode="Foreign">
	<xsl:param name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Prefix" select="''"/>
	<xsl:param name="Suffix" select="''"/>

	<xsl:choose>
		<xsl:when test="@xml:lang = $UILang or contains($UILang, '-') and starts-with(@xml:lang,substring-before($UILang, '-'))">
			<xsl:value-of select="$Prefix"/>
			<xsl:value-of select="."/>
			<xsl:value-of select="$Suffix"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="foreign" select="@xml:lang"/>
			<span>
				<xsl:attribute name="title">
					<xsl:apply-templates select="//*[@e:Name = $foreign]" mode="Label"/>
				</xsl:attribute>
				<xsl:value-of select="$Prefix"/>
				<xsl:value-of select="."/>
				<xsl:value-of select="$Suffix"/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
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

<!-- Attribute link display. -->
<xsl:template match="@*" mode="FormatLink" priority="-9">
	<xsl:variable name="link" select="."/>
	<xsl:apply-templates select="//@e:Name[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>

<!-- External object label display. -->
<xsl:template match="@e:Name" mode="Format" priority="-9">
	<xsl:apply-templates select="parent::*" mode="Label"/>
</xsl:template>

<!-- Date display format. -->
<xsl:template match="@*" mode="CheckDate">
	<xsl:variable name="date" select="substring-before(concat(., 'T'), 'T')"/>

	<xsl:choose>
		<xsl:when test="string-length($date) != 10 and string-length($date) != 7 and string-length($date) != 4">InvalidLength</xsl:when>
		<xsl:when test="string-length($date) = 10 and substring($date, 8, 1) != '-'">InvalidSeparator</xsl:when>
		<xsl:when test="string-length($date) &gt; 4 and substring($date, 5, 1) != '-'">InvalidSeparator</xsl:when>
		<xsl:when test="translate($date, '0123456789-', '') != ''">InvalidSymbol</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="@*" mode="FormatEnMMMM">
	<xsl:choose>
		<xsl:when test="substring(., 6, 2) = '01'">January</xsl:when>
		<xsl:when test="substring(., 6, 2) = '02'">February</xsl:when>
		<xsl:when test="substring(., 6, 2) = '03'">March</xsl:when>
		<xsl:when test="substring(., 6, 2) = '04'">April</xsl:when>
		<xsl:when test="substring(., 6, 2) = '05'">May</xsl:when>
		<xsl:when test="substring(., 6, 2) = '06'">June</xsl:when>
		<xsl:when test="substring(., 6, 2) = '07'">July</xsl:when>
		<xsl:when test="substring(., 6, 2) = '08'">August</xsl:when>
		<xsl:when test="substring(., 6, 2) = '09'">September</xsl:when>
		<xsl:when test="substring(., 6, 2) = '10'">October</xsl:when>
		<xsl:when test="substring(., 6, 2) = '11'">November</xsl:when>
		<xsl:when test="substring(., 6, 2) = '12'">December</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="@*" mode="FormatDD" priority="-1">
	<xsl:value-of select="substring(., 9, 2)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatYYYY" priority="-1">
	<xsl:value-of select="substring(., 1, 4)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatD" priority="-1">
	<xsl:if test="substring(., 9, 1)!='0'"><xsl:value-of select="substring(., 9, 1)"/></xsl:if>
	<xsl:value-of select="substring(., 10, 1)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatRuDMMMM" priority="-1">
	<xsl:apply-templates select="." mode="FormatD"/>
	<xsl:text> </xsl:text>
	<xsl:choose>
		<xsl:when test="substring(., 6, 2) = '01'">января</xsl:when>
		<xsl:when test="substring(., 6, 2) = '02'">февраля</xsl:when>
		<xsl:when test="substring(., 6, 2) = '03'">марта</xsl:when>
		<xsl:when test="substring(., 6, 2) = '04'">апреля</xsl:when>
		<xsl:when test="substring(., 6, 2) = '05'">мая</xsl:when>
		<xsl:when test="substring(., 6, 2) = '06'">июня</xsl:when>
		<xsl:when test="substring(., 6, 2) = '07'">июля</xsl:when>
		<xsl:when test="substring(., 6, 2) = '08'">августа</xsl:when>
		<xsl:when test="substring(., 6, 2) = '09'">сентября</xsl:when>
		<xsl:when test="substring(., 6, 2) = '10'">октября</xsl:when>
		<xsl:when test="substring(., 6, 2) = '11'">ноября</xsl:when>
		<xsl:when test="substring(., 6, 2) = '12'">декабря</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="@*" mode="FormatRuMMMM" priority="-1">
	<xsl:choose>
		<xsl:when test="substring(., 6, 2) = '01'">Январь</xsl:when>
		<xsl:when test="substring(., 6, 2) = '02'">Февраль</xsl:when>
		<xsl:when test="substring(., 6, 2) = '03'">Март</xsl:when>
		<xsl:when test="substring(., 6, 2) = '04'">Апрель</xsl:when>
		<xsl:when test="substring(., 6, 2) = '05'">Май</xsl:when>
		<xsl:when test="substring(., 6, 2) = '06'">Июнь</xsl:when>
		<xsl:when test="substring(., 6, 2) = '07'">Июль</xsl:when>
		<xsl:when test="substring(., 6, 2) = '08'">Август</xsl:when>
		<xsl:when test="substring(., 6, 2) = '09'">Сентябрь</xsl:when>
		<xsl:when test="substring(., 6, 2) = '10'">Октябрь</xsl:when>
		<xsl:when test="substring(., 6, 2) = '11'">Ноябрь</xsl:when>
		<xsl:when test="substring(., 6, 2) = '12'">Декабрь</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="@*" mode="FormatRuYYYY" priority="-1">
	<xsl:value-of select="substring(., 1, 4)"/>
	<xsl:text> г.</xsl:text>
</xsl:template>
<xsl:template match="@*" mode="FormatLongDate" priority="-1">
	<xsl:param name="UILang">
		<xsl:apply-templates select="/*" mode="UILang"/>
	</xsl:param>
	<xsl:variable name="check">
		<xsl:apply-templates select="." mode="CheckDate"/>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$check != ''">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:when test="$UILang='en-US'">
			<xsl:if test="string-length(.) &gt;= 7 and substring(., 6, 2) != '--'">
				<xsl:apply-templates select="." mode="FormatEnMMMM"/>
				<xsl:if test="string-length(.) &gt;= 10 and substring(., 9, 2) != '--'">
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="." mode="FormatDD"/>
				</xsl:if>
				<xsl:if test="substring(., 1, 4) != '----'">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="substring(., 1, 4) != '----'">
				<xsl:apply-templates select="." mode="FormatYYYY"/>
			</xsl:if>
		</xsl:when>
		<xsl:when test="$UILang='ru-RU'">
			<xsl:if test="string-length(.) &gt;= 7 and substring(., 6, 2) != '--'">
				<xsl:choose>
					<xsl:when test="string-length(.) &gt;= 10 and substring(., 9, 2) != '--'">
						<xsl:apply-templates select="." mode="FormatRuDMMMM"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="FormatRuMMMM"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="substring(., 1, 4) != '----'">
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="substring(., 1, 4) != '----'">
				<xsl:apply-templates select="." mode="FormatRuYYYY"/>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
