package edu.iastate.cs311.f13.hw6;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;
import edu.iastate.cs311.f13.hw6.IGraph;

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
        for (Pair<String, String> e : g.getOutgoingEdges(u)) {
            // Incident edge will be the second part of the pair
            String v = e.second;

            // Callback that we are processing edge e
            p.processEdge(e);

            // If we haven't visited v yet, recursively visit it
            if (states.get(v) == State.UNVISITED) {
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
        final ArrayList<String> result = new ArrayList<String>();

        DFS(g, new ITopologicalSortAlgorithms.DFSCallback() {
            @Override
            public void processDiscoveredVertex(String v) { }

            @Override
            public void processExploredVertex(String v) {
                result.add(v);
            }

            @Override
            public void processEdge(Pair<String, String> e) { }
        });

        return result;
    }

    @Override
    public int minScheduleLength(IGraph g, Map<String, Integer> jobDurations) {
        return 0;
    }

    private enum State {
        UNVISITED,
        PROCESSED,
        FINISHED,
    }
}
