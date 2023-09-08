<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:u="urn:local:util"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:import href="partials/page.xsl"/>

  <xsl:template match="*">
    <!-- show unmatched elements (for development/debugging) -->
    <xsl:message>
      <xsl:value-of select="name(.)"/>
    </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="t:div|t:p|t:code">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:hi[@rend='bold']">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="t:head">
    <xsl:element name="{'h' || count(ancestor::t:div)}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:ref">
    <xsl:call-template name="u:externalLink">
      <xsl:with-param name="href" select="@target"/>
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="t:graphic">
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:call-template name="page">
      <xsl:with-param name="doc_title" select="$project_short_title"/>
      <xsl:with-param name="content">
        <xsl:apply-templates select="t:TEI/t:text/t:body/t:div"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
