import java.util.Set;

public interface IScheduler {
    public interface IInterval {
        public int getStartTime();
        public int getEndTime();
    }

    public Set<IInterval> optimalSchedule(Set<IInterval> s);
}
