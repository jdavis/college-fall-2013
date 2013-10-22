/**
 * Interface for arranging a series of Records on a Page.
 */
public interface PageFormat {
    /**
     * Writes an array of Record bytes to a Page.
     * @param recordBytes Record to write.
     * @return Array of bytes.
     */
    byte[] writeRecord(final byte[][] recordBytes);

    /**
     * Reads Record bytes from an array of bytes.
     * @param bytes Array of bytes to read.
     * @return Array of Record bytes.
     */
    byte[][] readRecord(final byte[] bytes);
}
