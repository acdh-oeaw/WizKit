<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                exclude-result-prefixes="xs"
                version="2.0">
  <xsl:param name="documentSystemID" as="xs:string"/>
  <xsl:param name="contextElementXPathExpression" as="xs:string"/>

  <xsl:template name="start">
    <xsl:apply-templates select="doc($documentSystemID)"/>
  </xsl:template>

  <xsl:template match="/">
    <xsl:variable name="propertyElement"
                  select="saxon:eval(saxon:expression($contextElementXPathExpression, ./*))"/>
    <items action="replace">
      <xsl:for-each select="document('../../600_library/602_orgs/orgs.xml')//m:li/m:corpName">
        <xsl:if test="$propertyElement[not(normalize-space(@corresp))]">
          <item value="{normalize-space(m:corpName[@type='main'])}"/>
        </xsl:if>
      </xsl:for-each>
    </items>
  </xsl:template>
</xsl:stylesheet>
