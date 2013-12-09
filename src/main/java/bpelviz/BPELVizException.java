package bpelviz;

public class BPELVizException extends RuntimeException {

    public BPELVizException() {
    }

    public BPELVizException(String message) {
        super(message);
    }

    public BPELVizException(String message, Throwable cause) {
        super(message, cause);
    }

    public BPELVizException(Throwable cause) {
        super(cause);
    }

    public BPELVizException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
