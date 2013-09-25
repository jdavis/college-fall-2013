import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Set;

public class Runner implements IScheduler {
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
            result.add(new Interval(i, r.nextInt() % n));
        }

        return result;
    }

    public static void main (String[] args) {
        long start, end, t;
        long[][] results;

        int[] inputLength = {
            1,
            2,
            4,
            8,
            16,
        };

        ArrayList<Set<IInterval>> fixtures = new ArrayList<Set<IInterval>>();


        IScheduler[] schedulers = {
            new BruteForceScheduler(),
        };

        String[] names = {
            "BruteForce",
        };

        results = new long[schedulers.length][inputLength.length];

        for (int i = 0; i < inputLength.length; i += 1) {
            fixtures.add(randomIntervals(inputLength[i]));
        }

        for (int i = 0; i < schedulers.length; i += 1) {
            for (int j = 0; j < fixtures.size(); j += 1) {

                start = System.nanoTime();
                schedulers[i].optimalSchedule(fixtures.get(j));
                end = System.nanoTime();

                results[i][j] = end - start;
            }
        }

        for (int i = 0; i < schedulers.length; i += 1) {
            System.out.println(names[i] + ": ");

            for (int j = 0; j < fixtures.size(); j += 1) {
                System.out.println("\tn = " + inputLength[j]);
                System.out.println("\ttime = " + results[i][j]);
            }
        }
    }
}
