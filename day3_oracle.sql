/* Advent of Code 2022 - Day 3 Solution 1 */

with 
base as (
    select 
    	row_number() over(order by rowid) as row_no,
    	cde as rucksack,
		substr(cde, 1, length(cde) / 2) as first_compart,
    	substr(cde, length(cde) / 2 + 1, length(cde)) as second_compart
    from input_day3
),
find_common_type as (
	select 
    	a.*,
    	d.individual_elem as common_type
	from 
		base a
		cross apply (
	    	select 
				substr(first_compart, level, 1) as individual_elem
	    	from 
				( select * from base b where a.row_no = b.row_no )
		    	connect by
		    		level <= length(first_compart)
	    	intersect
	    	select 
				substr(second_compart, level, 1) individual_elem
	    	from 
	    		( select * from base c where a.row_no = c.row_no )
		    	connect by
		    		level <= length(second_compart)
	    ) d   
),
score_matrix as (
	select 
    	level as score,
		chr(96 + level) as letter
    from 
    	dual
		connect by 
	    	level <= 26
    union all
    select 
    	level + 26 as score,
		chr(64 + level) as letter 
    from 
    	dual
		connect by 
	    	level <= 26
),
score_match as (
	select 
    	a.*,
    	b.score
	from 
		find_common_type a 
		join score_matrix b
    		on a.common_type = b.letter
),
score_result as (
	select 
    	sum(score) as total_score
	from score_match
)
select * from score_result;

/* Advent of Code 2022 - Day 3 Solution 2 */

with base as (
    select 
    	row_number() over(order by rowid) as row_no,
    	cde as rucksack
    from input_day3
),
find_groups as (
    select 
        *
    from
        base
    match_recognize (
        order by 
        	row_no
        measures
    		classifier() as cla,
        	match_number() as group_no
        all rows per match 
        pattern
        	( frst sec third )
    	define
    		sec as sec.row_no = frst.row_no + 1,
    		third as third.row_no = sec.row_no + 1
    )
),
groups_pivot as (
    select 
    	find_groups.GROUP_NO,
    	max(case when cla = 'FRST' then RUCKSACK else '' end) as frst,
    	max(case when cla = 'SEC' then RUCKSACK else '' end) as sec,
    	max(case when cla = 'THIRD' then RUCKSACK else '' end) as third
    from find_groups
    group by find_groups.GROUP_NO
),
find_common_type as (
    select 
    	b.*,
        f.individual_elem as common_type
    from
        groups_pivot b 
    cross apply (
        select 
            substr(FRST, level, 1) as individual_elem
		from
			( select * from groups_pivot c where c.GROUP_NO = b.GROUP_NO )
			connect by
				level <= length(FRST)
	    intersect
		select 
			substr(SEC, level, 1) as individual_elem
		from
			( select * from groups_pivot d where d.GROUP_NO = b.GROUP_NO )
			connect by
				level <= length(SEC)
        intersect
        select 
            substr(THIRD, level, 1) as individual_elem
        from
            ( select * from groups_pivot e where e.GROUP_NO = b.GROUP_NO )
	        connect by
	            level <= length(THIRD)
    ) f
),
score_matrix as (
	select 
    	level as score,
		chr(96 + level) as letter
    from 
		dual
		connect by 
	    	level <= 26
    union all
    select 
    	level + 26 as score,
		chr(64 + level) as letter 
    from 
    	dual
		connect by 
	    	level <= 26
),
score_match as (
	select 
    	a.*,
    	b.score
	from 
		find_common_type a 
		join score_matrix b
    		on a.common_type = b.letter
),
score_result as (
	select 
    	sum(score) as total_score
	from score_match
)
select * from score_result;
