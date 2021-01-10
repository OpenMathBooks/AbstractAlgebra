<?xml version="1.0" encoding="UTF-8"?>


<!-- This file is part of the book                 -->
<!--                                               -->
<!--   Discrete Mathematics: an Open Introduction  -->
<!--                                               -->
<!-- Copyright (C) 2015-2018 Oscar Levin           -->
<!-- See the file COPYING for copying conditions.  -->

<!-- Parts of this file were adapted from the author guide at https://github.com/rbeezer/mathbook and the analagous file at https://github.com/twjudson/aata -->
<!-- Conveniences for classes of similar elements -->
<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>

<!-- DMOI customizations for LaTeX runs -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Assumes current file is in discrete-text/xsl and that the mathbook repository is adjacent -->
<xsl:import href="../../../mathbook/xsl/mathbook-latex.xsl" />
<!-- Assumes next file can be found in discrete-text/xsl -->
<xsl:import href="custom-common.xsl" />


<xsl:param name="debug.exercises.forward" select="'no'"/>


<!-- Parameters to pass via xsltproc "stringparam" on command-line            -->
<!-- Or make a thin customization layer and use 'select' to provide overrides -->
<!--  -->
<!-- LaTeX executable, "engine"                       -->
<!-- pdflatex is default, xelatex or lualatex for Unicode support -->
<!-- N.B. This has no effect, and may never.  xelatex and lualatex support is automatic -->
<xsl:param name="latex.engine" select="'pdflatex'" />
<!--  -->
<!-- Standard fontsizes: 10pt, 11pt, or 12pt       -->
<!-- extsizes package: 8pt, 9pt, 14pt, 17pt, 20pt  -->
<!-- memoir class offers more, but maybe other changes? -->
<xsl:param name="latex.font.size" select="'11pt'" />
<!--  -->
<!-- Geometry: page shape, margins, etc            -->
<!-- Pass a string with any of geometry's options  -->
<!-- Default is empty and thus ineffective         -->
<!-- Otherwise, happens early in preamble template -->
<xsl:param name="latex.geometry" select="'papersize={8.5in,11in},  width=6.5in, height=9.25in, top=1in, ignoreheadfoot'"/>
<!--  -->
<!-- PDF Watermarking                    -->
<!-- Non-empty string makes it happen    -->
<!-- Scale works well for "CONFIDENTIAL" -->
<!-- or  for "DRAFT YYYY/MM/DD"          -->
<xsl:param name="watermark.text" select="''"/>
<xsl:param name="watermark.scale" select="2.0"/>
<!--  -->
<!-- Author's Tools                                            -->
<!-- Set the author-tools parameter to 'yes'                   -->
<!-- (Documented in mathbook-common.xsl)                       -->
<!-- Installs some LaTeX-specific behavior                     -->
<!-- (1) Index entries in margin of the page                   -->
<!--      where defined, on single pass (no real index)        -->
<!-- (2) LaTeX labels near definition and use                  -->
<!--     N.B. Some are author-defined; others are internal,    -->
<!--     and CANNOT be used as xml:id's (will raise a warning) -->
<!--  -->
<!-- Draft Copies                                              -->
<!-- Various options for working copies for authors            -->
<!-- (1) LaTeX's draft mode                                    -->
<!-- (2) Crop marks on letter paper, centered                  -->
<!--     presuming geometry sets smaller page size             -->
<!--     with paperheight, paperwidth                          -->
<xsl:param name="latex.draft" select="'no'"/>
<!--  -->
<!-- Print Option                                         -->
<!-- For a non-electronic copy, inactive links in black   -->
<!-- Any color options go to black and white, as possible -->
<xsl:param name="latex.print" select="'no'"/>
<!-- Sidedness -->
<xsl:param name="latex.sides" select="'one'"/>
<!--  -->
<!-- Preamble insertions                    -->
<!-- Insert packages, options into preamble -->
<!-- early or late                          -->
<!-- <xsl:param name="latex.preamble.early" select="''" /> -->
<!-- <xsl:param name="latex.preamble.late" select="''" /> -->
<!--  -->
<!-- Console characters allow customization of how    -->
<!-- LaTeX macros are recognized in the fancyvrb      -->
<!-- package's Verbatim clone environment, "console"  -->
<!-- The defaults are traditional LaTeX, we let any   -->
<!-- other specification make a document-wide default -->
<!-- <xsl:param name="latex.console.macro-char" select="'\'" />
<xsl:param name="latex.console.begin-char" select="'{'" />
<xsl:param name="latex.console.end-char" select="'}'" /> -->

<!-- We have to identify snippets of LaTeX from the server,   -->
<!-- which we have stored in a directory, because XSLT 1.0    -->
<!-- is unable/unwilling to figure out where the source file  -->
<!-- lives (paths are relative to the stylesheet).  When this -->
<!-- is needed a fatal message will warn if it is not set.    -->
<!-- Path ends with a slash, anticipating appended filename   -->
<!-- This could be overridden in a compatibility layer        -->
<xsl:param name="webwork.server.latex" select="''" />






<!-- List Chapters and Sections in Table of Contents -->
<xsl:param name="toc.level" select="'3'" />


<!-- Exercises have "solution"s which should be put in the back. -->
<!-- Not sure what to do for homework solutions -->
<!-- <xsl:param name="exercise.text.statement" select="'yes'" />
<xsl:param name="exercise.text.hint" select="'yes'" />
<xsl:param name="exercise.text.answer" select="'no'" />
<xsl:param name="exercise.text.solution" select="'no'" />
<xsl:param name="exercise.backmatter.statement" select="'no'" />
<xsl:param name="exercise.backmatter.hint" select="'no'" />
<xsl:param name="exercise.backmatter.answer" select="'yes'" />
<xsl:param name="exercise.backmatter.solution" select="'yes'" /> -->



<!-- Include a style file at the end of the preamble: -->

<xsl:param name="latex.preamble.late">
  <xsl:text>%This should load all the style information that ptx does not.&#xa;</xsl:text>
    <xsl:text>\newcommand{\sectionbreak}{\clearpage\phantomsection}&#xa;</xsl:text>
</xsl:param>


<xsl:param name="latex.preabmle.early">

</xsl:param>

<xsl:param name="numbering.theorems.level" select="'0'" />
<!-- How many levels in numbering of projects, etc     -->
<!-- PROJECT-LIKE gets independent numbering -->
<xsl:param name="numbering.projects.level" select="'0'" />
<!-- How many levels in numbering of equations     -->
<!-- Analagous to numbering theorems, but distinct -->
<xsl:param name="numbering.equations.level" select="'0'" />
<!-- Level where footnote numbering resets                                -->
<!-- For example, "2" would be sections in books, subsections in articles -->
<xsl:param name="numbering.footnotes.level" select="'0'" />
<!-- Last level where subdivision (section) numbering takes place     -->
<!-- For example, "2" would mean subsections of a book are unnumbered -->
<!-- N.B.: the levels above cannot be numerically larger              -->
<xsl:param name="numbering.maximum.level" select="'0'" />



<!-- Restyle paragraphs: -->
<!-- "paragraphs" -->
<!-- Body:  \begin{paragraphs}{title}{label}   -->
<!-- "titlesec" package, Subsection 9.2 has LaTeX defaults -->
<!-- We drop the indentation, and we pass the title itself -->
<!-- explicity with macro parameter #1 since we do not save-->
<!-- off the title in a PTX macro.  None of this is meant  -->
<!-- to support customization in a style.                  -->
<!-- Once a tcolorbox, see warnings as part of divisional  -->
<!-- introductions and conclusions.                        -->
<xsl:template match="paragraphs" mode="environment">
    <xsl:text>%% paragraphs: the terminal, pseudo-division&#xa;</xsl:text>
    <xsl:text>%% We use the lowest LaTeX traditional division&#xa;</xsl:text>
    <xsl:text>\titleformat{\subparagraph}[block]{\normalfont\filcenter\scshape\bfseries}{\thesubparagraph}{0em}{#1}&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subparagraph}{0pt}{3.25ex plus 1ex minus .2ex}{1ex}&#xa;</xsl:text>
    <xsl:text>\NewDocumentEnvironment{paragraphs}{mm}&#xa;</xsl:text>
    <xsl:text>{\subparagraph*{#1}\hypertarget{#2}{}}{}&#xa;</xsl:text>
</xsl:template>
<!-- Paragraphs -->
<!-- Non-structural, even if they appear to be -->
<xsl:template match="paragraphs">
    <!-- Warn about paragraph deprecation -->
    <xsl:text>\begin{paragraphs}</xsl:text>
    <xsl:text>{</xsl:text>
    <!-- Get rid of punctuation: (change title-punctuated to title-full) -->
    <xsl:apply-templates select="." mode="title-full" />
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="." mode="latex-id" />
    <xsl:text>}</xsl:text>
    <xsl:text>%&#xa;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{paragraphs}%&#xa;</xsl:text>
</xsl:template>


<!-- "proof" -->
<!-- Body:  \begin{proof}{title}{label}    -->
<!-- Title comes with punctuation, always. -->
<!-- <xsl:template match="proof" mode="environment">
    <xsl:text>%% proof: title is a replacement&#xa;</xsl:text>
    <xsl:text>\tcbset{ proofstyle/.style={</xsl:text>
    <xsl:apply-templates select="." mode="tcb-style" />
    <xsl:text>} }&#xa;</xsl:text>
    <xsl:text>\newtcolorbox{proofptx}[2]{title={\notblank{#1}{#1}{</xsl:text>
    <xsl:apply-templates select="." mode="type-name"/>
    <xsl:text>.}}, phantom={\hypertarget{#2}{}}, breakable, parbox=false, proofstyle }&#xa;</xsl:text>
</xsl:template> -->

<!-- Actually, redefine proofs to use the amsthm env for now -->
<!-- Proofs -->
<!-- Subsidary to THEOREM-LIKE, or standalone        -->
<!-- Defaults to "Proof", can be replaced by "title" -->
<!-- TODO: rename as "proof" once  amsthm  package goes away -->
<!-- <xsl:template match="proof">
    <xsl:text>\begin{proof}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:if test="title">
        <xsl:apply-templates select="." mode="title-full"/>
    </xsl:if>
    <xsl:text>}</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates select="*" />
    <xsl:text>\end{proof}&#xa;</xsl:text>
</xsl:template> -->

<!--HACK: 3-23-19 redefine the qed symbol to be qed  -->
<!-- "proof" -->
<!-- Title in italics, as in amsthm style.           -->
<!-- Filled, black square as QED, tombstone, Halmos. -->
<!-- Pushing the tombstone flush-right is a bit      -->
<!-- ham-handed, but more elegant TeX-isms           -->
<!-- (eg \hfill) did not get it done.  We require at -->
<!-- least two spaces gap to remain on the same      -->
<!-- line. Presumably the line will stretch when the -->
<!-- tombstone moves onto its own line.              -->
<xsl:template match="proof" mode="tcb-style">
    <xsl:text>bwminimalstyle, fonttitle=\normalfont\itshape, attach title to upper, after title={\space}, after upper={\space\space\hspace*{\stretch{1}}\(\textsc{qed}\)}&#xa;</xsl:text>
</xsl:template>


<!-- %%%%%%%%%%%%% -->
<!-- page styles:  -->
<!-- %%%%%%%%%%%%% -->

<!-- Set up title and headers for worksheets -->
<!-- Macros for \thecourse and \theterm must be defined in -->
<xsl:template name="titlesec-subsection-style">
    <xsl:text>\titleformat{\subsection}
    {\large\filcenter\scshape\bfseries}
    {\thesubsection}
    {1em}
    {#1}
    [\large\authorsptx]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\subsection,numberless}[block]
    {\large\filcenter\bfseries}
    {}
    {0.0em}
    {\vskip -3em #1}&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\subsection}{0em}{3em}{1em}&#xa;</xsl:text>
</xsl:template>

<xsl:template name="titlesec-section-style">
    <xsl:text>\titleformat{\section}
    {\large\filcenter\scshape\bfseries}
    {\thesection}
    {1em}
    {#1}
    [\large\authorsptx]&#xa;</xsl:text>
    <xsl:text>\titleformat{name=\section,numberless}[block]
    {\large\filcenter\bfseries}
    {}
    {0.0em}
    {\vskip -3em #1}&#xa;</xsl:text>
    <xsl:text>\titlespacing*{\section}{0pt}{0pt}{2em}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="article|book" mode="titleps-style">
    <xsl:message>Article or book in mode titleeps-style has been called.</xsl:message>
    <xsl:text>
    \renewpagestyle{plain}{
    \sethead{\thecourse}{}{\theterm}
    \setfoot[][\thepage][]
    {}{\thepage}{}
    }
    \renewpagestyle{headings}{
    \sethead{\thecourse}{}{\theterm}
    \setfoot[][\thepage][]
    {}{\thepage}{}
    }
    \pagestyle{plain}
    </xsl:text>
</xsl:template>
</xsl:stylesheet>
