import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Set;
import java.util.PriorityQueue;

/**
 * Iterates over the complete set of intervals, starting with the longest
 * subset.
 *
 * Once it finds the first subset that doesn't conflict, it returns it.
 */
public class SmartBruteForceScheduler extends BruteForceScheduler {
    /** Default size for the priority queue. */
    private static final int DEFAULT_SIZE = 11;

    /**
     * Create a new scheduler.
     */
    public SmartBruteForceScheduler() {
        mSubsets = new PriorityQueue<Set<IInterval>>(
                DEFAULT_SIZE,
                new Comparator<Set<IInterval>>() {
            @Override
            public int compare(final Set<IInterval> s1,
                final Set<IInterval> s2) {
                return s2.size() - s1.size();
            }
        });
    }

    public Set<IInterval> optimalSchedule(final Set<IInterval> s) {
        mSubsets.clear();
        Iterator<Set<IInterval>> subsets = generateSubsets(s);

        while (subsets.hasNext()) {
            Set<IInterval> subset = subsets.next();

            if (conflicts(subset) == false) {
                return subset;
            }
        }

        return Collections.emptySet();
    }
}
