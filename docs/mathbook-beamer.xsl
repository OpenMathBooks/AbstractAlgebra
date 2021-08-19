<!-- As XML file --><!--********************************************************************
Copyright 2013 Robert A. Beezer, 2018 Oscar Levin

This file is part of MathBook XML.

MathBook XML is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 or version 3 of the
License (at your option).

MathBook XML is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MathBook XML.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************--><!-- http://pimpmyxslt.com/articles/entity-tricks-part2/ --><!-- Identify as a stylesheet --><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:date="http://exslt.org/dates-and-times" xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="exsl date str">

<xsl:import href="./mathbook-latex.xsl"/>

<!-- <xsl:import href="./mathbook-common.xsl" /> -->

<!-- Intend output for rendering by pdflatex -->
<xsl:output method="text"/>


<xsl:template match="/">
  <exsl:document href="images.tex" method="text">
    <xsl:text>\documentclass{beamer}

</xsl:text>
    <xsl:call-template name="beamer-preamble"/>
    <xsl:text>\begin{document}
</xsl:text>
    <xsl:apply-templates select="*" mode="beamer-images"/>
    <xsl:text>\end{document}
</xsl:text>
  </exsl:document>
</xsl:template>




<xsl:template match="section">
    <!-- <xsl:param name="content" /> -->
    <xsl:variable name="filename">
        <xsl:apply-templates select="." mode="internal-id"/>
        <text>.tex</text>
    </xsl:variable>
    <exsl:document href="{$filename}" method="text">
      <xsl:text>\documentclass{beamer}

</xsl:text>
      <xsl:call-template name="beamer-preamble"/>
      <xsl:text>\begin{documnent}
</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>\end{document}
</xsl:text>
    </exsl:document>
</xsl:template>





<!-- Preamble template -->
<xsl:template name="beamer-preamble">
  <xsl:text>%% Preamble:
</xsl:text>

  <xsl:text>%% Custom Preamble Entries, early (use latex.preamble.early)
</xsl:text>
  <xsl:if test="$latex.preamble.early != ''">
      <xsl:value-of select="$latex.preamble.early"/>
      <xsl:text>
</xsl:text>
  </xsl:if>


  <xsl:text>\usepackage{ifthen}
</xsl:text>
  <xsl:text>\usepackage{ifxetex,ifluatex}
</xsl:text>
  <xsl:text>%% Raster graphics inclusion
</xsl:text>
  <xsl:text>\usepackage{graphicx}
</xsl:text>
  <xsl:text>\usepackage{adjustbox}
</xsl:text>

  <xsl:if test="$docinfo/latex-image-preamble">
      <xsl:text>%% Graphics Preamble Entries
</xsl:text>
      <xsl:call-template name="sanitize-text">
          <xsl:with-param name="text" select="$docinfo/latex-image-preamble"/>
      </xsl:call-template>
  </xsl:if>
  <xsl:text>%% If tikz has been loaded, replace ampersand with \amp macro
</xsl:text>
  <xsl:if test="$document-root//latex-image-code|$document-root//latex-image">
      <xsl:text>\ifdefined\tikzset
</xsl:text>
      <xsl:text>    \tikzset{ampersand replacement = \amp}
</xsl:text>
      <xsl:text>\fi
</xsl:text>
  </xsl:if>
  <xsl:if test="//sidebyside">
      <xsl:text>%% NB: calc redefines \setlength
</xsl:text>
      <xsl:text>\usepackage{calc}
</xsl:text>
      <xsl:text>%% used repeatedly for vertical dimensions of sidebyside panels
</xsl:text>
      <xsl:text>\newlength{\panelmax}
</xsl:text>
  </xsl:if>

  <xsl:text>%% Custom Preamble Entries, late (use latex.preamble.late)
</xsl:text>
  <xsl:if test="$latex.preamble.late != ''">
      <xsl:value-of select="$latex.preamble.late"/>
      <xsl:text>
</xsl:text>
  </xsl:if>
  <xsl:text>%% Begin: Author-provided packages
</xsl:text>
  <xsl:text>%% (From  docinfo/latex-preamble/package  elements)
</xsl:text>
  <xsl:value-of select="$latex-packages"/>
  <xsl:text>%% End: Author-provided packages
</xsl:text>
  <xsl:text>%% Begin: Author-provided macros
</xsl:text>
  <xsl:text>%% (From  docinfo/macros  element)
</xsl:text>
  <xsl:text>%% Plus three from MBX for XML characters
</xsl:text>
  <xsl:value-of select="$latex-macros"/>
  <xsl:text>%% End: Author-provided macros
</xsl:text>

  <xsl:text>%% End of Preamble %% 
 
</xsl:text>
</xsl:template>




<!-- ###### -->
<!-- Images -->
<!-- ###### -->
<!-- <xsl:template match="*" mode="beamer-images" \> -->

<xsl:template match="*" mode="beamer-images">
  <xsl:apply-templates select="*" mode="beamer-images"/>
</xsl:template>

<!-- <xsl:template match="figure|sidebyside[image]" mode="beamer-images"> -->
<xsl:template match="image" mode="beamer-images">
  <xsl:text>\begin{frame}[plain]
 
</xsl:text>
  <!-- <xsl:text>\resizebox{!}{0.9\textheight}{% &#xa;</xsl:text> -->
  <xsl:text>\begin{adjustbox}{max totalsize={0.9\textwidth}{0.7\textheight},center}
</xsl:text>
  <xsl:apply-templates select="."/>
  <xsl:text>\end{adjustbox}
</xsl:text>
  <!-- <xsl:text>}&#xa;</xsl:text> -->
  <xsl:text>\end{frame}
 
</xsl:text>
</xsl:template>


<!-- Figures -->
<!-- Standard LaTeX figure environment redefined, see preamble comments -->
<xsl:template match="figure" mode="beamer-images">
    <xsl:if test="not(preceding-sibling::*[not(self::title or self::subtitle or self::idx or self::index[not(index-list)] or self::notation or self::todo or self::frontmatter or self::backmatter)])">
        <xsl:call-template name="leave-vertical-mode"/>
    </xsl:if>
    <xsl:text>\begin{frame}[plain]
 
</xsl:text>
    <xsl:text>\vfill
</xsl:text>
    <xsl:text>\begin{figure}
</xsl:text>
    <xsl:text>\begin{adjustbox}{max totalsize={0.9\textwidth}{0.75\textheight}}
</xsl:text>
    <xsl:text>\centering
</xsl:text>
    <xsl:apply-templates select="*[not(self::caption)]"/>
    <xsl:text>\end{adjustbox}
</xsl:text>
    <xsl:apply-templates select="caption"/>
    <xsl:text>\end{figure}
</xsl:text>
    <xsl:text>\vfill
</xsl:text>
    <xsl:text>\end{frame}
 
</xsl:text>
</xsl:template>

<!-- With full source specified, default to PDF format -->
<xsl:template match="image[@source]">
    <xsl:variable name="width">
        <xsl:apply-templates select="." mode="get-width-percentage"/>
    </xsl:variable>
    <xsl:variable name="extension">
        <xsl:call-template name="file-extension">
            <xsl:with-param name="filename" select="@source"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:text>\includegraphics[width=</xsl:text>
    <xsl:value-of select="substring-before($width,'%') div 100"/>
    <xsl:text>\linewidth]</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="@source" mode="internal-id"/>
    <xsl:if test="not($extension)">
        <xsl:text>.pdf
</xsl:text>
    </xsl:if>
    <xsl:text>}
</xsl:text>
</xsl:template>

<!-- Asymptote graphics language  -->
<!-- PDF's produced by mbx script -->
<xsl:template match="image[asymptote]">
    <xsl:variable name="width">
        <xsl:apply-templates select="." mode="get-width-percentage"/>
    </xsl:variable>
    <xsl:text>\includegraphics[width=</xsl:text>
    <xsl:value-of select="substring-before($width,'%') div 100"/>
    <xsl:text>\linewidth]</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$directory.images"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="." mode="internal-id"/>
    <xsl:text>.pdf}
</xsl:text>
</xsl:template>

<!-- Sage graphics plots          -->
<!-- PDF's produced by mbx script -->
<!-- PNGs are fallback for 3D     -->
<xsl:template match="image[sageplot]">
    <xsl:variable name="width">
        <xsl:apply-templates select="." mode="get-width-percentage"/>
    </xsl:variable>
    <xsl:text>\IfFileExists{</xsl:text>
    <xsl:value-of select="$directory.images"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="." mode="internal-id"/>
    <xsl:text>.pdf}%
</xsl:text>
    <xsl:text>{\includegraphics[width=</xsl:text>
    <xsl:value-of select="substring-before($width,'%') div 100"/>
    <xsl:text>\linewidth]</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$directory.images"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="." mode="internal-id"/>
    <xsl:text>.pdf}}%
</xsl:text>
    <xsl:text>{\includegraphics[width=</xsl:text>
    <xsl:value-of select="substring-before($width,'%') div 100"/>
    <xsl:text>\linewidth]</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$directory.images"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="." mode="internal-id"/>
    <xsl:text>.png}}
</xsl:text>
</xsl:template>

<!-- LaTeX Image Code (tikz, pgfplots, pstricks, etc) -->
<!-- Clean indentation, drop into LaTeX               -->
<!-- See "latex-image-preamble" for critical parts    -->
<!-- Side-By-Side scaling happens there, could be here -->
<xsl:template match="image[latex-image-code]|image[latex-image]">
    <!-- outer braces rein in the scope of any local graphics settings -->
    <xsl:text>{
</xsl:text>
    <xsl:call-template name="sanitize-text">
        <xsl:with-param name="text" select="latex-image-code|latex-image"/>
    </xsl:call-template>
    <xsl:text>}
</xsl:text>
</xsl:template>

<!-- was once direct-descendant of subdivision, this catches that -->
<xsl:template match="latex-image-code[not(parent::image)]">
    <xsl:message>MBX:WARNING: latex-image-code element should be enclosed by an image element</xsl:message>
</xsl:template>

</xsl:stylesheet>