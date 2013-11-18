#!/bin/sh

javac src/edu/iastate/cs311/f13/hw6/*.java
javac -classpath lib/junit.jar:lib/hamcrest-core.jar test/edu/iastate/cs311/f13/hw6/TestRunner.java

java -classpath lib/junit.jar:lib/hamcrest-core.jar:test/ org.junit.runner.JUnitCore edu.iastate.cs311.f13.hw6.TestRunner
