
# I hate when zips extract to no folder...
cd ..

# Create the homework submission
zip hw7-solution.zip homework07/hw07-{env-values,interpreter,lang,tests}.rkt homework07/p5/hw07-{env-values,interpreter,lang,p5-tests}.rkt

# Move to the solution dir
mv hw7-solution.zip homework07
