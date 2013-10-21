public interface Page {
    void setPageID(int pid);
    int getPageID();
    void setPageFormat(PageFormat format);
    int countRecords();
    int maxRecords();
    boolean isFull();
    boolean containsRecord(int rid);
    Record retrieveRecord(int rid);
}
