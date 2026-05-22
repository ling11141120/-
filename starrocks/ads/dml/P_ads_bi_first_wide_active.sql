----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_first_wide_active
-- workflow_version : 5
-- create_user      : linq
-- task_name        : ads_bi_first_wide_active
-- task_version     : 3
-- update_time      : 2023-12-27 14:37:33
-- sql_path         : \starrocks\tbl_ads_bi_first_wide_active\ads_bi_first_wide_active
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_first_wide_active where dt >='${bf_3_dt}' and dt<='${dt}';

-- SQL语句
insert into ads.ads_bi_first_wide_active
select a.fst_active_dt as dt,
       md5(concat_ws('_',a.product_id,corever,mt,ver,current_language,current_language2,country,reg_country,app_ver,reg_time,sex)) as md5_key,
       a.product_id,corever,mt,ver,current_language,current_language2,country,reg_country,ifnull(c.level,2),app_ver,reg_time,sex,
       count(user_id) as fst_active_unt,
       now() as etl_time
from ads.ads_bi_first_wide_active_mid a
left join(
    select product_id,id,corever,mt,ver,current_language,current_language2,country,reg_country,appver as app_ver,create_time as reg_time,sex
    from dim.dim_user_account_info_view
    )acc on a.product_id=acc.product_id and a.user_id=acc.id
left join dim.dim_countrylevel c on acc.product_id=c.product_id and acc.reg_country=c.short_name
where fst_active_dt >='${bf_3_dt}' and fst_active_dt<='${dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
