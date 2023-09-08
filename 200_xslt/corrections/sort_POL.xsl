<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.music-encoding.org/ns/mei"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">
  <xsl:output indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="m:mei/m:music/m:body/m:div/m:list/m:li">
    <xsl:element name="li">
      <xsl:apply-templates>
        <xsl:sort/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
