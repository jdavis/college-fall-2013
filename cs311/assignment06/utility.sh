#!/bin/sh

# I hate when zips extract to no folder...
cd ..

ARCHIVE=hw06-solution.zip

# Create the homework submission
zip $ARCHIVE assignment06/README.md assignment06/src/edu/iastate/cs311/f13/hw6/{IGraph,IMaxFlowAlgorithms,ITopologicalSortAlgorithms,Graph,MaxFlowAlgorithms,TopologicalSortAlgorithms}.java

# Move to the solution dir
mv $ARCHIVE assignment06/
