create or replace macro reverse_items(items) as 
    [x[2] for x in list_reverse_sort([ [case when x < 10 then x else '9' || x end, items[x+1]] for x in range(len(items))]) ]
;

create or replace view input as 
    select 
        row_number() over() as row_no,
        column0 as raw
    from
        read_csv_auto('day5.csv')
;

create or replace view rules as
    SELECT 
        row_number() over() as rule_no,
        list_filter(
            string_split(raw, ' '),
            x -> x similar to '\d\d?'
        )[2] as move_from,
        list_filter(
            string_split(raw, ' '),
            x -> x similar to '\d\d?'
        )[3] as move_to,
        list_filter(
            string_split(raw, ' '),
            x -> x similar to '\d\d?'
        )[1] as num_of_items_to_move
    FROM
        input
    WHERE 
        row_no > 10
;

create or replace view stacks as 
    with raw_stacks as (
        select
            row_no,
            raw[2],
            raw[6],
            raw[10],
            raw[14],
            raw[18],
            raw[22],
            raw[26],
            raw[30],
            raw[34]
        from
            input
        where
            row_no < 9
    ),
    stacks_agg as (
        select
            list(columns(c -> c like 'raw%') order by row_no desc)
        from
            raw_stacks
    ),
    stacks_filtered(
        stack_one, 
        stack_two, 
        stack_three,
        stack_four, 
        stack_five,
         stack_six, 
        stack_seven, 
        stack_eight, 
        stack_nine
    ) as (
        select 
            list_filter (
                columns(c -> c like 'list%'),
                x -> x <> ' '
            )
        from 
            stacks_agg
    )
select * from stacks_filtered
;


create or replace temp macro result_set (no_of_rules) as table
with recursive moving (
    rec_no,
    stack_one_original,
    stack_one_changed,
    stack_two_original,
    stack_two_changed,
    stack_three_original,
    stack_three_changed,
    stack_four_original,
    stack_four_changed,
    stack_five_original,
    stack_five_changed,
    stack_six_original,
    stack_six_changed,
    stack_seven_original,
    stack_seven_changed,
    stack_eight_original,
    stack_eight_changed,
    stack_nine_original,
    stack_nine_changed,
    removed_items
) as (
    select 
        rec_no,
        stack_one_original,
        case 
            when move_to = '1'
            then list_concat( stack_one_original, reverse_items(removed_items) )
            else stack_one_changed
        end,
        stack_two_original,
        case 
            when move_to = '2'
            then list_concat( stack_two_original, reverse_items(removed_items) )
            else stack_two_changed
        end,
        stack_three_original,
        case 
            when move_to = '3'
            then list_concat( stack_three_original, reverse_items(removed_items) )
            else stack_three_changed
        end,
        stack_four_original,
        case 
            when move_to = '4'
            then list_concat( stack_four_original, reverse_items(removed_items) )
            else stack_four_changed
        end,
        stack_five_original,
        case 
            when move_to = '5'
            then list_concat( stack_five_original, reverse_items(removed_items) )
            else stack_five_changed
        end,
        stack_six_original,
        case 
            when move_to = '6'
            then list_concat( stack_six_original, reverse_items(removed_items) )
            else stack_six_changed
        end,
        stack_seven_original,
        case 
            when move_to = '7'
            then list_concat( stack_seven_original, reverse_items(removed_items) )
            else stack_seven_changed
        end,
        stack_eight_original,
        case 
            when move_to = '8'
            then list_concat( stack_eight_original, reverse_items(removed_items) )
            else stack_eight_changed
        end,
        stack_nine_original,
        case 
            when move_to = '9'
            then list_concat( stack_nine_original, reverse_items(removed_items) )
            else stack_nine_changed
        end,
        removed_items
    from
        (
            select 
                1 as rec_no,
                stacks.stack_one as stack_one_original,
                stacks.stack_two as stack_two_original,
                stacks.stack_three as stack_three_original,
                stacks.stack_four as stack_four_original,
                stacks.stack_five as stack_five_original,
                stacks.stack_six as stack_six_original,
                stacks.stack_seven as stack_seven_original,
                stacks.stack_eight as stack_eight_original,
                stacks.stack_nine as stack_nine_original,
                rules.move_to as move_to,
                rules.move_from as move_from,
                rules.num_of_items_to_move as num_of_items_to_move,
                case 
                    when rules.move_from = '1'
                    then stacks.stack_one[1:len(stacks.stack_one) - rules.num_of_items_to_move::integer]
                    else stacks.stack_one
                end as stack_one_changed,
                case 
                    when rules.move_from = '2'
                    then stacks.stack_two[1:len(stacks.stack_two) - rules.num_of_items_to_move::integer]
                    else stacks.stack_two
                end as stack_two_changed,
                case 
                    when rules.move_from = '3'
                    then stacks.stack_three[1:len(stacks.stack_three) - rules.num_of_items_to_move::integer]
                    else stacks.stack_three
                end as stack_three_changed,
                case 
                    when rules.move_from = '4'
                    then stacks.stack_four[1:len(stacks.stack_four) - rules.num_of_items_to_move::integer]
                    else stacks.stack_four
                end as stack_four_changed,
                case 
                    when rules.move_from = '5'
                    then stacks.stack_five[1:len(stacks.stack_five) - rules.num_of_items_to_move::integer]
                    else stacks.stack_five
                end as stack_five_changed,
                case 
                    when rules.move_from = '6'
                    then stacks.stack_six[1:len(stacks.stack_six) - rules.num_of_items_to_move::integer]
                    else stacks.stack_six
                end as stack_six_changed,
                case 
                    when rules.move_from = '7'
                    then stacks.stack_seven[1:len(stacks.stack_seven) - rules.num_of_items_to_move::integer]
                    else stacks.stack_seven
                end as stack_seven_changed,
                case 
                    when rules.move_from = '8'
                    then stacks.stack_eight[1:len(stacks.stack_eight) - rules.num_of_items_to_move::integer]
                    else stacks.stack_eight
                end as stack_eight_changed,
                case 
                    when rules.move_from = '9'
                    then stacks.stack_nine[1:len(stacks.stack_nine) - rules.num_of_items_to_move::integer]
                    else stacks.stack_nine
                end as stack_nine_changed,
                case 
                    when rules.move_from = '1'
                    then stacks.stack_one[len(stacks.stack_one) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '2'
                    then stacks.stack_two[len(stacks.stack_two) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '3'
                    then stacks.stack_three[len(stacks.stack_three) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '4'
                    then stacks.stack_four[len(stacks.stack_four) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '5'
                    then stacks.stack_five[len(stacks.stack_five) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '6'
                    then stacks.stack_six[len(stacks.stack_six) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '7'
                    then stacks.stack_seven[len(stacks.stack_seven) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '8'
                    then stacks.stack_eight[len(stacks.stack_eight) - rules.num_of_items_to_move::integer + 1: ]
                    when rules.move_from = '9'
                    then stacks.stack_nine[len(stacks.stack_nine) - rules.num_of_items_to_move::integer + 1: ]
                end as removed_items
            from 
                stacks,  
                ( select * from rules where rule_no = 1 ) rules
        )
    union all
    select 
        rec_no,
        stack_one_original,
        case
            when move_to = '1'
            THEN list_concat( stack_one_changed, reverse_items(removed_items) )
            else stack_one_changed
        end,
        stack_two_original,
        case
            when move_to = '2'
            THEN list_concat( stack_two_changed, reverse_items(removed_items) )
            else stack_two_changed
        end,
        stack_three_original,
        case
            when move_to = '3'
            THEN list_concat( stack_three_changed, reverse_items(removed_items) )
            else stack_three_changed
        end,
        stack_four_original,
        case
            when move_to = '4'
            THEN list_concat( stack_four_changed, reverse_items(removed_items) )
            else stack_four_changed
        end,
        stack_five_original,
        case
            when move_to = '5'
            THEN list_concat( stack_five_changed, reverse_items(removed_items) )
            else stack_five_changed
        end,
        stack_six_original,
        case
            when move_to = '6'
            THEN list_concat( stack_six_changed, reverse_items(removed_items) )
            else stack_six_changed
        end,
        stack_seven_original,
        case
            when move_to = '7'
            THEN list_concat( stack_seven_changed, reverse_items(removed_items) )
            else stack_seven_changed
        end,
        stack_eight_original,
        case
            when move_to = '8'
            THEN list_concat( stack_eight_changed, reverse_items(removed_items) )
            else stack_eight_changed
        end,
        stack_nine_original,
        case
            when move_to = '9'
            THEN list_concat( stack_nine_changed, reverse_items(removed_items) )
            else stack_nine_changed
        end,
        removed_items
    from 
        (
            select 
                moving.rec_no + 1 as rec_no,
                moving.stack_one_changed as stack_one_original,
                moving.stack_two_changed as stack_two_original,
                moving.stack_three_changed as stack_three_original,
                moving.stack_four_changed as stack_four_original,
                moving.stack_five_changed as stack_five_original,
                moving.stack_six_changed as stack_six_original,
                moving.stack_seven_changed as stack_seven_original,
                moving.stack_eight_changed as stack_eight_original,
                moving.stack_nine_changed as stack_nine_original,
                rules.move_to as move_to,
                rules.move_from as move_from,
                rules.num_of_items_to_move as num_of_items_to_move,
                case 
                    when rules.move_from = '1'
                    then moving.stack_one_changed[1: len(moving.stack_one_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_one_changed
                end as stack_one_changed,
                case 
                    when rules.move_from = '2'
                    then moving.stack_two_changed[1: len(moving.stack_two_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_two_changed
                end as stack_two_changed,
                case 
                    when rules.move_from = '3'
                    then moving.stack_three_changed[1: len(moving.stack_three_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_three_changed
                end as stack_three_changed,
                case 
                    when rules.move_from = '4'
                    then moving.stack_four_changed[1: len(moving.stack_four_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_four_changed
                end as stack_four_changed,
                case 
                    when rules.move_from = '5'
                    then moving.stack_five_changed[1: len(moving.stack_five_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_five_changed
                end as stack_five_changed,
                case 
                    when rules.move_from = '6'
                    then moving.stack_six_changed[1: len(moving.stack_six_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_six_changed
                end as stack_six_changed,
                case 
                    when rules.move_from = '7'
                    then moving.stack_seven_changed[1: len(moving.stack_seven_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_seven_changed
                end as stack_seven_changed,
                case 
                    when rules.move_from = '8'
                    then moving.stack_eight_changed[1: len(moving.stack_eight_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_eight_changed
                end as stack_eight_changed,
                case 
                    when rules.move_from = '9'
                    then moving.stack_nine_changed[1: len(moving.stack_nine_changed) - rules.num_of_items_to_move::integer]
                    else moving.stack_nine_changed
                end as stack_nine_changed,
                case 
                    when rules.move_from = '1'
                    then moving.stack_one_changed[len(moving.stack_one_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '2'
                    then moving.stack_two_changed[len(moving.stack_two_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '3'
                    then moving.stack_three_changed[len(moving.stack_three_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '4'
                    then moving.stack_four_changed[len(moving.stack_four_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '5'
                    then moving.stack_five_changed[len(moving.stack_five_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '6'
                    then moving.stack_six_changed[len(moving.stack_six_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '7'
                    then moving.stack_seven_changed[len(moving.stack_seven_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '8'
                    then moving.stack_eight_changed[len(moving.stack_eight_changed) - rules.num_of_items_to_move::integer + 1:] 
                    when rules.move_from = '9'
                    then moving.stack_nine_changed[len(moving.stack_nine_changed) - rules.num_of_items_to_move::integer + 1:] 
                end as removed_items 
            from 
                moving,
                ( select * from rules where rule_no = rec_no + 1 ) rules
        )
    where 
        rec_no <= no_of_rules
)
select 
    rec_no, 
    stack_one_original,
    stack_one_changed,
    stack_two_original,
    stack_two_changed,
    stack_three_original,
    stack_three_changed,
    stack_four_original,
    stack_four_changed,
    stack_five_original,
    stack_five_changed,
    stack_six_original,
    stack_six_changed,
    stack_seven_original,
    stack_seven_changed,
    stack_eight_original,
    stack_eight_changed,
    stack_nine_original,
    stack_nine_changed,
    stack_one_changed[-1:] as one_last, 
    stack_two_changed[-1:] as two_last, 
    stack_three_changed[-1:] as three_last, 
    stack_four_changed[-1:] as four_last, 
    stack_five_changed[-1:] as five_last, 
    stack_six_changed[-1:] as six_last, 
    stack_seven_changed[-1:] as seven_last, 
    stack_eight_changed[-1:] as eight_last,
    stack_nine_changed[-1:] as nine_last
from 
    moving
;   

create or replace temp macro testing (no_of_rules) as table
with recursive testing (
    id,
    rule_no,
    move_from,
    move_to,
    num_of_items_to_move,
    one_changed,
    two_changed,
    three_changed,
    four_changed,
    five_changed,
    six_changed,
    seven_changed,
    eight_changed,
    nine_changed
) as (
    select
        1,
        rules.rule_no,
        rules.move_from,
        rules.move_to,
        rules.num_of_items_to_move,
        case 
            when rules.move_from = '1' then one - rules.num_of_items_to_move::integer 
            when rules.move_to = '1' then one + rules.num_of_items_to_move::integer  
            else one 
        end,
        case 
            when rules.move_from = '2' then two - rules.num_of_items_to_move::integer 
            when rules.move_to = '2' then two + rules.num_of_items_to_move::integer  
            else two 
        end,
        case 
            when rules.move_from = '3' then three - rules.num_of_items_to_move::integer 
            when rules.move_to = '3' then three + rules.num_of_items_to_move::integer  
            else three 
        end,
        case 
            when rules.move_from = '4' then four - rules.num_of_items_to_move::integer 
            when rules.move_to = '4' then four + rules.num_of_items_to_move::integer  
            else four 
        end,
        case 
            when rules.move_from = '5' then five - rules.num_of_items_to_move::integer 
            when rules.move_to = '5' then five + rules.num_of_items_to_move::integer  
            else five 
        end,
        case 
            when rules.move_from = '6' then six - rules.num_of_items_to_move::integer 
            when rules.move_to = '6' then six + rules.num_of_items_to_move::integer  
            else six 
        end,
        case 
            when rules.move_from = '7' then seven - rules.num_of_items_to_move::integer 
            when rules.move_to = '7' then seven + rules.num_of_items_to_move::integer  
            else seven 
        end,
        case 
            when rules.move_from = '8' then eight - rules.num_of_items_to_move::integer 
            when rules.move_to = '8' then eight + rules.num_of_items_to_move::integer  
            else eight 
        end,
        case 
            when rules.move_from = '9' then nine - rules.num_of_items_to_move::integer 
            when rules.move_to = '9' then nine + rules.num_of_items_to_move::integer  
            else nine 
        end
    from 
        (
            select 
                len(columns(c -> c like 'stack%')) 
            from 
                stacks
        ) as stacks (
            one,
            two,
            three,
            four,
            five,
            six,
            seven,
            eight,
            nine
        ), 
        ( select * from rules where rule_no = 1 ) rules
    UNION all 
    select 
        id + 1,
        rules.rule_no,
        rules.move_from,
        rules.move_to,
        rules.num_of_items_to_move,
        case 
            when rules.move_from = '1' then testing.one_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '1' then testing.one_changed + rules.num_of_items_to_move::integer  
            else testing.one_changed 
        end,
        case 
            when rules.move_from = '2' then testing.two_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '2' then testing.two_changed + rules.num_of_items_to_move::integer  
            else testing.two_changed 
        end,
        case 
            when rules.move_from = '3' then testing.three_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '3' then testing.three_changed + rules.num_of_items_to_move::integer  
            else testing.three_changed 
        end,
        case 
            when rules.move_from = '4' then testing.four_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '4' then testing.four_changed + rules.num_of_items_to_move::integer  
            else testing.four_changed 
        end,
        case 
            when rules.move_from = '5' then testing.five_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '5' then testing.five_changed + rules.num_of_items_to_move::integer  
            else testing.five_changed 
        end,
        case 
            when rules.move_from = '6' then testing.six_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '6' then testing.six_changed + rules.num_of_items_to_move::integer  
            else testing.six_changed 
        end,
        case 
            when rules.move_from = '7' then testing.seven_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '7' then testing.seven_changed + rules.num_of_items_to_move::integer  
            else testing.seven_changed 
        end,
        case 
            when rules.move_from = '8' then testing.eight_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '8' then testing.eight_changed + rules.num_of_items_to_move::integer  
            else testing.eight_changed 
        end,
        case 
            when rules.move_from = '9' then testing.nine_changed - rules.num_of_items_to_move::integer 
            when rules.move_to = '9' then testing.nine_changed + rules.num_of_items_to_move::integer  
            else testing.nine_changed 
        end
    from
        testing, 
        ( select * from rules where rule_no = id + 1 ) rules
    where
        rules.rule_no <= no_of_rules
)
select * from testing
;

select * from result_set(504);


