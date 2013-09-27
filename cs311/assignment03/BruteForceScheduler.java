import java.util.Arrays;
import java.util.Collections;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * Iterates over the complete set of intervals, saving the most optimal one for
 * last.
 */
public class BruteForceScheduler implements IScheduler {
    /** Generated subsets. */
    protected Collection<Set<IInterval>> mSubsets;

    /**
     * Creates a scheduler.
     */
    public BruteForceScheduler() {
        mSubsets = new HashSet<Set<IInterval>>();
    }

    /**
     * Generates all the subsets for the given collection.
     * @param s Collection to create subets from
     * @return Iterator over all the subsets
     */
    protected final Iterator<Set<IInterval>> generateSubsets(final Collection<IInterval> s) {
        Set<IInterval> emptySet = new HashSet<IInterval>();

        Iterator<IInterval> intervals = s.iterator();

        /* Add the empty set */
        mSubsets.add(emptySet);

        while (intervals.hasNext()) {
            IInterval i = intervals.next();
            mSubsets.addAll(duplicateAndAdd(i, mSubsets));
        }

        mSubsets.remove(emptySet);

        return mSubsets.iterator();
    }

    /**
     * Duplicates all sets given then adds the given interval.
     * @param i Interval to add to each subset
     * @param s Sets to duplicate
     * @return All the subsets with the interval added
     */
    protected final Collection<Set<IInterval>> duplicateAndAdd(
            final IInterval i,
            final Collection<Set<IInterval>> s) {
        HashSet<Set<IInterval>> result = new HashSet<Set<IInterval>>();

        Iterator<Set<IInterval>> sets = s.iterator();

        Set<IInterval> set;

        while (sets.hasNext()) {
            HashSet<IInterval> newSet = new HashSet<IInterval>();

            set = sets.next();

            newSet.addAll(set);
            newSet.add(i);

            result.add(newSet);
        }

        return result;
    }

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
     * It looks through them all and saving the subset with the most number of
     * intervals.
     *
     * @param s Set of intervals to look through
     * @return Set that contains the optimal intervals
     */
    public Set<IInterval> optimalSchedule(final Set<IInterval> s) {
        Set<IInterval> optimal = Collections.emptySet();

        mSubsets.clear();
        Iterator<Set<IInterval>> subsets = generateSubsets(s);

        while (subsets.hasNext()) {
            Set<IInterval> subset = subsets.next();

            if (conflicts(subset) == false && subset.size() > optimal.size()) {
                optimal = subset;
            }
        }

        return optimal;
    }
}
