#!/bin/sh

# I hate when zips extract to no folder...
cd ..

ARCHIVE=hw07-solution.zip

# Create the homework submission
zip $ARCHIVE homework07/hw07-{env-values,interpreter,lang,tests}.rkt homework07/p5/hw07-{env-values,interpreter,lang,p5-tests}.rkt

# Move to the solution dir
mv hw07-solution.zip homework07
