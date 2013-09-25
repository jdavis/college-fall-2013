import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class BruteForceScheduler implements IScheduler {
    private Iterator<Set<IInterval>> allSubsets(Set<IInterval> s) {
        HashSet<Set<IInterval>> result = new HashSet<Set<IInterval>>();
        Set<IInterval> emptySet = new HashSet<IInterval>();

        Iterator<IInterval> intervals = s.iterator();

        /* Add the empty set */
        result.add(emptySet);

        while (intervals.hasNext()) {
            IInterval i = intervals.next();
            result.addAll(duplicateAndAdd(i, result));
        }

        result.remove(emptySet);

        return result.iterator();
    }

    private Set<Set<IInterval>> duplicateAndAdd(IInterval i, Set<Set<IInterval>> s) {
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

    private boolean conflicts(Set<IInterval> s) {
        IInterval[] intervals = s.toArray(new IInterval[0]);

        Arrays.sort(intervals, new Comparator<IInterval>() {
            @Override
            public int compare(IInterval i1, IInterval i2) {
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

    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        Set<IInterval> optimal = Collections.emptySet();

        Iterator<Set<IInterval>> subsets = allSubsets(s);

        while (subsets.hasNext()) {
            Set<IInterval> subset = subsets.next();

            if (conflicts(subset) == false && subset.size() > optimal.size()) {
                optimal = subset;
            }
        }

        return optimal;
    }
}
