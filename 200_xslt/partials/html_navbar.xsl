<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

  <xsl:template match="/" name="nav_bar">
    <div class="wrapper-fluid wrapper-navbar sticky-navbar navbar-margin"
         id="wrapper-navbar"
         itemscope=""
         itemtype="http://schema.org/WebSite">
      <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container-fluid">
          <!-- Your site title as branding in the menu -->
          <a href="index.html"
             class="navbar-brand custom-logo-link"
             rel="home"
             itemprop="url">
            <img src="images/wizkit_logo.png"
                 alt="WizKit logo"
                 style="max-height: 4rem;filter: hue-rotate(160deg);"/>
            <!--<span class="h4">
              <xsl:value-of select="$project_short_title"/>
            </span>-->
          </a>
          <!-- end custom logo -->
          <button class="navbar-toggler"
                  type="button"
                  data-toggle="collapse"
                  data-target="#navbarNavDropdown"
                  aria-controls="navbarNavDropdown"
                  aria-expanded="false"
                  aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"/>
          </button>
          <div class="collapse navbar-collapse justify-content-end"
               id="navbarNavDropdown">
            <!-- Your menu goes here -->
            <ul id="main-menu" class="navbar-nav">
              <li class="nav-item">
                <a title="Works" href="works.html" class="nav-link">Works</a>
              </li>
              <li class="nav-item">
                <a title="Persons" href="persons.html" class="nav-link">Persons</a>
              </li>
              <li class="nav-item">
                <a title="Persons" href="organisations.html" class="nav-link">Organisations</a>
              </li>
            </ul>
            <!-- <a href="search.html"> -->
            <!--   <svg xmlns="http://www.w3.org/2000/svg" -->
            <!--        width="24" -->
            <!--        height="24" -->
            <!--        viewBox="0 0 24 24" -->
            <!--        fill="none" -->
            <!--        stroke="currentColor" -->
            <!--        stroke-width="2" -->
            <!--        stroke-linecap="round" -->
            <!--        stroke-linejoin="round" -->
            <!--        class="feather feather-search"> -->
            <!--     <circle cx="11" cy="11" r="8"/> -->
            <!--     <line x1="21" y1="21" x2="16.65" y2="16.65"/> -->
            <!--   </svg>SUCHE</a> -->
          </div>
          <!-- .collapse navbar-collapse -->
        </div>
        <!-- .container -->
      </nav>
      <!-- .site-navigation -->
    </div>
  </xsl:template>
</xsl:stylesheet>
