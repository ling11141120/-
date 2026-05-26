----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_dim_srsv_ad_product_rand_info
-- workflow_version : 3
-- create_user      : hufengju
-- task_name        : dim_srsv_ad_product_rand_info
-- task_version     : 3
-- update_time      : 2025-01-03 17:07:36
-- sql_path         : \starrocks\sch_dim_srsv_ad_product_rand_info\dim_srsv_ad_product_rand_info
----------------------------------------------------------------
-- 前置SQL语句
delete from dim.dim_srsv_ad_product_rand_info where dt='${dt}';

-- SQL语句
--- ============调度（每日1次）：广告基建-随机值================
insert into dim.dim_srsv_ad_product_rand_info
select '${dt}'dt
  ,a.product
  ,a.source2
  ,a.current_language
  ,a.code_id
  ,b.ad_optimizer_group
  ,b.ad_optimizer_uid
  ,b.nick_name
  ,0.9+rand()*0.1  rand_v
  ,now() as etl_tm
from (
  -- 每日书籍
  select distinct
    product
    ,source2
    ,code_id
    ,current_language
  from ads.ads_srsv_bi_ad_optimizer_target_data
  where code_id is not null and dt>'${bf_2_dt}'
) a
left join (
  --每日优化师
  select distinct
    product
    ,source2
    ,ad_optimizer_uid
    ,ad_optimizer_group
    ,nick_name
  from ads.ads_srsv_bi_ad_optimizer_target_data
  where ad_optimizer_uid is not null and dt>'${bf_2_dt}'
) b on a.product=b.product and a.source2=b.source2
;
