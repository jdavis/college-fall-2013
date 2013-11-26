package edu.iastate.cs311.f13.hw6;

import java.util.LinkedList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;

/**
 * Implementation of the ITopologicalSortAlgorithms interface.
 */
public class TopologicalSortAlgorithms implements ITopologicalSortAlgorithms {
    /** Holds states for vertices. */
    private HashMap<String, State> states = null;

    /**
     * Initializes our states object.
     */
    private void startingDFS() {
        states = new HashMap<String, State>();
    }

    /**
     * Calculate depth first on a graph with a given starting node or null if
     * starting doesn't matter.
     *
     * Complexity of this is the standard O(V + E) as according to CLRS. This
     * is because every vertex is visited at least once and every edge is
     * visited once.
     */
    public final void DFS(final IGraph g, final String s, final DFSCallback p) {
        // Reset all of our member variables
        startingDFS();

        // Initailize state of all the vertices
        for (String u : g.getVertices()) {
            states.put(u, State.UNVISITED);
        }

        // Start with s if given
        if (s != null) {
            if (states.get(s) == State.UNVISITED) {
                dfsVisit(g, p, s);
            }
        }

        // Iterate over the rest of the vertices
        for (String u : g.getVertices()) {
            // If we haven't visited it, that means we can DFS from it
            if (states.get(u) == State.UNVISITED) {
                dfsVisit(g, p, u);
            }
        }
    }


    @Override
    public final void DFS(final IGraph g, final DFSCallback p) {
        DFS(g, null, p);
    }

    /**
     * Visit a given vertex.
     *
     * Helper method for DFS method.
     *
     * @param g Graph to explore
     * @param p Callback processor
     * @param u Vertex to visit
     */
    private void dfsVisit(final IGraph g, final DFSCallback p, final String u) {
        // Callback that we are starting on vertex u
        p.processDiscoveredVertex(u);

        // Update the state of vertex u
        states.put(u, State.PROCESSED);

        // Iterate over all the outgoing edges from v
        for (Pair<String, String> e : g.getOutgoingEdges(u)) {
            // Incident edge will be the second part of the pair
            String v = e.second;

            // Callback that we are processing edge e
            p.processEdge(e);

            // If we haven't visited v yet, recursively visit it
            if (states.get(v) == State.UNVISITED) {
                dfsVisit(g, p, v);
            }
        }

        // Update the state of u
        states.put(u, State.FINISHED);

        // Callback that we finished with vertex u
        p.processExploredVertex(u);
    }

    /**
     * Uses our DFS method previously implemented but uses a special callback.
     *
     * This method runs in O(V + E) time just like DFS. This is because
     * inserting at the beginning of a LinkedList is constant time.
     *
     * @param g Graph to topologically sort
     * @return A List of a valid topological sort
     */
    @Override
    public final List<String> topologicalSort(final IGraph g) {
        final LinkedList<String> result = new LinkedList<String>();

        // Use our standard DFS and pass in a custom callback
        // We only need to use the processExploredVertex callback method
        DFS(g, new ITopologicalSortAlgorithms.DFSCallback() {
            @Override
            public void processDiscoveredVertex(final String v) { }

            @Override
            public void processExploredVertex(final String v) {
                // By inserting a vertex at the beginning of our result, we
                // ensure that we get a valid topological sort of the input
                // graph. This is because processExploredVertex is only called
                // once all of its children are visited.
                result.addFirst(v);
            }

            @Override
            public void processEdge(final Pair<String, String> e) { }
        });

        return result;
    }

    /**
     * Generates a valid topological sort and then traverses the DAG to
     * calculate the max time of traversing the DAG.
     *
     * First it does a standard topological sort O(V + E), then it traverses
     * the sort and determines the max to access the bottom of the DAG.
     * Maximally, this traversal would run in O(V + E) as well, thus
     * asymptotically, the entire method runs in:
     *      O((V + E) + (V + E)) =
     *                           = O(2V + * 2E)
     *                           = O(V + E).
     *
     * @param g Graph to calculate over
     * @param jobDurations Map of each job to a given integer duration
     * @return Value of the minimum schedule length
     */
    @Override
    public final int minScheduleLength(final IGraph g,
            final Map<String, Integer> jobDurations) {
        List<String> topo = topologicalSort(g);
        HashSet<String> visited = new HashSet<String>();

        int result = 0;

        for (String v : g.getVertices()) {
            if (!visited.contains(v)) {
                int x = minScheduleLengthRec(g, jobDurations, visited, topo, v);
                result = Math.max(result, x);
            }
        }

        return result;
    }

    /**
     * Helper function for minScheduleLength.
     *
     * Operates recursively until a given vertex has no more outgoing edges
     * (thus at the bottom of the DAG).
     *
     * @param g Graph to look through
     * @param jobDurations Map for the length of each vertex
     * @param visited All the nodes that have been visited so far
     * @param topo One valid topological sort
     * @param u Vertex to start at
     * @return Minium schedule length for current vertex
     */
    private int minScheduleLengthRec(final IGraph g,
            final Map<String, Integer> jobDurations,
            final Set<String> visited,
            final List<String> topo,
            final String u) {
        int total = jobDurations.get(u);
        int max = total;

        visited.add(u);

        for (Pair<String, String> e : g.getOutgoingEdges(u)) {
            // Incident edge will be the second part of the pair
            String v = e.second;
            int x = minScheduleLengthRec(g, jobDurations, visited, topo, v);

            if (total + x > max) {
                max = total + x;
            }
        }

        return max;
    }

    /**
     * Enum for states of vertices.
     */
    private enum State {
        /** Unvisited state. */
        UNVISITED,

        /** Processed but not finished state. */
        PROCESSED,

        /** Finished state. */
        FINISHED,
    }
}
