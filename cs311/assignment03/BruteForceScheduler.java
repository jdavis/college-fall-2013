import java.util.Collections;
import java.util.Set;

public class BruteForceScheduler implements IScheduler {
    private Set<IInterval>[] subsets(Set<IInterval> s) {
        return null;
    }

    private boolean conflicts(Set<IInterval> s) {
        return true;
    }

    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        Set<IInterval> optimal = Collections.emptySet();

        for (Set<IInterval> subset : subsets(s)) {
            if (conflicts(subset) == false && subset.size() > optimal.size()) {
                optimal = subset;
            }
        }

        return optimal;
    }
}
