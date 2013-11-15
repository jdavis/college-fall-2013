package edu.iastate.cs311.f13.hw6;

import java.util.List;
import java.util.Map;

import edu.iastate.cs311.f13.hw6.IGraph.Pair;

public interface ITopologicalSortAlgorithms {
	/**
	 * Performs a depth-first traversal of g. Executes the appropriate callback
	 * methods in processor at the appropriate times.
	 * 
	 * @param g
	 *            The graph to be traversed.
	 * @param processor
	 *            The callback functions that utilize the depth-first traversal.
	 */
	public void DFS(IGraph g, DFSCallback processor);

	/**
	 * Computes a topological sort (or topological ordering) of the vertices in
	 * g.
	 * 
	 * @param g
	 *            The graph that contains the vertices to be sorted and the
	 *            edges that constrain the possible orderings.
	 * @return A list of vertices that is a valid topological ordering of the
	 *         vertices in g.
	 */
	public List<String> topologicalSort(IGraph g);

	/**
	 * Computes the minimum amount of time required to complete the given set of
	 * jobs, subject to the constraint that a job j takes jobDurations[j]
	 * seconds on a single processor and must be completed before any job k
	 * where (j, k) is an edge in g. However, the scheduler has access to
	 * infinitely many processors and so can concurrently run as many
	 * independent jobs as it likes.
	 * 
	 * 
	 * @param g
	 *            The graph that encodes the set of jobs to be completed and the
	 *            dependency relationships between them. For any pair of jobs j
	 *            and k, j must be completed before k if and only if the edge
	 *            (j, k) is in g.
	 * @param jobDurations
	 *            The number of seconds required by each job.
	 * @return The minimal number of seconds that must elapse between the
	 *         beginning of the first job and the end of the last.
	 */
	public int minScheduleLength(IGraph g, Map<String, Integer> jobDurations);

	/**
	 * The implementation of this interface determines what DFS actually does.
	 * 
	 * @author Taylor
	 * 
	 */
	public interface DFSCallback {
		/**
		 * Called whenever DFS discovers a vertex v, i.e. when v is first
		 * reached with DFS.
		 * 
		 * @param v
		 */
		public void processDiscoveredVertex(String v);

		/**
		 * Called whenever DFS explores a vertex v, i.e. when the last neighbor
		 * of v is explored and DFS is about to return from DFS(v).
		 * 
		 * @param v
		 */
		public void processExploredVertex(String v);

		/**
		 * Called whenever DFS encounters the edge from e.first to e.second.
		 * 
		 * @param e
		 */
		public void processEdge(Pair<String, String> e);
	}
}
