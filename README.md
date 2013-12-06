# BPEL Renderer (HTML5)

This project provides a rendering of [WS-BPEL 2.0] processes using html5 techniques.

## Building

We use [Sass] to generate the CSS.
We keep the compiled `.css` file in the repository to enable a quick start with the renderer.

## Using
Use a XSLST 2.0 transformer with `bpel2html.xsl` as transformation.
For instance with [saxon], issue following command line:
`java -cp libs\saxon9he.jar net.sf.saxon.Transform -t -s:test.bpel -xsl:bpel2html.xsl -o:test.html`

## License

[MIT License]

  [WS-BPEL 2.0]: http://docs.oasis-open.org/wsbpel/2.0/wsbpel-v2.0.html
  [MIT License]: http://opensource.org/licenses/MIT
  [Sass]: http://sass-lang.com
  [saxon]: http://saxon.sourceforge.net/
