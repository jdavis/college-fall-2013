/**
 * Page class for DBMS.
 */
public class Page {
    /** Page ID. */
    private int pid;

    /** Size of the Page. */
    private int pageSize;

    /** Page Format. */
    private PageFormat pageFormat;

    /** Record Format. */
    private RecordFormat recordFormat;

    /** Number of Records. */
    private int nRecords;

    /** Length of a Record. */
    private int recordLength;

    /** Given data. */
    private byte[] data;

    /** Records in the Page. */
    private Records[] records;

    /** Fields in each Record. */
    private Fields[] fields;

    /**
     * Creates a Page.
     * @param givenFields Fields of the Record.
     * @param givenData Data to initialize with.
     */
    public Page(final Field[] givenFields, final byte[] givenData) {
        fields = givenFields;
        data = givenData;

        byte[][] recordBytes = pageFormat.readRecords(data, nRecords, recordLength);

        records = new Records[recordBytes.length];
        for (int i = 0; i < recordBytes.length; i += 1) {
            Record record = recordFormat.readRecord(fields, recordBytes[i]);
            records[i] = record;
        }
    }

    /**
     * Set the Page ID.
     * @param givenPid New Page ID.
     */
    public final void setPageID(final int givenPid) {
        pid = givenPid;
    }

    /**
     * Getter for the Page ID.
     * @return The Page ID.
     */
    public final int getPageID() {
        return pid;
    }

    /**
     * Sets the PageFormat.
     * @param format PageFormat to set.
     */
    public final void setPageFormat(final PageFormat format) {
        pageFormat = format;
    }

    /**
     * Sets the RecordFormat.
     * @param format RecordFormat to set.
     */
    public final void setRecordFormat(final RecordFormat format) {
        recordFormat = format;
    }

    /**
     * Return the number of records in the Page.
     * @return Number of records.
     */
    public final int countRecords() {
        return nRecords;
    }

    /**
     * Returns if the Record is full or not.
     * @return True or False depending on full.
     */
    public final boolean isFull() {
        int count = 0;

        for (int i = 0; i < recordBytes.length; i += 1) {
            count += recordBytes[i].length;
        }

        if (count + recordLength > pageSize) return false;
        else return true;
    }

    /**
     * Retrieve the given Record ID.
     * @param rid Record ID.
     * @return Record with the given Record ID.
     */
    public final Record retrieveRecord(final int rid) {
        for (Record record : records) {
            if (record.getRecordID() == rid) {
                return record;
            }
        }

        throw DBMSException("Table does not contain record " + rid);
    }
}
