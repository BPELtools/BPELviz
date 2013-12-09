# BPELviz

*BPELviz* visualizes [WS-BPEL 2.0] processes interactively with HTML5.

## Building

We use [Sass] to generate the CSS.
We keep the compiled `.css` file in the repository to enable a quick start with the renderer.

## License

[MIT License]

  [WS-BPEL 2.0]: http://docs.oasis-open.org/wsbpel/2.0/wsbpel-v2.0.html
  [MIT License]: http://opensource.org/licenses/MIT
  [Sass]: http://sass-lang.com
  [saxon]: http://saxon.sourceforge.net/

## Installation

    [manual] make sure that JAVA_HOME points to local jdk folder
    $ git clone https://github.com/koppor/BPELviz
    $ cd BPELviz
    $ gradlew installApp
    [manual] add build/install/textools/bin to PATH

## Usage

    usage: BPELviz [options] BPEL_FILE [HTML_FILE]
     -o,--open-in-browser   opens html file in default browser

    # Examples
    $ BPELviz -o example.bpel # opens the html5 of example.bpel in default browser
    $ BPELviz example.bpel example.html # creates example.html from example.bpel
    $ BPELviz -o example.bpel example.html # creates example.html from example.bpel and opens it in default browser
