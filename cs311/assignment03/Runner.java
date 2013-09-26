import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Set;
import java.lang.Math;

public class Runner implements IScheduler {
    /** Number of times to run the schedulers. */
    public static final int ROUNDS = 10000;

    /** Number of times to run the schedulers. */
    public static final int INPUT_MULTIPLIER = 2;

    /** Number of times to run the schedulers. */
    public static final int MULTIPLIER_LIMIT = 4;

    /** Number of nanoseconds in a second. */
    public static final double NANOS = 1000000000.0;

    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        return null;
    }

    static class Interval implements IInterval {
        private int startTime, endTime;

        public Interval(int start, int end) {
            startTime = start;
            endTime = end;
        }

        public int getStartTime() {
            return startTime;
        }
        public int getEndTime() {
            return endTime;
        }

        public String toString() {
            return "Interval: [" + startTime + " - " + endTime + "]";
        }
    }

    public static Set<IInterval> randomIntervals(int n) {
        HashSet<IInterval> result = new HashSet<IInterval>();
        Random r = new Random();

        for (int i = 0; i < n; i += 1) {
            result.add(new Interval(i, r.nextInt(n)));
        }

        return result;
    }

    public static void main(String[] args) {
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


        for (int r = 0; r < ROUNDS; r += 1) {

            // Empty all the fixtures for the new round
            fixtures.clear();

            // Create new fixtures
            for (int i = 0; i < MULTIPLIER_LIMIT; i += 1) {
                int n = (int) Math.pow(INPUT_MULTIPLIER, i);

                fixtures.add(randomIntervals(n));
            }

            // Run each scheduler for all the new fixtures
            for (int i = 0; i < fixtures.size(); i += 1) {
                for (int j = 0; j < schedulers.length; j += 1) {

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

        System.out.format("%1$20s |", "n");

        for (int i = 0; i < names.length; i += 1) {
            System.out.format("%1$20s |", names[i]);
        }

        for (int i = 0; i < names.length; i += 1) {
            System.out.format("%1$20s |", (names[i] + " Growth"));
        }

        System.out.print("\n");

        for (int i = 0; i < fixtures.size(); i += 1) {
            int n = (int) Math.pow(INPUT_MULTIPLIER, i);
            System.out.format("%1$20d |", n);

            for (int j = 0; j < schedulers.length; j += 1) {
                System.out.format("%1$20d |", results[i][j]);
            }

            if (i > 0) {
                for (int j = 0; j < schedulers.length; j += 1) {
                    System.out.format("%1$20.6g |", (double) results[i][j] / results[i - 1][j]);
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
