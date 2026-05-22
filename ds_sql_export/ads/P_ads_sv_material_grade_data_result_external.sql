----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_material_grade_data_result
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : sr_to_sr_ads_sv_material_grade_data_result_external
-- task_version     : 3
-- update_time      : 2024-12-11 15:49:32
-- sql_path         : \starrocks\tbl_ads_sv_material_grade_data_result\sr_to_sr_ads_sv_material_grade_data_result_external
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sv_material_grade_data_result_external`
select dt,
       material_id,
       date_key,
       material_type,
       source_chl,
       language_name,
       code,
       spend,
       impressions,
       clicks,
       link_clicks,
       installs,
       amount,
       first_date,
       grade_date,
       0 as rn,
       spend_sum,
       impressions_sum,
       clicks_sum,
       link_clicks_sum,
       installs_sum,
       amount_sum,
       ctr_link,
       cvr,
       roas,
       cpm,
       link_clicks_sum/impressions_sum as ctr_link_sum,
       installs_sum/link_clicks_sum as cvr_sum,
       amount_sum/spend_sum as roas_sum,
       spend_sum/impressions_sum*1000 as cpm_sum,
       0 as ctr_to1,
       cvr_to1,
       roas_to1,
       grade_score,
       grade,
       etl_tm
from ads.ads_sv_material_grade_data_result
where dt >= '${bf_1_dt}';
