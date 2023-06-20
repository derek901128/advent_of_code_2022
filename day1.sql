/* Advent of Code 2022 - Day 1 */

with base(calories, row_num) as (
    select 
        *,
        row_number() over()
    from 
        '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day1.csv'
),
null_only(null_row_no, lag_null_row_no, lead_null_row_no) as (
    select 
        row_num,
        ifnull(lag(row_num) over(), 0),
        ifnull(lead(row_num) over(), 0)
    from 
        base 
    where 
        calories is null
),
result(total_calories) as (
    select
        ( select sum(calories) from base where base.row_num between null_only.lag_null_row_no and null_only.null_row_no )
    from 
        null_only
    union 
    select 
        sum(base.calories)
    from 
        base 
    where
        base.row_num > ( select max(null_row_no) from null_only )
        
)
select 
    total_calories, 
    rank() over total_cal,
    sum(total_calories) over total_cal
from 
    result 
window
    total_cal as (order by total_calories desc) 
QUALIFY 
    rank() over total_cal <= 3 
order by 
    rank() over total_cal 
;


