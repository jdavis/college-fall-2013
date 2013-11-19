package edu.iastate.cs311.f13.hw6;

import java.util.Collection;

/**
 * Encodes a directed graph where vertices are labeled with strings.
 *
 * @author Taylor
 *
 */
public interface IGraph {
    public Collection<String> getVertices();

    public Collection<Pair<String, String>> getOutgoingEdges(String v);

    public void addVertex(String v);

    public void addEdge(Pair<String, String> e);

    public void deleteVertex(String v);

    public void deleteEdge(Pair<String, String> e);

    public class Pair<X, Y> {
        /** First part of the pair. */
        public final X first;

        /** Second part of the pair. */
        public final Y second;

        public Pair(final X first, final Y second) {
            if (first == null || second == null)
                throw new IllegalArgumentException();
            this.first = first;
            this.second = second;
        }

        @Override
        public String toString() {
            return "" + first + " -> " + second;
        }

        @Override
        public final boolean equals(final Object other) {
            if (other == null)
                return false;
            if (!(other instanceof Pair))
                return false;

            Pair<?, ?> o = (Pair<?, ?>) other;

            return first.equals(o.first) && second.equals(o.second);
        }

        @Override
        public final int hashCode() {
            return first.hashCode() + second.hashCode();
        }
    }
}
