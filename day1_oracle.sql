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
grp as (
    select 
    	cal,
    	nvl(max(nvl2(cal, 0, rownum)) over(order by rownum rows between unbounded preceding and 1 preceding), 0) as grp_no
    from
    	raw_input
)
select 
    sum(cal) 
from 
    grp 
group by 
    grp_no 
order by 
    sum(cal) desc 
fetch first 3 row only
;
