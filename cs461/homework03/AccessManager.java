/**
 * Main interface to the DBMS.
 */
public class AccessManager implements AccessManagerInterface {
    /** Name of the database. */
    private String dbName;

    /** List of tables in the database. */
    private HashMap<String, Table> tables;

    /** The PageFormat to use when placing a Record into a Page. */
    private PageFormat pageFormat;

    /** The RecordFormat to use when writing a Record. */
    private RecordFormat recordFormat;

    /**
     * Creates a new AccessManager.
     * @param givenDbName Database info to access.
     * @param givenPageFormat PageFormat to access.
     * @param givenRecordFormat RecordFormat to access.
     */
    public AccessManager(final String givenDbName,
            final PageFormat givenPageFormat,
            final RecordFormat givenRecordFormat) {
        // Read in all the information from the first Page
        Page page = DiskManager.readPage(0);

        //
        // Here we would read in all the serialized information regarding the
        // database schema such as the list of tables in the database which
        // contains all the mapping information and so on...
        //

        // Assign constructor values
        dbName = givenDbName;
        pageFormat = givenPageFormat;
        recordFormat = givenRecordFormat;
    }

    /**
     * Creates a new Table.
     * @param tableName Name of the new table.
     * @param fields Array of Fields to use.
     */
    public final void createTable(final String tableName,
            final Field[] fields) {
        Table table = new Table(fields, pageFormat, recordFormat);

        tables.put(tableName, table);
    }

    /**
     * Checks whether a table exists in the database.
     * @param tableName Name of the table.
     * @return True or false depending on the existence of the table.
     */
    public final boolean tableExists(final String tableName) {
        return tables.contains(tableName);
    }

    /**
     * Deletes a table.
     * @param tableName Name of the table to delete.
     * @throws DBMSException on any error.
     */
    public final void deleteTable(final String tableName) throws DBMSException {
        Table table = getTable(tableName);

        table.delete();

        // Remove from the list of tables
        tables.remove(tableName);
    }

    /**
     * Reads and returns a record.
     * @param tableName Name of the table to search.
     * @param rid Record ID to read.
     * @return The record that matches the ID given.
     * @throws DBMSException on any error.
     */
    public final Record readRecord(final String tableName,
            final int rid) throws DBMSException {
        Table table = getTable(tableName);

        return table.readRecord(rid);
    }

    /**
     * Writes a given Record to its Table.
     * @param tableName Name of the table.
     * @param rid ID of the Record.
     * @param record Record to write.
     * @throws DBMSException on any error.
     */
    public final void writeRecord(final String tableName,
            final int rid,
            final Record record) throws DBMSException {
        Table table = getTable(tableName);

        table.writeRecord(rid, record);
    }

    /**
     * Deletes a record.
     * @param tableName Name of the table.
     * @param rid Record ID to delete.
     * @throws DBMSException on any error.
     */
    public final void deleteRecord(final String tableName,
            final int rid) throws DBMSException {
        Table table = getTable(tableName);

        table.deleteRecord(rid);
    }

    /**
     * Sets the RecordFormat when serializing it.
     * @param format RecordFormat to use.
     */
    public final void setRecordFormat(final RecordFormat format) {
        recordFormat = format;
    }

    /**
     * Sets the PageFormat for when saving a Record to a Page.
     * @param format PageFormat to use.
     */
    public final void setPageFormat(final PageFormat format) {
        pageFormat = format;
    }

    /**
     * Closes the database to ensure everything is saved.
     */
    public final void close() {
        // Write all schema and mapping from records to pages to the first
        // Page.
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ObjectOutputStream serializer = new ObjectOutputStream(out);

        // Contains mapping from Database to Tables
        serializer.writeObject(db);

        // Contains mapping from Tables to Pages + Field info
        serializer.writeObject(tables);

        // Close serializer
        serializer.close();

        // Read the first Page into memory.
        Page page = DiskManager.readPage(0);

        // Write the Database information to it
        page.writeBytes(out.toByteArray());

        // Write it back to disk
        DiskManager.writePage(0, page);

        // Clean up
        out.close();
    }

    /**
     * Helper to check if a table exists and return it.
     * @param name Name of the table.
     * @return Table that matches.
     * @throws DBMSException on any error.
     */
    private Table getTable(final String name) throws DBMSException {
        Table table = tables.get(tableName);

        if (table == null) {
            throw DBMSException("Table " + tableName + " does not exist.");
        }

        return table;
    }
}
