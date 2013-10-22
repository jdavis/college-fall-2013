/**
 * PageFormat for packing in the Records.
 */
public class PackedPageFormat implements PageFormat {

    @Override
    public final byte[] writeRecords(final byte[][] recordBytes) {
        int length = 0;
        byte[] result;

        // Calculate the length of the entire Page
        for (int i = 0; i < recordBytes.length; i += 1) {
            length += recordBytes[i].length;
        }

        result = new byte[length];

        // Copy the bytes from the given Record bytes into the final byte array
        for (int i = 0, j = 0; i < recordBytes.length; i += 1) {
            // copyBytes(result, j, recordBytes[i]);
            j += recordBytes[i].length;
        }

        return result;
    }

    @Override
    public final byte[][] readRecords(final byte[] bytes,
            final int nRecords,
            final int recordLength) {
        byte[][] result = new byte[nRecords][recordLength];

        // Read the bytes from the given byte array into the corresponding
        // Record byte array
        for (int i = 0; i < recordBytes.length; i += 1) {
            // readBytes(result[i], bytes, i * recordLength, recordLength);
        }

        return result;
    }
}
