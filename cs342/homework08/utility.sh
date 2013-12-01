#!/bin/sh

# I hate when zips extract to no folder...
cd ..

ARCHIVE=hw08-solution.zip

# Create the homework submission
zip $ARCHIVE homework08/hw08-{env-values,interpreter,lang}.rkt

# Move to the solution dir
mv $ARCHIVE homework08
