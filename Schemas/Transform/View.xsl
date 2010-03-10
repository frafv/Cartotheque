<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:e="urn:schemas-xml-frafv:proxy">

<!-- UI language code for overriding (long format always). -->
<xsl:template match="*" mode="UILang">
	<xsl:text>en-US</xsl:text>
</xsl:template>

<!-- Default file title. -->
<xsl:template match="/*" mode="Title">
	<xsl:choose>
		<xsl:when test="*[local-name() = 'Label']">
			<xsl:apply-templates select="." mode="Label"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="local-name()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Default element display. -->
<xsl:template match="*">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewElement">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default file display. -->
<xsl:template match="/*">
	<xsl:apply-templates select="." mode="ViewContent"/>
</xsl:template>
<xsl:template match="/">
	<xsl:apply-templates select="*" mode="ViewElement"/>
</xsl:template>

<!-- Default languages selector display. -->
<xsl:template match="*" mode="Languages">
</xsl:template>

<!-- Default empty element display. -->
<xsl:template match="*[not(*) and not(@*) and text()]">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default attribute display. -->
<xsl:template match="@*">
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewValue">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default element and attribute name resolving. -->
<xsl:template match="@*|*" mode="Name">
	<xsl:apply-templates select="." mode="ViewText">
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="NameHint"/>
		</xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="." mode="NameText"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="@*|*" mode="NameText">
	<xsl:value-of select="local-name()"/>
</xsl:template>
<xsl:template match="@*|*" mode="NameHint">
</xsl:template>

<!-- Default element and attribute identifier resolving. -->
<xsl:template match="@*|*" mode="ID">
	<xsl:variable name="label" select="*[local-name() = 'Label'][@xml:lang='en' or starts-with(@xml:lang,'en-')][1]"/>

	<xsl:choose>
		<xsl:when test="$label">
			<xsl:apply-templates select="$label" mode="Format">
				<xsl:with-param name="UILang" select="$label/@xml:lang"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="local-name()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Default element and attribute content display. -->
<xsl:template match="@*|*" mode="Format">
	<xsl:apply-templates select="." mode="ViewText"/>
</xsl:template>
<xsl:template match="@*|*" mode="FormatText">
	<xsl:value-of select="."/>
</xsl:template>
<xsl:template match="@*|*" mode="FormatHint">
</xsl:template>

<!-- Element and attribute content display in a list. -->
<xsl:template match="@*|*" mode="FormatList">
	<xsl:if test="position()!=1">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="." mode="Format"/>
</xsl:template>
<xsl:template match="@*|*" mode="FormatListText">
	<xsl:if test="position()!=1">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<xsl:apply-templates select="." mode="FormatText"/>
</xsl:template>

<!-- Generates ID of element label by language (Lang), type (Type) and label element name (Name). -->
<xsl:template match="*" mode="LabelID">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="label" select="*[local-name() = $Name]"/>
	<xsl:variable name="langlabel" select="$label[@xml:lang = substring-before($Lang,'-') or @xml:lang = $Lang]"/>

	<xsl:choose>
		<xsl:when test="$Type != '' and $langlabel[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))]">
			<xsl:value-of select="generate-id($langlabel[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))])"/>
		</xsl:when>
		<xsl:when test="$langlabel">
			<xsl:value-of select="generate-id($langlabel)"/>
		</xsl:when>
		<xsl:when test="$label[contains(concat(' ',@Type,' '),' Org ')]">
			<xsl:value-of select="generate-id($label[contains(concat(' ',@Type,' '),' Org ')])"/>
		</xsl:when>
		<xsl:when test="$Type != '' and $label[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))]">
			<xsl:value-of select="generate-id($label[contains(concat(' ',@Type,' '),concat(' ',$Type,' '))])"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="generate-id($label)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element label display by language (Lang), type (Type) and label element name (Name). -->
<xsl:template match="*" mode="Label">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>

	<xsl:apply-templates select="." mode="ViewText">
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="LabelHint">
				<xsl:with-param name="Lang" select="$Lang"/>
				<xsl:with-param name="Type" select="$Type"/>
				<xsl:with-param name="Name" select="$Name"/>
			</xsl:apply-templates>
		</xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="." mode="LabelText">
				<xsl:with-param name="Lang" select="$Lang"/>
				<xsl:with-param name="Type" select="$Type"/>
				<xsl:with-param name="Name" select="$Name"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="LabelText">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="id">
		<xsl:apply-templates select="." mode="LabelID">
			<xsl:with-param name="Lang" select="$Lang"/>
			<xsl:with-param name="Type" select="$Type"/>
			<xsl:with-param name="Name" select="$Name"/>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $id]" mode="FormatText"/>
</xsl:template>
<xsl:template match="*" mode="LabelHint">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Type" select="''"/>
	<xsl:param name="Name">Label</xsl:param>
	<xsl:variable name="id">
		<xsl:apply-templates select="." mode="LabelID">
			<xsl:with-param name="Lang" select="$Lang"/>
			<xsl:with-param name="Type" select="$Type"/>
			<xsl:with-param name="Name" select="$Name"/>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $id]" mode="FormatHint"/>
</xsl:template>

<!-- Element abbreviation label (with full hint) display by language (Lang) and label element name (Name). -->
<xsl:template match="*" mode="LabelAbbr">
	<xsl:param name="Lang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>
	<xsl:param name="Name">Label</xsl:param>

	<xsl:apply-templates select="." mode="ViewText">
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="LabelAbbrHint">
				<xsl:with-param name="Lang" select="$Lang"/>
				<xsl:with-param name="Name" select="$Name"/>
			</xsl:apply-templates>
		</xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="." mode="LabelAbbrText">
				<xsl:with-param name="Lang" select="$Lang"/>
				<xsl:with-param name="Name" select="$Name"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="LabelAbbrText">
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

	<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $aid]" mode="FormatText"/>
</xsl:template>
<xsl:template match="*" mode="LabelAbbrHint">
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
			<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $aid]" mode="FormatHint"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="*[local-name() = $Name][generate-id(.) = $lid]" mode="FormatText"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element content display with foreign language hint. -->
<xsl:template match="*" mode="Foreign">
	<xsl:param name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>

	<xsl:apply-templates select="." mode="ViewText">
		<xsl:with-param name="UILang" select="UILang"/>
		<xsl:with-param name="Hint">
			<xsl:apply-templates select="." mode="ForeignHint">
				<xsl:with-param name="UILang" select="UILang"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="ForeignHint">
	<xsl:param name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:param>

	<xsl:choose>
		<xsl:when test="@xml:lang = $UILang or contains($UILang, '-') and starts-with(@xml:lang,substring-before($UILang, '-'))">
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="foreign" select="@xml:lang"/>
			<xsl:apply-templates select="//*[e:Prefix/@External = 'lang']/*[@e:Name = $foreign]" mode="LabelText"/>
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
<xsl:template match="@*" mode="FormatLink">
	<xsl:variable name="link" select="."/>

	<xsl:apply-templates select="//@e:Name[contains(concat(' ',$link,' '),concat(' ',.,' '))]" mode="FormatList"/>
</xsl:template>

<!-- External object label display. -->
<xsl:template match="@e:Name" mode="Format">
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
<xsl:template match="@*" mode="FormatDD">
	<xsl:value-of select="substring(., 9, 2)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatYYYY">
	<xsl:value-of select="substring(., 1, 4)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatD">
	<xsl:if test="substring(., 9, 1)!='0'"><xsl:value-of select="substring(., 9, 1)"/></xsl:if>
	<xsl:value-of select="substring(., 10, 1)"/>
</xsl:template>
<xsl:template match="@*" mode="FormatRuDMMMM">
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
<xsl:template match="@*" mode="FormatRuMMMM">
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
<xsl:template match="@*" mode="FormatRuYYYY">
	<xsl:value-of select="substring(., 1, 4)"/>
	<xsl:text> г.</xsl:text>
</xsl:template>
<xsl:template match="@*" mode="FormatLongDate">
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
