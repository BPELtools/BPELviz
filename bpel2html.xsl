<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:bpel="http://docs.oasis-open.org/wsbpel/2.0/process/executable">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <!-- create doctype html5 element -->
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="/bpel:process">
        <html>
            <head>
                <title>BPEL Renderer</title>
                <meta charset="utf-8"/>

                <script src="http://requirejs.org/docs/release/2.1.9/minified/require.js"></script>
                <script>
                    require.config({
                    paths: {
                        "jquery": "http://codeorigin.jquery.com/jquery-2.0.3.min",
                        "bootstrap3": "http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min"
                    },
                    shim: {
                        "bootstrap3": ["jquery"]
                    }});
                </script>

                <link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet"
                      type="text/css"/>
                <link href="bpel-renderer-html5.css" rel="stylesheet" type="text/css"/>

                <style>
                    .popover {
                        max-width: 800px;
                        width: auto;
                    }
                </style>

            </head>
            <body>

                <div class="bpel_process">
                    <xsl:apply-templates select="@* | node()"/>
                </div>

                <script>
                    require(["bpel-renderer-html5"], function(renderer) {
                        renderer.initialize();
                    });
                    require(["jquery", "bootstrap3"], function($) {
                        $("div[rel='popover']").popover();
                    });
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

            <div class="bpel_">
                <xsl:apply-templates select="bpel:condition"/>
                <xsl:apply-templates select="child[not(bpel:condition or bpel:else or bpel:elseif)]"/>
            </div>

            <xsl:apply-templates select="bpel:elseif"/>
            <xsl:apply-templates select="bpel:else"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:*">
        <xsl:variable name="xml-serialization-full"><xsl:apply-templates mode='serialize' select='.'/></xsl:variable>
        <xsl:variable name="line-break" select="'&#x0a;'"/>
        <xsl:variable name="lines" select="tokenize($xml-serialization-full, $line-break)"/>
        <xsl:variable name="xml-serialization">
            <xsl:variable name="line-numbers" as="xs:integer" select="count($lines)"/>

            <xsl:text>&lt;pre&gt;</xsl:text>
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

            <xsl:text>&lt;/pre&gt;</xsl:text>
        </xsl:variable>
        <div class="bpel_{fn:local-name()} shrinkable"
             rel="popover"
             data-trigger="hover"
             data-content="{$xml-serialization}"
             data-toggle="popover"
             data-html="true" data-placement="right">
            <xsl:apply-templates select="@* | node()"/>
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
        <xsl:text>&amp;lt;</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*" mode="serialize" />
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:text>&amp;gt;</xsl:text>
                <xsl:apply-templates mode="serialize" />
                <xsl:text>&amp;lt;/</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>&amp;gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&amp;gt;</xsl:text>
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