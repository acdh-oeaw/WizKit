<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:output method="xhtml"
              encoding="UTF-8"
              indent="yes"
              omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:import href="html_navbar.xsl"/>
  <xsl:import href="html_head.xsl"/>
  <xsl:import href="html_footer.xsl"/>
  <xsl:import href="util.xsl"/>
  <xsl:variable name="newline" as="xs:string" select="'&#xA;'"/>

  <xsl:template name="page">
    <xsl:param name="doc_title" as="xs:string" select="$project_short_title"/>
    <xsl:param name="addHead" as="item()*"/>
    <xsl:param name="content" as="item()+"/>
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <xsl:value-of select="$newline"/>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
      <xsl:call-template name="html_head">
        <xsl:with-param name="html_title" select="$doc_title"/>
        <xsl:with-param name="addHead" select="$addHead"/>
      </xsl:call-template>
      <body class="page">
        <div class="hfeed site" id="page">
          <xsl:call-template name="nav_bar"/>
          <div class="container-fluid">
            <div class="card">
              <xsl:sequence select="$content"/>
            </div>
          </div>
          <xsl:call-template name="html_footer"/>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
