import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.PriorityQueue;
import java.util.Set;

/**
 * Iterates over the complete set of intervals, starting with the longest
 * subset.
 *
 * Once it finds the first subset that doesn't conflict, it returns it.
 */
public class SmartBruteForceScheduler implements IScheduler {
    /** Default size for the priority queue. */
    private static final int DEFAULT_SIZE = 11;

    /**
     * Determines if a set of intervals is conflicting.
     * @param s Set of intervals to compare
     * @return Boolean if conflicting
     */
    protected final boolean conflicts(final Set<IInterval> s) {
        IInterval[] intervals = s.toArray(new IInterval[0]);

        Arrays.sort(intervals, new Comparator<IInterval>() {
            @Override
            public int compare(final IInterval i1, final IInterval i2) {
                return i1.getEndTime() - i2.getEndTime();
            }
        });

        for (int i = 1; i < intervals.length; i += 1) {
            if (intervals[i - 1].getEndTime() > intervals[i].getStartTime()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Determines the optimal schedule based on the intervals given.
     *
     * Generates an optimal schedule by creating the subsets from biggest to
     * smallest and returning the first subset that doesn't have conflicts.
     *
     * It looks through them all and saving the subset with the most number of
     * intervals.
     *
     * @param s Set of intervals to look through
     * @return Set that contains the optimal intervals
     */
    public Set<IInterval> optimalSchedule(final Set<IInterval> s) {
        PriorityQueue<Set<IInterval>> sets = new PriorityQueue<Set<IInterval>>(DEFAULT_SIZE,
                new Comparator<Set<IInterval>>() {
                    @Override
                    public int compare(final Set<IInterval> s1,
                        final Set<IInterval> s2) {
                        return s2.size() - s1.size();
                    }
                });

        Iterator<IInterval> intervals = s.iterator();

        sets.add(s);

        Set<Set<IInterval>> nextSets = new HashSet<Set<IInterval>>();
        IInterval i = intervals.next();

        while (!sets.isEmpty()) {
            Set<IInterval> subset = sets.poll();
            nextSets.add(subset);

            if (conflicts(subset) == false) {
                return subset;
            }

            // Add more to the priority queue
            if (sets.isEmpty()) {
                if (subset.size() == 0) break;

                Iterator<Set<IInterval>> iter = nextSets.iterator();

                while (iter.hasNext()) {
                    Set<IInterval> next = iter.next();
                    HashSet<IInterval> smaller = new HashSet<IInterval>();

                    smaller.addAll(next);
                    smaller.remove(i);
                    sets.add(smaller);
                }

                nextSets.clear();
                i = intervals.next();
            }
        }

        return Collections.emptySet();
    }
}
