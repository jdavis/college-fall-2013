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
        final HashMap<String, String> parents = new HashMap<String, String>();
        final HashMap<String, Integer> depth = new HashMap<String, Integer>();
        final HashMap<String, Integer> startTime = new HashMap<String, Integer>();
        final HashMap<String, Integer> finishTime = new HashMap<String, Integer>();
        final int[] time = new int[1];

        time[0] = 0;

        // Initailize parents of all the vertices
        // Runs in O(V)
        for (String u : g.getVertices()) {
            parents.put(u, null);
            depth.put(u, 0);
        }

        DFS(g, new ITopologicalSortAlgorithms.DFSCallback() {
            private String previousParent = null;

            @Override
            public void processDiscoveredVertex(final String v) {
                parents.put(v, previousParent);

                if (previousParent != null) {
                    depth.put(v, depth.get(previousParent) + 1);
                }

                previousParent = v;
                time[0] += 1;
                startTime.put(v, time[0]);
            }

            @Override
            public void processExploredVertex(final String v) {
                previousParent = parents.get(v);
                time[0] += jobDurations.get(v);
                finishTime.put(v, time[0]);
            }

            @Override
            public void processEdge(final Pair<String, String> e) { }
        });

        System.out.println("Parents: " + parents);
        System.out.println("Start time: " + startTime);
        System.out.println("Finish time: " + finishTime);
        System.out.println("Depth: " + depth);

        int result = 0;

        for (String u : g.getVertices()) {
            result += jobDurations.get(u);
        }

        return result;
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
