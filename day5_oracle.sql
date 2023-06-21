/* Advent of Code: Day5 - Part 1 */

with raw_rules(game_rules) as (
    select 'move 1 from 2 to 1' from dual union all
    select 'move 3 from 1 to 3' from dual union all
    select 'move 2 from 2 to 1' from dual union all
    select 'move 1 from 1 to 2' from dual
),
cleaned_up_rules (row_no, num_of_items, move_from, move_to) as (  
    select
        row_number() over(order by 1),
        regexp_substr(game_rules, '\d\d?', 1, 1), 
        regexp_substr(game_rules, '\d\d?', 1, 2),
        regexp_substr(game_rules, '\d\d?', 1, 3)
    from 
        raw_rules
),
raw_stacks(stacks) as (
    select '    [D]    ' from dual union all 
    select '[N] [C]    ' from dual union all 
    select '[Z] [M] [P]' from dual
),
break_stacks(row_no, lvl_1, lvl_2, lvl_3) as (
    select 
        row_number() over(order by 1),
        substr(stacks, 2, 1), 
        substr(stacks, 6, 1),
        substr(stacks, 10, 1) 
    from 
        raw_stacks
),
cleaned_up_stacks(stack_one, stack_two, stack_three) as (
    select 
        listagg(trim(LVL_1)) within group (order by row_no desc),
        listagg(trim(LVL_2)) within group (order by row_no desc),
        listagg(trim(LVL_3)) within group (order by row_no desc)
    from  
        break_stacks
),
moving (
        id,
        num_of_items, 
        move_from, 
        move_to,
        stack_one,
        stack_two,
        stack_three,
        items_to_remove,
        stack_one_changed,
        stack_two_changed,
        stack_three_changed
    ) as ( 
    select
        1,
        cleaned_up_rules.num_of_items, 
        cleaned_up_rules.move_from, 
        cleaned_up_rules.move_to,
        cleaned_up_stacks.stack_one, 
        cleaned_up_stacks.stack_two, 
        cleaned_up_stacks.stack_three, 
        reverse(
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
            )
        ) as items_to_remove,
        case 
            when cleaned_up_rules.move_from = '1' 
            then substr(cleaned_up_stacks.stack_one, 1, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '1' 
            then cleaned_up_stacks.stack_one || 
            reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                    '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                    '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
                )
            )
            else cleaned_up_stacks.stack_one 
        end as stack_one_changed,
        case 
            when cleaned_up_rules.move_from = '2' 
            then substr(cleaned_up_stacks.stack_two, 1, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '2' 
            then cleaned_up_stacks.stack_two ||
            reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                    '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                    '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
                )
            )
            else cleaned_up_stacks.stack_two 
        end as stack_two_changed,
        case 
            when cleaned_up_rules.move_from = '3' 
            then substr(cleaned_up_stacks.stack_three, 1, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '3' 
            then cleaned_up_stacks.stack_three ||
            reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                    '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                    '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
                )
            )
            else cleaned_up_stacks.stack_three 
        end as stack_three_changed
    from
        cleaned_up_stacks,
        cleaned_up_rules
    where
        cleaned_up_rules.row_no = 1
    union all
    select
        moving.id + 1 as id,
        cleaned_up_rules.num_of_items, 
        cleaned_up_rules.move_from, 
        cleaned_up_rules.move_to,
        moving.STACK_ONE_CHANGED as stack_one, 
        moving.STACK_TWO_CHANGED as stack_two, 
        moving.STACK_THREE_CHANGED as stack_three,
        reverse(
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
            )
        ) as items_to_remove,
        case 
            when cleaned_up_rules.move_from = '1' 
            then substr(moving.STACK_ONE_CHANGED, 1, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '1' 
            then moving.STACK_ONE_CHANGED || 
            reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                    '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                    '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
                )
            )
            else moving.STACK_ONE_CHANGED
        end as stack_one_changed,
        case 
            when cleaned_up_rules.move_from = '2' 
            then substr(moving.STACK_TWO_CHANGED, 1, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '2'
            then moving.STACK_TWO_CHANGED || reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                    '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                    '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
                )
            )
            else moving.STACK_TWO_CHANGED 
        end as stack_two_changed,
        case 
            when cleaned_up_rules.move_from = '3' 
            then substr(moving.STACK_THREE_CHANGED, 1, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items)
            when cleaned_up_rules.move_to = '3'
            then moving.STACK_THREE_CHANGED || reverse(
                decode(
                    cleaned_up_rules.move_from, 
                    '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                    '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                    '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
                )
            ) 
            else moving.STACK_THREE_CHANGED 
        end as stack_three_changed
    from
        moving,
        cleaned_up_rules
    where
        cleaned_up_rules.row_no = moving.id + 1
    and
        cleaned_up_rules.row_no <= ( select count(*) from cleaned_up_rules )
)
select
    *
from
    moving
;

/* Advent of Code: Day5 - Part 2 */

with raw_rules(game_rules) as (
    select 'move 1 from 2 to 1' from dual union all
    select 'move 3 from 1 to 3' from dual union all
    select 'move 2 from 2 to 1' from dual union all
    select 'move 1 from 1 to 2' from dual
),
cleaned_up_rules (row_no, num_of_items, move_from, move_to) as (  
    select
        row_number() over(order by 1),
        regexp_substr(game_rules, '\d\d?', 1, 1), 
        regexp_substr(game_rules, '\d\d?', 1, 2),
        regexp_substr(game_rules, '\d\d?', 1, 3)
    from 
        raw_rules
),
raw_stacks(stacks) as (
    select '    [D]    ' from dual union all 
    select '[N] [C]    ' from dual union all 
    select '[Z] [M] [P]' from dual
),
break_stacks(row_no, lvl_1, lvl_2, lvl_3) as (
    select 
        row_number() over(order by 1),
        substr(stacks, 2, 1), 
        substr(stacks, 6, 1),
        substr(stacks, 10, 1) 
    from 
        raw_stacks
),
cleaned_up_stacks(stack_one, stack_two, stack_three) as (
    select 
        listagg(trim(LVL_1)) within group (order by row_no desc),
        listagg(trim(LVL_2)) within group (order by row_no desc),
        listagg(trim(LVL_3)) within group (order by row_no desc)
    from  
        break_stacks
),
moving (
        id,
        num_of_items, 
        move_from, 
        move_to,
        stack_one,
        stack_two,
        stack_three,
        items_to_remove,
        stack_one_changed,
        stack_two_changed,
        stack_three_changed
    ) as ( 
    select
        1,
        cleaned_up_rules.num_of_items, 
        cleaned_up_rules.move_from, 
        cleaned_up_rules.move_to,
        cleaned_up_stacks.stack_one, 
        cleaned_up_stacks.stack_two, 
        cleaned_up_stacks.stack_three, 
        reverse(
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
            )
        ) as items_to_remove,
        case 
            when cleaned_up_rules.move_from = '1' 
            then substr(cleaned_up_stacks.stack_one, 1, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '1' 
            then cleaned_up_stacks.stack_one || 
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
            )
            else cleaned_up_stacks.stack_one 
        end as stack_one_changed,
        case 
            when cleaned_up_rules.move_from = '2' 
            then substr(cleaned_up_stacks.stack_two, 1, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '2' 
            then cleaned_up_stacks.stack_two ||
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
            )
            else cleaned_up_stacks.stack_two 
        end as stack_two_changed,
        case 
            when cleaned_up_rules.move_from = '3' 
            then substr(cleaned_up_stacks.stack_three, 1, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '3' 
            then cleaned_up_stacks.stack_three ||
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(cleaned_up_stacks.stack_one, length(cleaned_up_stacks.stack_one) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_one)),
                '2', substr(cleaned_up_stacks.stack_two, length(cleaned_up_stacks.stack_two) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_two)),
                '3', substr(cleaned_up_stacks.stack_three, length(cleaned_up_stacks.stack_three) - cleaned_up_rules.num_of_items + 1, length(cleaned_up_stacks.stack_three))
            )
            else cleaned_up_stacks.stack_three 
        end as stack_three_changed
    from
        cleaned_up_stacks,
        cleaned_up_rules
    where
        cleaned_up_rules.row_no = 1
    union all
    select
        moving.id + 1 as id,
        cleaned_up_rules.num_of_items, 
        cleaned_up_rules.move_from, 
        cleaned_up_rules.move_to,
        moving.STACK_ONE_CHANGED as stack_one, 
        moving.STACK_TWO_CHANGED as stack_two, 
        moving.STACK_THREE_CHANGED as stack_three,
        decode(
            cleaned_up_rules.move_from, 
            '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
            '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
            '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
        ) as items_to_remove,
        case 
            when cleaned_up_rules.move_from = '1' 
            then substr(moving.STACK_ONE_CHANGED, 1, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '1' 
            then moving.STACK_ONE_CHANGED || 
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
            )
            else moving.STACK_ONE_CHANGED
        end as stack_one_changed,
        case 
            when cleaned_up_rules.move_from = '2' 
            then substr(moving.STACK_TWO_CHANGED, 1, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items) 
            when cleaned_up_rules.move_to = '2'
            then moving.STACK_TWO_CHANGED || 
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
            )
            else moving.STACK_TWO_CHANGED 
        end as stack_two_changed,
        case 
            when cleaned_up_rules.move_from = '3' 
            then substr(moving.STACK_THREE_CHANGED, 1, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items)
            when cleaned_up_rules.move_to = '3'
            then moving.STACK_THREE_CHANGED ||
            decode(
                cleaned_up_rules.move_from, 
                '1', substr(moving.STACK_ONE_CHANGED, length(moving.STACK_ONE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_ONE_CHANGED)),
                '2', substr(moving.STACK_TWO_CHANGED, length(moving.STACK_TWO_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_TWO_CHANGED)),
                '3', substr(moving.STACK_THREE_CHANGED, length(moving.STACK_THREE_CHANGED) - cleaned_up_rules.num_of_items + 1, length(moving.STACK_THREE_CHANGED))
            )
            else moving.STACK_THREE_CHANGED 
        end as stack_three_changed
    from
        moving,
        cleaned_up_rules
    where
        cleaned_up_rules.row_no = moving.id + 1
    and
        cleaned_up_rules.row_no <= ( select count(*) from cleaned_up_rules )
)
select
    *
from
    moving
;

