package bpelviz;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

/**
 * Creates the html5 visualization of a bpel file.
 */
public class BPELViz {

    public static final String BPELVIZ_CSS = "BPELviz.css";
    public static final String BPELVIZ_JS = "BPELviz.js";

    public void bpel2html(Path bpelFile, Path htmlFile) throws BPELVizException {
        try {
            createTransformer().transform(new StreamSource(bpelFile.toFile()), new StreamResult(htmlFile.toFile()));
        } catch (TransformerException e) {
            throw new BPELVizException(e);
        }

        try {
            Files.copy(BPELViz.class.getResourceAsStream("/" + BPELVIZ_CSS), htmlFile.getParent().resolve(BPELVIZ_CSS), StandardCopyOption.REPLACE_EXISTING);
            Files.copy(BPELViz.class.getResourceAsStream("/" + BPELVIZ_JS), htmlFile.getParent().resolve(BPELVIZ_JS), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new BPELVizException("Could not copy css/js file", e);
        }
    }

    private Transformer createTransformer() throws TransformerConfigurationException {
        Templates templates = createTemplates();
        return templates.newTransformer();
    }

    private Templates createTemplates() throws TransformerConfigurationException {
        Source xsltSource = new StreamSource(BPELViz.class.getResourceAsStream("/bpel2html.xsl"));
        TransformerFactory transFact = TransformerFactory.newInstance();
        transFact.setURIResolver(new URIResolver() {
            @Override
            public Source resolve(String href, String base) throws TransformerException {
                return new StreamSource(BPELViz.class.getResourceAsStream("/" + href));
            }
        });
        return transFact.newTemplates(xsltSource);
    }

}
