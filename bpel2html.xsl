<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bpel="http://docs.oasis-open.org/wsbpel/2.0/process/executable">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>


    <xsl:template match="/bpel:process">
        <html>
            <head>
                <script src="http://code.jquery.com/jquery.min.js"></script>
                <link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet"
                      type="text/css"/>
                <link href="bpel-renderer-html5.css" rel="stylesheet" type="text/css"/>
                <meta charset="utf-8"/>
                <title>BPEL Renderer</title>
            </head>
            <body>

                <div class="bpel_process bpel_structured_activity bpel_activity">
                    <xsl:apply-templates select="@* | node()"/>
                </div>

            </body>
        </html>
    </xsl:template>

    <xsl:template match="bpel:sequence">
        <div class="bpel_sequence bpel_structured_activity bpel_activity">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:condition">
        <div class="bpel_condition">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:scope">
        <div class="bpel_scope bpel_structured_activity bpel_activity">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:else">
        <div class="bpel_activity bpel_if_child bpel_if_else">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:if">
        <div class="bpel_if bpel_structured_activity bpel_activity">
            <xsl:apply-templates select="@*"/>

            <div class="bpel_activity bpel_if_child bpel_if_main">
                <xsl:apply-templates select="bpel:condition"/>
                <xsl:apply-templates select="child[not(bpel:condition or bpel:else or bpel:elseif)]"/>
            </div>

            <xsl:apply-templates select="bpel:elseif"/>
            <xsl:apply-templates select="bpel:else"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:elseif">
        <div class="bpel_activity bpel_if_child bpel_if_elseif">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:while">
        <div class="bpel_while bpel_structured_activity bpel_activity">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:wait">
        <div class="bpel_basic_activity bpel_wait bpel_activity">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:receive">
        <div class="bpel_receive bpel_basic_activity bpel_activity">
            <xsl:apply-templates select="@* | node()"/>
        </div>
    </xsl:template>

    <xsl:template match="bpel:invoke">
        <div class="bpel_invoke bpel_basic_activity bpel_activity">
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

</xsl:stylesheet>