package edu.iastate.cs311.f13.hw6;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.Graph;
import edu.iastate.cs311.f13.hw6.IGraph.Pair;
import edu.iastate.cs311.f13.hw6.TopologicalSortAlgorithms;

/**
 * Implementation of the IMaxFlowAlgorithms.
 */
public class MaxFlowAlgorithms implements IMaxFlowAlgorithms {

    /**
     * Helper method to return an augmented path if it exists.
     *
     * @param s Starting vertex
     * @param t Ending vertex
     * @return An augmented path or null if one doesn't exist.
     */
    private List<Pair<String, String>> augmentedPath(final IGraph g,
            final String s,
            final String t) {
        final LinkedList<Pair<String, String>> result = new LinkedList<Pair<String, String>>();
        final HashMap<String, String> parents = new HashMap<String, String>();

        TopologicalSortAlgorithms topo = new TopologicalSortAlgorithms();

        topo.DFS(g, s, new ITopologicalSortAlgorithms.DFSCallback() {
            private boolean didFind = false;
            private String previousParent = null;

            @Override
            public void processDiscoveredVertex(final String v) {
                parents.put(v, previousParent);
                previousParent = v;
            }

            @Override
            public void processExploredVertex(final String v) {
                previousParent = parents.get(v);
            }

            @Override
            public void processEdge(final Pair<String, String> e) {
                String v = e.first;
                String u = e.second;
            }
        });

        String x = t;
        String y = null;

        while (x != null) {
            if (y != null) {
                result.addFirst(new Pair<String, String>(x, y));
            }

            y = x;
            x = parents.get(x);
        }

        if (result.size() == 0) {
            return null;
        }

        return result;
    }

    /**
     * Helper method to calculate a residual costs.
     *
     * @param g Current graph
     * @param s Starting vertex
     * @param t Ending vertex
     * @param f Map representing the capacity of the edges
     * @param c Map representing the capacity of the edges
     * @return The residual costs
     */
    private Map<Pair<String, String>, Integer> residualCost(final IGraph g,
            final String s,
            final String t,
            final Map<Pair<String, String>, Integer> f,
            final Map<Pair<String, String>, Integer> c) {

        System.out.println("Calculating residualGraph");
        HashMap<Pair<String, String>, Integer> result = new HashMap<Pair<String, String>, Integer>();

        for (Pair<String, String> e : c.keySet()) {
            int uv = c.get(e) - f.get(e);
            int vu = f.get(e);

            if (uv > 0) {
                result.put(e, uv);
            }

            Pair<String, String> residual = new Pair<String, String>(e.second, e.first);
            if (vu > 0 && c.containsKey(residual)) {
                result.put(residual, vu);
            }
        }

        System.out.println("Residual Costs: " + result);
        return result;

    }

    /**
     * Helper method to return the residual graph.
     * @param f Current flow
     * @return The augmented graph
     */
    private IGraph residualGraph(final Map<Pair<String, String>, Integer> f) {
        Graph result = new Graph();

        for (Pair<String, String> e : f.keySet()) {
            String v = e.first;
            String u = e.second;

            result.addVertex(v);
            result.addVertex(u);

            result.addEdge(e);
        }

        System.out.println("Residual Graph: " + result);

        return result;
    }

    @Override
    public final Map<Pair<String, String>, Integer> maxFlow(final IGraph g,
            final String s,
            final String t,
            final Map<Pair<String, String>, Integer> c) {
        System.out.println("Calculating maxFlow");
        Map<Pair<String, String>, Integer> f;
        HashMap<Pair<String, String>, Integer> result = new HashMap<Pair<String, String>, Integer>();

        for (Pair<String, String> e : c.keySet()) {
            result.put(e, 0);
        }

        IGraph gR;
        List<Pair<String, String>> p;

        f = residualCost(g, s, t, result, c);
        gR = residualGraph(result);

        while ((p = augmentedPath(gR, s, t)) != null) {
            System.out.println("Path: " + p);
            int cost = Integer.MAX_VALUE;

            for (Pair<String, String> e : p) {
                cost = Math.min(cost, f.get(e));
            }

            System.out.println("MinCost: " + cost);

            for (Pair<String, String> e : p) {
                if (c.containsKey(e)) {
                    result.put(e, result.get(e) + cost);
                } else {
                    Pair<String, String> er = new Pair<String, String>(e.second, e.first);
                    result.put(er, result.get(er) - cost);
                }
            }

            f = residualCost(g, s, t, result, c);
            gR = residualGraph(f);

            System.out.println("Result so far: " + result);
        }

        return result;
    }

    @Override
    public final Map<Pair<String, String>, Integer> maxFlowWithVertexCapacities(
            final IGraph g,
            final String s,
            final String t,
            final Map<String, Integer> vertexCapacities) {
        return new HashMap<Pair<String, String>, Integer>();
    }

    @Override
    public final Collection<List<String>> maxVertexDisjointPaths(final IGraph g,
            final String s,
            final String t) {
        return null;
    }
}
