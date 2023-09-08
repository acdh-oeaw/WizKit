<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.music-encoding.org/ns/mei"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
  <xsl:output encoding="UTF-8" indent="no"/>
  <xsl:preserve-space elements="*"/>

  <xsl:param name="worksDir" as="xs:string"/>

  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="m:seriesStmt/m:identifier[@type = 'file-collection' and text() = '000000']">
    <!-- ensure work id is present -->
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:number value="count(collection($worksDir || '?select=*.xml')/m:mei[//m:seriesStmt/m:identifier[@type = 'file-collection' and normalize-space(.) and number(.) &gt; 0]]) + 1" format="000000"/>
    </xsl:copy>
  </xsl:template>

  <xsl:variable name="Pers-doc"
                select="document('../../600_library/601_persons/persons.xml')"/>
  <xsl:key name="Pers-Key"
           match="m:persName[@xml:id]"
           use="m:persName[@type = 'main']"/>
  <xsl:variable name="Corp-doc"
                select="document('../../600_library/602_orgs/orgs.xml')"/>
  <xsl:key name="Corp-Key"
           match="m:corpName[@xml:id]"
           use="m:corpName[@type = 'main']"/>

  <!--Personenregisterabgleich-->
  <xsl:template match="m:persName">
    <xsl:choose>
      <xsl:when test=". != ''">
        <xsl:element name="persName">
          <xsl:copy-of select="@role | @type | @auth | @codedval | @xml:id"/>
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
              <xsl:otherwise>
                <xsl:copy-of select="@auth.uri"/>
              </xsl:otherwise>
            </xsl:choose>
          <xsl:choose>
            <xsl:when test="not(normalize-space(@corresp)) or @corresp='not_found'">
              <xsl:choose>
                <xsl:when test="key('Pers-Key', normalize-space(text()), $Pers-doc)">
                  <xsl:attribute name="corresp">
                    <xsl:value-of select="concat('P-', key('Pers-Key', normalize-space(text()), $Pers-doc)/m:identifier[@label = 'persons'])"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="corresp">
                    <xsl:text>not_found</xsl:text>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="corresp">
                <xsl:copy-of select="@corresp"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--Körperschaftenabgleich-->
  <xsl:template match="m:corpName">
    <xsl:choose>
      <xsl:when test=". != ''">
        <xsl:element name="corpName">
          <xsl:copy-of select="@role | @type | @auth | @codedval | @xml:id"/>
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
            <xsl:otherwise>
              <xsl:copy-of select="@auth.uri"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="not(normalize-space(@corresp)) or @corresp='not_found'">
              <xsl:choose>
                <xsl:when test="key('Corp-Key', normalize-space(text()), $Corp-doc)">
                  <xsl:attribute name="corresp">
                    <xsl:value-of select="concat('O-', key('Corp-Key', normalize-space(text()), $Corp-doc)/m:identifier[@label = 'orgs'])"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="corresp">
                    <xsl:text>not_found</xsl:text>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="@corresp"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
