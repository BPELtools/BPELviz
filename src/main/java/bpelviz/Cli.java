package bpelviz;

import org.apache.commons.cli.*;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

/**
 * The parameters for the cli.
 */
public class Cli {

    private Options options;
    private CommandLine cmd;

    public Cli(String[] args) {
        options = new Options();
        options.addOption("o", "open-in-browser", false, "opens html file in default browser");

        CommandLineParser parser = new BasicParser();

        try {
            cmd = parser.parse(options, args);
        } catch (ParseException e) {
            printUsageAndExit("Internal error (" + e.getMessage() + ")");
        }

        validate();
    }

    public void validate() {
        if (cmd.getArgList().isEmpty()) {
            printUsageAndExit("No bpel file given as input");
        }

        if (!Files.isRegularFile(getBpelFile())) {
            printUsageAndExit("Given bpel file " + getBpelFile() + " is no regular file");
        }

        if (!Files.exists(getBpelFile())) {
            printUsageAndExit("Given bpel file " + getBpelFile() + " does not exists");
        }

        if (!getBpelFile().toString().endsWith(".bpel")) {
            printUsageAndExit("Given file " + getBpelFile() + " is no bpel file");
        }

        if (!Files.isRegularFile(getHtmlFile())) {
            printUsageAndExit("Given bpel file " + getBpelFile() + " is no regular file");
        }

        if (!getHtmlFile().toString().endsWith(".html")) {
            printUsageAndExit("Given file " + getHtmlFile() + " is no html file");
        }
    }

    public Path getHtmlFile() {
        if (cmd.getArgs().length == 2) {
            return Paths.get(cmd.getArgs()[1]);
        } else {
            Path bpelFile = getBpelFile().toAbsolutePath();
            String bpelFileName = bpelFile.getFileName().toString();
            String htmlFileName = bpelFileName.replace(".bpel", ".html");
            return bpelFile.getParent().resolve(htmlFileName);
        }
    }

    public boolean openHtmlInBrowser() {
        return cmd.hasOption("o");
    }

    private void printUsageAndExit(String message) {
        System.err.println("Error: " + message);
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("BPELviz [options] BPEL_FILE [HTML_FILE]", options);
        System.exit(-1);
    }

    public Path getBpelFile() {
        Object first = cmd.getArgList().get(0);
        return Paths.get(first.toString());
    }
}
