----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_reco_firstpay
-- workflow_version : 21
-- create_user      : admin
-- task_name        : alg_firstpay_feature_export
-- task_version     : 2
-- update_time      : 2025-04-02 20:30:08
-- sql_path         : \starrocks\tbl_alg_reco_firstpay\alg_firstpay_feature_export
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_update_repay_feat_tmp;

-- SQL语句
insert overwrite alg.alg_firstpay_feature_export
select dd, ff
from(
  select
    concat(feature_name, ':', feature_value) dd,
    concat(pay_total, ',', pay_max, ',', pay_min, ',', CEILING(pay_avg), ',', CEILING(pay_model)) ff
  from alg.alg_firstpay_feature
)x
order by dd;
