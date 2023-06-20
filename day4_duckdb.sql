/* Advent of Code 2022 - Day 4 Solution 1 */

with input as (
    select 
        row_number() over() as row_no,
        section_1, 
        str_split(section_1, '-')[1]::Integer as section_1_min,
        str_split(section_1, '-')[2]::Integer as section_1_max,
        section_2,
        str_split(section_2, '-')[1]::Integer as section_2_min,
        str_split(section_2, '-')[2]::Integer as section_2_max
    from    
        read_csv(
            '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day4.csv',
            delim=',',
            columns={
                'section_1': 'varchar',
                'section_2': 'varchar',
            }
        )
),
find_fully_contained as (
    select 
        row_no,
        section_1,
        section_2,
        case  
            when (
                section_1_min between section_2_min and section_2_max and 
                section_1_max between section_2_min and section_2_max 
            ) 
            then 'Y'
            else 'N'
        end as section_1_fully_contained,
        case  
            when (
                section_2_min between section_1_min and section_1_max and 
                section_2_max between section_1_min and section_1_max 
            ) 
            then 'Y'
            else 'N'
        end as section_2_fully_contained,
    from  
        input
),
no_of_fully_ontained as (
    select 
        count(*) 
    from 
        find_fully_contained 
    where 
        section_1_fully_contained = 'Y' 
    or 
        section_2_fully_contained = 'Y'
)
select * from no_of_fully_ontained;

/* Advent of Code 2022 - Day 4 Solution 2 */

with input as (
    select 
        row_number() over() as row_no,
        section_1, 
        str_split(section_1, '-')[1]::Integer as section_1_min,
        str_split(section_1, '-')[2]::Integer as section_1_max,
        section_2,
        str_split(section_2, '-')[1]::Integer as section_2_min,
        str_split(section_2, '-')[2]::Integer as section_2_max
    from    
        read_csv(
            '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day4.csv',
            delim=',',
            columns={
                'section_1': 'varchar',
                'section_2': 'varchar',
            }
        )
),
find_overlapped as (
    select 
        row_no,
        section_1,
        section_2,
        case  
            when (
                section_1_min between section_2_min and section_2_max or 
                section_1_max between section_2_min and section_2_max 
            ) 
            then 'Y'
            else 'N'
        end as section_1_overlapped,
        case  
            when (
                section_2_min between section_1_min and section_1_max or 
                section_2_max between section_1_min and section_1_max 
            ) 
            then 'Y'
            else 'N'
        end as section_2_overlapped,
    from  
        input
),
no_of_overlap as (
    select 
        count(*) 
    from 
        find_overlapped 
    where 
        section_1_overlapped = 'Y' 
    or 
        section_2_overlapped = 'Y'
)
select * from no_of_overlap;
