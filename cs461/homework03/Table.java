/**
 * Table class for DBMS.
 *
 * Abstracts away some of the Table management features from the AccessManager.
 */
public class Table {
    /** List of Fields in the Table. */
    private Fields[] fields;

    /** Mapping from Record ID to Page ID. */
    private HashMap<Integer, Integer> recordToPage;

    /** The PageFormat to use when placing a Record into a Page. */
    private PageFormat pageFormat;

    /** The RecordFormat to use when writing a Record. */
    private RecordFormat recordFormat;

    /** Array of all the full Page IDs. */
    private ArrayList<Integer> fullPages;

    /** Array of all the full Page IDs. */
    private ArrayList<Integer> nonFullPages;

    /**
     * Creates a new Table.
     * @param givenFields Fields to create.
     * @param givenPageFormat PageFormat to use.
     * @param givenRecordFormat RecordFormat to use.
     */
    public Table(final Fields[] givenFields,
            final PageFormat givenPageFormat,
            final RecordFormat givenRecordFormat) {
        // Set the values
        fields = givenFields;
        pageFormat = givenPageFormat;
        recordFormat = givenRecordFormat;
    }

    /**
     * Deletes all the Pages being used up by the Table.
     */
    public final void delete() {
        // Iterate over all the Pages, deleting them one by one
        for (Integer pid : recordToPage.values()) {
            DiskManager.deletePage(pid);
        }
    }

    /**
     * Reads a Record from the Table.
     * @param rid Record ID to read.
     * @return Record that was read.
     * @throws DBMSException on any error.
     */
    public final Record readRecord(final int rid) throws DBMSException {
        if (recordToPage.contains(rid)) {
            int pid = recordToPage.get(rid);

            Page page = DiskManager.readPage(pid);

            page.setPageFormat(pageFormat);
            page.setRecordFormat(recordFormat);

            return page.retrieveRecord(rid);
        }

        throw DBMSException("Table does not contain record " + rid);
    }

    /**
     * Writes a given Record to the Table.
     * @param rid Record ID to write.
     * @param record Record object to write.
     */
    public final void writeRecord(final int rid, final Record record) {
        Page page;

        if (recordToPage.contains(rid)) {
            int pid = recordToPage.get(rid);

            page = DiskManager.readPage(pid);

            page.setPageFormat(pageFormat);
            page.setRecordFormat(recordFormat);

            page.writeRecord(record);
        } else {
            // We need a Page with space
            page = nextAvailablePage();

            page.setPageFormat(pageFormat);
            page.setRecordFormat(recordFormat);

            // Save the Record to the Page
            page.writeRecord(record);

            // Store location of the Record
            recordToPage.put(rid, page.getPageID());
        }

        // Update our Heap of Pages
        if (page.isFull()) {
            nonFullPages.remove(page);
            fullPages.add(page);
        }
    }

    /**
     * Deletes a Record from the Table.
     * @param rid Record ID to delete.
     */
    public final void deleteRecord(final int rid) {
        if (!recordToPage.contains(rid)) {
            throw DBMSException("Table does not contain record " + rid);
        }

        // Find out where the Record is
        int pid = recordToPage.get(rid);

        // Read the Page from disk
        Page page = DiskManager.readPage(pid);

        page.setPageFormat(pageFormat);
        page.setRecordFormat(recordFormat);

        // Delete the Record
        page.deleteRecord(rid);

        // Update our mapping
        recordToPage.remove(rid);
    }

    /**
     * Helper method to get the next available Page with space.
     * @return Page with space.
     */
    private Page nextAvailablePage() {
        for (Integer pid : nonFullPages) {
            Page page = DiskManager.readPage(pid);

            page.setPageFormat(pageFormat);
            page.setRecordFormat(recordFormat);

            if (!page.isFull()) {
                return page;
            }
        }

        throw DBMSException("Table is full.");
    }
}
