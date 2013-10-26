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

### Basic Statistics
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

    Records per page
        = (page size / record size)
        = ((2048 - 48) / 100)
        = 20

### Part A
Query: `sal > 100`

#### Solution

##### Using B+ Index (pg 494)

Total Cost:
1. Cost of traversing from root to leaf +
2. Cost of retrieving pages in sequence +
3. Cost of retrieving pages that contain the data records

###### Part One
    Traversing from root to leaf = 2

###### Part Two
    Retrieving page in sequence
        = (number of matching records) / (entries per page)
        = 20,000 / 100
        = 200

###### Part Three

Now we just need to retrieve the records. According to the given info, for `sal`
the index is dense and unclustered. This means that the tuples aren't in the
same order as the entries and we might need to read every page once.

    Retrieving pages that contain data records
        = 20,000

###### B+ Index Cost

`Total Cost = 2 + 200 + 20,000 = 20,202`

##### Scanning (page 493)

`Total Cost = 10,000 pages`

##### Final Answer

Since `10,000 < 20,202`, just scanning all the pages and selecting when `sal >
100` is more efficient.

### Part B
Query: `age = 20`

#### Solution

##### Hash Index

Total Cost:
1. Cost of retrieving matching data entries +
2. Cost of retrieving qualifying tuples

###### Part One
    Cost of retrieving matching data entries
    = (matching entries * hash index read)
    = (20,000 * 1.2)
    = 24,000

###### Part Two
Each entry could point to a different page and since there are 20,000 matching
records, we might have to read 20,000 pages.

###### Hash Index Cost
`Total Cost = 24,000 + 20,000 = 44,000`

##### Using B+ Index (pg 494)

Total Cost:
1. Cost of traversing from root to leaf +
2. Cost of retrieving pages in sequence +
3. Cost of retrieving pages that contain the data records

###### Part One
    Cost of traversing from root to leaf
    = 2

###### Part Two
    Retrieving pages in sequence
    = (number of matching records) / (entries per page)
    = (20,000 / 100)
    = 200

###### Part Three
Since our index is clustered on (age, sal), we will have multiple records on a
page. Thus

    Retrieving pages that contain data records
    = (number of matching records) / (records per page)
    = 20,000 / 20
    = 1,000

###### B+ Index Cost
`Total Cost = 2 + 200 + 1,000 = 1,202`

##### Scanning

`Total Cost = 10,000 pages`

##### Final Answer

Since `1,202 < 10,00 < 44,000`, using the B+ index is the fastest way to go.

### Part C
Query: `sal > 200 ` and `age > 30` and `title = "CFO"`

#### Solution

There is no index on title, thus we must scan all the pages.

##### B+ Index

We know this from Part A:

    Total Cost = 2 + 200 + 20,000 = 20,202

##### Hash Index

We know this from Part B:

    Total Cost = 24,000 + 20,000 = 44,000

##### Scanning (page 493)

`Total Cost = 10,000 pages`

##### B+ Index and B+ Index

Total Cost:
1. Cost of retrieving entries from first index +
2. Cost of retrieving entries from second index
3. Cost of retrieving records

The first index we use is the B+ tree that is indexed on sal
The second index that we use is the B+ tree that is indexed on (age, sal)

###### Part One

    Cost of retrieving entries for first index
    = (cost to tree leaf) + (cost to read each entry)
    = 2 + (number of matching records / entries per page)
    = 2 + (20,000 / 100)
    = 2 + 200
    = 202

###### Part Two

    Cost of retrieving entries for second index
    = (cost to tree leaf) + (cost to read each entry)
    = 2 + (number of matching records / entries per page)
    = 2 + (20,000 / 100)
    = 2 + 200
    = 202

###### Part Three

    Cost of retrieving records
    = (number of matching records from after retrieving from index) / (records per page)
    = (20,000 * .1) / (20)
    = 100

###### Total Cost

`Total Cost = 202 + 202 + 100 = 504`

#### Final Answer

Since `504 < 20,202 < 10,000 < 44,000`, we know that using the combined B+ tree
indexes gives us the fastest lookup time.

## Problem 2

### Part A

### Part B

### Part C
