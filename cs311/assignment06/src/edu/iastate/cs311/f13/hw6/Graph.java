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
    /** Hashmap of all the edges in the graph. */
    private HashMap<String, ArrayList<Pair<String, String>>> mData;

    @Override
    public final String toString() {
        String result = "";
        Iterator it = mData.entrySet().iterator();

        while (it.hasNext()) {
            Entry entry = (Entry) it.next();
            String u = (String) entry.getKey();


            ArrayList<Pair<String, String>> edges = (ArrayList<Pair<String, String>>) entry.getValue();
            result += u + " = " + edges + "\n";
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
        return (Collection<Pair<String, String>>) mData.get(v);
    }

    @Override
    public final void addVertex(final String v) {
        if (!mData.containsKey(v)) {
            mData.put(v, new ArrayList<Pair<String, String>>());
        }
    }

    @Override
    public final void addEdge(final Pair<String, String> e) {
        String v = e.first;
        ArrayList<Pair<String, String>> edges = mData.get(v);

        if (edges != null) {
            edges.add(e);
        }

    }

    @Override
    public final void deleteVertex(final String v) {
        mData.remove(v);

        Iterator it = mData.entrySet().iterator();

        while (it.hasNext()) {
            Entry entry = (Entry) it.next();
            String u = (String) entry.getKey();

            Pair<String, String> e = new Pair<String, String>(u, v);

            ArrayList<Pair<String, String>> edges = (ArrayList<Pair<String, String>>) entry.getValue();
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
