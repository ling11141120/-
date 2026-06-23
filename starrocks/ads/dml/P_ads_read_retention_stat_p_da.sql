----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_1_dt__0
-- task_version     : 15
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_1_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_1_dt}' and date_stat_type = 0;

-- SQL语句
insert into ads.ads_read_retention_stat_p_da
with d7_consume_users as (
    select a.product_id
         , a.book_id
         , a.user_id
      from dws.dws_user_first_read_book_est_ed       as a
      left join dwm.dwm_consume_user_consume_w5_p_di as b
        on a.product_id = b.product_id
       and a.book_id = b.book_id
       and a.user_id = b.user_id
       and b.types = 1
       and b.con_chp_amount > 0
       and b.dt = '${bf_1_dt}'
     where a.dt = '${bf_1_dt}'
     group by a.product_id, a.book_id, a.user_id
    having count(distinct b.dt) = 1
)
select a.dt
     , case when right (a.book_id, 3)=322 then 3
            when right (a.book_id, 3)=418 then 7
            when right (a.book_id, 3)=409 then 5
            when right (a.book_id, 3)=414 then 11
            when right (a.book_id, 3)=445 then 15
            when right (a.book_id, 3)=375 then 4
            when right (a.book_id, 3)=410 then 6
            when right (a.book_id, 3)=419 then 9
            when right (a.book_id, 3)=433 then 12
            when right (a.book_id, 3)=436 then 14
            when right (a.book_id, 3)=412 then 16
            when right (a.book_id, 3)=413 then 8
            when right (a.book_id, 3)=415 then 10
            when right (a.book_id, 3)=447 then 17
            when right (a.book_id, 3)=448 then 18
            when right (a.book_id, 3)='001' then 3
            when a.product_id =3333 then 2
            when a.product_id in (7757, 8858, 7777, 8888) then 1
            else -99
        end                                                          as lang_id
     , a.book_id
     , case when a.mt is null then 0 else a.mt end                   as mt
     , a.source_user_tp
     , 0                                                             as date_stat_type
     , b.book_name
     , b.book_code
     , case when a.user_id is not null then to_bitmap(a.user_id) end as first_read_user
     , case when a.user_id is not null then to_bitmap(a.user_id) end as read_users
     , case when d.con_chp_amount > 0 then d.con_chp_amount end      as consume_amount
     , case when d.user_id is not null then to_bitmap(d.user_id) end as consume_users
     , case when a.user_id is not null then to_bitmap(a.user_id) end as d7_read_users
     , case when f.user_id is not null then to_bitmap(f.user_id) end as d7_consume_users
     , now()
  from dws.dws_user_first_read_book_est_ed           as a
  left join dim.dim_shuangwen_book_read_consume_info as b
    on a.book_id = b.book_id
  left join dwm.dwm_consume_user_consume_w5_p_di     as d
    on a.product_id = d.product_id
   and a.book_id = d.book_id
   and a.user_id = d.user_id
   and d.types = 1
   and d.dt = '${bf_1_dt}'
  left join d7_consume_users                         as f
    on a.product_id = f.product_id
   and a.book_id = f.book_id
   and a.user_id = f.user_id
 where a.dt = '${bf_1_dt}'
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_2_dt__0
-- task_version     : 13
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_2_dt__0
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_read_retention_stat_p_da where  dt = '${bf_2_dt}' and date_stat_type = 0;

-- SQL语句
insert into ads.ads_read_retention_stat_p_da
with d7_read_users as (
    select a.product_id
         , a.book_id
         , a.user_id
         , count(distinct to_date(b.create_time)) as red_days
      from dws.dws_user_first_read_book_est_ed as a
      left join (select product_id
                      , book_id
                      , user_id
                      , hours_add(create_time, -13) as create_time
                   from dwd.dwd_read_user_chapter_view
                  where dt >= '${bf_3_dt}'
                    and hours_add(create_time, -13) >= '${bf_2_dt}'
                    and hours_add(create_time, -13) <= '${bf_1_dt}'
                )                              as b
        on a.book_id = b.book_id
       and a.user_id = b.user_id
       and a.product_id = b.product_id
     where a.dt = '${bf_2_dt}'
     group by 1, 2, 3
)
, d7_consume_users as (
    select a.product_id
         , a.book_id
         , a.user_id
      from dws.dws_user_first_read_book_est_ed       as a
      left join dwm.dwm_consume_user_consume_w5_p_di as b
        on a.product_id = b.product_id
       and a.book_id = b.book_id
       and a.user_id = b.user_id
       and b.types = 1
       and b.con_chp_amount > 0
       and b.dt >= '${bf_2_dt}'
       and b.dt <= '${bf_1_dt}'
     where a.dt = '${bf_2_dt}'
     group by a.product_id, a.book_id, a.user_id
    having count(distinct b.dt) = 1
)
select a.dt
     , case when right(a.book_id,3)=322 then 3
            when right(a.book_id,3)=418 then 7
            when right(a.book_id,3)=409 then 5
            when right(a.book_id,3)=414 then 11
            when right(a.book_id,3)=445 then 15
            when right(a.book_id,3)=375 then 4
            when right(a.book_id,3)=410 then 6
            when right(a.book_id,3)=419 then 9
            when right(a.book_id,3)=433 then 12
            when right(a.book_id,3)=436 then 14
            when right(a.book_id,3)=412 then 16
            when right(a.book_id,3)=413 then 8
            when right(a.book_id,3)=415 then 10
            when right(a.book_id,3)=447 then 17
            when right(a.book_id,3)=448 then 18
            when right(a.book_id,3)='001' then 3
            when a.product_id =3333 then 2
            when a.product_id in (7757,8858,7777,8888) then 1
            else -99
        end                                                          as lang_id
     , a.book_id
     , case when a.mt is null then 0 else a.mt end                   as mt
     , a.source_user_tp
     , 0                                                             as date_stat_type
     , b.book_name
     , b.book_code
     , case when a.user_id is not null then to_bitmap(a.user_id) end as first_read_user
     , case when a.user_id is not null then to_bitmap(a.user_id) end as read_users
     , case when d.con_chp_amount > 0 then d.con_chp_amount end      as consume_amount
     , case when d.user_id is not null then to_bitmap(d.user_id) end as consume_users
     , case when e.user_id is not null then to_bitmap(e.user_id) end as d7_read_users
     , case when f.user_id is not null then to_bitmap(f.user_id) end as d7_consume_users
     , now()                                                         as etl_time
  from dws.dws_user_first_read_book_est_ed           as a
  left join dim.dim_shuangwen_book_read_consume_info as b
    on a.book_id = b.book_id
  left join dwm.dwm_consume_user_consume_w5_p_di     as d
    on a.product_id = d.product_id
   and a.book_id = d.book_id
   and a.user_id = d.user_id
   and d.types = 1
   and d.dt = '${bf_2_dt}'
  left join d7_read_users                            as e
    on a.product_id = e.product_id
   and a.book_id = e.book_id
   and a.user_id = e.user_id
   and e.red_days = 1
  left join d7_consume_users                         as f
    on a.product_id = f.product_id
   and a.book_id = f.book_id
   and a.user_id = f.user_id
 where a.dt = '${bf_2_dt}'
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_2_dt__1
-- task_version     : 12
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_2_dt__1
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_read_retention_stat_p_da where  dt = '${bf_2_dt}' and date_stat_type = 1;

-- SQL语句
insert into ads.ads_read_retention_stat_p_da
with d7_read_users as (
    select a.product_id
         , a.book_id
         , a.user_id
         , count(distinct to_date(b.create_time)) as red_days
      from dws.dws_user_first_read_book_est_ed as a
      left join (select product_id
                      , book_id
                      , user_id
                      , hours_add(create_time, -13) as create_time
                   from dwd.dwd_read_user_chapter_view
                  where dt >= '${bf_3_dt}'
                    and hours_add(create_time, -13) >= '${bf_2_dt}'
                    and hours_add(create_time, -13) <= '${bf_1_dt}'
                )                              as b
        on a.book_id = b.book_id
       and a.user_id = b.user_id
       and a.product_id = b.product_id
     where a.dt = '${bf_2_dt}'
     group by 1, 2, 3
)
, d7_consume_users as (
    select a.product_id
         , a.book_id
         , a.user_id
      from dws.dws_user_first_read_book_est_ed       as a
      left join dwm.dwm_consume_user_consume_w5_p_di as b
        on a.product_id = b.product_id
       and a.book_id = b.book_id
       and a.user_id = b.user_id
       and b.types = 1
       and b.con_chp_amount > 0
       and b.dt >= '${bf_2_dt}'
       and b.dt <= '${bf_1_dt}'
     where a.dt = '${bf_2_dt}'
     group by a.product_id, a.book_id, a.user_id
    having count(distinct b.dt) = 2
)
select a.dt
     , case when right(a.book_id,3)=322 then 3
            when right(a.book_id,3)=418 then 7
            when right(a.book_id,3)=409 then 5
            when right(a.book_id,3)=414 then 11
            when right(a.book_id,3)=445 then 15
            when right(a.book_id,3)=375 then 4
            when right(a.book_id,3)=410 then 6
            when right(a.book_id,3)=419 then 9
            when right(a.book_id,3)=433 then 12
            when right(a.book_id,3)=436 then 14
            when right(a.book_id,3)=412 then 16
            when right(a.book_id,3)=413 then 8
            when right(a.book_id,3)=415 then 10
            when right(a.book_id,3)=447 then 17
            when right(a.book_id,3)=448 then 18
            when right(a.book_id,3)='001' then 3
            when a.product_id =3333 then 2
            when a.product_id in (7757,8858,7777,8888) then 1
            else -99
        end as lang_id
     , a.book_id
     , case when a.mt is null then 0 else a.mt end                   as mt
     , a.source_user_tp
     , 1                                                             as date_stat_type
     , b.book_name
     , b.book_code
     , case when a.user_id is not null then to_bitmap(a.user_id) end as first_read_user
     , case when c.user_id is not null then to_bitmap(c.user_id) end as read_users
     , case when d.con_chp_amount > 0 then d.con_chp_amount end      as consume_amount
     , case when d.user_id is not null then to_bitmap(d.user_id) end as consume_users
     , case when e.user_id is not null then to_bitmap(e.user_id) end as d7_read_users
     , case when f.user_id is not null then to_bitmap(f.user_id) end as d7_consume_users
     , now()                                                         as etl_time
  from dws.dws_user_first_read_book_est_ed           as a
  left join dim.dim_shuangwen_book_read_consume_info as b
    on a.book_id = b.book_id
  left join (select c.product_id, c.book_id, c.user_id
               from dwd.dwd_read_user_chapter_view c
              where date(hours_add(c.dt, -13)) >= '${bf_2_dt}'
                and date(hours_add(c.create_time, -13)) = '${bf_1_dt}'
              group by c.product_id, c.book_id, c.user_id
            )                                        as c
    on a.product_id = c.product_id
   and a.book_id = c.book_id
   and a.user_id = c.user_id
  left join dwm.dwm_consume_user_consume_w5_p_di     as d
    on a.product_id = d.product_id
   and a.book_id = d.book_id
   and a.user_id = d.user_id
   and d.types = 1
   and d.dt = '${bf_1_dt}'
  left join d7_read_users                            as e
    on a.product_id = e.product_id
   and a.book_id = e.book_id
   and a.user_id = e.user_id
   and e.red_days = 2
  left join d7_consume_users                         as f
    on a.product_id = f.product_id
   and a.book_id = f.book_id
   and a.user_id = f.user_id
 where a.dt = '${bf_2_dt}'
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_3_dt__0
-- task_version     : 10
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_3_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_3_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_4_dt}'
    and hours_add(create_time,-13) >= '${bf_3_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_3_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_3_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_3_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_3_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_3_dt__1
-- task_version     : 12
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_3_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_3_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_4_dt}'
    and hours_add(create_time,-13) >= '${bf_3_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_3_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_3_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_3_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_3_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_3_dt__2
-- task_version     : 12
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_3_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_3_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_4_dt}'
    and hours_add(create_time,-13) >= '${bf_3_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_3_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_3_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_3_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_3_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_4_dt__0
-- task_version     : 11
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_4_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_4_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_5_dt}'
    and hours_add(create_time,-13) >= '${bf_4_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_4_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_4_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_4_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_4_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_4_dt__1
-- task_version     : 9
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_4_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_4_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_5_dt}'
    and hours_add(create_time,-13) >= '${bf_4_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_4_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_4_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_4_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_4_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_4_dt__2
-- task_version     : 9
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_4_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_4_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_5_dt}'
    and hours_add(create_time,-13) >= '${bf_4_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_4_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_4_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_4_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_4_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_4_dt__3
-- task_version     : 9
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_4_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_4_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_5_dt}'
    and hours_add(create_time,-13) >= '${bf_4_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_4_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_4_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_4_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 4
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_4_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_5_dt__0
-- task_version     : 7
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_5_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_5_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_6_dt}'
    and hours_add(create_time,-13) >= '${bf_5_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_5_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_5_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_5_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_5_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_5_dt__1
-- task_version     : 8
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_5_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_5_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_6_dt}'
    and hours_add(create_time,-13) >= '${bf_5_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_5_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_5_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_5_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_5_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_4_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_5_dt__2
-- task_version     : 8
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_5_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_5_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_6_dt}'
    and hours_add(create_time,-13) >= '${bf_5_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_5_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_5_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_5_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_5_dt__3
-- task_version     : 10
-- update_time      : 2025-03-18 15:36:43
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_5_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_5_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_6_dt}'
    and hours_add(create_time,-13) >= '${bf_5_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_5_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_5_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_5_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 4
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_5_dt__4
-- task_version     : 10
-- update_time      : 2024-10-19 18:48:14
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_5_dt__4
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_5_dt}' and date_stat_type = 4;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_6_dt}'
    and hours_add(create_time,-13) >= '${bf_5_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_5_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_5_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_5_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 5
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        4 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 5
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_5_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__0
-- task_version     : 6
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_6_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__1
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_6_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_5_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_5_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__2
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_5_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_4_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__3
-- task_version     : 10
-- update_time      : 2025-03-18 15:36:43
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 4
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__4
-- task_version     : 8
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__4
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 4;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 5
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        4 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days =5
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_6_dt__5
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_6_dt__5
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_6_dt}' and date_stat_type = 5;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_7_dt}'
    and hours_add(create_time,-13) >= '${bf_6_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_6_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_6_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_6_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 6
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        5 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 6
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_6_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__0
-- task_version     : 7
-- update_time      : 2024-10-22 01:54:40
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
     when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_7_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__1
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_7_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_6_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_6_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__2
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_6_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_5_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_5_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__3
-- task_version     : 7
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 4
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_5_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_4_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__4
-- task_version     : 8
-- update_time      : 2025-03-18 15:36:43
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__4
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 4;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 5
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        4 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 5
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__5
-- task_version     : 8
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__5
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 5;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 6
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        5 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 6
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_7_dt__6
-- task_version     : 8
-- update_time      : 2024-10-19 18:54:07
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_7_dt__6
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_7_dt}' and date_stat_type = 6;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_8_dt}'
    and hours_add(create_time,-13) >= '${bf_7_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_7_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_7_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_7_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 7
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        6 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 7
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_7_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__0
-- task_version     : 10
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
        a.product_id,
        a.book_id,
        a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 1
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_8_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__1
-- task_version     : 9
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
    a.product_id,
    a.book_id,
    a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 2
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_8_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_7_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_7_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__2
-- task_version     : 9
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
        a.product_id,
        a.book_id,
        a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 3
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_7_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_6_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_6_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__3
-- task_version     : 10
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
    a.product_id,
    a.book_id,
    a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 4
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_6_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_5_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_5_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__4
-- task_version     : 10
-- update_time      : 2025-03-18 15:36:43
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__4
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 4;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
    a.product_id,
    a.book_id,
    a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 5
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        4 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_5_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_4_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 5
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__5
-- task_version     : 9
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__5
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 5;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
        a.product_id,
        a.book_id,
        a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 6
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        5 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 6
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__6
-- task_version     : 9
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__6
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 6;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
        a.product_id,
        a.book_id,
        a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
        ON a.product_id = b.product_id
        and a.book_id = b.book_id
        and a.user_id = b.user_id
        and b.types = 1
        and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 7
)

SELECT
        a.dt,
        case
            when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
        end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        6 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 7
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_8_dt__7
-- task_version     : 12
-- update_time      : 2024-10-22 14:19:36
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_8_dt__7
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_8_dt}' and date_stat_type = 7;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_9_dt}'
    and hours_add(create_time,-13) >= '${bf_8_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_8_dt}'
    GROUP by 1,2,3
),

d7_consume_users AS (
SELECT
     a.product_id,
     a.book_id,
     a.user_id
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
      ON a.product_id = b.product_id
      and a.book_id = b.book_id
      and a.user_id = b.user_id
      and b.types = 1
      and b.con_chp_amount > 0
        AND b.dt >= '${bf_8_dt}'
        AND b.dt <= '${bf_1_dt}'
WHERE a.dt = '${bf_8_dt}'
GROUP BY a.product_id,a.book_id,a.user_id
HAVING COUNT(DISTINCT b.dt) = 8
)

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
    a.book_id,
    CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
    a.source_user_tp,
    7 AS date_stat_type,
    b.book_name,
    b.book_code,
    CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
    CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
    CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
    CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
    CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
    CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
    NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_2_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_1_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_1_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 8
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_8_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__0
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__0
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 0;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
        a.product_id,
        a.book_id,
        a.user_id,
        COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
                select
                        product_id,
                        book_id,
                        user_id,
                        hours_add(create_time,-13) as create_time
                from dwd.dwd_read_user_chapter_view
                where dt >= '${bf_10_dt}'
                and hours_add(create_time,-13) >= '${bf_9_dt}'
                and hours_add(create_time,-13) <= '${bf_1_dt}'
                ) b
        on	a.book_id = b.book_id
        and a.user_id = b.user_id
        and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 1
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        0 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_9_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 1
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__1
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__1
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 1;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 2
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        1 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_9_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_8_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_8_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 2
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__2
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__2
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 2;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 3
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        2 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_8_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_7_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_7_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 3
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__3
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__3
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 3;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 4
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        3 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_7_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_6_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_6_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
      AND e.red_days = 4
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__4
-- task_version     : 4
-- update_time      : 2025-03-18 15:36:43
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__4
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 4;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 5
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        4 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_6_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_5_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_5_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
        AND e.red_days = 5
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__5
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__5
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 5;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 6
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        5 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_5_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_4_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_4_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 6
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__6
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__6
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 6;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 7
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
        a.book_id,
        CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
        a.source_user_tp,
        6 AS date_stat_type,
        b.book_name,
        b.book_code,
        CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
        CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
        CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
        CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
        CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
        CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
        NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_4_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_3_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_3_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 7
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_retention_stat_p_da
-- workflow_version : 57
-- create_user      : xixg
-- task_name        : ads_read_retention_stat_p_da__bf_9_dt__7
-- task_version     : 3
-- update_time      : 2024-10-19 18:55:45
-- sql_path         : \starrocks\tbl_ads_read_retention_stat_p_da\ads_read_retention_stat_p_da__bf_9_dt__7
----------------------------------------------------------------
-- 前置SQL语句
DELETE FROM ads.ads_read_retention_stat_p_da WHERE  dt = '${bf_9_dt}' and date_stat_type = 7;

-- SQL语句
INSERT INTO ads.ads_read_retention_stat_p_da
WITH d7_read_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id,
    COUNT (DISTINCT to_date(b.create_time)) as red_days
    FROM dws.dws_user_first_read_book_est_ed a
    left join (
    select
    product_id,
    book_id,
    user_id,
    hours_add(create_time,-13) as create_time
    from dwd.dwd_read_user_chapter_view
    where dt >= '${bf_10_dt}'
    and hours_add(create_time,-13) >= '${bf_9_dt}'
    and hours_add(create_time,-13) <= '${bf_1_dt}'
    ) b
    on	a.book_id = b.book_id
    and a.user_id = b.user_id
    and a.product_id = b.product_id
    WHERE a.dt = '${bf_9_dt}'
    GROUP by 1,2,3
    ),

    d7_consume_users AS (
    SELECT
    a.product_id,
    a.book_id,
    a.user_id
    FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di b
    ON a.product_id = b.product_id
    and a.book_id = b.book_id
    and a.user_id = b.user_id
    and b.types = 1
    and b.con_chp_amount > 0
    AND b.dt >= '${bf_9_dt}'
    AND b.dt <= '${bf_1_dt}'
    WHERE a.dt = '${bf_9_dt}'
    GROUP BY a.product_id,a.book_id,a.user_id
    HAVING COUNT(DISTINCT b.dt) = 8
    )

SELECT
    a.dt,
    case
        when right(a.book_id,3)=322 then 3
    when right(a.book_id,3)=418 then 7
    when right(a.book_id,3)=409 then 5
    when right(a.book_id,3)=414 then 11
    when right(a.book_id,3)=445 then 15
    when right(a.book_id,3)=375 then 4
    when right(a.book_id,3)=410 then 6
    when right(a.book_id,3)=419 then 9
    when right(a.book_id,3)=433 then 12
    when right(a.book_id,3)=436 then 14
    when right(a.book_id,3)=412 then 16
    when right(a.book_id,3)=413 then 8
    when right(a.book_id,3)=415 then 10
    when right(a.book_id,3)=447 then 17
    when right(a.book_id,3)=448 then 18
    when right(a.book_id,3)='001' then 3
    when a.product_id =3333 then 2
    when a.product_id in (7757,8858,7777,8888) then  1
    ELSE -99
end as lang_id,
    a.book_id,
    CASE WHEN a.mt IS NULL THEN 0 ELSE a.mt END AS mt,
    a.source_user_tp,
    7 AS date_stat_type,
    b.book_name,
    b.book_code,
    CASE WHEN a.user_id IS NOT NULL THEN TO_BITMAP(a.user_id) END AS first_read_user,
    CASE WHEN c.user_id IS NOT NULL THEN TO_BITMAP(c.user_id) END AS read_users,
    CASE WHEN d.con_chp_amount > 0 THEN d.con_chp_amount END  AS consume_amount,
    CASE WHEN d.user_id IS NOT NULL THEN TO_BITMAP(d.user_id) END AS consume_users,
    CASE WHEN e.user_id IS NOT NULL THEN TO_BITMAP(e.user_id) END AS d7_read_users,
    CASE WHEN f.user_id IS NOT NULL THEN TO_BITMAP(f.user_id) END AS d7_consume_users,
    NOW()
FROM dws.dws_user_first_read_book_est_ed a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
        ON a.book_id = b.book_id
    LEFT JOIN (
                select  c.product_id,c.book_id,c.user_id
                  from  dwd.dwd_read_user_chapter_view c
                 where  date(hours_add(c.dt,-13)) >= '${bf_3_dt}'
                   and date(hours_add(c.create_time,-13)) = '${bf_2_dt}'
                 group by c.product_id,c.book_id,c.user_id
              ) c
        ON a.product_id = c.product_id
       and a.book_id = c.book_id
       and a.user_id = c.user_id
    LEFT JOIN dwm.dwm_consume_user_consume_w5_p_di d
        ON a.product_id = d.product_id
       and a.book_id = d.book_id
       and a.user_id = d.user_id
       and d.types = 1
       AND d.dt = '${bf_2_dt}'
    LEFT JOIN d7_read_users e
        ON a.product_id = e.product_id
       and a.book_id = e.book_id
       and a.user_id = e.user_id
       AND e.red_days = 8
    LEFT JOIN d7_consume_users f
        ON a.product_id = f.product_id
       and a.book_id = f.book_id
       and a.user_id = f.user_id
WHERE a.dt = '${bf_9_dt}';
