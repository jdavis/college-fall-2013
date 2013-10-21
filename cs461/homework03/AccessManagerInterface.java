public interface AccessManagerInterface {
    Table createTable(String tableName, Object[] fields);
    boolean deleteTable(String tableName);
    Record readRecord(String tableName, int rid);
    boolean writeRecord(String tableName, int rid, Record record);
    boolean deleteRecord(String tableName, int rid);
    void setRecordFormat(RecordFormat format);
    void setPageFormat(PageFormat format);
}
