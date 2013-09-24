/*
 * Part A
 */
SELECT ms.name
FROM StarsIn s, MovieStar ms
WHERE s.movieTitle = 'Terms of Endearment'
AND ms.name = s.starName AND ms.gender = 'M';

/*
 * Part B
 */
SELECT s.starName
FROM StarsIn s, Movie m
WHERE m.studioName = 'MGM' AND m.year = 1995
AND s.movieTitle = m.title AND s.movieYear = m.year;

/*
 * Part C
 */
SELECT m2.title
FROM Movie m1, Movie m2
WHERE m1.title = 'Gone With the Wind'
AND m2.length > m1.length;

/*
 * Part D
 */
SELECT m2.name
FROM MovieExec m1, MovieExec m2
WHERE m1.name = 'Merv Griffin'
AND m2.netWorth > m1.netWorth;
