public interface AccessManagerInterface {
    boolean createTable(Object db, String tableName, Object[] fields);
    Object readRecord(Object db, String tableName, int rid);
    boolean writeRecord(Object db, String tableName, int rid);
    boolean deleteRecord(Object db, String tableName, int rid);
    boolean append(Object db, String tableName, Object record);
}
