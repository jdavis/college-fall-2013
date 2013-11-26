package edu.iastate.cs311.f13.hw6;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;

/**
 * Implementation of the IMaxFlowAlgorithms.
 */
public class MaxFlowAlgorithms implements IMaxFlowAlgorithms {
    /** Unit capacity of a graph. */
    private static final int UNIT_CAPACITY = 1;

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

        HashMap<Pair<String, String>, Integer> result = new HashMap<Pair<String, String>, Integer>();

        for (Pair<String, String> e : c.keySet()) {
            int uv = c.get(e) - f.get(e);
            int vu = f.get(e);

            if (uv > 0) {
                result.put(e, uv);
            }

            Pair<String, String> residual = new Pair<String, String>(e.second, e.first);
            if (vu > 0) {
                result.put(residual, vu);
            }
        }

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

        return result;
    }

    @Override
    public final Map<Pair<String, String>, Integer> maxFlow(final IGraph g,
            final String s,
            final String t,
            final Map<Pair<String, String>, Integer> c) {
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
            int cost = Integer.MAX_VALUE;

            for (Pair<String, String> e : p) {
                cost = Math.min(cost, f.get(e));
            }

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
        }

        return result;
    }

    @Override
    public final Map<Pair<String, String>, Integer> maxFlowWithVertexCapacities(
            final IGraph g,
            final String s,
            final String t,
            final Map<String, Integer> vertexCapacities) {
        // Transform the graph
        IGraph gN = new Graph();
        HashMap<Pair<String, String>, Integer> c = new HashMap<Pair<String, String>, Integer>();

        for (String v : g.getVertices()) {
            int capacity = vertexCapacities.get(v);

            for (Pair<String, String> e : g.getOutgoingEdges(v)) {
                String u = e.second;

                String augVertex = v + " augmented " + u;

                Pair<String, String> vToAug = new Pair<String, String>(v, augVertex);
                Pair<String, String> augToU = new Pair<String, String>(augVertex, u);

                c.put(vToAug, capacity);
                c.put(augToU, capacity);

                gN.addVertex(v);
                gN.addVertex(augVertex);
                gN.addVertex(u);

                gN.addEdge(vToAug);
                gN.addEdge(augToU);
            }
        }

        // Add constraint on t output
        String tN = t + " augmented ";
        Pair<String, String> tToTN = new Pair<String, String>(t, tN);

        gN.addVertex(t);
        gN.addVertex(tN);

        gN.addEdge(tToTN);

        c.put(tToTN, vertexCapacities.get(t));

        return maxFlow(gN, s, tN, c);
    }

    @Override
    public final Collection<List<String>> maxVertexDisjointPaths(final IGraph g,
            final String s,
            final String t) {
        HashMap<Pair<String, String>, Integer> c = new HashMap<Pair<String, String>, Integer>();

        for (String v : g.getVertices()) {
            for (Pair<String, String> e : g.getOutgoingEdges(v)) {
                c.put(e, UNIT_CAPACITY);
            }
        }

        Map<Pair<String, String>, Integer> f = maxFlow(g, s, t, c);

        IGraph gN = new Graph();

        for (Pair<String, String> edge : f.keySet()) {
            if (f.get(edge) == 0) continue;

            gN.addVertex(edge.first);
            gN.addVertex(edge.second);
            gN.addEdge(edge);
        }

        System.out.println("Disjoint path old graph\n" + g);
        System.out.println("Disjoint path new graph\n" + gN);

        TopologicalSortAlgorithms topo = new TopologicalSortAlgorithms();

        final ArrayList<List<String>> paths = new ArrayList<List<String>>();
        final HashSet<String> visited = new HashSet<String>();

        topo.DFS(gN, s, new ITopologicalSortAlgorithms.DFSCallback() {
            private ArrayList<String> currentPath = null;

            @Override
            public void processDiscoveredVertex(final String v) {
            }

            @Override
            public void processExploredVertex(final String v) {
            }

            @Override
            public void processEdge(final Pair<String, String> e) {
                String u = e.first;
                String v = e.second;

                if (currentPath == null) {
                    currentPath = new ArrayList<String>();
                    currentPath.add(u);
                }

                if (v.equals(t)) {
                    currentPath.add(t);
                    paths.add(currentPath);
                    currentPath = null;
                } else {
                    currentPath.add(v);
                }
            }
        });

        return paths;
    }
}
