public class AccessManager implements AccessManagerInterface {
    private Database db;
    private ArrayList<Table>[] tables;
    private PageFormat pFormat;
    private RecordFormat rFormat;

    public AccessManager() {
        tables = new ArrayList<Table>();
    }

    Table createTable(String tableName, Field[] fields) {

    }

    boolean deleteTable(String tableName);
    Record readRecord(String tableName, int rid);
    boolean writeRecord(String tableName, int rid, Record record);
    boolean deleteRecord(String tableName, int rid);
    void setRecordFormat(RecordFormat format);
    void setPageFormat(PageFormat format);
}
