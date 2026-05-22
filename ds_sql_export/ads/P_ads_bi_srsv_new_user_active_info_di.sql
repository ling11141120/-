----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_srsv_new_user_active_info_di
-- workflow_version : 13
-- create_user      : hufengju
-- task_name        : ads_bi_srsv_new_user_active_info_di
-- task_version     : 12
-- update_time      : 2024-11-29 14:56:35
-- sql_path         : \starrocks\tbl_ads_bi_srsv_new_user_active_info_di\ads_bi_srsv_new_user_active_info_di
----------------------------------------------------------------
-- SQL语句
--=========日常调度===============
insert into ads.`ads_bi_srsv_new_user_active_info_di`
-- 用户第一次安装时的bookID
with user_book_id AS (
SELECT
	prodct_type,
    user_id,
    book_id
FROM
    (
    SELECT
			case when a.product_id =6833 then 2 when a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511) then  1 end as prodct_type,product_id,
			user_id,
           book_id ,
           install_date
    FROM ads.ads_user_install_info_view a
    where product_id in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
    ) a
    QUALIFY ROW_NUMBER() OVER (PARTITION BY prodct_type,user_id ORDER BY install_date)  =1
),
book_info as (
	select 1 as prodct_type,book_id,book_code
	from dim.dim_shuangwen_book_read_consume_info
	union all
	select 2 as prodct_type,series_id as book_id,source_series_code as book_code
	from dim.dim_sv_series_hi
),
user_first_book AS (
    SELECT
    	 a.prodct_type,
         a.user_id ,
         a.book_id ,
         b.book_code
    FROM user_book_id a
     LEFT JOIN book_info b
    ON a.prodct_type=b.prodct_type and  a.book_id = b.book_id
 )
 select
	t.dt,t.md5_key,t.product_id,t.core,t.current_language2,t.mt,t.reg_country,t.user_id,t1.book_id as first_bookid,t1.book_code,t.reg_days,now() as etl_time
from (
	select  a.dt,md5(concat_ws('_',a.dt,a.product_id,a.core,a.mt,a.reg_country,a.current_language2,a.user_id)) as md5_key,
			a.product_id,a.core,a.current_language2,a.mt,a.reg_country,a.user_id,
			case when a.product_id =6833 then 2 when a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,6833) then  1 end as prodct_type,
			DATEDIFF(b.dt, a.dt) as reg_days,
			now() as etl_time
	from (   -- ----------------------------------------------------
			 select dt,product_id,user_id,corever as core,mt,reg_country,country_level,current_language2
			 from dws.dws_srsv_wide_user_type_info_di a
			 where dt >= '${bf_1_dt}'
			   and user_period in (1)
			   and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
		 )a
		 left join
		 ( -- --------------------------------------------------
			select product_id, user_id ,max(dt) as dt
				from dws.dws_user_wide_active_ed
				where  product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
				group by product_id, user_id
			union all  -- --------short_video-----------------
			select  product_id, user_id ,max(dt) as dt
				from dws.dws_user_short_video_wide_active_ed
				where  product_id   in (6833)
				group by product_id, user_id
		)b on b.dt>='${bf_1_dt}' and b.dt >= a.dt and a.product_id = b.product_id and a.user_id = b.user_id

		union all

	select  a.dt,md5(concat_ws('_',a.dt,a.product_id,a.core,a.mt,a.reg_country,a.current_language2,a.user_id)) as md5_key,
			a.product_id,a.core,a.current_language2,a.mt,a.reg_country,a.user_id,
			case when a.product_id =6833 then 2 when a.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,6833) then  1 end as prodct_type,
			DATEDIFF(b.dt, a.dt) as reg_days,
			now() as etl_time
	from (   -- ----------------------------------------------------
			 select dt,product_id,user_id,corever as core,mt,reg_country,country_level,current_language2
			 from dws.dws_srsv_wide_user_type_info_di a
			 where dt < '${bf_1_dt}'
			   and user_period in (1)
			   and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,6833)
		 )a
		 inner join
		 ( -- --------------------------------------------------
			select product_id, user_id ,max(dt) as dt
				from dws.dws_user_wide_active_ed
				where  product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
				group by product_id, user_id
			union all  -- --------short_video-----------------
			select  product_id, user_id ,max(dt) as dt
				from dws.dws_user_short_video_wide_active_ed
				where  product_id   in (6833)
				group by product_id, user_id
		)b on b.dt>='${bf_1_dt}' and b.dt >= a.dt and a.product_id = b.product_id and a.user_id = b.user_id

) t
left join user_first_book t1 on t.prodct_type = t1.prodct_type and t.user_id=t1.user_id
;
