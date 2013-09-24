CREATE TABLE Emp (
	eid INT,
	lname CHAR(32),
	fname CHAR(32),
	age INT,
	salary DOUBLE,
	PRIMARY KEY (eid)
);

CREATE TABLE Dept (
	dname CHAR(40),
	budget DOUBLE,
	managerid INT,
	PRIMARY KEY (dname),
	FOREIGN KEY (managerid) REFERENCES Emp (eid)
);

CREATE TABLE Works (
	eid INT,
	dname CHAR(40),
	pct_time INT,
	PRIMARY KEY (eid, dname),
	FOREIGN KEY(eid) REFERENCES Emp (eid),
	FOREIGN KEY(dname) REFERENCES Dept (dname)
);

INSERT INTO Emp (eid, lname, fname, age, salary) VALUES (1, 'Davis', 'Josh', 23, 100);
INSERT INTO Emp (eid, lname, fname, age, salary) VALUES (2, 'Davis', 'Bob', 23, 100);
INSERT INTO Emp (eid, lname, fname, age, salary) VALUES (3, 'Davis', 'Poor', 23, 100);
INSERT INTO Dept (dname, budget, managerid) VALUES ('Software', 2000000, 1);
INSERT INTO Dept (dname, budget, managerid) VALUES ('Hardware', 20, 1);
INSERT INTO Dept (dname, budget, managerid) VALUES ('Stuff', 20, 1);
INSERT INTO Dept (dname, budget, managerid) VALUES ('Another', 2000000, 2);
INSERT INTO Dept (dname, budget, managerid) VALUES ('New', 100, 3);
INSERT INTO Works (eid, dname, pct_time) VALUES (3, 'Software', 10);
INSERT INTO Works (eid, dname, pct_time) VALUES (3, 'Hardware', 10);