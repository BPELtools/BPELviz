package bpelviz;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.commons.io.FileUtils;

public class BetsyTestVisualizer {

	private static final String BPEL = ".bpel";
	private static final String HTML = ".html";
	private static final Path SOURCE_DIR = Paths.get("betsy-tests");
	private static final Path TARGET_DIR = Paths
			.get("./betsy-test-visualizations");

	public static void main(String[] args) throws IOException, BPELVizException {
		createTargetDirectory();
		visualizeInDir(SOURCE_DIR);
	}

	private static void createTargetDirectory() throws IOException {
		FileUtils.deleteDirectory(TARGET_DIR.toFile());
		Files.createDirectory(TARGET_DIR);
	}

	private static void visualizeInDir(Path bpelDirectory) throws IOException,
			BPELVizException {
		for (Path path : Files.newDirectoryStream(bpelDirectory)) {
			if (Files.isDirectory(path)) {
				visualizeInDir(path);
			} else if (Files.isRegularFile(path)
					&& path.toString().endsWith(BPEL)) {
				visualize(path);
			}
		}
	}

	private static void visualize(Path bpelFile) throws BPELVizException {
		Path targetFilePath = deriveHtmlPath(bpelFile);
		new BPELViz().bpel2html(bpelFile, targetFilePath);
	}

	private static Path deriveHtmlPath(Path bpelFile) {
		String fileName = extractFileName(bpelFile);
		Path relativBpelPath = SOURCE_DIR.relativize(bpelFile);
		Path singleTargetDir = TARGET_DIR.resolve(relativBpelPath.getParent())
				.resolve(fileName);
		Path targetFilePath = singleTargetDir.resolve(fileName + HTML);
		return targetFilePath;
	}

	private static String extractFileName(Path path) {
		String fileName = path.getFileName().toString();
		return fileName.substring(0, fileName.length() - 5);
	}

}
