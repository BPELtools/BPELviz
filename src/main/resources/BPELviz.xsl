<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:bpel="http://docs.oasis-open.org/wsbpel/2.0/process/executable"
                xmlns:bpelviz="http://github.com/BPELtools/BPELviz"
                >

    <xsl:import href="BPELviz-id-handling.xsl" />

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <!-- constants -->
    <xsl:variable name="line-break" select="'&#x0a;'"/>

    <!-- create doctype html5 element -->
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="/bpel:process">
        <html>
            <head>
                <title>BPELviz</title>
                <meta charset="utf-8"/>

                <!-- latest release is 3.0.83. That does not play well with requirejs. Therefore, everything of SyntaxHighlighter is loaded before requirejs -->
                <script src="http://alexgorbatchev.com/pub/sh/3.0.83/scripts/shCore.js" type="text/javascript"></script>
                <script src="http://alexgorbatchev.com/pub/sh/3.0.83/scripts/shBrushXml.js" type="text/javascript"></script>

                <script src="http://requirejs.org/docs/release/2.1.9/minified/require.js"></script>
                <script>
                    require.config({
                    paths: {
                        "jquery": "http://codeorigin.jquery.com/jquery-2.0.3.min",
                        "bootstrap3": "http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min"
                    },
                    shim: {
                        "bootstrap3": ["jquery"]
                    }});
                </script>

                <link href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>

                <link href="http://alexgorbatchev.com/pub/sh/current/styles/shCore.css" rel="stylesheet" type="text/css" />
                <link href="http://alexgorbatchev.com/pub/sh/current/styles/shThemeDefault.css" rel="stylesheet" type="text/css" />
                <link href="http://alexgorbatchev.com/pub/sh/current/styles/shThemeEclipse.css" rel="stylesheet" type="text/css" />

                <link href="BPELviz.css" rel="stylesheet" type="text/css"/>

            </head>
            <body>
                <div id="processContainer">
                    <div class="bpel_process bpel">
                        <xsl:apply-templates select="@* | node()"/>
                    </div>
                </div>

                <xsl:variable name="xml-serialization-full"><xsl:apply-templates mode='serialize' select='.'/></xsl:variable>

                <div id="tabContainer">
                    <!-- Nav tabs -->
                    <ul class="nav nav-tabs" id="SourceTabs">
                        <li class="active"><a href="#SourceExtractTab" data-toggle="tab">Source Extract</a></li>
                        <li><a href="#FullSourceTab" data-toggle="tab">Full Source</a></li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div class="tab-pane active" id="SourceExtractTab">Click on an element to show its source</div>
                        <div class="tab-pane" id="FullSourceTab">
                            <div id="FullSource">
                                <pre class="brush: xml"><xsl:value-of select="$xml-serialization-full" /></pre>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                    require(["BPELviz"], function(renderer) {
                        renderer.initialize();
                    });

                    SyntaxHighlighter.all();
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="bpel:condition">
        <div class="bpel_condition">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:if">
        <div class="bpel_if">
            <xsl:apply-templates select="@*"/>

            <div class="bpel">
                <xsl:apply-templates select="bpel:condition"/>
                <xsl:apply-templates select="child[not(bpel:condition or bpel:else or bpel:elseif)]"/>
            </div>

            <xsl:apply-templates select="bpel:elseif"/>
            <xsl:apply-templates select="bpel:else"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:*">
        <xsl:variable name="xml-serialization-full"><xsl:apply-templates mode='serialize' select='.'/></xsl:variable>
        <xsl:variable name="lines" select="tokenize($xml-serialization-full, $line-break)"/>
        <xsl:variable name="xml-serialization">
            <xsl:variable name="line-numbers" as="xs:integer" select="count($lines)"/>

            <xsl:choose>
                <xsl:when test="$line-numbers > 11">
                    <xsl:value-of select="string-join(subsequence($lines, 0, 5), $line-break)"/>
                    <xsl:value-of select="$line-break"/>
                    ... <xsl:value-of select="$line-numbers - 10"/> lines are hidden ...
                    <xsl:value-of select="$line-break"/>
                    <xsl:value-of select="string-join(subsequence($lines, ($line-numbers - 4)), $line-break)"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$xml-serialization-full"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <div id="{bpelviz:deriveIdentifier(.)}" class="bpel bpel_{fn:local-name()}">
            <!-- TODO: show buttons only at activities -->
            <button class="btn btn-sm collapseExpandToggleBtn glyphicon glyphicon-minus"></button>
            <div class="content"><xsl:apply-templates select="@* | node()"/></div>
        </div>
        <div id="source-{bpelviz:deriveIdentifier(.)}" class="dotted_source">
            <!-- gutter:false -> don't display line numbers. Required, because line counting currently always starts at one -->
            <pre class="brush: xml; gutter: false;"><xsl:value-of select="$xml-serialization" /></pre>
        </div>
    </xsl:template>

    <xsl:template match="attribute::name">
        <div class="bpel_name">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <!-- Override default template for copying text -->
    <xsl:template match="text()|@*"/>

    <!-- serialize xml node to string -->
    <xsl:template match="*" mode="serialize">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*" mode="serialize" />
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:text>&gt;</xsl:text>
                <xsl:apply-templates mode="serialize" />
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*" mode="serialize">
        <xsl:text> </xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>="</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    <xsl:template match="text()" mode="serialize">
        <xsl:value-of select="."/>
    </xsl:template>
    
    


</xsl:stylesheet>