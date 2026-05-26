----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_srsv_material_rating_probability
-- workflow_version : 73
-- create_user      : chenmo
-- task_name        : to_ads_sr
-- task_version     : 7
-- update_time      : 2025-06-05 14:46:01
-- sql_path         : \starrocks\sch_ads_srsv_material_rating_probability\to_ads_sr
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_material_rating_probability_external
select dt,
       project_code,
       asset_guid,
       source_chl_type,
       book_id,
       language_name,
       code,
       bm_compelete_time,
       date_key,
       grade_date,
       first_date,
       days,
       level,
       is_old_asset,
       spend_dt_sum,
       spend_sum,
       impressions_sum,
       clicks_sum,
       link_clicks_sum,
       installs_sum,
       amount_sum,
       grade_score_sum_raw,
       grade_score_sum2,
       odds,
       material_type,
       need_mai,
        code_type as asset_type,
        bm_id,
       etl_tm
from ads.ads_srsv_material_rating_probability
where dt>=date(hours_sub(now(),13+24));
