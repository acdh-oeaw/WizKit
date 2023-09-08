<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:u="urn:local:util"
                xmlns:v="urn:local:vocab"
                xmlns:l="urn:local"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:import href="../vocabulary/relators.xsl"/>

  <xsl:param name="worksDir" as="xs:string"/>

  <xsl:function name="l:getRoles" as="xs:string*">
    <xsl:param name="occs" as="element()*"/>
    <xsl:variable name="allResults" as="xs:string*">
      <xsl:for-each select="$occs">
        <xsl:choose>
          <xsl:when test="normalize-space(@role)">
            <xsl:value-of select="($v:relators(@role), @role)[1]"/>
          </xsl:when>
          <xsl:when test="parent::m:publisher">
            <xsl:value-of select="$v:relators('pbl')"/>
          </xsl:when>
          <!-- <xsl:when test="parent::m:hand"> -->
          <!--   <xsl:value-of select="$v:relators('scr')"/> -->
          <!-- </xsl:when> -->
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="sort(distinct-values($allResults))"/>
  </xsl:function>

  <xsl:template match="m:work" mode="worksTable">
    <xsl:param name="registerRef" as="xs:string?"/>
    <tr>
      <td>
        <xsl:value-of select="m:contributor/m:persName[@role='cmp']"/>
      </td>
      <td>
        <xsl:value-of select="m:title"/>
      </td>
      <td>
        <xsl:value-of select="m:identifier[@label=('Opuszahl', 'opus')]"/>
      </td>
      <xsl:if test="$registerRef">
        <td>
          <xsl:value-of select="l:getRoles(ancestor::m:meiHead//*[@corresp = $registerRef])"
                        separator=", "/>
        </td>
      </xsl:if>
      <td>
        <a href="{u:workLink(.)}" title="'Details'">
          <xsl:call-template name="u:arrowRight"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="worksTable">
    <xsl:param name="registerRef" as="xs:string?"/>
    <xsl:variable name="works" as="element(m:work)*">
      <xsl:choose>
        <xsl:when test="$registerRef">
          <xsl:sequence select="collection($worksDir || '?select=*.xml')/m:mei/m:meiHead/m:workList/m:work[ancestor::m:meiHead//*[@corresp = $registerRef]]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="collection($worksDir || '?select=*.xml')/m:mei/m:meiHead/m:workList/m:work"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div>
      <table id="worksTable" class="table table-striped display">
        <thead>
          <tr>
            <th>Composer</th>
            <th>Title</th>
            <th>Opus</th>
            <xsl:if test="$registerRef">
              <th>Role(s)</th>
            </xsl:if>
            <th>Details</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="$works" mode="worksTable">
            <xsl:with-param name="registerRef" select="$registerRef"/>
          </xsl:apply-templates>
        </tbody>
      </table>
    </div>
    <script>
      $(document).ready(function () {
        new DataTable('#worksTable');
      });
    </script>
  </xsl:template>
</xsl:stylesheet>
