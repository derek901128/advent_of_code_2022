/*Advent of Code: Day 10 - Part 1 */

with raw_input(commands) as (
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'noop' from dual union all
    select 'addx 3' from dual union all
    select 'addx -2' from dual union all
    select 'addx 4' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 7' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'addx -10' from dual union all
    select 'addx 2' from dual union all
    select 'addx 14' from dual union all
    select 'noop' from dual union all
    select 'addx -38' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'addx 20' from dual union all
    select 'addx -19' from dual union all
    select 'addx 28' from dual union all
    select 'addx -21' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'addx 2' from dual union all
    select 'addx -4' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx -4' from dual union all
    select 'addx 11' from dual union all
    select 'addx -27' from dual union all
    select 'addx 28' from dual union all
    select 'addx -38' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx -1' from dual union all
    select 'noop' from dual union all
    select 'addx 6' from dual union all
    select 'addx 3' from dual union all
    select 'addx -2' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 7' from dual union all
    select 'addx 2' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'addx 2' from dual union all
    select 'addx -11' from dual union all
    select 'addx 6' from dual union all
    select 'addx 8' from dual union all
    select 'noop' from dual union all
    select 'addx 3' from dual union all
    select 'addx -37' from dual union all
    select 'addx 1' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx -5' from dual union all
    select 'addx 13' from dual union all
    select 'addx 2' from dual union all
    select 'addx -8' from dual union all
    select 'addx 9' from dual union all
    select 'addx 4' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'addx -2' from dual union all
    select 'addx -14' from dual union all
    select 'addx 21' from dual union all
    select 'addx 1' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx -38' from dual union all
    select 'addx 2' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'addx -2' from dual union all
    select 'noop' from dual union all
    select 'addx 11' from dual union all
    select 'addx -6' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'addx 2' from dual union all
    select 'addx -10' from dual union all
    select 'addx 15' from dual union all
    select 'noop' from dual union all
    select 'addx -24' from dual union all
    select 'addx 17' from dual union all
    select 'addx 10' from dual union all
    select 'noop' from dual union all
    select 'addx 3' from dual union all
    select 'addx -38' from dual union all
    select 'addx 5' from dual union all
    select 'addx 2' from dual union all
    select 'addx 3' from dual union all
    select 'addx -2' from dual union all
    select 'addx 2' from dual union all
    select 'addx 7' from dual union all
    select 'addx 1' from dual union all
    select 'addx -1' from dual union all
    select 'noop' from dual union all
    select 'addx 5' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'addx -21' from dual union all
    select 'addx 28' from dual union all
    select 'addx 1' from dual union all
    select 'noop' from dual union all
    select 'addx 2' from dual union all
    select 'noop' from dual union all
    select 'addx 3' from dual union all
    select 'noop' from dual union all
    select 'noop' from dual
),
set_up as (
    select
        row_number() over(order by 1) as command_no,
        commands,
        case commands
            when 'noop'
            then 1
            else 2
        end as cycles_needed,
        case 
            when commands like 'addx%'
            then to_number(ltrim(commands, 'addx '))  
            else 0
        end as x_to_add
    from
        raw_input
),
each_cycle as (
    select 
        d.*,
        row_number() over(order by d.command_no, d.cycle_no) as round_no,
        case 
            when max(d.cycle_no) over(partition by d.command_no) = d.cycle_no 
            then d.x_to_add
            else 0
        end as actual_x_to_add
    from 
        set_up a 
    cross apply (
        select 
            c.*,
            level as cycle_no
        from
            ( select * from set_up b where a.command_no = b.command_no ) c 
        connect by 
            level <= c.cycles_needed
    ) d
),
semi_final as (
    select 
        round_no,
        commands,
        actual_x_to_add,
		lpad('.', 40, '.') as base_grid_1,
    	lpad('.', 40, '.') as base_grid_2,
    	lpad('.', 40, '.') as base_grid_3,
    	lpad('.', 40, '.') as base_grid_4,
    	lpad('.', 40, '.') as base_grid_5,
    	lpad('.', 40, '.') as base_grid_6,
        sum(actual_x_to_add) over(order by round_no rows between unbounded preceding and 1 preceding) + 1 as total_during,
    	sum(actual_x_to_add) over(order by round_no rows between unbounded preceding and current row) + 1 as total_end,
        (sum(actual_x_to_add) over(order by round_no rows between unbounded preceding and 1 preceding) + 1) * round_no as strength_signal
    from 
        each_cycle
),
part1 as (
    select 
        sum(strength_signal) as answer
    from
        semi_final
    where
        round_no in (20, 60, 100, 140, 180, 220)
),
part2_staging(id, round_no, commands, total_during, total_end, grid_1, grid_2, grid_3, grid_4, grid_5, grid_6) as (
    select
    	1,
    	round_no,
    	commands,
    	total_during,
    	total_end,
    	case 
    		when (round_no between 1 and 40) and (round_no between nvl(total_during, 1) and nvl(total_during, 1) + 2)
    		then regexp_replace(base_grid_1, '.{1}', '#', round_no, 1)
    		else base_grid_1
    	end,
		case
    		when (round_no between 41 and 80) and (round_no - 40 between nvl(total_during, 1) and nvl(total_during, 1) + 2)
    		then regexp_replace(base_grid_2, '.{1}', '#', round_no - 40, 1)
    		else base_grid_2
    	end,
    	case
            when (round_no between 81 and 120) and (round_no - 80 between nvl(total_during, 1) and nvl(total_during, 1) + 2)
    		then regexp_replace(base_grid_3, '.{1}', '#', round_no - 80, 1)
    		else base_grid_3
    	end,
    	case 
            when (round_no between 121 and 160) and (round_no - 120 between nvl(total_during, 1) and nvl(total_during, 1) + 2)
   	 		then regexp_replace(base_grid_4, '.{1}', '#', round_no - 120, 1)
    		else base_grid_4
    	end,
    	case
            when (round_no between 161 and 200) and (round_no - 160 between nvl(total_during, 1) and nvl(total_during, 1) + 2)
			then regexp_replace(base_grid_5, '.{1}', '#', round_no - 160, 1)
    		else base_grid_5
    	end,
    	case 
            when (round_no between 201 and 240) and (round_no - 200 between nvl(total_during, 1) and nvl(total_during, 1) + 2)
            then regexp_replace(base_grid_6, '.{1}', '#', round_no - 200, 1)
            else base_grid_6
        end
    from
    	semi_final
	where	
    	round_no = 1
    union all
    select 
		part2_staging.id + 1,
    	semi_final.round_no,
    	semi_final.commands,
    	semi_final.total_during,
    	semi_final.total_end,
		case 
    		when (semi_final.round_no between 1 and 40) and (semi_final.round_no between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2)
    		then regexp_replace(part2_staging.grid_1, '.{1}', '#', semi_final.round_no, 1)
    		else part2_staging.grid_1
    	end,
		case
    		when (semi_final.round_no between 41 and 80) and (semi_final.round_no - 40 between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2) 
    		then regexp_replace(part2_staging.grid_2, '.{1}', '#', semi_final.round_no - 40, 1)
    		else part2_staging.grid_2
    	end,
    	case
            when (semi_final.round_no between 81 and 120) and (semi_final.round_no - 80 between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2) 
    		then regexp_replace(part2_staging.grid_3, '.{1}', '#', semi_final.round_no - 80, 1)
    		else part2_staging.grid_3
    	end,
    	case 
            when (semi_final.round_no between 121 and 160) and (semi_final.round_no - 120 between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2) 
   	 		then regexp_replace(part2_staging.grid_4, '.{1}', '#', semi_final.round_no - 120, 1)
    		else part2_staging.grid_4
    	end,
    	case
            when (semi_final.round_no between 161 and 200) and (semi_final.round_no - 160 between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2)
			then regexp_replace(part2_staging.grid_5, '.{1}', '#', semi_final.round_no - 160, 1)
    		else part2_staging.grid_5
    	end,
    	case 
            when (semi_final.round_no between 201 and 240) and (semi_final.round_no - 200 between nvl(semi_final.total_during, 1) and nvl(semi_final.total_during, 1) + 2)
            then regexp_replace(part2_staging.grid_6, '.{1}', '#', semi_final.round_no - 200, 1)
            else part2_staging.grid_6
        end
    from
    	part2_staging
    join
    	semi_final 
    on
    	part2_staging.id + 1 = semi_final.round_no
    where
    	part2_staging.id <= 240
	
),
part2_final(answer) as (
    select grid_1 from part2_staging where round_no = 240 union all
    select grid_2 from part2_staging where round_no = 240 union all
    select grid_3 from part2_staging where round_no = 240 union all
    select grid_4 from part2_staging where round_no = 240 union all
    select grid_5 from part2_staging where round_no = 240 union all
    select grid_6 from part2_staging where round_no = 240
)
select replace(answer, '.', ' ') from part2_final;



