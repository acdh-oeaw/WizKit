<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:m="http://www.music-encoding.org/ns/mei"
                xmlns="http://www.w3.org/1999/xhtml"
                version="3.0"
                exclude-result-prefixes="#all">
  <xsl:import href="partials/page.xsl"/>

  <xsl:template match="/">
    <xsl:call-template name="page">
      <xsl:with-param name="doc_title" select="$project_short_title"/>
      <xsl:with-param name="content">
        <div class="container" style="max-width:100%;padding:0!important;">
          <div class="wrapper" id="wrapper-hero-content">
            <div class="container-fluid-content hero-light"
                 id="wrapper-hero-inner"
                 tabindex="-1">
              <div class="row">
                <div class="col-md-8" style="padding: 0 0 0 4em;">
                  <div class="main-title">
                    <h3 style="color:#000;padding:.2em .5em;margin:0;text-align:left;">Welcome to the WizKit!</h3>
                  </div>
                  <div>
                    <button class="btn btn-round" style="padding: 1em;margin:1em;">
                      <a href="works.html" style="font-size:22px;color:#000;">Get started</a>
                    </button>
                    <button class="btn btn-round" style="padding: 1em;margin:1em;">
                      <a href="documentation.html" style="font-size:22px;color:#000;">Documentation</a>
                    </button>
                  </div>
                </div>
              </div>
              <div class="quote-box">
                <h4>What our users are saying</h4>
                <blockquote style="padding: 0.5rem 4rem; font-size: smaller;">
                  <p>"Oh, let me tell you, dear music enthusiasts, about my delightful escapade into the world of MEI data with the enchanting WizKit! As a musicologist who often finds herself lost in the melodious mazes of historical compositions, I must admit, technology has always been as puzzling to me as deciphering ancient notations. But fear not, for the WizKit has bestowed upon me the gift of musical enchantment without the ordeal of techno-trickery!</p>
                  <p>Picture this: a cozy room adorned with old manuscripts, my cat Johann purring by my side, and me – armed with nothing but my trusty spectacles and a heart full of curiosity. Enter the WizKit, like a knight in shining armor, here to rescue me from the dungeons of tech confusion.</p>
                  <p>With a wave of my metaphorical wand (a mere mouse click, really), I'm transported into a realm where MEI data dances like musical notes on a staff, and I am the composer of my digital destiny. The WizKit's interface, oh, so intuitive! It gently guided me through the labyrinth of MEI intricacies, as if I were strolling through a garden of harmonious roses.</p>
                  <p>And the magic didn't stop there! With the WizKit, I was able to conjure up visualizations that made my heart flutter like a waltz from days of yore. Graphs and charts materialized before my eyes, illuminating patterns in the music that once seemed as mysterious as the moonlit night. My non-tech-savvy self felt like a maestro orchestrating a symphony of data effortlessly, all thanks to the mystical powers of the WizKit.</p>
                  <p>But let's not forget the pièce de résistance – the spellbinding documentation and support! Every question I had, every conundrum that tickled my academic senses, was met with responses that made me feel like I was sipping tea with the grandmasters of musicology themselves. The WizKit's team guided me with such patience and grace that I felt like I was waltzing through a ballroom of knowledge.</p>
                  <p>In conclusion, dear fellow explorers of musical realms, if this non-tech-savvy musicologist can unravel the mysteries of MEI data using the WizKit, then truly anyone can. It's a serenade of simplicity, a sonata of support, and a symphony of success. So, don your imaginary capes, embrace the WizKit, and embark on a harmonious journey that will leave you singing praises louder than a choir at the grandest cathedral!"</p>
                  <p>(Note: This testimonial is a playful parody and not based on any actual product or experience.)</p>
                  <p>-- ChatGPT</p>
                </blockquote>
              </div>
            </div>
          </div>
        </div>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
