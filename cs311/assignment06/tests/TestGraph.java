import static org.junit.Assert.assertThat;
import static org.hamcrest.CoreMatchers.equalTo;

import org.junit.Test;

import java.util.Arrays;
import java.util.ArrayList;
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
    public void testEmptyGraph() {
        IGraph g = TestRunner.newGraph();

        Collection<String> expected = Arrays.asList();
        Collection<String> actual = g.getVertices();

        assertThat("Check the graph has no vertices", actual, equalTo(expected));
    }

    @Test
    public void testAddOneVertex() {
        IGraph g = TestRunner.newGraph();
        String v = "A";

        g.addVertex(v);

        Collection<String> expected = Arrays.asList(v);
        Collection<String> actual = g.getVertices();

        assertThat("Check the added vertex was added", actual, equalTo(expected));
    }

    @Test
    public void testAddMultipleVertices() {
        IGraph g = TestRunner.newGraph();
        ArrayList<String> vertices = new ArrayList<String>();

        for (char c = 'A'; c < 'A' + 10; c += 1) {
            String s = "" + c;
            vertices.add(s);
            g.addVertex(s);
        }

        Collection<String> expected = (Collection<String>) vertices;
        Collection<String> actual = g.getVertices();

        assertThat("Check for added vertices", actual, equalTo(expected));
    }

    @Test
    public void testEmptyEdgesForSingleVertex() {
        IGraph g = TestRunner.newGraph();
        String v = "A";

        g.addVertex(v);

        Collection<String> expected = Arrays.asList();
        Collection<String> actual = g.getOutgoingEdges(v);

        assertThat("Check a single vertex has no outgoing edges", actual, equalTo(expected));
    }
}
