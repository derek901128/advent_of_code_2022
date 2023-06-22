/* Advent of Code 2022: Day 6 - Part 1 & 2 */

create macro result_set(requirement) as table 
    with raw_input(full_str) as (
        select 
            *
        from
            'day6_input.csv'
    ),
    str_massage as (
    select
        list_position(
            list_apply(
                [str_split(full_str, '')[x:x+requirement - 1] for x in range(1, length(full_str) - (requirement - 1))],
                x -> len(list_distinct(x))
            ),
            requirement
        ) + requirement - 1 as answer
    from 
        raw_input
    )
    select answer from str_massage
;

select * from result_set(4);
select * from result_set(14);

