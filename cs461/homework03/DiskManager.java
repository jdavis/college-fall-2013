/**
 * Class that abstracts away the disk management operations.
 */
public static class DiskManager {
    /**
     * Creates and returns a new Page.
     * @return The new Page.
     */
    final Page createPage() {
        return null;
    }

    /**
     * Deletes a Page.
     * @param pid Page id to delete.
     */
    final void deletePage(final int pid) { }

    /**
     * Write a Page to disk.
     * @param pid Page ID to write.
     * @param page Page to write.
     */
    final void writePage(final int pid, final Page page) { }

    /**
     * Reads a Page from disk.
     * @param pid Page ID to read.
     * @return Page that was read.
     */
    final Page readPage(final int pid) {
        return null;
    }
}
