import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

public class SmartBruteForceScheduler extends BruteForceScheduler {
    protected TreeSet<Set<IInterval>> mSubsets;

    public SmartBruteForceScheduler() {
        mSubsets = new TreeSet<Set<IInterval>>(new Comparator<Set<IInterval>>() {
            @Override
            public int compare(Set<IInterval> s1, Set<IInterval> s2) {
                return s1.size() - s2.size();
            }
        });
    }

    protected Iterator<Set<IInterval>> allSubsets() {
        return mSubsets.descendingIterator();
    }

    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        Set<IInterval> optimal = Collections.emptySet();

        Iterator<Set<IInterval>> subsets = generateSubsets(s);

        System.out.println("In Smart BruteForce");

        while (subsets.hasNext()) {
            Set<IInterval> subset = subsets.next();

            System.out.println("Subset = " + subset);

            if (conflicts(subset) == false && subset.size() > optimal.size()) {
                optimal = subset;
            }
        }

        return optimal;
    }
}
