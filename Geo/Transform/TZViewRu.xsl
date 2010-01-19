<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tz="urn:geo-schemas-xml-frafv:timezone" xmlns:p="urn:geo-schemas-xml-frafv:proxy" exclude-result-prefixes="tz p">
<xsl:import href="TZViewEn.xsl"/>
<xsl:output encoding="UTF-16" indent="yes" method="html"/>
<xsl:template match="tz:TimeZoneList" mode="Title" priority="9">
	<xsl:text>Список часовых поясов</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZoneList" mode="Header">
	<h1 id="main">Список часовых поясов</h1>
	<p>Ниже представлен список часовых поясов из Microsoft Windows.</p>
</xsl:template>
<xsl:template match="tz:Info" mode="BiasLabel">
	<xsl:text>Разница с UTC (GMT)</xsl:text>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="LabelHeader">
	<tr>
		<th colspan="4">Названия на разных языках</th>
	</tr>
	<tr>
		<th>Язык</th>
		<th>Часовой пояс</th>
		<th>Летнее время</th>
		<th>Зимнее время</th>
	</tr>
</xsl:template>
<xsl:template match="tz:TimeZone" mode="Footer">
	<p>
		<a href="#main">Вверх</a>
		<xsl:text> </xsl:text>
		<a href="javascript:history.back();">Назад</a>
	</p>
</xsl:template>
<xsl:template match="tz:Date" mode="Label">
	<xsl:choose>
		<xsl:when test="@Type = 'Daylight'">Переход на летнее время</xsl:when>
		<xsl:when test="@Type = 'Standard'">Переход на зимнее время</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="*" mode="DateLabelNoDST">
	<li><b>Переход на летнее время: </b>
	<xsl:text>не происходит</xsl:text></li>
</xsl:template>
<xsl:template match="tz:Info" mode="Header">
	<xsl:if test="@Year">
		<b>Для <xsl:value-of select="@Year"/> года</b>
	</xsl:if>
</xsl:template>
<xsl:template match="tz:Date[@Time]">
	<li>
	<b><xsl:apply-templates select="." mode="Label"/>: </b>
	<xsl:if test="@Bias and @Time">
		<xsl:choose>
			<xsl:when test="@Bias = '-01:00:00'">прибавляется 1 час </xsl:when>
			<xsl:when test="@Bias = '01:00:00'">вычитается 1 час </xsl:when>
			<xsl:otherwise><xsl:value-of select="@Bias"/></xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="@Date and @Day">(</xsl:if>
	<xsl:choose>
		<xsl:when test="@Week = 'First'">
			<xsl:choose>
				<xsl:when test="@Day = 'Monday'">в первый понедельник </xsl:when>
				<xsl:when test="@Day = 'Tuesday'">в первый вторник </xsl:when>
				<xsl:when test="@Day = 'Wednesday'">в первую среду </xsl:when>
				<xsl:when test="@Day = 'Thursday'">в первый четверг </xsl:when>
				<xsl:when test="@Day = 'Friday'">в первую пятницу </xsl:when>
				<xsl:when test="@Day = 'Saturday'">в первую субботу </xsl:when>
				<xsl:when test="@Day = 'Sunday'">в первое воскресенье </xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@Week = 'Second'">
			<xsl:choose>
				<xsl:when test="@Day = 'Monday'">во второй понедельник </xsl:when>
				<xsl:when test="@Day = 'Tuesday'">во второй вторник </xsl:when>
				<xsl:when test="@Day = 'Wednesday'">во вторую среду </xsl:when>
				<xsl:when test="@Day = 'Thursday'">во второй четверг </xsl:when>
				<xsl:when test="@Day = 'Friday'">во вторую пятницу </xsl:when>
				<xsl:when test="@Day = 'Saturday'">во вторую субботу </xsl:when>
				<xsl:when test="@Day = 'Sunday'">во второе воскресенье </xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@Week = 'Third'">
			<xsl:choose>
				<xsl:when test="@Day = 'Monday'">в третий понедельник </xsl:when>
				<xsl:when test="@Day = 'Tuesday'">в третий вторник </xsl:when>
				<xsl:when test="@Day = 'Wednesday'">в третью среду </xsl:when>
				<xsl:when test="@Day = 'Thursday'">в третий четверг </xsl:when>
				<xsl:when test="@Day = 'Friday'">в третью пятницу </xsl:when>
				<xsl:when test="@Day = 'Saturday'">в третью субботу </xsl:when>
				<xsl:when test="@Day = 'Sunday'">в третье воскресенье </xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@Week = 'Fourth'">
			<xsl:choose>
				<xsl:when test="@Day = 'Monday'">в четвёртый понедельник </xsl:when>
				<xsl:when test="@Day = 'Tuesday'">в четвёртый вторник </xsl:when>
				<xsl:when test="@Day = 'Wednesday'">в четвёртую среду </xsl:when>
				<xsl:when test="@Day = 'Thursday'">в четвёртый четверг </xsl:when>
				<xsl:when test="@Day = 'Friday'">в четвёртую пятницу </xsl:when>
				<xsl:when test="@Day = 'Saturday'">в четвёртую субботу </xsl:when>
				<xsl:when test="@Day = 'Sunday'">в четвёртое воскресенье </xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="@Week = 'Last'">
			<xsl:choose>
				<xsl:when test="@Day = 'Monday'">в последний понедельник </xsl:when>
				<xsl:when test="@Day = 'Tuesday'">в последний вторник </xsl:when>
				<xsl:when test="@Day = 'Wednesday'">в последнюю среду </xsl:when>
				<xsl:when test="@Day = 'Thursday'">в последний четверг </xsl:when>
				<xsl:when test="@Day = 'Friday'">в последнюю пятницу </xsl:when>
				<xsl:when test="@Day = 'Saturday'">в последнюю субботу </xsl:when>
				<xsl:when test="@Day = 'Sunday'">в последнее воскресенье </xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>
	<xsl:if test="@Date">
		<xsl:if test="@Day">) </xsl:if>
		<xsl:if test="substring(@Date, 9, 1)!='0'"><xsl:value-of select="substring(@Date, 9, 1)"/></xsl:if>
		<xsl:value-of select="substring(@Date, 10, 1)"/>
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="@Month = 'January' or substring(@Date, 6, 2) = '01'">января</xsl:when>
		<xsl:when test="@Month = 'February' or substring(@Date, 6, 2) = '02'">февраля</xsl:when>
		<xsl:when test="@Month = 'March' or substring(@Date, 6, 2) = '03'">марта</xsl:when>
		<xsl:when test="@Month = 'April' or substring(@Date, 6, 2) = '04'">апреля</xsl:when>
		<xsl:when test="@Month = 'May' or substring(@Date, 6, 2) = '05'">мая</xsl:when>
		<xsl:when test="@Month = 'June' or substring(@Date, 6, 2) = '06'">июня</xsl:when>
		<xsl:when test="@Month = 'July' or substring(@Date, 6, 2) = '07'">июля</xsl:when>
		<xsl:when test="@Month = 'August' or substring(@Date, 6, 2) = '08'">августа</xsl:when>
		<xsl:when test="@Month = 'September' or substring(@Date, 6, 2) = '09'">сентября</xsl:when>
		<xsl:when test="@Month = 'October' or substring(@Date, 6, 2) = '10'">октября</xsl:when>
		<xsl:when test="@Month = 'November' or substring(@Date, 6, 2) = '11'">ноября</xsl:when>
		<xsl:when test="@Month = 'December' or substring(@Date, 6, 2) = '12'">декабря</xsl:when>
	</xsl:choose>
	<xsl:if test="not(parent::tz:Info/@Year) and @Date">
		 <xsl:text> </xsl:text>
		 <xsl:value-of select="substring(@Date, 1, 4)"/>
		 <xsl:text> г.</xsl:text>
	</xsl:if>
	<xsl:if test="@Time">
			<xsl:text> в </xsl:text>
			<xsl:if test="substring(@Time, 1, 1)!='0'"><xsl:value-of select="substring(@Time, 1, 1)"/></xsl:if>
			<xsl:value-of select="substring(@Time, 2, 4)"/>
			<xsl:if test="substring(@Time, 7, 2)!='00'"><xsl:value-of select="substring(@Time, 6, 3)"/></xsl:if>
	</xsl:if>
	</li>
</xsl:template>
<xsl:template match="*" mode="Label">
	<xsl:choose>
		<xsl:when test="(tz:Label|p:Label)[@xml:lang='ru' or @xml:lang='ru-RU']"><xsl:value-of select="(tz:Label|p:Label)[@xml:lang='ru' or @xml:lang='ru-RU'][1]"/></xsl:when>
		<xsl:otherwise><xsl:call-template name="LabelEnLang"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="p:Label">
	<xsl:choose>
		<xsl:when test="@xml:lang='ru' or @xml:lang='ru-RU'">
			<xsl:value-of select="."/>
		</xsl:when>
		<xsl:otherwise>
			<span>
				<xsl:attribute name="title">
					<xsl:apply-templates select="parent::p:Language" mode="Label"/>
				</xsl:attribute>
				<xsl:value-of select="."/>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
