import java.util.Set;

/**
 * Interface for creating a scheduler.
 */
public interface IScheduler {
    /**
     * Internal interface for an Interval.
     */
    public interface IInterval {
        /**
         * Return the start time.
         * @return The start time
         */
        int getStartTime();

        /**
         * Return the end time.
         * @return The end time
         */
        int getEndTime();
    }

    /**
     * Determines the optimal schedule based on the intervals given.
     * @param s Set of intervals to look through
     * @return Set that contains the optimal intervals
     */
    Set<IInterval> optimalSchedule(Set<IInterval> s);
}
