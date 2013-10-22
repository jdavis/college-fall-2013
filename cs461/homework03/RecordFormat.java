/**
 * Interface for serializing a Record.
 */
public interface RecordFormat {
    /**
     * Writes a Record to a byte array.
     * @param record Record to write.
     * @return Array of bytes.
     */
    byte[] writeRecord(final Record record);

    /**
     * Reads a Record from an array of bytes.
     * @param fields Fields to look for.
     * @param bytes Array of bytes to read.
     * @return Record that was read.
     */
    Record readRecord(final Field[] fields, final byte[] bytes);
}
