import java.util.Set;

public abstract class Scheduler implements IScheduler {
    protected boolean conflicts(Set<IInterval> s) {
        return false;
    }
}
