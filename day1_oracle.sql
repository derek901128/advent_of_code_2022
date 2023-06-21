/* Advent of Code: Day1 - Part 1 & 2 */

with day1_input(calaries) as (
    select 1000 from dual union all
    select 2000 from dual union all
    select 3000 from dual union all
    select null from dual union all
    select 4000 from dual union all
    select null from dual union all
    select 5000 from dual union all
    select 6000 from dual union all
    select null from dual union all
    select 7000 from dual union all
    select 8000 from dual union all
    select 9000 from dual union all
    select null from dual union all
    select 10000 from dual
),
base as (
    select 
        row_number() over(order by 1) as row_no,
        calaries
    from
        day1_input 
),
find_pattern as (
    select 
        m.*,
        rank() over(order by m.total_calaries desc) as ranking
    from
        base
    match_recognize(
        order by 
            row_no
        measures 
            sum(food.calaries) as total_calaries
        one row per match 
        pattern 
            ( food{1, } )
        define 
            food as calaries is not null
    ) m
)
select 
    *
from
    find_pattern
where
    ranking <= 3
order by 
    ranking
;