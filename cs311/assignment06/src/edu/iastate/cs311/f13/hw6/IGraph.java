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
        public final X first;
        public final Y second;

        public Pair(X first, Y second) {
            if (first == null || second == null)
                throw new IllegalArgumentException();
            this.first = first;
            this.second = second;
        }

        @Override
        public boolean equals(Object other) {
            if (other == null)
                return false;
            if (!(other instanceof Pair))
                return false;

            Pair<?, ?> o = (Pair<?, ?>) other;

            return first.equals(o.first) && second.equals(o.second);
        }

        @Override
        public int hashCode() {
            return first.hashCode() + second.hashCode();
        }
    }
}
