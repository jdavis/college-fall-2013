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
     * @return Object values that was read
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
            // Wait until the lock is released
            while ((state = lock.getState()) == TwoPhaseLockState.EXCLUSIVE);
        }

        if (state == TwoPhaseLockState.NONE) {
            // Set it to shared since we are reading
            lock.setState(TwoPhaseLockState.SHARED);
        }

        // Read our object
        result = dbManager.read(o);

        // Finish reading
        lock = locks.get(o);
        holds = holders.get(o);
        suspends = suspenders.get(o);

        if (holds.size() == 0 && suspends.size() == 0) {
            locks.remove(o);
            holders.remove(o);
            suspenders.remove(o);
        } else if (holds.size() == 0) {
            lock.setState(TwoPhaseLockState.NONE);
        }

        return result;
    }

    /**
     * Called when a transaction wishes to write an object.
     *
     * @param tid ID of the transaction
     * @param o Object to write
     */
    public void write(final int tid, final Object o) {
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
            // Wait until the lock is released
            while ((state = lock.getState()) != TwoPhaseLockState.EXCLUSIVE);
        }

        if (state == TwoPhaseLockState.NONE) {
            // Set it to shared since we are reading
            lock.setState(TwoPhaseLockState.SHARED);
        }

        // Read our object
        result = dbManager.read(o);

        // Finish reading
        lock = locks.get(o);
        holds = holders.get(o);
        suspends = suspenders.get(o);

        if (holds.size() == 0 && suspends.size() == 0) {
            locks.remove(o);
            holders.remove(o);
            suspenders.remove(o);
        } else if (holds.size() == 0) {
            lock.setState(TwoPhaseLockState.NONE);
        }

        return result;
    }

    /**
     * Called when a transaction wishes to commit.
     *
     * @param tid ID of the transaction
     */
    public void commit(final int tid) {

    }

    /**
     * Called when a transaction wishes to abort.
     *
     * @param tid ID of the transaction
     */
    public void abort(final int tid) {

    }
}
