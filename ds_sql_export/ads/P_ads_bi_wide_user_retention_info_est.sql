----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_wide_user_retention_info_est
-- workflow_version : 12
-- create_user      : hufengju
-- task_name        : ads_bi_wide_user_retention_info_est
-- task_version     : 12
-- update_time      : 2025-06-13 15:47:19
-- sql_path         : \starrocks\tbl_ads_bi_wide_user_retention_info_est\ads_bi_wide_user_retention_info_est
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_wide_user_retention_info_est
-- -----------------------------活跃用户 0-- -30------------------------------------
select a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id))  as md5_key,
       a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
       DATEDIFF(b.dt, a.dt) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ----
       now()                         as etl_time
from (   -- --------------------------------------------------
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
           and a.dt <= '${bf_1_dt}'
           and user_period in (2)
           and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
     )a
left join ( -- --------------read------------------------------------
    select dt, product_id, user_id from dws.dws_user_wide_active_est_ed where dt >= date_sub('${bf_1_dt}', interval 31 day) and dt <= '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all  -- --------short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) >= date_sub('${bf_1_dt}', interval 31 day)  and date(date_add(a.reg_time,interval -13 hour)) <= '${bf_1_dt}' and product_id   in (6833)

)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
    and b.dt >= a.dt
    and b.dt <= DATE_ADD(a.dt, interval 31 day)
    and a.product_id = b.product_id and a.user_id = b.user_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16

union all  -- ---------------活跃用户 60 90 120 150 180 ------  --------------------
select  a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id)) as md5_key,
        a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
        DATEDIFF(b.dt, a.dt) as reg_days,
        count(distinct b.user_id)     as retention_num,-- ----
        now()                         as etl_time
from (
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where (a.dt = date_sub('${bf_1_dt}', interval 60 day)  and user_period in (2) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 90 day)  and user_period in (2) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 120 day) and user_period in (2) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 150 day) and user_period in (2) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 180 day) and user_period in (2) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833))
     )a
         inner join (
    select dt, product_id, user_id from dws.dws_user_wide_active_est_ed  where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all  -- --------short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) >= date_sub('${bf_1_dt}', interval 31 day)  and date(date_add(a.reg_time,interval -13 hour)) <= '${bf_1_dt}' and product_id   in (6833)

)b on  a.dt = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id or
       (a.dt = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14 ,15,16 ;

-- SQL语句
-- 新用户
insert into ads.ads_bi_wide_user_retention_info_est
-- ---------------------------新用户 0-- -30------------------------------------
select  a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id)) as md5_key,
        a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
        DATEDIFF(b.dt, a.dt) as reg_days,
        count(distinct b.user_id)     as retention_num,-- ----
        now()                         as etl_time
from (   -- ----------------------------------------------------
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
           and a.dt <= '${bf_1_dt}'
           and user_period in (1)
           and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
     )a
         left join ( -- --------------------------------------------------
    select dt, product_id, user_id  from dws.dws_user_wide_active_est_ed where dt >= date_sub('${bf_1_dt}', interval 31 day)  and dt <= '${bf_1_dt}'  and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all  -- --------short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) >= date_sub('${bf_1_dt}', interval 31 day)  and date(date_add(a.reg_time,interval -13 hour)) <= '${bf_1_dt}' and product_id   in (6833)

)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
    and b.dt >= a.dt
    and b.dt <= DATE_ADD(a.dt, interval 31 day)
    and a.product_id = b.product_id and a.user_id = b.user_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16

union all  -- ---------------新用户 60 90 120 150 180 ------  --------------------
select  a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id)) as md5_key,
        a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
        DATEDIFF(b.dt, a.dt) as reg_days,
        count(distinct b.user_id)     as retention_num,-- ----
        now()                         as etl_time
from (
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where (a.dt = date_sub('${bf_1_dt}', interval 60 day) and user_period in (1) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 90 day) and  user_period in (1) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 120 day) and  user_period in (1) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 150 day) and  user_period in (1) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 180 day) and  user_period in (1) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833))
     )a
         inner join (
    select dt, product_id, user_id from dws.dws_user_wide_active_est_ed where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all -- short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) = '${bf_1_dt}' and product_id   in (6833)

)b on  a.dt = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id or
       (a.dt = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.dt = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16;

-- SQL语句
-- rmt
insert into ads.ads_bi_wide_user_retention_info_est
-- -----------------------------rmt用户 0-- -30------------------------------------
select a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id)) as md5_key,
       a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
       DATEDIFF(b.dt, a.dt) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ----
       now()                         as etl_time
from (   -- ----------------------rmt----------------------------
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where a.dt >= date_sub('${bf_1_dt}', interval 31 day)
           and a.dt <= '${bf_1_dt}'

           and user_period in (3)
           and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
     )a
left join ( -- --------------------------------------------------
    select dt, product_id, user_id,mt,corever  from dws.dws_user_wide_active_est_ed   where dt >= date_sub('${bf_1_dt}', interval 31 day)  and dt <= '${bf_1_dt}'  and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all -- short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id,mt,corever  from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) >= date_sub('${bf_1_dt}', interval 31 day)  and date(date_add(a.reg_time,interval -13 hour)) <= '${bf_1_dt}'  and product_id   in (6833)

)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
    and b.dt >= a.dt
    and b.dt <= DATE_ADD(a.dt, interval 31 day)
    and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16
union all  -- ---------------rmt用户 的 60 90 120 150 180 ------  --------------------

select a.dt,md5(concat_ws('_',a.dt,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,DATEDIFF(b.dt, a.dt),a.chl2,a.chl,a.user_ad_source,a.book_id))as md5_key,
       a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,a.user_ad_source,a.book_id,
       DATEDIFF(b.dt, a.dt) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ----
       now()                         as etl_time
from (
         select a.dt,a.product_id,a.user_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,a.is_pay,a.chl2,a.chl,b.user_ad_source ,c.book_id
         from dws.dws_srsv_wide_user_type_info_est_di a
		 left join dim.dim_user_other_info_view	b on a.product_id=b.product_id and a.user_id=b.id
		 left join dim.dim_user_account_info_view  c on a.product_id=c.product_id and a.user_id=c.id
         where (a.dt = date_sub('${bf_1_dt}', interval 60 day) and user_period in (3) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 90 day) and  user_period in (3) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 120 day) and user_period in (3) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 150 day) and user_period in (3) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)) or
             (a.dt = date_sub('${bf_1_dt}', interval 180 day) and user_period in (3) and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833))
     )a
         inner join (
    select dt, product_id, user_id,mt,corever from dws.dws_user_wide_active_est_ed where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
    union all -- short_video-----------------
    select date(date_add(a.reg_time,interval -13 hour)) as dt, product_id, user_id,mt,corever from dws.dws_user_short_video_wide_active_ed  a
	where date(date_add(a.reg_time,interval -13 hour)) = '${bf_1_dt}' and product_id   in (6833)

)b on  (a.dt = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever ) or
       (a.dt = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever) or
       (a.dt = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever) or
       (a.dt = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever) or
       (a.dt = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id  and a.mt=b.mt and a.corever=b.corever)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14,15,16;
