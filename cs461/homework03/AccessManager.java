public class AccessManager implements AccessManagerInterface {
    private Database db;
    private HashMap<String, Table> tables;
    private PageFormat pageFormat;
    private RecordFormat recordFormat;

    public AccessManager() {
        tables = new HashMap<String, Table>();
    }

    public void createTable(String tableName, Field[] fields) {
        Table table = new Table(fields);

        tables.put(tableName, table);
    }

    public boolean tableExists(String tableName) {
        return tables.contains(tableName);
    }

    public void deleteTable(String tableName) {
        Table table = tables.get(tableName);

        table.delete();

        // Remove from the list of tables
        tables.remove(tableName);
    }

    public Record readRecord(String tableName, int rid) {
        Table table = getTable(tableName);

        return table.readRecord(rid, recordFormat);
    }

    public void writeRecord(String tableName, int rid, Record record) {
        Table table = getTable(tableName);

        table.writeRecord(rid, record, recordFormat);
    }

    public void deleteRecord(String tableName, int rid) {
        Table table = getTable(tableName);

        table.deleteRecord(rid, recordFormat);
    }

    public void setRecordFormat(RecordFormat format) {
        recordFormat = format;
    }

    public void setPageFormat(PageFormat format) {
        pageFormat = format;
    }

    public void close() {
        // Write all schema and mapping from records to pages to the first
        // Page.
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ObjectOutputStream serializer = new ObjectOutputStream(out);
        serializer.writeObject(tables);
        serializer.close();


    }

    private Table getTable(String name) {
        Table table = tables.get(tableName);

        if (table == null) {
            throw DBMSException("Table " + tableName + " does not exist.")
        }

        return table;
    }
}
