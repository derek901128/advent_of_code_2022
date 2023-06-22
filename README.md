# advent_of_code_2022

Finally, my first Advent of Code. 
As a SQL coder who writes queries day in and day out, my natural instinct is to solve all the challenges using pure SQL - no procedures, just views, ctes, and maybe occasionally some marcos to show how much of a real programmer I am. 

Jokes aside, there're three reasons why I decide to ditch my hosuework and code for yet another few hours after work: 
1. Possibilities. The more SQL I write at work, the more I'm into it, the more I appreciate just how universal and long lasting it is, how deceptively simple and yet surprisingly complex it can get. Soon I reached to a point where I start wondering: how much more can I do with this language ? 
2. Duckdb. SQL has different "flavors", and the one I've been longing to properly explore is Duckdb. There's little chance I'll be using it in any professional context, but its features are just too insanely dreamingly tempting: data ingestion, column expressions, struct, enums, list comprehensions... and in SQL ?  
3. Oracle. I use Oracle 12c at work. It's old, yes, but in tech old could also mean robust and reliable. By putting it side by side with something like Duckdb, I can find out how much I am missing out, and how much should I be grateful for. 

Along the way, I'll be journaling my thoughts at random intervals.

Day1: 
- Duckdb's ability to read input and turn it into porper relation is crazily straigthforward - something as simple as "select * from 'input.csv'" could very well be sufficient to get you going. Along with all its command line options, it can almost work like a scripting language.
- Oracle supports match_recognize, but Duckdb doesn't, which is a shame, because match_recognize is a wonderful piece of SQL magic - it allows the SQL authors to write declarative row-wise pattern matching code that is flexible, easy to maintain, easy to change and easy to reason about. It helps me find suspicious transaction patterns at work for AML purpose, and it solves day1's challenge beautifully.

Day2: 
- I like Day2 quite a bit, because it inspires me to think proactively in terms of relations when coming up with a SQL-esque solution. Normally, using SQL means working with relational databases, which means I'm dealing with relations/tables by default, there's no need for me to think. But coding challenges are not databases, things don't naturally exist as relations, so it's up to me to think relationally and break things up in terms of relations, if I am to solve them in SQL. In this case, instead of resorting to if-then-else kind of imperative logic, I set up ctes for the scoring scheme and matrix, which allow me to use joins on them to find the score. Almost like switch statements, but better (?).

Day3: 
- Finally get to explore some of Duckdb's syntactical sugar, like list_distinct, list_concat, list_transform, etc, when trying to find the common type between the two compartments. Honestly I'm not as impressed as I thought I would be. I don't think they make better solution, they just lead to a differen solution, which, in this case, is too programmatic for my taste.
- While Oracle doesn't have these supposedly modern methods, it has mighty "connect by level.." contructs, which allows us to write intuitive recursive query. With that, I come up with a beautifully relational way to find out the common type of the two compartments: with raw input as the base cte, I use the connect by + substr(compartment, level, 1) to loop through each letter of each compartment, turning them into two columns of letters, using "intersect" on the two columns and the result would be the common type, then cross applying it back to the base cte with row_no being the join condition, meaning for each row the above process will be carried out. Beautiful stuff.

Day5: 
- Huge challenge. First, figuring out how to set up the appropriate table shape for both the instructions and the crates require a lot of forward thinking. Second, the problem of keeing track of the changing states of the crates is very tircky without the help of variables and loop construct. That's why I'm forced to think recursively. The solution is perhaps too long, but it's certainly a milestone for me.
- Again, Duckdb doesn't necessarily produce better solution, despite all its modern features and data types.

Day6: 
- Day6 is a breeze. Once again I use the connect by + sustr trick to break all lettes into rows, each letter for each row, adding row numbers to determine the position. Then I use the row numbers as a pivot, cross applying every 4 / 14 items to each row number with a range join (e.g. 1 gets 1, 2, 3, 4; 2 gets 2, 3, 4, 5). This way, every row number will get 4 / 14 items, and I can do a distinct count group by row number. The minimum row_no that has a count over 4 or 14 will be the group we're looking for. 
- This is not the first solution I can think of. The first that comes to mind is match_recognize and lag. Both works for part1 of the challenge, but part2 shows just how tedious they can get, as I need to manually type out all inequality conditions. 














    
