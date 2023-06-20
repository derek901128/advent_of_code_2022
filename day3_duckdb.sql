/* Advent of Code 2022 - Day 3 Solution 1 */

with input as (
    select 
        *
    from
        read_csv(
            '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day3.csv',
            columns={'rucksacks':'varchar'}
        )
),
stg_1_compartments as (
    select 
        rucksacks, 
        substr(
            rucksacks, 
            1, 
            (length(rucksacks)/2)::INTEGER
        ) as first_compartment,
        substr(
            rucksacks, 
            (length(rucksacks)/2)::INTEGER + 1, 
            length(rucksacks)::INTEGER
        ) as second_compartment
    from 
        input
),
stg_2_compare as (
    select 
        s.*,
        list_aggregate(
            list_transform(
                list_concat(
                    list_distinct(string_split_regex(first_compartment, '')),
                    list_distinct(string_split_regex(second_compartment, ''))
                ),
                x -> ascii(x)
            ),
            'sum'
        ) as ascii_sum_dup,
        list_aggregate(
            list_transform(
                list_distinct(
                    list_concat(
                        list_distinct(string_split_regex(first_compartment, '')),
                        list_distinct(string_split_regex(second_compartment, ''))
                    )
                ),
                x -> ascii(x)
            ),
            'sum'
        ) as ascii_sum_unq,
    from 
        stg_1_compartments s
),
stg_3_type_score as (
    select 
        rucksacks,
        first_compartment,
        second_compartment,
        chr((ascii_sum_dup - ascii_sum_unq)::INTEGER) as comm_type,
        ascii_sum_dup - ascii_sum_unq  as type_score,
    from
        stg_2_compare
),
score_matrix as (
    select 
        score - 96 as score, 
        chr(score::INTEGER) as comm_type
    from 
        range(97, 97+26) as t(score, comm_type)
    union all
    select 
        score - 38 as score, 
        chr(score::INTEGER) as comm_type
    from range(65, 65+26) as t(score, comm_type)
),
output as (
    select
        sum(sm.score) 
    FROM
        stg_3_type_score ss
    join
        score_matrix sm
    on
        ss.comm_type = sm.comm_type
)
select * from output;


























