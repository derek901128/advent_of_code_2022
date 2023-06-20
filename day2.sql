/* 1. Part 1 */

with input as (
    SELECT 
        *,
        row_number()over() as row_no
    from
        read_csv(
            '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day2.csv', 
            delim=' ', 
            header=False, 
            columns={'oppo': 'varchar', 'you': 'varchar'}
        )
),
score_comparison as (
    select
        *
    FROM ( 
        values 
            ('X', 'A', 3),
            ('X', 'B', 0),
            ('X', 'C', 6),
            ('Y', 'A', 6),
            ('Y', 'B', 3),
            ('Y', 'C', 0),
            ('Z', 'A', 0),
            ('Z', 'B', 6),
            ('Z', 'C', 3)
    ) as t(you, oppo, score)
),
score_by_itself as (
    select 
        *
    FROM (
        values 
            ('X', 1),
            ('Y', 2),
            ('Z', 3)
    ) as t(you, score)
),
final_result as (
    select 
        i.row_no,
        i.oppo,
        i.you, 
        sc.score as score_by_comparison, 
        sbi.score as score_by_itself,
        sc.score + sbi.score as total_score
    from 
        input i 
    join 
        score_comparison sc 
    on 
        i.you = sc.you
    and 
        i.oppo = sc.oppo
    join
        score_by_itself sbi 
    on 
        i.you = sbi.you
)
select sum(total_score) from final_result;

/* 2. Part 2 */

with input as (
    SELECT 
        *,
        row_number()over() as row_no
    from
        read_csv(
            '/Users/derek901128/Desktop/programming languages/sql/aoc2022/day2.csv', 
            delim=' ', 
            header=False, 
            columns={'oppo': 'varchar', 'result_code': 'varchar'}
        )
),
matrix as (
    select
        *
    FROM ( 
        values 
            ('A', 'A', 'draw'),
            ('A', 'B', 'lose'),
            ('A', 'C', 'win'),
            ('B', 'A', 'win'),
            ('B', 'B', 'draw'),
            ('B', 'C', 'lose'),
            ('C', 'A', 'lose'),
            ('C', 'B', 'win'),
            ('C', 'C', 'draw')
    ) as t(main, oppo, game_result) 
),
result_score as (
    select 
        *
    FROM (
        values 
            ('X', 'lose', 0),
            ('Y', 'draw', 3),
            ('Z', 'win', 6)
    ) as t(result_code, game_result, score)
),
choice_score as (
    select 
        *
    FROM (
        values 
            ('A', 1),
            ('B', 2),
            ('C', 3)
    ) as t(choice, score)

),
final_result as (
    select 
        i.row_no,
        i.oppo,
        i.result_code, 
        rs.game_result,
        rs.score as score_by_result,
        m.main as your_choice,
        cs.score as score_by_choice,
        rs.score + cs.score as total_score 
    from 
        input i 
    join
        result_score rs
    on 
        i.result_code = rs.result_code
    join
        matrix m 
    on
        m.game_result = rs.game_result
    and 
        m.oppo = i.oppo
    join
        choice_score cs
    on
        cs.choice = m.main
)
select sum(total_score) from final_result;



