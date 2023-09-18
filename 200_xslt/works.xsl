<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:u="urn:local:util"
                xmlns:v="urn:local:vocab"
                xmlns:l="urn:local"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:import href="partials/page.xsl"/>
  <xsl:import href="partials/worksTable.xsl"/>
  <xsl:import href="vocabulary/marcmusperf.xsl"/>
  <xsl:param name="worksDir" as="xs:string"/>

  <xsl:template match="m:incip/m:score">
    <!-- verovio rendering, adapted from dcm catalog ui -->
    <xsl:variable name="dataID" select="'vrv-incip_' || generate-id() || '_xml'"/>
    <!-- this logic replicated in verovio.js -->
    <xsl:variable name="renderID" select="replace($dataID, '_xml$', '_svg')"/>
    <h6 style="width:20%; font-variant: small-caps; font-weight: normal; margin-left:0.5rem;">Incipit</h6>
    <div id="{$renderID}"/>
    <script id="{$dataID}" type="text/xmldata">
      <mei xmlns="http://www.music-encoding.org/ns/mei"
           meiversion="{(ancestor::m:mei/@meiversion, '4.0.0')[1]}">
        <meiHead/>
        <music>
          <body>
            <mdiv>
              <xsl:copy-of select="."/>
            </mdiv>
          </body>
        </music>
      </mei>
    </script>
  </xsl:template>

  <xsl:template match="m:persName|m:corpName">
    <xsl:param name="showRole" as="xs:boolean" select="true()"/>
    <xsl:variable name="fromRegister" as="element()?" select="u:findInRegister(.)"/>
    <xsl:choose>
      <xsl:when test="$fromRegister">
        <a href="{u:registerLink($fromRegister)}">
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$showRole and normalize-space(@role)">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$v:relators(@role)"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

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

  <xsl:template match="m:eventList[@type = 'performances']">
    <xsl:call-template name="u:accordions">
      <xsl:with-param name="accordionItems" as="element(u:accordionItem)*">
        <xsl:for-each select="m:event">
          <u:accordionItem>
            <xsl:attribute name="headerText">
              <xsl:value-of select="concat(format-date(m:date/@isodate, '[Y], [MNn] [D1o]', 'en', (), ()), ' – ', m:geogName[@role='place'])"/>
              <!--<xsl:value-of select="(m:date,m:geogName)[normalize-space(.)]" separator=", "/>-->
            </xsl:attribute>
            <xsl:call-template name="u:tableNoEmpty">
              <xsl:with-param name="table" as="element(h:table)">
                <table class="table table-kv">
                  <tr>
                    <th>Date</th>
                    <td>
                      <xsl:value-of select="m:date"/>
                    </td>
                  </tr>
                  <tr>
                    <th>Place / Venue</th>
                    <td>
                      <xsl:sequence select="u:applySepNoEmpty(m:geogName)"/>
                    </td>
                  </tr>
                  <tr>
                    <th>Contributor(s)</th>
                    <td>
                      <xsl:sequence select="u:applySepNoEmpty(m:persName)"/>
                    </td>
                  </tr>
                  <tr>
                    <th>Ensemble(s)</th>
                    <td>
                      <xsl:sequence select="u:applySepNoEmpty(m:corpName)"/>
                    </td>
                  </tr>
                  <tr>
                    <th>Comment</th>
                    <td>
                      <xsl:value-of select="m:desc"/>
                    </td>
                  </tr>
                </table>
              </xsl:with-param>
            </xsl:call-template>
          </u:accordionItem>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="m:eventList[@type != 'performances']">
    <xsl:variable name="hasPlace"
                  as="xs:boolean"
                  select="boolean(m:event/m:geogName[normalize-space(.)])"/>
    <xsl:variable name="hasContributors"
                  as="xs:boolean"
                  select="boolean(m:event/(m:persName[normalize-space(.)]|m:corpName[normalize-space(.)]))"/>
    <table class="table table-hover t20">
      <thead>
        <tr>
          <th>Date</th>
          <xsl:if test="$hasPlace">
            <th>Place</th>
          </xsl:if>
          <xsl:if test="$hasContributors">
            <th>Contributors</th>
          </xsl:if>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="m:event">
          <tr>
            <td>
              <xsl:value-of select="m:date"/>
            </td>
            <xsl:if test="$hasPlace">
              <td>
                <xsl:value-of select="m:geogName" separator=", "/>
              </td>
            </xsl:if>
            <xsl:if test="$hasContributors">
              <xsl:apply-templates select="m:persName|m:corpName"/>
            </xsl:if>
            <td>
              <xsl:apply-templates select="m:desc"/>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="m:perfRes">
    <xsl:variable name="moreThanOne" as="xs:boolean" select="number(@count) &gt; 1"/>
    <xsl:if test="$moreThanOne">
      <xsl:value-of select="@count"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="m:hand">
    <xsl:if test="m:persName !=''">
      <span>
        <xsl:apply-templates select="m:persName|m:corpName">
          <xsl:with-param name="showRole" select="false()"/>
        </xsl:apply-templates>
        <xsl:text> (</xsl:text>
        <xsl:choose>
          <xsl:when test="@type='main'">
            <xsl:text>main scribe of the source in </xsl:text>
            <xsl:value-of select="@medium"/>
          </xsl:when>
          <xsl:when test="@type='minor'">
            <xsl:text>minor additions in </xsl:text>
            <xsl:value-of select="@medium"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>additions in </xsl:text>
            <xsl:value-of select="@medium"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
        <xsl:if test="position() != last()">
          <xsl:text>; </xsl:text>
        </xsl:if>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="m:perfResList[normalize-space(@corresp)]">
    <xsl:apply-templates select="id(substring-after(@corresp, '#'))"/>
  </xsl:template>

  <xsl:template match="m:perfResList">
    <xsl:variable name="hasHead"
                  as="xs:boolean"
                  select="boolean(normalize-space(m:head))"/>
    <span>
      <xsl:if test="$hasHead">
        <strong>
          <xsl:value-of select="m:head"/>
        </strong>
        <xsl:text> (</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="m:perfRes"/>
      <xsl:if test="$hasHead">
        <xsl:text>)</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="m:castList">
    <span>
      <strong>Cast</strong>
      <xsl:apply-templates select="m:castItem"/>
    </span>
  </xsl:template>

  <xsl:template match="m:castItem">
    <xsl:value-of select="m:role"/>
    <xsl:if test="m:roleDesc !=''">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="m:roleDesc"/>
    </xsl:if>
    <xsl:if test="m:perfRes/@codedval !=''">
      <xsl:text> (</xsl:text>
      <xsl:variable name="mmp"
                    select="($v:marcmusperf(m:perfRes/@codedval), m:perfRes/@codedval) [1]"/>
      <xsl:value-of select="if(contains($mmp, ' - ')) then substring-after($mmp, ' - ') else $mmp"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="position() != last()">
      <xsl:text>; </xsl:text>
    </xsl:if>
    <xsl:if test="position() = last()">
      <xsl:text>.</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="m:identifier">
    <xsl:value-of select="@label"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="m:key" as="xs:string">
    <xsl:value-of>
      <xsl:value-of select="upper-case(@pname)"/>
      <xsl:value-of select="translate(@accid, 'sfn', '♯♭')"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@mode"/>
    </xsl:value-of>
  </xsl:template>

  <xsl:template match="m:meter" as="xs:string">
    <xsl:value-of>
      <xsl:value-of select="@count"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@unit"/>
    </xsl:value-of>
  </xsl:template>

  <xsl:function name="l:isTopLevel" as="xs:boolean">
    <xsl:param name="e" as="element()"/>
    <xsl:sequence select="count($e/ancestor-or-self::m:componentList) &lt;= 1"/>
  </xsl:function>

  <xsl:template match="m:componentList[l:isTopLevel(.)]">
    <xsl:call-template name="u:accordions">
      <xsl:with-param name="accordionItems" as="element(u:accordionItem)*">
        <xsl:apply-templates select="m:expression"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="m:componentList/m:expression[l:isTopLevel(.)]">
    <u:accordionItem headerText="{m:title}">
      <xsl:call-template name="u:tableNoEmpty">
        <xsl:with-param name="table" as="element(h:table)">
          <table class="table table-kv">
            <tr>
              <th>Instrumentation</th>
              <td>
                <xsl:apply-templates select="m:perfMedium/m:perfResList"/>
              </td>
            </tr>
            <tr>
              <th>Tempo</th>
              <td>
                <xsl:value-of select="m:tempo"/>
              </td>
            </tr>
            <tr>
              <th>Meter</th>
              <td>
                <xsl:apply-templates select="m:meter"/>
              </td>
            </tr>
            <tr>
              <th>Key</th>
              <td>
                <xsl:apply-templates select="m:key"/>
              </td>
            </tr>
            <tr>
              <th>Textincipit</th>
              <td>
                <xsl:value-of select="m:incip/m:incipText"/>
              </td>
            </tr>
            <tr>
              <th>Parts</th>
              <td>
                <xsl:apply-templates select="m:componentList"/>
              </td>
            </tr>
          </table>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="m:incip/m:score[*]"/>
    </u:accordionItem>
  </xsl:template>

  <xsl:template match="m:componentList[not(l:isTopLevel(.))]">
    <ul class="list-componentlist">
      <xsl:apply-templates select="m:expression"/>
    </ul>
  </xsl:template>

  <xsl:template match="m:componentList/m:expression[not(l:isTopLevel(.))]">
    <li>
      <span>
        <xsl:value-of select="m:title"/>
        <xsl:variable name="moreInfo"
                      as="element()*"
                      select="(m:tempo[not(contains(current()/m:title/text(), text()))], m:key)"/>
        <xsl:if test="$moreInfo">
          <xsl:text> (</xsl:text>
          <xsl:sequence select="u:applySepNoEmpty($moreInfo)"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </span>
      <xsl:apply-templates select="m:componentList"/>
    </li>
  </xsl:template>

  <xsl:template match="m:work" mode="page">
    <xsl:result-document href="{u:workLink(.)}">
      <xsl:variable name="title" as="xs:string" select="m:title"/>
      <xsl:call-template name="page">
        <xsl:with-param name="doc_title" select="$title"/>
        <xsl:with-param name="addHead">
          <xsl:if test="//m:incip/m:score[*]">
            <script src="dist/verovio/verovio-toolkit-wasm.js"/>
            <script src="js/verovio.js"/>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="content">
          <div class="card-header">
            <h1>
              <xsl:value-of select="$title"/>
            </h1>
          </div>
          <div class="card-body">
            <ul class="nav nav-tabs" id="workTab" role="tablist">
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
                        id="parts-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#parts"
                        type="button"
                        role="tab"
                        aria-controls="parts"
                        aria-selected="true">Parts</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="genesis-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#genesis"
                        type="button"
                        role="tab"
                        aria-controls="genesis"
                        aria-selected="false">Work genesis</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="sources-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#sources"
                        type="button"
                        role="tab"
                        aria-controls="sources"
                        aria-selected="false">Sources</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="performances-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#performances"
                        type="button"
                        role="tab"
                        aria-controls="performances"
                        aria-selected="false">Performances</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link"
                        id="citation-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#citation"
                        type="button"
                        role="tab"
                        aria-controls="citation"
                        aria-selected="false">Authority data &amp; citation</button>
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
                          <th>Work number(s)</th>
                          <td>
                            <xsl:sequence select="u:applySepNoEmpty(m:identifier)"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Composer(s)</th>
                          <td>
                            <xsl:sequence select="u:applySepNoEmpty(m:contributor/m:persName[@role='cmp'])"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Contributor(s)</th>
                          <td>
                            <xsl:sequence select="u:applySepNoEmpty(m:contributor/m:persName[@role!='cmp'])"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Creation</th>
                          <td>
                            <xsl:value-of select="m:creation/m:date"/>
                          </td>
                        </tr>
                        <xsl:variable name="perfMediumContent" as="element(h:span)*">
                          <xsl:apply-templates select="m:perfMedium//m:perfResList[m:perfRes]"/>
                          <xsl:apply-templates select="m:perfMedium//m:castList[m:castItem]"/>
                        </xsl:variable>
                        <tr>
                          <th>Instrumentation</th>
                          <td>
                            <xsl:sequence select="u:listSimple($perfMediumContent)"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Key</th>
                          <td>
                            <xsl:apply-templates select="m:key"/>
                          </td>
                        </tr>
                        <tr>
                          <th>Tempo</th>
                          <td>
                            <xsl:value-of select="m:tempo"/>
                          </td>
                        </tr>
                        <!--Vielleicht lieber kombiniert mit Notenincipit in einer Klappbox-->
                        <tr>
                          <th>Textincipit</th>
                          <td>
                            <xsl:value-of select="m:incip/m:incipText"/>
                          </td>
                        </tr>
                      </table>
                    </xsl:with-param>
                  </xsl:call-template>
                  <xsl:apply-templates select="m:incip/m:score[*]"/>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="parts"
                   role="tabpanel"
                   aria-labelledby="parts-tab">
                <div class="ssSearchOn">
                  <xsl:apply-templates select="m:expressionList/m:expression/m:componentList"/>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="genesis"
                   role="tabpanel"
                   aria-labelledby="genesis-tab">
                <div class="ssSearchOn">
                  <xsl:apply-templates select="m:history/m:eventList[@type='composition']"/>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="sources"
                   role="tabpanel"
                   aria-labelledby="sources-tab">
                <div class="ssSearchOn">
                  <xsl:call-template name="u:accordions">
                    <xsl:with-param name="accordionItems" as="element(u:accordionItem)*">
                      <u:accordionItem headerText="Manuscript sources">
                        <ul style="padding: 0; margin: 0;">
                          <xsl:for-each select="ancestor::m:meiHead/m:manifestationList/m:manifestation[@singleton='true']">
                            <li style="margin: 0; background-color: aliceblue;">
                              <h6 class="ms-head">
                                <xsl:value-of select="m:titleStmt/m:title"/>
                              </h6>
                              <div class="ssSearchOn">
                                <xsl:call-template name="u:tableNoEmpty">
                                  <xsl:with-param name="table" as="element(h:table)">
                                    <table class="table table-kv">
                                      <tr>
                                        <th>Medium</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:physMedium"/>
                                        </td>
                                      </tr>
                                      <!--Ab hier hätte ich gern das der rest versteckt ist wie bei alternative Namen-->
                                      <tr>
                                        <th>Cover</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='cover']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Main title page</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='main']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Single title</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='single']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Head title</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='head']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Date / Creation</th>
                                        <td>
                                          <xsl:choose>
                                            <xsl:when test="m:physDesc/m:addDesc/m:annot[@label='dating']!=''">
                                              <i>
                                                <xsl:value-of select="m:physDesc/m:addDesc/m:annot[@label='dating']"/>
                                              </i>
                                            </xsl:when>
                                            <xsl:otherwise>
                                              <xsl:value-of select="m:creation/m:date"/>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Condition</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:condition"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Annotation(s)</th>
                                        <td>
                                          <xsl:variable name="concat-annot">
                                            <xsl:apply-templates select="m:physDesc/m:addDesc/m:annot[@label!='dating']"/>
                                          </xsl:variable>
                                          <xsl:sequence select="u:listSimple($concat-annot)"/>
                                        </td>
                                      </tr>
                                      <xsl:variable name="concat-scribe">
                                        <xsl:apply-templates select="m:physDesc/m:handList/m:hand"/>
                                      </xsl:variable>
                                      <tr>
                                        <th>Scribe(s)</th>
                                        <td>
                                          <xsl:sequence select="u:listSimple($concat-scribe)"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Foliation</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:supportDesc/m:foliation"/>
                                        </td>
                                      </tr>
                                      <xsl:variable name="provenance">
                                        <ul style="padding: 0; margin: 0;">
                                          <li style="margin: 0;">
                                            <div class="ssSearchOn">
                                              <span class="label-inline">Location:</span>
                                              <xsl:if test="m:physLoc/m:repository/m:geogName">
                                                <xsl:value-of select="m:physLoc/m:repository/m:geogName"/>
                                                <xsl:text>, </xsl:text>
                                              </xsl:if>
                                              <xsl:if test="m:physLoc/m:repository/m:corpName">
                                                <xsl:value-of select="m:physLoc/m:repository/m:corpName"/>
                                                <xsl:text> </xsl:text>
                                              </xsl:if>
                                              <xsl:if test="m:physLoc/m:repository/m:identifier[@auth='RISM']">
                                                <xsl:text>(</xsl:text>
                                                <xsl:call-template name="u:externalLink">
                                                  <xsl:with-param name="href"
                                                                  select="'https://opac.rism.info/search?id=' || m:physLoc/m:repository/m:identifier/@codedval"/>
                                                  <xsl:with-param name="text" select="m:physLoc/m:repository/m:identifier[@auth='RISM']"/>
                                                </xsl:call-template>
                                                <xsl:text>)</xsl:text>
                                              </xsl:if>
                                              <xsl:if test="position()=last()">
                                                <xsl:text>.</xsl:text>
                                              </xsl:if>
                                            </div>
                                          </li>
                                          <li>
                                            <div class="ssSearchOn">
                                              <span class="label-inline">Shelf mark:</span>
                                              <xsl:if test="m:physLoc/m:identifier[@label='shelf_mark']">
                                                <xsl:value-of select="m:physLoc/m:identifier[@label='shelf_mark']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:if test="m:physLoc/m:repository/m:ptr[@label='catalog']">
                                                  <xsl:text>(</xsl:text>
                                                  <xsl:call-template name="u:externalLink">
                                                    <xsl:with-param name="href"
                                                                    select="m:physLoc/m:repository/m:ptr[@label='catalog']/@target"/>
                                                    <xsl:with-param name="text">Catalog</xsl:with-param>
                                                  </xsl:call-template>
                                                  <xsl:text>)</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="position()=last()">
                                                  <xsl:text>.</xsl:text>
                                                </xsl:if>
                                              </xsl:if>
                                            </div>
                                          </li>
                                          <li>
                                            <div class="ssSearchOn">
                                              <span class="label-inline">Digital reproduction:</span>
                                              <xsl:choose>
                                                <xsl:when test="m:physLoc/m:repository/m:ptr[@label='digital_image']">
                                                  <xsl:call-template name="u:externalLink">
                                                    <xsl:with-param name="href"
                                                                    select="m:physLoc/m:repository/m:ptr[@label='digital_image']/@target"/>
                                                    <xsl:with-param name="text">View online</xsl:with-param>
                                                  </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>-</xsl:otherwise>
                                              </xsl:choose>
                                            </div>
                                          </li>
                                        </ul>
                                      </xsl:variable>
                                      <xsl:if test="m:physLoc/m:repository/m:corpName!=''">
                                        <tr>
                                          <th>Provenance</th>
                                          <td>
                                            <xsl:sequence select="$provenance"/>
                                          </td>
                                        </tr>
                                      </xsl:if>
                                    </table>
                                  </xsl:with-param>
                                </xsl:call-template>
                              </div>
                            </li>
                          </xsl:for-each>
                        </ul>
                      </u:accordionItem>
                      <u:accordionItem headerText="Printed sources">
                        <ul style="padding: 0; margin: 0;">
                          <xsl:for-each select="ancestor::m:meiHead/m:manifestationList/m:manifestation[@singleton!='true']">
                            <li style="margin: 0; background-color: aliceblue;">
                              <h6 class="ms-head">
                                <xsl:value-of select="m:titleStmt/m:title"/>
                              </h6>
                              <div class="ssSearchOn">
                                <xsl:call-template name="u:tableNoEmpty">
                                  <xsl:with-param name="table" as="element(h:table)">
                                    <table class="table table-kv">
                                      <!--Irgendwo muss es eingeklappt werden-->
                                      <tr>
                                        <th>Cover</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='cover']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Main title page</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='main']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Single title</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='single']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Head title</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:titlePage[@label='head']"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Medium</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:physMedium"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Publisher</th>
                                        <td>
                                          <xsl:value-of select="m:pubStmt/m:publisher/m:corpName"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Plate number</th>
                                        <td>
                                          <xsl:value-of select="m:physDesc/m:plateNum"/>
                                        </td>
                                      </tr>
                                      <tr>
                                        <th>Publication</th>
                                        <td>
                                          <xsl:if test="m:pubStmt/m:pubPlace">
                                            <xsl:value-of select="m:pubStmt/m:pubPlace"/>
                                            <xsl:text>: </xsl:text>
                                          </xsl:if>
                                          <xsl:choose>
                                            <xsl:when test="m:pubStmt/m:date">
                                              <xsl:value-of select="m:pubStmt/m:date"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                              <xsl:text>[unknown]</xsl:text>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                          <xsl:if test="position() = last()">
                                            <xsl:text>.</xsl:text>
                                          </xsl:if>
                                        </td>
                                      </tr>
                                      <xsl:variable name="provenance_print">
                                        <ul style="padding: 0; margin: 0;">
                                          <xsl:for-each select="m:itemList/m:item">
                                            <li style="margin: 0;">
                                              <div class="ssSearchOn">
                                                <span class="label-inline">Location:</span>
                                                <xsl:if test="m:physLoc/m:repository/m:geogName">
                                                  <xsl:value-of select="m:physLoc/m:repository/m:geogName"/>
                                                  <xsl:text>, </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="m:physLoc/m:repository/m:corpName">
                                                  <xsl:value-of select="m:physLoc/m:repository/m:corpName"/>
                                                  <xsl:text> </xsl:text>
                                                </xsl:if>
                                                <xsl:if test="m:physLoc/m:repository/m:identifier[@auth='RISM']">
                                                  <xsl:text>(</xsl:text>
                                                  <xsl:call-template name="u:externalLink">
                                                    <xsl:with-param name="href"
                                                                    select="'https://opac.rism.info/search?id=' || m:physLoc/m:repository/m:identifier/@codedval"/>
                                                    <xsl:with-param name="text" select="m:physLoc/m:repository/m:identifier[@auth='RISM']"/>
                                                  </xsl:call-template>
                                                  <xsl:text>)</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="position()=last()">
                                                  <xsl:text>.</xsl:text>
                                                </xsl:if>
                                              </div>
                                            </li>
                                            <li>
                                              <div class="ssSearchOn">
                                                <span class="label-inline">Shelf mark:</span>
                                                <xsl:if test="m:physLoc/m:identifier[@label='shelf_mark']">
                                                  <xsl:value-of select="m:physLoc/m:identifier[@label='shelf_mark']"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:if test="m:physLoc/m:repository/m:ptr[@label='catalog']">
                                                    <xsl:text>(</xsl:text>
                                                    <xsl:call-template name="u:externalLink">
                                                      <xsl:with-param name="href"
                                                                      select="m:physLoc/m:repository/m:ptr[@label='catalog']/@target"/>
                                                      <xsl:with-param name="text">Catalog</xsl:with-param>
                                                    </xsl:call-template>
                                                    <xsl:text>)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if test="position()=last()">
                                                    <xsl:text>.</xsl:text>
                                                  </xsl:if>
                                                </xsl:if>
                                              </div>
                                            </li>
                                            <li>
                                              <div class="ssSearchOn">
                                                <span class="label-inline">Digital reproduction:</span>
                                                <xsl:choose>
                                                  <xsl:when test="m:physLoc/m:repository/m:ptr[@label='digital_image']">
                                                    <xsl:call-template name="u:externalLink">
                                                      <xsl:with-param name="href"
                                                                      select="m:physLoc/m:repository/m:ptr[@label='digital_image']/@target"/>
                                                      <xsl:with-param name="text">View online</xsl:with-param>
                                                    </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>-</xsl:otherwise>
                                                </xsl:choose>
                                              </div>
                                            </li>
                                            <xsl:if test="position()!=last()">
                                              <hr/>
                                            </xsl:if>
                                          </xsl:for-each>
                                        </ul>
                                      </xsl:variable>
                                      <tr>
                                        <th>Documented Evidence</th>
                                        <td>
                                          <xsl:sequence select="$provenance_print"/>
                                        </td>
                                      </tr>
                                    </table>
                                  </xsl:with-param>
                                </xsl:call-template>
                              </div>
                            </li>
                            <xsl:if test="position()!=last()">
                              <br/>
                            </xsl:if>
                          </xsl:for-each>
                        </ul>
                      </u:accordionItem>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="performances"
                   role="tabpanel"
                   aria-labelledby="performances-tab">
                <div class="ssSearchOn">
                  <xsl:apply-templates select="m:history/m:eventList[@type='performances']"/>
                </div>
              </div>
              <div class="tab-pane fade"
                   id="citation"
                   role="tabpanel"
                   aria-labelledby="citation-tab">
                <div class="ssSearchOn">
                  <xsl:call-template name="u:tableNoEmpty">
                    <xsl:with-param name="table" as="element(h:table)">
                      <table class="table table-kv">
                        <tr>
                          <th style="width:20%; font-variant: small-caps; font-weight: normal;">Recommended citation</th>
                          <td>
                            <cite>
                              <xsl:value-of select="$title"/>
                            </cite>
                            <xsl:text> [work catalog record], in: WizKIT, ed. by </xsl:text>
                            <xsl:apply-templates select="ancestor::m:mei/m:meiHead/m:fileDesc/m:titleStmt/m:respStmt/m:persName[@role='edt']"/>
                            <xsl:text>, requested on </xsl:text>
                            <script>document.write(new Date().toISOString().substring(0, 10));</script>
                            <xsl:text> </xsl:text>
                            <xsl:element name="a">
                              <xsl:attribute name="href">
                                <xsl:value-of select="u:workLink(.)"/>
                              </xsl:attribute>
                              <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                              </xsl:attribute>
                              <xsl:value-of select="$title"/>
                              <xsl:text>.</xsl:text>
                            </xsl:element>
                          </td>
                        </tr>
                        <tr>
                          <th>GND</th>
                          <td>
                            <xsl:call-template name="u:externalLink">
                              <xsl:with-param name="href"
                                              select="m:identifier[@auth='GND']/@auth.uri || m:identifier[@auth='GND']/@codedval"/>
                              <xsl:with-param name="text" select="m:identifier[@auth='GND']/@codedval"/>
                            </xsl:call-template>
                          </td>
                        </tr>
                        <tr>
                          <th>VIAF</th>
                          <td>
                            <xsl:call-template name="u:externalLink">
                              <xsl:with-param name="href"
                                              select="m:identifier[@auth='VIAF']/@auth.uri || m:identifier[@auth='VIAF']/@codedval"/>
                              <xsl:with-param name="text" select="m:identifier[@auth='VIAF']/@codedval"/>
                            </xsl:call-template>
                          </td>
                        </tr>
                        <tr>
                          <th>LCCN</th>
                          <td>
                            <xsl:call-template name="u:externalLink">
                              <xsl:with-param name="href"
                                              select="m:identifier[@auth='LCCN']/@auth.uri || m:identifier[@auth='LCCN']/@codedval"/>
                              <xsl:with-param name="text" select="m:identifier[@auth='LCCN']/@codedval"/>
                            </xsl:call-template>
                          </td>
                        </tr>
                      </table>
                    </xsl:with-param>
                  </xsl:call-template>
                </div>
              </div>
            </div>
          </div>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="/">
    <xsl:variable name="title" as="xs:string">Works</xsl:variable>
    <xsl:call-template name="page">
      <xsl:with-param name="doc_title" select="$title"/>
      <xsl:with-param name="content">
        <h1>
          <xsl:value-of select="$title"/>
        </h1>
        <xsl:call-template name="worksTable"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="collection($worksDir || '?select=*.xml')/m:mei/m:meiHead/m:workList/m:work"
                         mode="page"/>
  </xsl:template>
</xsl:stylesheet>
