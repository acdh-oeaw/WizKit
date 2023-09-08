<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:u="urn:local:util"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:import href="partials/page.xsl"/>
  <xsl:import href="partials/worksTable.xsl"/>
  <xsl:param name="worksDir" as="xs:string"/>
  
  <xsl:template match="m:mei/m:meiHead/m:fileDesc/m:titleStmt/m:respStmt/m:persName[@role='edt']">
    <xsl:choose>
      <xsl:when test="count(m:persName[@role='edt']) = 1">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:when test="count(m:persName[@role='edt']) = 2">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text> and </xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="position() != last() and position() != last()-1">
          <xsl:value-of select="."/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()-1">
          <xsl:value-of select="."/>
        </xsl:if>
        <xsl:if test="position() = last()">
          <xsl:text> and </xsl:text>
          <xsl:value-of select="."/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="m:persName|m:corpName" mode="page">
    <xsl:result-document href="{u:registerLink(.)}">
      <xsl:variable name="mainName"
                    as="xs:string"
                    select="(m:persName[@type='main'], m:corpName[@type='main'])[1]"/>
      <xsl:variable name="doc_title_3" select="ancestor::m:list/m:head || ' ' || $mainName"/>
      <xsl:call-template name="page">
        <xsl:with-param name="doc_title" select="$doc_title_3"/>
        <xsl:with-param name="content">
          <div class="card-header">
            <h1>
              <xsl:value-of select="$mainName"/>
            </h1>
          </div>
          <div class="card-body">
            <ul class="nav nav-tabs" id="myTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active"
                        id="home-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#home"
                        type="button"
                        role="tab"
                        aria-controls="home"
                        aria-selected="true">Core data</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="profile-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#profile"
                        type="button"
                        role="tab"
                        aria-controls="profile"
                        aria-selected="false">Authority data &amp; citation</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="contact-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#contact"
                        type="button"
                        role="tab"
                        aria-controls="contact"
                        aria-selected="false">References</button>
              </li>
            </ul>
            <div class="tab-content" id="myTabContent">
              <div class="tab-pane fade show active"
                   id="home"
                   role="tabpanel"
                   aria-labelledby="home-tab">
                <div class="ssSearchOn">
                  <xsl:call-template name="u:tableNoEmpty">
                    <xsl:with-param name="table" as="element(h:table)">
                      <table class="table table-kv">
                        <tr>
                          <th>Surname</th>
                          <td>
                            <xsl:value-of select="m:famName"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Forename</th>
                          <td>
                            <xsl:value-of select="m:foreName"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Name</th>
                          <td>
                            <xsl:value-of select="m:corpName[@type='main']"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Name (alternative)</th>
                          <td>
                            <xsl:sequence select="u:listShowMore(m:persName[@type='alternative'])"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Name (birth)</th>
                          <td>
                            <xsl:value-of select="m:persName[@type='birth']"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Pseudonym</th>
                          <td>
                            <xsl:value-of select="m:persName[@type='pseudonym']"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Date of birth</th>
                          <td>
                            <xsl:value-of select="m:date/m:date[@type='birth']/m:date"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Place of birth</th>
                          <td>
                            <xsl:value-of select="m:date/m:date[@type='birth']/m:geogName"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Date of death</th>
                          <td>
                            <xsl:value-of select="m:date/m:date[@type='death']/m:date"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Place of death</th>
                          <td>
                            <xsl:value-of select="m:date/m:date[@type='death']/m:geogName"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Role / position</th>
                          <td>
                            <xsl:sequence select="u:listSimple(m:catchwords/m:term)"/>
                          </td>
                        </tr>
                      </table>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="profile"
                   role="tabpanel"
                   aria-labelledby="profile-tab">
                <div class="ssSearchOn">
                  <table class="table">
                    <xsl:if test="m:identifier[@auth='GND']/text()">
                      <tr>
                        <th style="width:20%;">GND</th>
                        <td>
                          <xsl:call-template name="u:externalLink">
                            <xsl:with-param name="href"
                                            select="m:identifier[@auth='GND']/@auth.uri || m:identifier[@auth='GND']"/>
                            <xsl:with-param name="text" select="m:identifier[@auth='GND']"/>
                          </xsl:call-template>
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="m:identifier[@auth='VIAF']/text()">
                      <tr>
                        <th style="width:20%;">VIAF</th>
                        <td>
                          <xsl:call-template name="u:externalLink">
                            <xsl:with-param name="href"
                                            select="m:identifier[@auth='VIAF']/@auth.uri || m:identifier[@auth='VIAF']"/>
                            <xsl:with-param name="text" select="m:identifier[@auth='VIAF']"/>
                          </xsl:call-template>
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="m:identifier[@auth='LCCN']/text()">
                      <tr>
                        <th style="width:20%;">LCCN</th>
                        <td>
                          <xsl:call-template name="u:externalLink">
                            <xsl:with-param name="href"
                                            select="m:identifier[@auth='LCCN']/@auth.uri || m:identifier[@auth='LCCN']"/>
                            <xsl:with-param name="text" select="m:identifier[@auth='LCCN']"/>
                          </xsl:call-template>
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="string-length(m:ptr[@label='OeML']/@target) &gt; 1 or string-length(m:ptr[@label='OeBL']/@target) &gt; 1 or string-length(m:ptr[@label='BMLO']/@target) &gt; 1 or string-length(m:ptr[@label='ABLO']/@target) &gt; 1">
                      <tr>
                        <th>Links</th>
                        <td>
                          <ul style="padding:0;margin-bottom:0;">
                            <xsl:if test="string-length(m:ptr[@label='OeML']/@target) &gt; 1 and not(starts-with(m:ptr[@label='OeML']/@target, '#'))">
                              <li style="margin-top:0;margin-bottom:.2em;">
                                <xsl:call-template name="u:externalLink">
                                  <xsl:with-param name="href" select="m:ptr[@label='OeML']/@target"/>
                                  <xsl:with-param name="text">OeML</xsl:with-param>
                                </xsl:call-template>
                              </li>
                            </xsl:if>
                            <xsl:if test="string-length(m:ptr[@label='OeBL']/@target) &gt; 1 and not(starts-with(m:ptr[@label='OeBL']/@target, '#'))">
                              <li style="margin-top:0;margin-bottom:.2em;">
                                <xsl:call-template name="u:externalLink">
                                  <xsl:with-param name="href" select="m:ptr[@label='OeBL']/@target"/>
                                  <xsl:with-param name="text">OeBL</xsl:with-param>
                                </xsl:call-template>
                              </li>
                            </xsl:if>
                            <xsl:if test="string-length(m:ptr[@label='BMLO']/@target) &gt; 1 and not(starts-with(m:ptr[@label='BMLO']/@target, '#'))">
                              <li style="margin-top:0;margin-bottom:.2em;">
                                <xsl:call-template name="u:externalLink">
                                  <xsl:with-param name="href" select="m:ptr[@label='BMLO']/@target"/>
                                  <xsl:with-param name="text">BMLO</xsl:with-param>
                                </xsl:call-template>
                              </li>
                            </xsl:if>
                            <xsl:if test="string-length(m:ptr[@label='ABLO']/@target) &gt; 1 and not(starts-with(m:ptr[@label='ABLO']/@target, '#'))">
                              <li style="margin-top:0;margin-bottom:.2em;">
                                <xsl:call-template name="u:externalLink">
                                  <xsl:with-param name="href" select="m:ptr[@label='ABLO']/@target"/>
                                  <xsl:with-param name="text">ABLO</xsl:with-param>
                                </xsl:call-template>
                              </li>
                            </xsl:if>
                            <xsl:if test="m:annot[@label='Kurzbiographie']/m:p/@ref">
                              <xsl:for-each select="m:annot[@label='Kurzbiographie']/m:p/@ref">
                                <li style="margin-top:0;margin-bottom:.2em;">
                                  <a title="Kurzbiographie" href="{.}">
                                    <xsl:value-of select="concat('Kurzbiographie', ' Link ', position())"/>
                                  </a>
                                </li>
                              </xsl:for-each>
                            </xsl:if>
                          </ul>
                        </td>
                      </tr>
                    </xsl:if>
                    <tr>
                      <th style="width:20%;">Recommended citation</th>
                      <td>
                        <cite>
                          <xsl:value-of select="$mainName"/>
                        </cite>
                        <xsl:text> [register data record], in: WizKIT, ed. by</xsl:text>
                        <xsl:apply-templates select="ancestor::m:mei/m:meiHead/m:fileDesc/m:titleStmt/m:respStmt/m:persName[@role='edt']"/>
                        <xsl:text>, requested on </xsl:text>
                        <script>document.write(new Date().toISOString().substring(0, 10));</script>
                        <xsl:text> </xsl:text>
                        <xsl:variable name="persLink" select="'#'"/>
                        <xsl:element name="a">
                          <xsl:attribute name="href">
                            <xsl:value-of select="$persLink"/>
                          </xsl:attribute>
                          <xsl:attribute name="target">
                            <xsl:text>_blank</xsl:text>
                          </xsl:attribute>
                          <xsl:value-of select="$persLink"/>
                          <xsl:text>.</xsl:text>
                        </xsl:element>
                      </td>
                    </tr>
                  </table>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="contact"
                   role="tabpanel"
                   aria-labelledby="contact-tab">
                <xsl:call-template name="worksTable">
                  <xsl:with-param name="registerRef" select="u:registerRef(.)"/>
                </xsl:call-template>
              </div>
            </div>
          </div>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>
  
  
  

  <xsl:template match="m:persName" mode="table">
    <xsl:variable name="id"
                  as="xs:string"
                  select="m:identifier[@label='Register-ID']/@codedval"/>
    <tr>
      <td>
        <xsl:for-each select="m:persName[@type='main']">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </td>
      <td>
        <xsl:text>(</xsl:text>
        <xsl:choose>
          <xsl:when test="m:date/m:date[@type='birth']/m:date/@isodate !=''">
            <xsl:value-of select="substring(m:date/m:date[@type='birth']/m:date/@isodate, 1, 4)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>?</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>–</xsl:text>
        <xsl:choose>
          <xsl:when test="m:date/m:date[@type='death']/m:date/@isodate !=''">
            <xsl:value-of select="substring(m:date/m:date[@type='death']/m:date/@isodate, 1, 4)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>?</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
      </td>
      <td>
        <xsl:for-each select="m:catchwords">
          <xsl:variable name="count-terms" select="count(m:term)"/>
          <ul>
            <xsl:for-each select="m:term">
              <xsl:choose>
                <xsl:when test="$count-terms &gt; 1">
                  <li style="margin-bottom:.3em;">
                    <xsl:value-of select="."/>
                  </li>
                </xsl:when>
                <xsl:otherwise>
                  <li>
                    <xsl:value-of select="."/>
                  </li>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </ul>
        </xsl:for-each>
      </td>
      <td>
        <a href="{u:registerLink(.)}" title="{m:persName[@type='main']}">
          <xsl:call-template name="u:arrowRight"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="m:corpName" mode="table">
    <tr>
      <td>
        <xsl:value-of select="m:corpName[@type='main']"/>
      </td>
      <td>-</td>
      <td>-</td>
      <td>
        <a href="{u:registerLink(.)}" title="{m:corpName[@type='main']}">
          <xsl:call-template name="u:arrowRight"/>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="m:li[local-name(*[1]) = 'persName']">
    <table id="registerTable" class="table table-striped display">
      <thead>
        <tr>
          <th>Name</th>
          <th>Lebensdaten</th>
          <th>Funktion / Rolle</th>
          <th>Details</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="m:persName" mode="table"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="m:li[local-name(*[1]) = 'corpName']">
    <table id="registerTable" class="table table-striped display">
      <thead>
        <tr>
          <th>Name</th>
          <th>Place</th>
          <th>Description</th>
          <th>Details</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="m:corpName" mode="table"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="/">
    <xsl:variable name="title"
                  as="xs:string"
                  select="/m:mei/m:music/m:body/m:div/m:list/m:head"/>
    <xsl:call-template name="page">
      <xsl:with-param name="doc_title" select="$title"/>
      <xsl:with-param name="content">
        <h1>
          <xsl:value-of select="$title"/>
        </h1>
        <div>
          <xsl:apply-templates select="/m:mei/m:music/m:body/m:div/m:list/m:li"/>
        </div>
        <script>
          $(document).ready(function () {
            new DataTable('#registerTable');
          });
        </script>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="/m:mei/m:music/m:body/m:div/m:list/m:li/*" mode="page"/>
  </xsl:template>
</xsl:stylesheet>
