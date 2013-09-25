import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

public class SmartBruteForceScheduler extends BruteForceScheduler {
    public SmartBruteForceScheduler() {
        mSubsets = new TreeSet<Set<IInterval>>(new Comparator<Set<IInterval>>() {
            @Override
            public int compare(Set<IInterval> s1, Set<IInterval> s2) {
                return s1.size() - s2.size();
            }
        });
    }

    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        Set<IInterval> optimal = Collections.emptySet();

        Iterator<Set<IInterval>> subsets = generateSubsets(s);

        while (subsets.hasNext()) {
            Set<IInterval> subset = subsets.next();

            if (conflicts(subset) == false) {
                return subset;
            }
        }

        return Collections.emptySet();
    }

    protected Iterator<Set<IInterval>> allSubsets() {
        TreeSet<Set<IInterval>> set = (TreeSet<Set<IInterval>>) mSubsets;
        return set.descendingIterator();
    }
}
