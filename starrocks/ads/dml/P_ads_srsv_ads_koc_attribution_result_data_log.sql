----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_ads_koc_attribution_result_data
-- workflow_version : 77
-- create_user      : yanxh
-- task_name        : ads_srsv_ads_koc_attribution_result_data
-- task_version     : 50
-- update_time      : 2025-09-20 13:52:08
-- sql_path         : \starrocks\tbl_ads_srsv_ads_koc_attribution_result_data\ads_srsv_ads_koc_attribution_result_data
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_srsv_ads_koc_attribution_result_data_log where dt<'${bf_20_dt}';

-- SQL语句
----============= 2024-10-22 添加 ads_srsv_ads_koc_attribution_result_data_log 日志表=================================
insert into ads.`ads_srsv_ads_koc_attribution_result_data_log`
select dt, product_id,adid,project_tp,book_id,mt,core,source_chl,chl,current_language,koc_code,dev_unt,koc_amt,koc_amt_after,order_num,koc_amt_14d,koc_amt_after_14d,ad_amt,etl_tm,DATE_FORMAT(now(), '%Y%m%d%H%i%s') AS batch_no ,now() as create_time,curdate()  as create_dt
from ads.ads_srsv_ads_koc_attribution_result_data
where dt>='${bf_20_dt}'
and (dev_unt>0 or koc_amt>0 or koc_amt_after>0 or koc_amt_14d>0 or ad_amt>0)
;
