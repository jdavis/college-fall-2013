import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class EarliestDeadlineScheduler implements IScheduler {
    public Set<IInterval> optimalSchedule(Set<IInterval> s) {
        HashSet<IInterval> optimal = new HashSet<IInterval>();

        IInterval[] intervals = s.toArray(new IInterval[0]);

        Arrays.sort(intervals, new Comparator<IInterval>() {
            @Override
            public int compare(IInterval i1, IInterval i2) {
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
