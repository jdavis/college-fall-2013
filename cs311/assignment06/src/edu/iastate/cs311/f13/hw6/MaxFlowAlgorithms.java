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
     * @param g Graph to use when finding an augmenting path
     * @param s Starting vertex
     * @param t Ending vertex
     *
     * @return An augmented path or null if one doesn't exist.
     */
    private List<Pair<String, String>> augmentedPath(final IGraph g,
            final String s,
            final String t) {

        final LinkedList<Pair<String, String>> result = new LinkedList<Pair<String, String>>();
        final HashMap<String, String> parents = new HashMap<String, String>();

        TopologicalSortAlgorithms topo = new TopologicalSortAlgorithms();

        // Run DFS starting at s with our own defined callback
        topo.DFS(g, s, new ITopologicalSortAlgorithms.DFSCallback() {
            private String previousParent = null;

            @Override
            public void processDiscoveredVertex(final String v) {
                // Update the parent for this vertex which will allow us to
                // construct the path backwards
                parents.put(v, previousParent);
                previousParent = v;
            }

            @Override
            public void processExploredVertex(final String v) {
                previousParent = parents.get(v);
            }

            @Override
            public void processEdge(final Pair<String, String> e) { }
        });

        String x = t;
        String y = null;

        // Iterate over the parent nodes starting with t until we reach s. The
        // result is an augmenting path
        while (x != null) {
            if (y != null) {
                result.addFirst(new Pair<String, String>(x, y));
            }

            y = x;
            x = parents.get(x);
        }

        // Short circuit and return null when no path found
        if (result.size() == 0) {
            return null;
        }

        return result;
    }

    /**
     * Helper method to calculate a residual costs.
     *
     * Algorithm runs in O(E) time as it needs to operate on each edge
     * and add a residual flow and remaining flow given the capacity of
     * the network.
     *
     * @param g Current graph
     * @param s Starting vertex
     * @param t Ending vertex
     * @param f Map representing the current flow of the edges
     * @param c Map representing the capacity of the edges
     * @return The residual graph costs
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

            // If there is remaining flow, add it to the resulting cost
            if (uv > 0) {
                result.put(e, uv);
            }

            // The reverse edge
            Pair<String, String> residual = new Pair<String, String>(e.second, e.first);

            // If there is currently a flow, add it to the reverse edge
            if (vu > 0) {
                result.put(residual, vu);
            }
        }

        return result;
    }

    /**
     * Helper method to return the residual graph.
     *
     *  Takes in a given residual cost flow as returned by residualCost and
     *  returns a graph that represents it.
     *
     *  This algorithm runs in O(V + E) time because we are essentially copying
     *  a graph.
     *
     * @param f Map representing the current flow of the edges
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

    /**
     * Calculates and returns a valid maximum flow using the parameters given.
     *
     * This algorithm runs in O(Ef) time in the worst case.
     *
     * @param g Graph to use for the maximum flow
     * @param s Source vertex in the graph
     * @param t Sink vertex in the graph
     * @param c Map containing the capacities of each edge in the graph
     * @return Map representing a possible maximum flow
     */
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

        // Calculate the residual cost & graph
        f = residualCost(g, s, t, result, c);
        gR = residualGraph(f);

        // Standard Ford-Fulkerson...
        // Iterate until there is no augmented path left
        while ((p = augmentedPath(gR, s, t)) != null) {
            int cost = Integer.MAX_VALUE;

            // Determine the minimum cost of the augmented path
            for (Pair<String, String> e : p) {
                cost = Math.min(cost, f.get(e));
            }

            // Iterate over each edge in the path, updating the current flow
            for (Pair<String, String> e : p) {
                if (c.containsKey(e)) {
                    result.put(e, result.get(e) + cost);
                } else {
                    Pair<String, String> er = new Pair<String, String>(e.second, e.first);
                    result.put(er, result.get(er) - cost);
                }
            }

            // Start over by recalculating our residual graph and cost
            f = residualCost(g, s, t, result, c);
            gR = residualGraph(f);
        }

        return result;
    }

    /**
     * Transform the given vertex capacity graph into a normal max flow graph
     * and returns the result.
     *
     * This algorithm performs a single transformation of the given graph which
     * runs in O(V + E) time. Then it computes the standard max flow of our new
     * graph which runs in O(Ef) time. Thus asymptotically it runs in O((V +
     * E)f).
     *
     * @param g Graph to use for the maximum flow
     * @param s Source vertex in the graph
     * @param t Sink vertex in the graph
     * @param c Map containing the capacities of each vertex in the graph
     * @return Map representing a possible maximum flow
     */
    @Override
    public final Map<Pair<String, String>, Integer> maxFlowWithVertexCapacities(
            final IGraph g,
            final String s,
            final String t,
            final Map<String, Integer> c) {
        // Transform the graph
        IGraph gN = new Graph();
        HashMap<Pair<String, String>, Integer> c = new HashMap<Pair<String, String>, Integer>();

        // Iterate over all the vertices, creating our newly transformed graph
        for (String v : g.getVertices()) {
            int capacity = c.get(v);

            // For each edge, add a new node with an edge to it that equals the
            // vertex capacity. This ensures that all inflow equals the vertex
            // capacity because the outflow is the same as the given vertex
            // capacity
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

        c.put(tToTN, c.get(t));

        // Calculate the maxFlow normally with the new transformed graph
        return maxFlow(gN, s, tN, c);
    }

    /**
     * Transform the max pairwise vertex disjoint path problem into the max flow problem
     * by using a unit capacity of 1 for each edge in the graph.
     *
     * The max flow mapping the is returned will give us the maximum pairwise
     * paths for as long as the flow of the edge is 1. If the flow is 0, that
     * edge can't be in the path.
     *
     * This algorithm was inspired by:
     *       Title: Edge-Disjoint (s, t)-Paths in Undirected Planar Graphs in
     *              Linear Time
     *      Author: Karsten Wihe
     *
     * This algorithm runs in O(V + E) time as according to the research of
     * Wihe.
     *
     * @param g Graph to use for the maximum flow
     * @param s Source vertex in the graph
     * @param t Sink vertex in the graph
     * @return Collection containing all the pairwise vertex disjoint paths
     */
    @Override
    public final Collection<List<String>> maxVertexDisjointPaths(final IGraph g,
            final String s,
            final String t) {
        HashMap<Pair<String, String>, Integer> c = new HashMap<Pair<String, String>, Integer>();

        // Construct our new edge capacities using the unit capacity of 1
        for (String v : g.getVertices()) {
            for (Pair<String, String> e : g.getOutgoingEdges(v)) {
                c.put(e, UNIT_CAPACITY);
            }
        }

        // Calculate the max flow
        Map<Pair<String, String>, Integer> f = maxFlow(g, s, t, c);

        IGraph gN = new Graph();

        // Add all the edges that have flow of 1 to our new graph
        for (Pair<String, String> edge : f.keySet()) {
            if (f.get(edge) == 0) continue;

            gN.addVertex(edge.first);
            gN.addVertex(edge.second);
            gN.addEdge(edge);
        }

        TopologicalSortAlgorithms topo = new TopologicalSortAlgorithms();

        final ArrayList<List<String>> paths = new ArrayList<List<String>>();
        final HashSet<String> visited = new HashSet<String>();

        // Run DFS on the newly formed graph to construct a DAG
        topo.DFS(gN, s, new ITopologicalSortAlgorithms.DFSCallback() {
            private ArrayList<String> currentPath = null;

            @Override
            public void processDiscoveredVertex(final String v) { }

            @Override
            public void processExploredVertex(final String v) { }

            @Override
            public void processEdge(final Pair<String, String> e) {
                String u = e.first;
                String v = e.second;

                // Create a new currentPath if null
                if (currentPath == null) {
                    currentPath = new ArrayList<String>();
                    currentPath.add(u);
                }

                // If we reach the end, add the currentPath to our final
                // result, paths and set it to null, else just add the current
                // vertex
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
