package edu.iastate.cs311.f13.hw6;

import java.util.HashMap;

public class TopSort implements ITopologicalSortAlgorithms {
    private HashMap<String,State> states = null;
    private HashMap<String,String> parents = null;

    private void startingDFS() {
        states = new HashMap<String,State>();
        parents = new HashMap<String,String>();
    }


    @Override
    public void DFS(IGraph g, DFSCallback p) {
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

    private void dfsVisit(IGraph g, DFSCallback p, String u) {
        // Callback that we are starting on vertex u
        p.processDiscoveredVertex(u);

        // Update the state of vertex u
        states.put(u, State.PROCESSED);

        // Iterate over all the outgoing edges from v
        for (Pair<String, String> e : g.getOutGoingEdges(v)) {
            // Incident edge will be the second part of the pair
            String v = e.second();

            // Callback that we are processing edge e
            p.processEdge(e);

            // If we haven't visited v yet, recursively visit it
            if (state.get(v) == State.UNVISITED) {
                parents.put(v, u);
                dfsVisit(g, p, u);
            }
        }

        // Update the state of u
        states.put(u, State.FINISHED);

        // Callback that we finished with vertex u
        p.processExploredVertex(u);
    }

    @Override
    public List<String> topologicalSort(IGraph g) {
    }

    @Override
    public int minScheduleLength(IGraph g, Map<String, Integer> jobDurations);

    private Enum State {
        UNVISITED,
        PROCESSED,
        FINISHED,
    }
}
