<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xsl xs"
                version="3.0">
  <xsl:include href="./params.xsl"/>

  <xsl:template match="/" name="html_head">
    <xsl:param name="html_title" select="$project_short_title"/>
    <xsl:param name="addHead" as="item()*"/>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <meta name="mobile-web-app-capable" content="yes"/>
      <meta name="apple-mobile-web-app-capable" content="yes"/>
      <meta name="apple-mobile-web-app-title" content="{$html_title}"/>
      <link rel="profile" href="http://gmpg.org/xfn/11"/>
      <link rel="icon" href="images/wizkit_red_16.png" type="image/png"/>
      <title>
        <xsl:value-of select="$html_title"/>
      </title>
      <link rel="stylesheet"
            href="dist/bootstrap/bootstrap.min.css"
            type="text/css"/>
      <script src="dist/bootstrap/bootstrap.bundle.js"/>
      <link href="dist/DataTables/datatables.min.css" rel="stylesheet"/>
      <script src="dist/DataTables/datatables.min.js"/>
      <link rel="stylesheet" href="css/style.css" type="text/css"/>
      <script src="js/util.js" type="text/javascript"/>
      <xsl:sequence select="$addHead"/>
    </head>
  </xsl:template>
</xsl:stylesheet>
