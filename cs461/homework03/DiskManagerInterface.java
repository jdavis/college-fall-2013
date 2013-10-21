public interface DiskManagerInterface {
    void allocatePage();
    void deletePage(int pid);
    void writePage(int pid, Object page);
    void readPage(int pid);
}
