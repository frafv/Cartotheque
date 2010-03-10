<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="Wiki.xsl"/>
<xsl:import href="LocRu.xsl"/>
<xsl:output encoding="UTF-8" method="text"/>

<!-- UI strings -->

<xsl:template match="*" mode="Footer">
	<xsl:text>&#10;&#10;</xsl:text>
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link">#List of Locations</xsl:with-param>
		<xsl:with-param name="Text">Вверх</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
