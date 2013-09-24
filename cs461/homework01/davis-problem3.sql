# Part A
SELECT e.lname, e.age
FROM Emp e, Works w1, Works w2
WHERE (e.eid = w1.eid AND e.eid = w2.eid AND w1.dname = 'Hardware' AND w2.dname = 'Software');

# Part B
SELECT DISTINCT d.managerid
FROM Dept d
WHERE NOT EXISTS (
	SELECT d1.managerid
	FROM Dept d1
	WHERE d1.managerid = d.managerid AND d1.budget < 1000000
);


# Part C
SELECT e.lname
FROM Emp e, Dept d
WHERE d.managerid = e.eid AND d.dname in (
	SELECT d1.dname
	FROM Dept d1
	WHERE d1.managerid = d.managerid
	AND d1.budget = (SELECT MAX(budget) FROM Dept)
);

# Part D
SELECT DISTINCT d.managerid
FROM Dept d
WHERE EXISTS (
	SELECT *, SUM(budget) as MaxBudget
	FROM Dept d1
	WHERE d1.managerid = d.managerid
	GROUP BY d.managerid
	HAVING MaxBudget > 5000000
);