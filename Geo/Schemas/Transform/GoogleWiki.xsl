<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="UTF-8" method="text"/>

<!-- Default element display. -->
<xsl:template match="*" mode="ViewElement">
	<xsl:param name="Name">
		<xsl:apply-templates select="." mode="Name"/>
	</xsl:param>
	<xsl:param name="Label">
		<xsl:if test="*[local-name() = 'Label']">
			<xsl:apply-templates select="." mode="Label"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="Ident"/>

	<xsl:text>&#10;</xsl:text>
	<xsl:value-of select="$Ident"/>
	<xsl:text>  * </xsl:text>
	<xsl:choose>
		<xsl:when test="$Name != '' and $Label != ''">
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$Name"/>
			<xsl:text>:* </xsl:text>
		</xsl:when>
		<xsl:when test="$Name != ''">
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$Name"/>
			<xsl:text>*</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:value-of select="$Label"/>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="Table" select="*[local-name() = 'Label']"/>
		<xsl:with-param name="List2" select="*[local-name() != 'Label']"/>
		<xsl:with-param name="Ident" select="concat($Ident,'  ')"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default element index display. -->
<xsl:template match="*" mode="ViewIndex">
	<xsl:param name="Link"/>
	<xsl:param name="Name">
		<xsl:apply-templates select="." mode="NameText"/>
	</xsl:param>
	<xsl:param name="Label">
		<xsl:if test="*[local-name() = 'Label']">
			<xsl:apply-templates select="." mode="LabelText"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="Ident"/>

	<xsl:text>&#10;</xsl:text>
	<xsl:value-of select="$Ident"/>
	<xsl:text>  * </xsl:text>
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link" select="$Link"/>
		<xsl:with-param name="Text">
			<xsl:value-of select="$Name"/>
			<xsl:if test="$Name != '' and $Label != ''">
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:value-of select="$Label"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewIndexList">
		<xsl:with-param name="List" select="*[local-name() != 'Label']"/>
		<xsl:with-param name="Ident" select="concat($Ident,'  ')"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default element content display. -->
<xsl:template match="*" mode="ViewList">
	<xsl:param name="List" select="@*"/>
	<xsl:param name="Table" select="/.."/>
	<xsl:param name="List2" select="/.."/>
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="$List">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewContent">
		<xsl:with-param name="Table" select="$Table"/>
		<xsl:with-param name="List" select="$List2"/>
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="ViewContent">
	<xsl:param name="Table" select="/.."/>
	<xsl:param name="List" select="/.."/>
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewTable">
		<xsl:with-param name="Rows" select="$Table"/>
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="$List">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
	<xsl:if test="not(*) and text()">
		<xsl:text>&#10;</xsl:text>
		<xsl:value-of select="$Ident"/>
		<xsl:text>  * </xsl:text>
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:if>
</xsl:template>

<!-- Default element index content display. -->
<xsl:template match="*" mode="ViewIndexList">
	<xsl:param name="List" select="*"/>
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="." mode="ViewIndexContent">
		<xsl:with-param name="List" select="$List"/>
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="*" mode="ViewIndexContent">
	<xsl:param name="List"/>
	<xsl:param name="Ident"/>

	<xsl:apply-templates select="$List" mode="Index">
		<xsl:with-param name="Ident" select="$Ident"/>
	</xsl:apply-templates>
</xsl:template>

<!-- Default empty element or attribute value display. -->
<xsl:template match="@*|*" mode="ViewValue">
	<xsl:param name="Name">
		<xsl:apply-templates select="." mode="Name"/>
	</xsl:param>
	<xsl:param name="Value">
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:param>
	<xsl:param name="Ident"/>

	<xsl:text>&#10;</xsl:text>
	<xsl:value-of select="$Ident"/>
	<xsl:text>  * </xsl:text>
	<xsl:if test="$Name != ''">
		<xsl:text>*</xsl:text>
		<xsl:value-of select="$Name"/>
		<xsl:text>:* </xsl:text>
	</xsl:if>
	<xsl:value-of select="$Value"/>
</xsl:template>

<!-- Element or Attribute with hint display. -->
<xsl:template match="@*|*" mode="ViewText">
	<xsl:param name="UILang">
		<xsl:apply-templates select="/*" mode="UILang"/>
	</xsl:param>
	<xsl:param name="Hint">
		<xsl:apply-templates select="." mode="FormatHint">
			<xsl:with-param name="UILang" select="$UILang"/>
		</xsl:apply-templates>
	</xsl:param>
	<xsl:param name="Text">
		<xsl:apply-templates select="." mode="FormatText">
			<xsl:with-param name="UILang" select="$UILang"/>
		</xsl:apply-templates>
	</xsl:param>

	<xsl:choose>
		<xsl:when test="$Hint=''">
			<xsl:value-of select="$Text"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&lt;span title="</xsl:text>
			<xsl:value-of select="$Hint"/>
			<xsl:text>"&gt;</xsl:text>
			<xsl:value-of select="$Text"/>
			<xsl:text>&lt;/span&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element or Attribute link display. -->
<xsl:template match="@*|*" mode="ViewLink">
	<xsl:param name="Link" select="."/>
	<xsl:param name="Hint">
		<xsl:apply-templates select="." mode="FormatHint"/>
	</xsl:param>
	<xsl:param name="Text">
		<xsl:apply-templates select="." mode="FormatText"/>
	</xsl:param>

	<xsl:choose>
		<xsl:when test="$Link=''">
			<xsl:apply-templates select="." mode="ViewText">
				<xsl:with-param name="Hint" select="$Hint"/>
				<xsl:with-param name="Text" select="$Text"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="translate($Link,' ','_')"/>
			<xsl:if test="$Text!=''">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$Text"/>
			</xsl:if>
			<xsl:text>]</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element or Attribute paragraph display. -->
<xsl:template match="@*|*" mode="ViewTextParagraph">
	<xsl:param name="Text">
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:param>
	<xsl:param name="Ident"/>

	<xsl:text>&#10;</xsl:text>
	<xsl:value-of select="$Ident"/>
	<xsl:value-of select="$Text"/>
</xsl:template>

<!-- Element title display. -->
<xsl:template match="*" mode="ViewTitle">
	<xsl:param name="ID">
		<xsl:apply-templates select="." mode="ID"/>
	</xsl:param>
	<xsl:param name="Title">
		<xsl:apply-templates select="." mode="Label"/>
	</xsl:param>

	<xsl:if test="$ID != '' and $ID != string($Title)">
		<xsl:text>&#10;== </xsl:text>
		<xsl:value-of select="$ID"/>
		<xsl:text> ==</xsl:text>
	</xsl:if>
	<xsl:text>&#10;= </xsl:text>
	<xsl:value-of select="$Title"/>
	<xsl:text> =</xsl:text>
</xsl:template>

<!-- Element header display. -->
<xsl:template match="*" mode="ViewHeader">
	<xsl:param name="ID">
		<xsl:apply-templates select="." mode="ID"/>
	</xsl:param>
	<xsl:param name="Title">
		<xsl:apply-templates select="." mode="Label"/>
	</xsl:param>
	<xsl:param name="Subtitle"/>

	<xsl:text>&#10;&#10;----</xsl:text>
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="ID" select="$ID"/>
		<xsl:with-param name="Title" select="$Title"/>
	</xsl:apply-templates>
	<xsl:if test="$Subtitle != ''">
		<xsl:text>&#10;== (</xsl:text>
		<xsl:value-of select="$Subtitle"/>
		<xsl:text>) ==</xsl:text>
	</xsl:if>
</xsl:template>

<!-- Default file display. -->
<xsl:template match="/*" mode="ViewElement">
	<xsl:param name="Label">
		<xsl:apply-templates select="." mode="Title"/>
	</xsl:param>

	<xsl:if test="$Label">
		<xsl:text>#summary </xsl:text>
		<xsl:value-of select="$Label"/>
		<xsl:text>&#10;</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="." mode="ViewContent"/>
	<xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- Default file content display. -->
<xsl:template match="/*" mode="ViewContent">
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="Title">
			<xsl:apply-templates select="." mode="Title"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:text>&#10;&#10;&lt;wiki:toc/&gt;</xsl:text>
	<xsl:text>&#10;&#10;----</xsl:text>
	<xsl:apply-templates select="@*[namespace-uri() != 'http://www.w3.org/2001/XMLSchema-instance']"/>
	<xsl:apply-templates select="." mode="ViewTable">
		<xsl:with-param name="Rows" select="*[local-name() = 'Label']"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="*[local-name() != 'Label']"/>
	<xsl:if test="text()">
		<xsl:text>&#10;  * </xsl:text>
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:if>
</xsl:template>

<xsl:template match="*" mode="ViewLanguages">
</xsl:template>

<!-- Default element header -->
<xsl:template match="*" mode="ViewSingleHeader">
</xsl:template>

<!-- Default element footer -->
<xsl:template match="*" mode="ViewSingleFooter">
	<xsl:text>&#10;&#10;</xsl:text>
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link">#<xsl:apply-templates select="/*" mode="ID"/></xsl:with-param>
		<xsl:with-param name="Text">
			<xsl:apply-templates select="." mode="FooterUp"/>
		</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

<!-- Elements list display by name (Name) as table. -->
<xsl:template match="*" mode="ViewTable">
	<xsl:param name="Rows"/>
	<xsl:param name="Name">
		<xsl:apply-templates select="$Rows[1]" mode="Name"/>
	</xsl:param>
	<xsl:param name="Ident"/>

	<xsl:if test="$Rows">
		<xsl:text>&#10;</xsl:text>
		<xsl:value-of select="$Ident"/>
		<xsl:text>  * *</xsl:text>
		<xsl:value-of select="$Name"/>
		<xsl:text>:* </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:value-of select="$Ident"/>
		<xsl:text>    |</xsl:text>
		<xsl:for-each select="$Rows/@*">
			<xsl:sort select="local-name()"/>
			<xsl:variable name="attr" select="name()"/>
			<xsl:if test="generate-id(.) = generate-id($Rows/@*[name() = $attr])">
				<xsl:text>| *</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>* |</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$Rows/text()">
			<xsl:text>| *</xsl:text>
			<xsl:value-of select="$Name"/>
			<xsl:text>* |</xsl:text>
		</xsl:if>
		<xsl:text>|</xsl:text>
		<xsl:for-each select="$Rows">
			<xsl:variable name="Row" select="."/>
			<xsl:text>&#10;</xsl:text>
			<xsl:value-of select="$Ident"/>
			<xsl:text>    |</xsl:text>
			<xsl:for-each select="$Rows/@*">
				<xsl:sort select="local-name()"/>
				<xsl:variable name="attr" select="name()"/>
				<xsl:if test="generate-id(.) = generate-id($Rows/@*[name() = $attr])">
					<xsl:text>| </xsl:text>
					<xsl:apply-templates select="$Row/@*[name() = $attr]" mode="Format"/>
					<xsl:text> |</xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="$Rows/text()">
				<xsl:text>| </xsl:text>
				<xsl:apply-templates select="$Row" mode="Format"/>
				<xsl:text> |</xsl:text>
			</xsl:if>
			<xsl:text>|</xsl:text>
		</xsl:for-each>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
