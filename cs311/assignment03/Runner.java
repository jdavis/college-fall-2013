import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
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

    public static void main (String[] args) {
        System.out.println("Testing");

        HashSet<IInterval> s = new HashSet<IInterval>();

        BruteForceScheduler scheduler = new BruteForceScheduler();

        s.add(new Interval(0, 4));
        s.add(new Interval(3, 6));
        s.add(new Interval(6, 7));

        Set<IInterval> result = scheduler.optimalSchedule(s);

        System.out.println("Optimal = " + result);
    }
}
