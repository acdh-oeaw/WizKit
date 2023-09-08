<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:u="urn:local:util"
                version="3.0"
                exclude-result-prefixes="#all">

  <xsl:template name="u:arrowRight">
    <svg xmlns="http://www.w3.org/2000/svg"
         width="16"
         height="16"
         fill="currentColor"
         class="bi bi-box-arrow-in-right"
         viewBox="0 0 16 16">
      <path fill-rule="evenodd"
            d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
      <path fill-rule="evenodd"
            d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
    </svg>
  </xsl:template>

  <xsl:function name="u:applySepNoEmpty" as="item()*">
    <xsl:param name="items" as="item()*"/>
    <xsl:for-each select="$items[normalize-space(.)]">
      <xsl:apply-templates select="."/>
      <xsl:if test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="u:listSimple" as="element(h:ul)">
    <xsl:param name="items" as="item()*"/>
    <ul style="padding: 0; margin: 0;">
      <xsl:for-each select="$items">
        <li style="margin: 0;">
          <xsl:copy-of select="."/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:function>

  <xsl:function name="u:listShowMore" as="element(h:ul)">
    <xsl:param name="items" as="item()*"/>
    <ul style="padding: 0; margin: 0;">
      <xsl:for-each select="$items">
        <xsl:choose>
          <xsl:when test="position() != 1">
            <li style="margin: 0;" class="fade about-text-hidden">
              <xsl:copy-of select="."/>
            </li>
          </xsl:when>
          <xsl:otherwise>
            <li style="margin: 0;">
              <xsl:copy-of select="."/>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:if test="count($items) &gt; 1">
        <li style="margin: 0; text-decoration: underline; text-decoration-style: dotted; cursor: pointer;"
            id="show-text">show more</li>
      </xsl:if>
    </ul>
  </xsl:function>

  <xsl:function name="u:isEmptyTableRow" as="xs:boolean">
    <xsl:param name="tr" as="element(h:tr)"/>
    <xsl:sequence select="$tr/h:td and not(some $td in $tr/h:td satisfies normalize-space($td))"/>
  </xsl:function>

  <xsl:template name="u:tableNoEmpty" as="element(h:table)?">
    <xsl:param name="table" as="element(h:table)"/>
    <xsl:if test="not(every $tr in $table//h:tr[h:td] satisfies u:isEmptyTableRow($tr))">
      <xsl:apply-templates select="$table" mode="u:tableCopy"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="h:tr[u:isEmptyTableRow(.)]" mode="u:tableCopy"/>
  <xsl:mode name="u:tableCopy" on-no-match="shallow-copy"/>

  <xsl:template name="u:externalLink" as="element(h:a)">
    <xsl:param name="href" as="xs:string?"/>
    <xsl:param name="text" as="xs:string?"/>
    <a target="_blank" rel="noopener noreferrer" href="{$href}">
      <xsl:value-of select="$text"/>
    </a>
  </xsl:template>

  <xsl:template name="u:accordions" as="element(h:div)">
    <xsl:param name="accordionItems" as="element(u:accordionItem)*"/>
    <xsl:variable name="accId" as="xs:string" select="'acc-' || generate-id()"/>
    <div class="accordion-wrapper">
      <div class="accordion-buttons float-end pe-2">
        <button class="allAccOpenBtn" onclick="openAllAccordions('{$accId}')">Open</button>
        <button class="allAccCloseBtn" onclick="closeAllAccordions('{$accId}')">Close</button>
      </div>
      <div class="accordion" id="{$accId}">
        <xsl:for-each select="$accordionItems[normalize-space(.)]">
          <!-- <u:accordionItem headerText="Test">copied contents<u:accordionItem> -->
          <div class="accordion-item">
            <h6 class="accordion-header" id="heading-{$accId}-{position()}">
              <button class="accordion-button collapsed"
                      type="button"
                      data-bs-toggle="collapse"
                      data-bs-target="#collapse-{$accId}-{position()}"
                      aria-expanded="false"
                      aria-controls="collapse-{$accId}-{position()}">
                <strong>
                  <xsl:value-of select="@headerText"/>
                </strong>
              </button>
            </h6>
            <div id="collapse-{$accId}-{position()}"
                 class="accordion-collapse collapse"
                 aria-labelledby="heading-{$accId}-{position()}">
              <div class="accordion-body">
                <xsl:sequence select="node()"/>
              </div>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>

  <xsl:function name="u:workRef" as="xs:string">
    <xsl:param name="work" as="element(m:work)"/>
    <xsl:value-of>
      <xsl:text>W-</xsl:text>
      <xsl:value-of select="$work/ancestor::m:mei/m:meiHead/m:fileDesc/m:seriesStmt/m:identifier[@type='file-collection']"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="u:workLink" as="xs:string">
    <xsl:param name="work" as="element(m:work)"/>
    <xsl:value-of select="u:workRef($work) || '.html'"/>
  </xsl:function>

  <xsl:function name="u:registerRef" as="xs:string">
    <xsl:param name="item" as="element()"/>
    <xsl:value-of>
      <xsl:value-of select="$u:prefixes(local-name($item))"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$item/m:identifier[@type='register-ID']"/>
    </xsl:value-of>
  </xsl:function>
  <xsl:variable name="u:prefixes"
                as="map(xs:string, xs:string)"
                select="map { 'persName': 'P', 'corpName': 'O' }"/>

  <xsl:function name="u:registerLink" as="xs:string">
    <xsl:param name="item" as="element()"/>
    <xsl:value-of select="u:registerRef($item) || '.html'"/>
  </xsl:function>

  <xsl:function name="u:findInRegister" as="element()?">
    <xsl:param name="x" as="element()"/>
    <!-- use gnd as fallback -->
    <xsl:copy-of select="document($u:registerFiles(local-name($x)))//(key('registerKey', $x/@corresp)|*[m:identifier[@auth = $x/@auth and text() = $x/@codedval]])[1]"/>
  </xsl:function>
  <xsl:key name="registerKey"
           match="m:persName|m:corpName"
           use="u:registerRef(.)"/>
  <xsl:variable name="u:library" as="xs:string">../../600_library</xsl:variable>
  <xsl:variable name="u:registerFiles"
                as="map(xs:string, xs:string)"
                select="map { 'persName': $u:library || '/601_persons/persons.xml', 'corpName': $u:library || '/602_orgs/orgs.xml' }"/>
</xsl:stylesheet>
