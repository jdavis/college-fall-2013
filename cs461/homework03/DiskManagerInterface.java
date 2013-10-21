public interface DiskManagerInterface {
    public interface Page {
    
    }

    void allocatePage();
    void deletePage(int pid);
    void writePage(int pid, Object page);
    void readRecord(int pid);
}
