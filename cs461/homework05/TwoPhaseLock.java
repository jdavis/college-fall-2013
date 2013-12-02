/**
 * Basic strict 2PL class.
 */
public class TwoPhaseLock {
    /**
     * Enum for the states that lock can be in.
     */
    public enum TwoPhaseLockState {
        /** Shared state for when reading. */
        SHARED,

        /** Exclusive state for when writing. */
        NONE,

        /** Empty state for the lock. */
        EXCLUSIVE,
    }

    /** Current state of the lock. */
    private TwoPhaseLockState mState;

    /** Basic constructor for TwoPhaseLock. */
    public TwoPhaseLock() {
        // Default state is NONE
        mState = TwoPhaseLockState.NONE;
    }

    /**
     * Getter for the lock state.
     *
     * @return State of the lock
     */
    public final synchronized TwoPhaseLockState getState() {
        return mState;
    }

    /**
     * Setter for the lock state.
     *
     * @param state State to set the lock to
     */
    public final synchronized void setState(final TwoPhaseLockState state) {
        mState = state;
    }
}
