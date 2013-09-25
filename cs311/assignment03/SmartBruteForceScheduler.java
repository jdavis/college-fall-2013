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

    protected Iterator<Set<IInterval>> allSubsets() {
        TreeSet<Set<IInterval>> set = (TreeSet<Set<IInterval>>) mSubsets;
        return set.descendingIterator();
    }
}
