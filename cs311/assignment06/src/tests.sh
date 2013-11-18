#!/bin/sh

javac edu/iastate/cs311/f13/hw6/*.java

javac -classpath lib/junit.jar:lib/hamcrest-core.jar TestRunner.java
java -cp lib/junit.jar:lib/hamcrest-core.jar org.junit.runner.JUnitCore TestRunner
