<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:e="urn:schemas-xml-frafv:proxy" exclude-result-prefixes="e">
<xsl:output encoding="UTF-16" indent="yes" method="html"/>

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

	<li type="circle">
	<xsl:choose>
		<xsl:when test="$Name != '' and $Label != ''">
			<b><xsl:copy-of select="$Name"/>: </b>
		</xsl:when>
		<xsl:when test="$Name != ''">
			<b><xsl:copy-of select="$Name"/></b>
		</xsl:when>
	</xsl:choose>
	<xsl:copy-of select="$Label"/>
	<xsl:apply-templates select="." mode="ViewList">
		<xsl:with-param name="Table" select="*[local-name() = 'Label']"/>
		<xsl:with-param name="List2" select="*[local-name() != 'Label']"/>
	</xsl:apply-templates>
	</li>
</xsl:template>

<!-- Default element index display. -->
<xsl:template match="*" mode="ViewIndex">
	<xsl:param name="Link"/>
	<xsl:param name="Name">
		<xsl:apply-templates select="." mode="NameText"/>
	</xsl:param>
	<xsl:param name="Hint">
		<xsl:if test="*[local-name() = 'Label']">
			<xsl:apply-templates select="." mode="LabelHint"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="Label">
		<xsl:if test="*[local-name() = 'Label']">
			<xsl:apply-templates select="." mode="LabelText"/>
		</xsl:if>
	</xsl:param>

	<li type="circle">
	<xsl:apply-templates select="." mode="ViewLink">
		<xsl:with-param name="Link" select="$Link"/>
		<xsl:with-param name="Hint" select="$Hint"/>
		<xsl:with-param name="Text">
			<xsl:copy-of select="$Name"/>
			<xsl:if test="$Name != '' and $Label != ''">
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:copy-of select="$Label"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<xsl:apply-templates select="." mode="ViewIndexList">
		<xsl:with-param name="List" select="*[local-name() != 'Label']"/>
	</xsl:apply-templates>
	</li>
</xsl:template>

<!-- Default element content display. -->
<xsl:template match="*" mode="ViewList">
	<xsl:param name="List" select="@*"/>
	<xsl:param name="Table" select="/.."/>
	<xsl:param name="List2" select="/.."/>

	<ul>
		<xsl:apply-templates select="$List"/>
		<xsl:apply-templates select="." mode="ViewContent">
			<xsl:with-param name="Table" select="$Table"/>
			<xsl:with-param name="List" select="$List2"/>
		</xsl:apply-templates>
	</ul>
</xsl:template>
<xsl:template match="*" mode="ViewContent">
	<xsl:param name="Table" select="/.."/>
	<xsl:param name="List" select="/.."/>

	<xsl:apply-templates select="." mode="ViewTable">
		<xsl:with-param name="Rows" select="$Table"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="$List"/>
	<xsl:if test="not(*) and text()">
		<li type="circle">
			<xsl:apply-templates select="." mode="Format"/>
		</li>
	</xsl:if>
</xsl:template>

<!-- Default element index content display. -->
<xsl:template match="*" mode="ViewIndexList">
	<xsl:param name="List" select="*"/>

	<ul>
		<xsl:apply-templates select="." mode="ViewIndexContent">
			<xsl:with-param name="List" select="$List"/>
		</xsl:apply-templates>
	</ul>
</xsl:template>
<xsl:template match="*" mode="ViewIndexContent">
	<xsl:param name="List"/>

	<xsl:apply-templates select="$List" mode="Index"/>
</xsl:template>

<!-- Default empty element or attribute value display. -->
<xsl:template match="@*|*" mode="ViewValue">
	<xsl:param name="Name">
		<xsl:apply-templates select="." mode="Name"/>
	</xsl:param>
	<xsl:param name="Value">
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:param>

	<li type="disc">
	<xsl:if test="$Name != ''">
		<b><xsl:copy-of select="$Name"/>: </b>
	</xsl:if>
	<xsl:copy-of select="$Value"/>
	</li>
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
			<xsl:copy-of select="$Text"/>
		</xsl:when>
		<xsl:otherwise>
			<span title="{$Hint}">
				<xsl:copy-of select="$Text"/>
			</span>
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
	<xsl:variable name="href">
		<xsl:choose>
			<xsl:when test="contains($Link,'#')">
				<xsl:value-of select="substring-before($Link,'#')"/>
				<xsl:text>#</xsl:text>
				<xsl:value-of select="translate(substring-after($Link,'#'),' /\()','')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$Link"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$Link = ''">
			<xsl:apply-templates select="." mode="ViewText">
				<xsl:with-param name="Hint" select="$Hint"/>
				<xsl:with-param name="Text" select="$Text"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<a href="{$href}">
				<xsl:if test="$Hint != ''">
					<xsl:attribute name="title">
						<xsl:value-of select="$Hint"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:copy-of select="$Text"/>
				<xsl:if test="$Text=''">
					<xsl:value-of select="$Link"/>
				</xsl:if>
			</a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Element or Attribute paragraph display. -->
<xsl:template match="@*|*" mode="ViewTextParagraph">
	<xsl:param name="Text">
		<xsl:apply-templates select="." mode="Format"/>
	</xsl:param>

	<p><xsl:copy-of select="$Text"/></p>
</xsl:template>

<!-- Element title display. -->
<xsl:template match="*" mode="ViewTitle">
	<xsl:param name="ID">
		<xsl:apply-templates select="." mode="ID"/>
	</xsl:param>
	<xsl:param name="Title">
		<xsl:apply-templates select="." mode="Label"/>
	</xsl:param>

	<h1>
		<xsl:if test="$ID != ''">
			<xsl:attribute name="id">
				<xsl:value-of select="translate($ID,' /\()','')"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:copy-of select="$Title"/>
	</h1>
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

	<hr/>
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="ID" select="$ID"/>
		<xsl:with-param name="Title" select="$Title"/>
	</xsl:apply-templates>
	<xsl:if test="$Subtitle != ''">
		<h2><xsl:copy-of select="$Subtitle"/></h2>
	</xsl:if>
</xsl:template>

<!-- Default file display. -->
<xsl:template match="/*" mode="ViewElement">
	<xsl:param name="Label">
		<xsl:apply-templates select="." mode="Title"/>
	</xsl:param>

	<html>
		<head>
			<title><xsl:value-of select="$Label"/></title>
			<meta http-equiv="Expires" content="0"/>
			<script language="javascript">
				<![CDATA[
					function LoadXML(source) {
						if(document.implementation && document.implementation.createDocument) {
							// load the XML file
							var myXMLHTTPRequest = new XMLHttpRequest();
							myXMLHTTPRequest.open("GET", source, false);
							myXMLHTTPRequest.send(null);

							return myXMLHTTPRequest.responseXML;
						} else if(window.ActiveXObject) { // IE
							// load XML
							xmlDoc = new ActiveXObject("MSXML2.DOMDocument");
							xmlDoc.async = false;
							xmlDoc.load(source);

							return xmlDoc;
						} else return null;
					}
					function Transform(xmlDoc,xslDoc) {
						if(document.implementation && document.implementation.createDocument) {
							var xsltProcessor = new XSLTProcessor();
							xsltProcessor.importStylesheet(xslDoc);

							var fragment = xsltProcessor.transformToFragment(xmlDoc.documentElement, document);

							var div = document.body.lastChild;
							div.innerHTML = "";
							div.appendChild(fragment);
						} else if(window.ActiveXObject) { // IE
							var html = xmlDoc.documentElement.transformNode(xslDoc);

							var div = document.body.children.tags("div")(0);
							div.innerHTML = html;
						}
					}
					function Make(lang,file) {
						if (!lang) lang = navigator.language ? navigator.language : navigator.userLanguage;
						var xmlDoc = LoadXML(document.location.href);
						if(!xmlDoc) return;

						if (!file) {
							var div = document.body.lastChild;
							if (!div || !div.firstChild) return;
							div = div.firstChild;
							var a = div.firstChild;
							while(a && (a.nodeName != "A" || a.href.indexOf("('"+lang+"'") < 0 && a.href.indexOf("('"+lang+"-") < 0))
								a = a.nextSibling;
							if (!a) return;
							var k1 = a.href.indexOf("','");
							var k2 = a.href.indexOf("');");
							file = a.href.substring(k1+3,k2);
						}

						var stylesheet;
						var pi = xmlDoc.firstChild;
						if (pi && pi.nodeType == 7 && pi.nodeName == "xml")
							pi = pi.nextSibling;
						if (pi && pi.nodeType == 7 && pi.nodeName == "xml-stylesheet") {
							stylesheet = pi.data;
							var k1 = stylesheet.indexOf("href=\"");
							var k2 = stylesheet.lastIndexOf("\"");
							stylesheet = stylesheet.substring(k1+6,k2);
						} else return;

						var xslDoc = LoadXML(stylesheet);
						var imp = xslDoc.documentElement.firstChild;
						while(imp && (imp.nodeName != "xsl:import" || imp.getAttribute("href") == "Web.xsl")) {
							imp = imp.nextSibling;
						}
						if (!imp) return;
						imp.setAttribute("href",file);

						Transform(xmlDoc,xslDoc);
					}
				]]>
			</script>
		</head>
		<body onload="Make(null,null);">
			<div>
				<xsl:apply-templates select="." mode="ViewContent"/>
			</div>
		</body>
	</html>
</xsl:template>

<!-- Default file content display. -->
<xsl:template match="/*" mode="ViewContent">
	<xsl:apply-templates select="." mode="ViewTitle">
		<xsl:with-param name="Title">
			<xsl:apply-templates select="." mode="Title"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<ul>
		<xsl:apply-templates select="@*[namespace-uri() != 'http://www.w3.org/2001/XMLSchema-instance']"/>
		<xsl:apply-templates select="." mode="ViewTable">
			<xsl:with-param name="Rows" select="*[local-name() = 'Label']"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="*[local-name() != 'Label']"/>
		<xsl:if test="text()">
			<li type="circle">
				<xsl:apply-templates select="." mode="Format"/>
			</li>
		</xsl:if>
	</ul>
</xsl:template>

<xsl:template match="*" mode="ViewLanguages">
	<div>
		<xsl:apply-templates select="." mode="Languages"/>
	</div>
</xsl:template>
<xsl:template match="*" mode="ViewLanguage">
	<xsl:param name="Lang"/>
	<xsl:param name="Stylesheet"/>
	<xsl:variable name="UILang">
		<xsl:apply-templates select="." mode="UILang"/>
	</xsl:variable>

	<xsl:for-each select="//*[e:Prefix/@External = 'lang']/*[@e:Name = $Lang or contains($Lang,'-') and @e:Name = substring-before($Lang,'-')][1]">
		<xsl:choose>
			<xsl:when test="$UILang = $Lang">
				<xsl:apply-templates select="." mode="Label"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="ViewLink">
					<xsl:with-param name="Link">
						<xsl:text>javascript:window.Make('</xsl:text>
						<xsl:value-of select="@e:Name"/>
						<xsl:text>','</xsl:text>
						<xsl:value-of select="$Stylesheet"/>
						<xsl:text>');</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="Text">
						<xsl:apply-templates select="." mode="Label"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
	</xsl:for-each>
</xsl:template>

<!-- Elements list display by name (Name) as table. -->
<xsl:template match="*" mode="ViewTable">
	<xsl:param name="Rows"/>
	<xsl:param name="Name">
		<xsl:apply-templates select="$Rows[1]" mode="Name"/>
	</xsl:param>

	<xsl:if test="$Rows">
		<li type="circle">
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
		</li>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
