# advent_of_code_2022

Finally, my first Advent of Code. 
As a SQL coder who writes queries day in and day out, my natural instinct is to solve all the challenges using pure SQL - no procedures, just views, ctes, and maybe occasionally some marcos to show how much of a real programmer I am. 

Jokes aside, there're three reasons why I decide to ditch my hosuework and code for yet another few hours after work: 
1. Possibilities. The more SQL I write at work, the more I'm into it, the more I appreciate just how universal and long lasting it is, how deceptively simple and yet surprisingly complex it can get. Soon I reached to a point where I start wondering: how much more can I do with this language ? 
2. Duckdb. SQL has different "flavors", and the one I've been longing to properly explore is Duckdb. There's little chance I'll be using it in any professional context, but its features are just too insanely dreamingly tempting: data ingestion, column expressions, struct, enums, list comprehensions... and in SQL ?  
3. Oracle. I use Oracle 12c at work. It's old, yes, but in tech old could also mean robust and reliable. By putting it side by side with something like Duckdb, I can find out how much I am missing out, and how much should I be grateful for. 

Along the way, I'll be journaling my thoughts at random intervals.

Day1: 
- Duckdb's ability to read input is crazily good and simple, something as simple as "select * from 'input.csv' could very possibly get you going. Along with all its command line options it can almost work like a scripting language.
- Oracle supports match_recognize, but Duckdb doesn't, which is a shame, because match_recognize is a wonderful piece of SQL magic, it allow SQL author to declaratively write row-wise pattern matching code that is flexible, easy to maintain, easy to change and easy to reason about. It helps me find suspicious transactions pattern at work for AML purpose, and it solves day1's challenge beautifully.

Day2: 
- I like Day2 quite a bit, because it inspires me to think proactively in terms of relations when coming up with a SQL-esque solution. Normally, using SQL means working with relational databases, things are in relations/tables by default, there's no need for me to think. But coding challenges are not databases, all the input are not relations by default, it's up to me to think relationally and break things up in terms of relations, rather than procedures. So instead of resorting to if-then-else kind of imperative logic, I set up ctes and joins. Almost like switch statements, but better (?).

Day3: 
- Finally get to explore some of Duckdb's syntactical sugar, like list_distinct, list_concat, list_transform, etc, when trying to Honestly I'm not as impressed as I thought I would be, mainly because I don't think they make better solution, they just lead to a differen solution, which, in this case, is too programmatic for my taste.
- While Oracle doesn't have these supposedly modern methods, it has "connect by level..", which is a very handy way to write recursive query. With that, I come up with a beautifully relational way to find out the common type of the two compartments: with raw input as the base cte, I use the connect by + substr(compartment, level, 1) to loop through each letter of each compartment, turning them into two columns of letters, intersecting them to find the common letter that exists in both columns as the common type, while cross applying it to the base cte on row_no, meaning for each row the above process will be carried out. Beautiful stuff.

Day5: 
- Huge challenge. First, figuring out to set up the appropriate table shape for the instructions and crates require a lot of foreward thinking. Second, the problem of keeing track of the changing states of the crates is very tircky without the help of variables and loop construct. I'm forced to think recursively. The solution is perhaps too long, but it's a milestone for me.
- Again, Duckdb doesn't nessarily product better solution, despite all its modern features and data types.















    
