----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_update_repay_feat
-- workflow_version : 43
-- create_user      : admin
-- task_name        : alg_update_repay_feat_tmp
-- task_version     : 4
-- update_time      : 2025-04-02 20:39:41
-- sql_path         : \starrocks\tbl_alg_update_repay_feat\alg_update_repay_feat_tmp
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_update_repay_feat_tmp;

-- SQL语句
insert into alg.alg_update_repay_feat_tmp
select
concat('nv', x.user_id) as user_id,
'repayfeat' falg,
concat(x.pay_total, ',', x.pay_max, ',', x.pay_min, ',', CEILING(x.pay_avg), ',', CEILING(x.pay_times), ',', x.pay_total_30d, ',', x.pay_max_30d, ',',  coalesce(CEILING(x.pay_avg_30d), 0), ',', x.pay_total_15d, ',', x.pay_max_15d, ',',  coalesce(CEILING(x.pay_avg_15d), 0), ',', x.pay_total_7d, ',', x.pay_max_7d, ',',  coalesce(CEILING(x.pay_avg_7d), 0), ',',  x.pay_total_3d, ',', x.pay_max_3d, ',',  coalesce(CEILING(x.pay_avg_3d), 0), ',', x.pay_total_1d, ',', x.pay_max_1d, ',',  coalesce(CEILING(x.pay_avg_1d), 0)) as feat_info
from alg.alg_update_repay_feat x
where dt ='${bf_1_dt}';
