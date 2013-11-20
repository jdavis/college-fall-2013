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
public class TopologicalSort implements ITopologicalSortAlgorithms {
    /** Holds states for vertices. */
    private HashMap<String, State> states = null;

    /**
     * Initializes our states object.
     */
    private void startingDFS() {
        states = new HashMap<String, State>();
    }


    @Override
    public final void DFS(final IGraph g, final DFSCallback p) {
        // Reset all of our member variables
        startingDFS();

        // Initailize state of all the vertices
        for (String u : g.getVertices()) {
            states.put(u, State.UNVISITED);
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
