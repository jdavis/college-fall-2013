package edu.iastate.cs311.f13.hw6;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Map.Entry;

/**
 * Implementation of IGraph interface.
 */
public class Graph implements IGraph {
    /** Hashmap of all the vertices, edges in the graph. */
    private HashMap<String, ArrayList<Pair<String, String>>> mData;

    @Override
    public final String toString() {
        String result = "";
        Iterator<Entry<String, ArrayList<Pair<String, String>>>> it = mData.entrySet().iterator();

        result += "Graph:\n";
        while (it.hasNext()) {
            Entry<String, ArrayList<Pair<String, String>>> entry = it.next();
            String u = entry.getKey();


            ArrayList<Pair<String, String>> edges = entry.getValue();
            result += "\t" + u + " = " + edges + "\n";
        }

        return result;
    }

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
        // Returns either null or the ArrayList of outgoing edges
        return (Collection<Pair<String, String>>) mData.get(v);
    }

    @Override
    public final void addVertex(final String v) {
        // Only add if the graph doesn't contain the vertex
        // This allows us to add vertices multiple times without consequence
        if (!mData.containsKey(v)) {
            mData.put(v, new ArrayList<Pair<String, String>>());
        }
    }

    @Override
    public final void addEdge(final Pair<String, String> e) {
        String v = e.first;
        ArrayList<Pair<String, String>> edges = mData.get(v);

        // Only add the edge if the originating vertex is in the graph
        if (edges != null) {
            edges.add(e);
        }

    }

    /**
     * Deleting a vertex takes O(V * E) time in the worst case.
     *
     * The algorithm needs to go through all vertices and its edges to see if
     * there is an edge to the newly deleted vertex.
     *
     * @param v Edge to delete
     */
    @Override
    public final void deleteVertex(final String v) {
        // First remove the ArrayList
        mData.remove(v);

        // Iterate over all the key value pairs
        Iterator<Entry<String, ArrayList<Pair<String, String>>>> it = mData.entrySet().iterator();

        while (it.hasNext()) {
            Entry<String, ArrayList<Pair<String, String>>> entry = it.next();

            String u = entry.getKey();
            Pair<String, String> e = new Pair<String, String>(u, v);

            ArrayList<Pair<String, String>> edges = entry.getValue();

            // Delete the edge if it exists in the outgoing edges
            if (edges.contains(e)) {
                edges.remove(e);
            }
        }
    }

    @Override
    public final void deleteEdge(final Pair<String, String> e) {
        String v = e.first;
        ArrayList<Pair<String, String>> edges = mData.get(v);

        edges.remove(e);
    }
}
