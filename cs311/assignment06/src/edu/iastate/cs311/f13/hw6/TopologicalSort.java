package edu.iastate.cs311.f13.hw6;

import java.util.LinkedList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;

/**
 * Implementation of the ITopologicalSortAlgorithms interface.
 */
public class TopologicalSort implements ITopologicalSortAlgorithms {
    /** Holds states for vertices. */
    private HashMap<String, State> states = null;

    /** Holds parents of vertices. */
    private HashMap<String, String> parents = null;

    /**
     * Initializes our states and parents objects.
     */
    private void startingDFS() {
        states = new HashMap<String, State>();
        parents = new HashMap<String, String>();
    }


    @Override
    public final void DFS(final IGraph g, final DFSCallback p) {
        // Reset all of our member variables
        startingDFS();

        // Initailize state and parents of all the vertices
        for (String u : g.getVertices()) {
            states.put(u, State.UNVISITED);
            parents.put(u, null);
        }

        // Iterate over all the vertices
        for (String u : g.getVertices()) {
            // If we haven't visited it, that means we can DFS from it
            if (states.get(u) == State.UNVISITED) {
                dfsVisit(g, p, u);
            }
        }
    }

    /**
     * Visit a given vertex.
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
                parents.put(v, u);
                dfsVisit(g, p, v);
            }
        }

        // Update the state of u
        states.put(u, State.FINISHED);

        // Callback that we finished with vertex u
        p.processExploredVertex(u);
    }

    @Override
    public final List<String> topologicalSort(final IGraph g) {
        final LinkedList<String> result = new LinkedList<String>();

        DFS(g, new ITopologicalSortAlgorithms.DFSCallback() {
            @Override
            public void processDiscoveredVertex(final String v) { }

            @Override
            public void processExploredVertex(final String v) {
                result.addFirst(v);
            }

            @Override
            public void processEdge(final Pair<String, String> e) { }
        });

        return result;
    }

    @Override
    public final int minScheduleLength(final IGraph g,
            final Map<String, Integer> jobDurations) {
        return 0;
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
