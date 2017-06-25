from (select id, rl_id, row_number() over(PARTITION BY id ORDER BY modify_date desc) as rowid from table_1)tt where rowid = 1)
