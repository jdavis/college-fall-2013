Assignment 4
============

by Josh Davis
Due: Monday, Oct 28

## Problem 1

Consider the relation Employee:
- eid an integer
- ename a string
- sal an integer
- title a string
- age an integer

Other properties:
1. Each Employee record is 100 bytes long
2. Total Employee relation uses 10,000 pages
3. Each index data entry is 20 bytes long

Indexes using Alt 2:
1. Hash index on eid
2. Dense, unclustered B+ index on sal
3. Hash index on age
4. Dense, clustered B+ index on (age, sal)

Assumptions:
1. Data page can hold 20 Employee tuples. Each page can hold as many relations
   as possible. The relation is stored as a heap file.
2. One disk I/O is needed to retrieve a page.
3. Cost for retrieving all relevant internal nodes of a B+ tree from a root to
   desirable leaf node is 2 disk I/Os.
4. Page size is 2048 bytes, 48 bytes are reserved.
5. 1.2 I/O needed to use hash index to find a data entry that satisfies the
   selection criterion.
6. As many data entries as possible are stored in a page.
7. Reduction factor is .1

### Part A
Query: `sal > 100`

#### Solution

Total Cost:
1. Cost of traversing from root to leaf +
2. Cost of retrieving pages in sequence +
3. Cost of retrieving pages that contain the data records

##### Part One
    Traversing from root to leaf = 2

##### Part Two
    Number of records
        = (number of total pages relation uses * size of pages) / (size of
        record)
        = (10,000 * (2048 - 48)) / (100)
        = 200,000 records

    Number of matching records
        = (number of records * reduction factor)
        = 200,000 * .1
        = 20,000 matching records

    Entries per page
        = (page size / entry size)
        = ((2048 - 48) / 20)
        = 100

    Retrieving page in sequence
        = (number of matching records) / (entries per page)
        = 20,000 / 100
        = 200

##### Part Three

Now we just need to retrieve the records. According to the given info, for `sal`
the index is dense and unclustered. This means that the tuples aren't in the
same order as the entries and we might need to read every page once.

    Retrieving pages that contain data records
        = 20,000

##### Final Answer

`Total Cost = 2 + 200 + 20,000 = 20,202`

### Part B
Query: `age = 20`

### Part C
Query: `sal > 200 ` and `age > 30` and `title = "CFO"`

## Problem 2

### Part A

### Part B

### Part C
