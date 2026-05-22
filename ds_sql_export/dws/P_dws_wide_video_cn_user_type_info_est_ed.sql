----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_wide_video_cn_user_type_info_est_ed
-- workflow_version : 4
-- create_user      : hufengju
-- task_name        : dws_wide_video_cn_user_type_info_est_ed
-- task_version     : 4
-- update_time      : 2024-11-21 19:37:58
-- sql_path         : \starrocks\tbl_dws_wide_video_cn_user_type_info_est_ed\dws_wide_video_cn_user_type_info_est_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_wide_video_cn_user_type_info_est_ed where dt=${bf_1_dt}'';

-- SQL语句
insert into dws.dws_wide_video_cn_user_type_info_est_ed
select '${bf_1_dt}' as dt,
       a1.dt  as stat_period,
       a1.product_id,
       a1.years,
       1                                                 as period_types,
       a1.last_day_of_week,
       a1.last_day_of_month,
       a1.user_id,
       a1.corever,
       a1.mt,
       a1.reg_country,
       -99 as country_level,
       a1.current_language2,
       a1.source,
       a1.user_period,
       now()                                             as etl_time
from (
         select x.years,x.dt,x.Install_Date,x.last_day_of_week,x.last_day_of_month,x.product_id,x.user_id,x.corever,x.mt,
                x.reg_country,x.current_language2,x.source,x.user_period
         from (
                  select YEAR(a.dt) as years,dt, install_date,
                         date(date_sub(date_trunc('week', date_add(a.dt, interval 1 week)), interval 1 day)) as last_day_of_week,
                         date(date_sub(date_trunc('month', date_add(a.dt, interval 1 month)), interval 1 day)) last_day_of_month,
                         product_id,Unique_CdReaderId as user_id,core as corever,mt,case when a.Country = '' then 'unknown' else a.Country end as reg_country,a.current_language2,
                         1 as source,
                         3 as user_period,
                         row_number() over (partition by product_id,Unique_CdReaderId,mt,core order by Source desc ,Install_Date) as  rn
                  from dwd.dwd_user_install_info_ed_est_view a
                  where a.dt >= '${bf_1_dt}' and a.dt < '${dt}' and a.product_id in (6883) and a.Unique_CdReaderId != -1 and a.IsDelete = 0
              ) x
         where x.rn = 1
     ) a1
         left join (
			select 6883 as productid, unique_cdreader_id as id,date_add(create_time,interval -13 hour) as create_time
			from dim.dim_video_cn_accountinfo_view
		 ) a2 on a1.product_id = a2.productid and a1.user_id = a2.id and a2.create_time < date_sub(a1.install_date, interval 1 HOUR)
         left join dim.dim_countrylevel b on a1.product_id = b.product_id and a1.reg_country = b.short_name;
