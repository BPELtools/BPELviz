package bpelviz;

import java.awt.*;
import java.nio.file.Path;

public class Main {

    public static void main(String[] args) throws BPELVizException {
        Cli cli = new Cli(args);

        Path bpelFile = cli.getBpelFile();
        Path htmlFile = cli.getHtmlFile();

        // main logic
        new BPELViz().bpel2html(bpelFile, htmlFile);

        // post actions
        if (cli.openHtmlInBrowser()) {
            try {
                Desktop.getDesktop().browse(htmlFile.toUri());
            } catch (Exception ignore) {
            }
        }
    }

}
