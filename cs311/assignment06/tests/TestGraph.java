import static org.junit.Assert.assertThat;
import static org.hamcrest.CoreMatchers.equalTo;

import org.junit.Test;

import java.util.Arrays;
import java.util.Collection;

import edu.iastate.cs311.f13.hw6.IGraph;

/**
 * Test IGraph implementation class.
 */
public class TestGraph {

    /**
     * Test that creating a new instance of the IGraph implementation doens't
     * give us an exception.
     *
     * If it does, check the TestRunner.java file to make sure your IGraph
     * implementation class is being imported and set correctly.
     */
    @Test
    public void testCreateEmptyGraph() {
        TestRunner.newGraph();
    }

    @Test
    public void testAddOneVertex() {
        IGraph g = TestRunner.newGraph();
        String v = "A";

        g.addVertex(v);

        Collection<String> expected = Arrays.asList(v);
        Collection<String> actual = g.getVertices();

        assertThat("Added vertex exists", actual, equalTo(expected));
    }
}
