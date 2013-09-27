import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

/**
 * Runs all the schedulers.
 */
public class Runner implements IScheduler {
    /** Number of times to run the schedulers. */
    public static final int ROUNDS = 10000;

    /** Factor to multiply the input by. */
    public static final int INPUT_MULTIPLIER = 2;

    /** Limit to how many times to multiply the input. */
    public static final int MULTIPLIER_LIMIT = 4;

    final public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        return null;
    }

    /**
     * Basic interval class.
     */
    static class Interval implements IInterval {
        /** Start and end times. */
        private int startTime, endTime;

        /**
         * Create a interval with given parameters.
         * @param start Start time of the interval
         * @param end End time of the interval
         */
        public Interval(final int start, final int end) {
            startTime = start;
            endTime = end;
        }

        /**
         * Getter for the start time.
         * @return Start time
         */
        public int getStartTime() {
            return startTime;
        }

        /**
         * Getter for the end time.
         * @return End time
         */
        public int getEndTime() {
            return endTime;
        }

        @Override
        public String toString() {
            return "Interval: [" + startTime + " - " + endTime + "]";
        }
    }

    /**
     * Create a random set of intervals.
     * @param n Input size
     * @return Set with n random intervals
     */
    public static Set<IInterval> randomIntervals(final int n) {
        HashSet<IInterval> result = new HashSet<IInterval>();
        Random r = new Random();

        for (int i = 0; i < n; i += 1) {
            result.add(new Interval(i, r.nextInt(n)));
        }

        return result;
    }

    /**
     * Create a "bad" set of intervals.
     *
     * It will always require checking all the subsets.
     *
     * @param n Input size
     * @return Set with n random intervals
     */
    public static Set<IInterval> badIntervals(final int n) {
        HashSet<IInterval> result = new HashSet<IInterval>();
        Random r = new Random();

        for (int i = 0; i < n; i += 1) {
            result.add(new Interval(0, n));
        }

        return result;
    }

    public static void main(final String[] args) {
        long start, end, t;
        long[][] results;

        ArrayList<Set<IInterval>> fixtures = new ArrayList<Set<IInterval>>();

        IScheduler[] schedulers = {
            new BruteForceScheduler(),
            new SmartBruteForceScheduler(),
            new EarliestDeadlineScheduler(),
        };

        String[] names = {
            "Brute",
            "Smart",
            "Earliest",
        };

        results = new long[MULTIPLIER_LIMIT][schedulers.length];

        //
        // Run each scheduler ROUNDS times for each set of intervals.
        //

        for (int r = 0; r < ROUNDS; r += 1) {

            // Empty all the fixtures for the new round
            fixtures.clear();

            // Create new fixtures
            for (int i = 0; i < MULTIPLIER_LIMIT; i += 1) {
                int n = (int) Math.pow(INPUT_MULTIPLIER, i);

                if (i == MULTIPLIER_LIMIT) {
                    fixtures.add(badIntervals(n));
                } else {
                    fixtures.add(randomIntervals(n));
                }
            }

            // Run each scheduler for all the new fixtures
            for (int i = 0; i < fixtures.size(); i += 1) {
                for (int j = 0; j < schedulers.length; j += 1) {
                    // Determine how long it ran
                    Set<IInterval> fixture = fixtures.get(i);
                    start = System.nanoTime();
                    schedulers[j].optimalSchedule(fixture);
                    end = System.nanoTime();
                    t = end - start;

                    // Continued average for each round
                    results[i][j] = (results[i][j] + t) / 2;
                }
            }
        }

        //
        // Column headers
        //

        System.out.format("%1$20s |", "n");

        for (int i = 0; i < names.length; i += 1) {
            System.out.format("%1$20s |", names[i]);
        }

        for (int i = 0; i < names.length; i += 1) {
            System.out.format("%1$20s |", (names[i] + " Growth"));
        }

        System.out.print("\n");

        //
        // Print the results into a nice table
        //

        for (int i = 0; i < fixtures.size(); i += 1) {
            int n = (int) Math.pow(INPUT_MULTIPLIER, i);
            System.out.format("%1$20d |", n);

            for (int j = 0; j < schedulers.length; j += 1) {
                System.out.format("%1$20d |", results[i][j]);
            }

            if (i > 0) {
                for (int j = 0; j < schedulers.length; j += 1) {
                    double d = results[i][j] / results[i - 1][j];
                    System.out.format("%1$20.6g |", d);
                }
            } else {
                for (int j = 0; j < schedulers.length; j += 1) {
                    System.out.format("%1$20s |", "DNE");
                }
            }

            System.out.print("\n");
        }
    }
}
