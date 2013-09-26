import java.util.Arrays;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Set;

/**
 * Uses a greedy method to determine the optimal schedule of intervals.
 */
public class EarliestDeadlineScheduler implements IScheduler {
    public final Set<IInterval> optimalSchedule(final Set<IInterval> s) {
        HashSet<IInterval> optimal = new HashSet<IInterval>();

        IInterval[] intervals = s.toArray(new IInterval[0]);

        Arrays.sort(intervals, new Comparator<IInterval>() {
            @Override
            public int compare(final IInterval i1,
                final IInterval i2) {
                return i1.getEndTime() - i2.getEndTime();
            }
        });

        if (intervals.length == 0) {
            return optimal;
        }

        IInterval current = intervals[0];

        optimal.add(current);

        for (int i = 1; i < intervals.length; i += 1) {
            if (intervals[i].getStartTime() >= current.getEndTime()) {
                current = intervals[i];
                optimal.add(current);
            }
        }

        return optimal;
    }
}
