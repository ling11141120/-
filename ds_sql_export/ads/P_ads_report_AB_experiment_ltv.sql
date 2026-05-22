----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads.ads_report_AB_experiment_ltv
-- task_version     : 3
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads.ads_report_AB_experiment_ltv
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_ltv where dt>=date_sub('${bf_1_dt}',interval 120 day ) and dt<='${bf_1_dt}';

-- SQL语句
insert into ads.ads_report_AB_experiment_ltv
select a.dt,a.types,a.app_lang_id,a.page_name,a.recommet_unt,a.read_unt,a.consume_unt,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30,ltv60,ltv90,ltv120,now() as etl_time
from ads.ads_report_AB_experiment_ltv_mid1 a
left join (
    select dt,types,app_lang_id,page_name,recommet_unt,read_unt,consume_unt,ltv60,ltv90,ltv120
    from ads.ads_report_AB_experiment_ltv_mid2
    where dt>=date_sub('${bf_1_dt}',interval 120 day ) and dt<='${bf_1_dt}'
    )b on a.dt=b.dt and a.types=b.types and a.app_lang_id=b.app_lang_id and a.page_name=b.page_name
where a.dt>=date_sub('${bf_1_dt}',interval 120 day ) and a.dt<='${bf_1_dt}';
