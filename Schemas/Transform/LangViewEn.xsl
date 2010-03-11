<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="Web.xsl"/>
<xsl:import href="LangEn.xsl"/>
<xsl:output encoding="UTF-16" indent="yes" method="html"/>

<!-- UI strings -->

<xsl:template match="*" mode="Footer">
	<p>
		<xsl:apply-templates select="." mode="ViewLink">
			<xsl:with-param name="Link">#<xsl:apply-templates select="/*" mode="ID"/></xsl:with-param>
			<xsl:with-param name="Text">
				<xsl:apply-templates select="." mode="FooterUp"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">
			<xsl:apply-templates select="." mode="FooterBack"/>
		</a>
	</p>
</xsl:template>

</xsl:stylesheet>
