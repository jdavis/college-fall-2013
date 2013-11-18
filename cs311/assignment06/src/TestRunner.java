import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
  TestRunner.MaxFlowTests.class,
  TestRunner.TopologicalTests.class,
})

/**
 * Empty class for the suites.
 */
public class TestRunner {

    public class MaxFlowTests {
        @Test
        public void emptyTest() {

        }
    }

    public class TopologicalTests {
        @Test
        public void emptyTest() {

        }
    }
}
