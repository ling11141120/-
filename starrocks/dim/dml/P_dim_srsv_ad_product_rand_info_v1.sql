----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_dim_srsv_ad_product_rand_info_v1
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dim_srsv_ad_product_rand_info_v1
-- task_version     : 13
-- update_time      : 2025-01-03 16:51:09
-- sql_path         : \starrocks\sch_dim_srsv_ad_product_rand_info_v1\dim_srsv_ad_product_rand_info_v1
----------------------------------------------------------------
-- 前置SQL语句
delete from dim.dim_srsv_ad_product_rand_info_v1 where dt='${dt}';

-- SQL语句
insert into dim.dim_srsv_ad_product_rand_info_v1
select '${dt}'dt
  ,a.product
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
    ,code_id
  from ads.ads_srsv_bi_ad_optimizer_target_data_v1
  where code_id is not null and dt>'${bf_2_dt}'
) a
left join (
  -- 每日优化师
  select distinct
    product
    ,ad_optimizer_uid
    ,ad_optimizer_group
    ,nick_name
  from ads.ads_srsv_bi_ad_optimizer_target_data_v1
  where ad_optimizer_uid is not null and dt>'${bf_2_dt}'
) b on a.product=b.product
;
