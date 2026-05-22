----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_short_video_first_wide_active
-- workflow_version : 3
-- create_user      : linq
-- task_name        : ads_bi_short_video_first_wide_active
-- task_version     : 2
-- update_time      : 2023-12-18 15:12:56
-- sql_path         : \starrocks\tbl_ads_bi_short_video_first_wide_active\ads_bi_short_video_first_wide_active
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_first_wide_active where dt >='${bf_3_dt}' and dt<='${dt}';

-- SQL语句
insert into ads.ads_bi_short_video_first_wide_active
select a.fst_active_dt as dt,
       md5(concat_ws('_',a.product_id,corever,mt,current_language,current_language2,reg_country,reg_time,sex)) as md5_key,
       a.product_id,corever,mt,current_language,current_language2,reg_country,reg_time,sex,
       count(a.user_id) as fst_active_unt,
       now() as etl_time
from ads.ads_bi_short_video_first_wide_active_mid a
left join(
    select product_id,user_id,corever,mt,current_language,current_language2,reg_country,create_time as reg_time,sex
    from dim.dim_short_video_user_accountinfo
    )acc on a.product_id=acc.product_id and a.user_id=acc.user_id
where fst_active_dt >='${bf_3_dt}' and fst_active_dt<='${dt}'
group by 1,2,3,4,5,6,7,8,9,10;
