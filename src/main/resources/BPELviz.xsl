<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:bpelviz="http://github.com/BPELtools/BPELviz">

    <xsl:function name="bpelviz:deriveIdentifier">
        <xsl:param name="node" required="yes" />

        <xsl:variable name="nodeName" select="name($node)" as="xs:string" />
        <xsl:variable name="abbreviatedName" select="bpelviz:abbreviateNode($nodeName)" as="xs:string" />

        <xsl:choose>
            <xsl:when test="not($node = $node/..)">
                <xsl:value-of select="concat(bpelviz:deriveIdentifier($node/..), '>', $abbreviatedName)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$abbreviatedName" /></xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xsl:function name="bpelviz:abbreviateNode">
        <xsl:param name="node" as="xs:string" required="yes"/>

        <xsl:choose>
            <!-- conversion patterns are presented here -->
            <xsl:when test="$node = 'compensationHandler'">CH</xsl:when>
            <xsl:when test="$node = 'else'">else</xsl:when>
            <xsl:when test="$node = 'elseif'">elif</xsl:when>
            <xsl:when test="$node = 'eventHandlers'">EH</xsl:when>
            <xsl:when test="$node = 'faultHandlers'">FH</xsl:when>
            <xsl:when test="$node = 'flow'">fw</xsl:when>
            <xsl:when test="$node = 'forEach'">fe</xsl:when>
            <xsl:when test="$node = 'onAlarm'">oA</xsl:when>
            <xsl:when test="$node = 'onEvent'">oE</xsl:when>
            <xsl:when test="$node = 'onMessage'">oM</xsl:when>
            <xsl:when test="$node = 'pick'">pi</xsl:when>
            <xsl:when test="$node = 'process'">pr</xsl:when>
            <xsl:when test="$node = 'repeatUntil'">ru</xsl:when>
            <xsl:when test="$node = 'scope'">sc</xsl:when>
            <xsl:when test="$node = 'sequence'">sq</xsl:when>
            <xsl:when test="$node = 'terminationHandler'">TH</xsl:when>
            <xsl:when test="$node = 'while'">w</xsl:when>

            <!-- use name of node when no specific conversion rule is available -->
            <xsl:otherwise><xsl:value-of select="$node" /></xsl:otherwise>
        </xsl:choose>

    </xsl:function>

</xsl:stylesheet>