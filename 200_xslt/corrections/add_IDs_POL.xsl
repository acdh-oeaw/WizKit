<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.music-encoding.org/ns/mei"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
  <xsl:output encoding="UTF-8" indent="no"/>
  <xsl:preserve-space elements="*"/>

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <!--  PERSONS  -->
  <xsl:template match="m:li/m:persName">
    <xsl:choose>
      <xsl:when test="./@xml:id != ''">
        <xsl:copy>
          <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="persName">
          <xsl:attribute name="xml:id">
            <xsl:value-of select="generate-id()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:param name="Start">
    <xsl:variable name="body"
                  select="count(//m:li/m:persName[./m:identifier[@label='persons']!=''])"/>
    <xsl:variable name="max">
      <xsl:value-of select="//m:identifier[@label='persons'][not(following::m:identifier[@label='persons'] &gt; . or preceding::m:identifier[@label='persons'] &gt; .)]"/>
    </xsl:variable>
    <xsl:value-of select="$max - $body + 1"/>
  </xsl:param>

  <xsl:template match="m:identifier[@label = 'persons']">
    <xsl:choose>
      <xsl:when test=". != ''">
        <xsl:copy>
          <xsl:apply-templates select="text() | @*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="identifier">
          <xsl:attribute name="type">
            <xsl:text>register-ID</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="label">
            <xsl:text>persons</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="codedval">
            <xsl:number select="parent::node()" start-at="{$Start}" format="000000"/>
          </xsl:attribute>
          <xsl:number select="parent::node()" start-at="{$Start}" format="000000"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Add auth.uri -->
  <xsl:template match="m:identifier[@auth]">
    <xsl:element name="identifier">
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="@auth='GND'">
          <xsl:attribute name="auth.uri">
            <xsl:text>https://d-nb.info/gnd/</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@auth='VIAF'">
          <xsl:attribute name="auth.uri">
            <xsl:text>https://viaf.org/viaf/</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@auth='LCCN'">
          <xsl:attribute name="auth.uri">
            <xsl:text>https://lccn.loc.gov/</xsl:text>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  

  <!--  ORGANISATIONS  -->
  <xsl:template match="m:li/m:corpName">
    <xsl:choose>
      <xsl:when test="./@xml:id != ''">
        <xsl:copy>
          <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="corpName">
          <xsl:attribute name="xml:id">
            <xsl:value-of select="generate-id()"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:param name="start_org">
    <xsl:variable name="body"
                  select="count(//m:li/m:corpName[./m:identifier[@label='orgs']!=''])"/>
    <xsl:variable name="max">
      <xsl:value-of select="//m:identifier[@label='orgs'][not(following::m:identifier[@label='orgs'] &gt; . or preceding::m:identifier[@label='orgs'] &gt; .)]"/>
    </xsl:variable>
    <xsl:value-of select="$max - $body + 1"/>
  </xsl:param>

  <xsl:template match="m:identifier[@label = 'orgs']">
    <xsl:choose>
      <xsl:when test=". != ''">
        <xsl:copy>
          <xsl:apply-templates select="text() | @*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="identifier">
          <xsl:attribute name="type">
            <xsl:text>register-ID</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="label">
            <xsl:text>orgs</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="codedval">
            <xsl:number select="parent::node()" start-at="{$start_org}" format="000000"/>
          </xsl:attribute>
          <xsl:number select="parent::node()" start-at="{$start_org}" format="000000"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:message>
      <xsl:value-of select="$start_org"/>
    </xsl:message>
  </xsl:template>
</xsl:stylesheet>
