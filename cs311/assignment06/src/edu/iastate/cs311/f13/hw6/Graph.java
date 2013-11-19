package edu.iastate.cs311.f13.hw6;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

/**
 * Implementation of IGraph interface.
 */
public class Graph implements IGraph {
    /** Hashmap of all the edges in the graph. */
    private HashMap<String, ArrayList<Pair<String, String>>> mData;

    /**
     * Create an empty Graph.
     */
    public Graph() {
        mData = new HashMap<String, ArrayList<Pair<String, String>>>();
    }

    @Override
    public final Collection<String> getVertices() {
        return (Collection<String>) mData.keySet();
    }

    @Override
    public final Collection<Pair<String, String>> getOutgoingEdges(
            final String v) {
        return (Collection<Pair<String, String>>) mData.get(v);
    }

    @Override
    public final void addVertex(final String v) {
        mData.put(v, new ArrayList<Pair<String, String>>());
    }

    @Override
    public final void addEdge(final Pair<String, String> e) {
        String v = e.first;
        ArrayList<Pair<String, String>> edges = mData.get(v);

        edges.add(e);
    }

    @Override
    public final void deleteVertex(final String v) {
        mData.remove(v);
    }

    @Override
    public final void deleteEdge(final Pair<String, String> e) {
        String v = e.first;
        ArrayList<Pair<String, String>> edges = mData.get(v);

        edges.remove(e);
    }
}
