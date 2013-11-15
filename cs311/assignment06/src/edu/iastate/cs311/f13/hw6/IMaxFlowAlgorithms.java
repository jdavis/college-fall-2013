package edu.iastate.cs311.f13.hw6;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;

public interface IMaxFlowAlgorithms {
    /**
     * Computes the maximal flow that can travel on g from s to t while
     * constrained by edgeCapacities.
     *
     * @param g
     *            The graph through which flow will travel.
     * @param s
     *            The source vertex.
     * @param t
     *            The destination vertex.
     * @param edgeCapacities
     *            The capacities of the edges in g. You may assume that: for all
     *            e, e is a key in edgeCapacities if and only if e is an edge in
     *            g.
     * @return A maximal flow.
     */
    public Map<Pair<String, String>, Integer> maxFlow(IGraph g, String s,
            String t, Map<Pair<String, String>, Integer> edgeCapacities);

    /**
     * Computes the maximal flow that can travel on g from s to t while
     * constrained by vertexCapacities.
     *
     * @param g
     *            The graph through which flow will travel.
     * @param s
     *            The source vertex.
     * @param t
     *            The destination vertex.
     * @param vertexCapacities
     *            The capacities of the vertices in g. You may assume that: for
     *            all v, v is a key in vertexCapacities if and only f v is a
     *            vertex in g.
     * @return A maximal flow.
     */
    public Map<Pair<String, String>, Integer> maxFlowWithVertexCapacities(
            IGraph g, String s, String t, Map<String, Integer> vertexCapacities);

    /**
     * Computes the maximum cardinality set of pairwise vertex-disjoint paths
     * through g from s to t. Note that two paths are considered vertex-disjoint
     * if and only if they share no vertices besides s and t.
     *
     * @param g
     *            The graph which contains s, t, and all of the s-t paths.
     * @param s
     *            The first vertex in every path.
     * @param t
     *            The last vertex in every path.
     * @return A Collection of paths through g, each of which starts at s and
     *         ends at t, where every pair of paths in the collection are
     *         vertex-disjoint from one another.
     */
    public Collection<List<String>> maxVertexDisjointPaths(IGraph g, String s,
            String t);
}
