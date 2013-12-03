import TwoPhaseLock.TwoPhaseLockState;

/**
 * Basic class that represents the Object manager.
 */
public class ObjectManager {
    /** Database manager that we read from. */
    private DatabaseManager dbManager;

    /** Hashmap that represents each transaction lock. */
    private HashMap<Object, TwoPhaseLock> locks;

    /** Hashmap that represents a list of holders for the given object. */
    private HashMap<Object, List<Integer>> holders;

    /** Hashmap that represents objects being held by each transaction. */
    private HashMap<Integer, List<Object>> heldObjects;

    /**
     * Hashmap that represents a list of suspended transactions for the given
     * object.
     */
    private HashMap<Object, List<Integer>> suspended;

    /** Construct our ObjectManager. */
    public ObjectManager() {
        dbManager = new DatabaseManager();
        locks = new HashMap<Object, TwoPhaseLock>();
        holders = new HashMap<Object, List<Integer>>();
        suspended = new HashMap<Object, List<Integer>>();
    }

    /**
     * Called when a transaction wishes to read an object.
     *
     * @param tid ID of the transaction
     * @param o Object to write
     * @return Object values that was read or null if read was blocked.
     */
    public Object read(final int tid, final Object o) {
        List<Integer> holds;
        List<Integer> suspends;
        Object result;

        TwoPhaseLock lock = locks.get(o);

        // No reading going on, init all objects
        if (lock == null) {
            locks.put(o, new TwoPhaseLock());
            holders.put(o, new ArrayList<Integer>());
            suspended.put(o, new ArrayList<Integer>());
        }

        TwoPhaseLockState state = lock.getState();

        if (state == TwoPhaseLockState.EXCLUSIVE) {
            // Add ourselves to the suspenders
            suspenders.get(o).add(tid);

            // Null because read was blocked
            return null;
        } else if (state == TwoPhaseLockState.SHARED) {
            // Add ourselves to the holding list
            holders.get(o).add(tid);
        } else {
            // Set it to shared since we are reading
            lock.setState(TwoPhaseLockState.SHARED);
        }

        // Read and return our object
        return dbManager.read(o);
    }

    /**
     * Called when a transaction wishes to write an object.
     *
     * @param tid ID of the transaction
     * @param o Object to write
     * @return True if the write was allowed, false if it was blocked
     */
    public boolean write(final int tid, final Object o) {
        List<Integer> holds;
        List<Integer> suspends;
        Object result;

        TwoPhaseLock lock = locks.get(o);

        // No writing going on, init all objects
        if (lock == null) {
            locks.put(o, new TwoPhaseLock());
            holders.put(o, new ArrayList<Integer>());
            suspended.put(o, new ArrayList<Integer>());
        }

        TwoPhaseLockState state = lock.getState();

        if (state == TwoPhaseLockState.EXCLUSIVE) {
            // Add ourselves to the suspenders
            suspenders.get(o).add(tid);

            // False because write was blocked
            return false;
        } else if (state == TwoPhaseLockState.SHARED) {
            // Add ourselves to the suspenders
            suspenders.get(o).add(tid);

            // False because write was blocked
            return false;
        } else {
            // Set it to shared since we are writing
            lock.setState(TwoPhaseLockState.EXCLUSIVE);
        }

        // Write our object and be done!
        dbManager.write(o);

        return true;
    }

    /**
     * Called when a transaction wishes to commit.
     *
     * @param tid ID of the transaction
     */
    public void commit(final int tid) {
        for (Object o : heldObjects.get(tid)) {
            // Release all object locks for the given transaction
        }
    }

    /**
     * Called when a transaction wishes to abort.
     *
     * @param tid ID of the transaction
     */
    public void abort(final int tid) {
        for (Object o : heldObjects.get(tid)) {
            // Release all object locks for the given transaction
        }
    }
}
