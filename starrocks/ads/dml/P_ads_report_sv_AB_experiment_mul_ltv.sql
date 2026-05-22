----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_ltv
-- task_version     : 5
-- update_time      : 2024-10-16 16:00:43
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_ltv
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_sv_AB_experiment_mul_ltv where (dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
       or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day);

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul_ltv
with rec as(
    select dt,source_types,product_id,lang_id,user_id,series_id,element_id,element_type
    from ads.ads_report_sv_AB_experiment_mul_base_mid
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
       or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
)
select rec.dt,rec.process_types,rec.source_types,rec.product_id,rec.lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       max(a.is_watch) as is_watch,sum(a.ltv0) as ltv0,sum(a.ltv1) as ltv1,sum(a.ltv3) as ltv3,sum(a.ltv5) as ltv5,sum(a.ltv7) as ltv7,
       sum(a.ltv15) as ltv15,sum(a.ltv30) as ltv30,
       sum(if(b.ltv60 is null,a.ltv30,b.ltv60)) as ltv60,
       sum(if(b.ltv90 is null,a.ltv30,b.ltv90)) as ltv90,
       sum(if(b.ltv120 is null,a.ltv30,b.ltv120)) as ltv120,
       now() as etl_time
from (
    select dt,1 as process_types,source_types,product_id,lang_id,user_id,series_id,element_id,element_type
    from rec
    union all
    select dt,2 as process_types,source_types,product_id,lang_id,user_id,series_id,element_id,element_type
    from rec
)rec
left join (
    select dt,process_types,source_types,product_id,user_id,sereis_id,is_watch,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30
    from ads.ads_report_sv_AB_experiment_mul_ltv_mid1
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}') or
          dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
    ) a  on rec.dt=a.dt and rec.process_types=a.process_types and rec.source_types=a.source_types and rec.product_id=a.product_id
                and rec.user_id=a.user_id and rec.series_id=a.sereis_id
left join (
    select dt,process_types,source_types,product_id,user_id,series_id,is_watch,ltv60,ltv90,ltv120
    from ads.ads_report_sv_AB_experiment_mul_ltv_mid2
    where (dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
    ) b  on rec.dt=b.dt and rec.process_types=b.process_types and rec.source_types=b.source_types and rec.product_id=b.product_id
                and rec.user_id=b.user_id and rec.series_id=b.series_id
left join ads.ads_report_sv_AB_experiment_mul_group_tmp gr
    on rec.product_id=gr.product_id and rec.user_id=gr.user_id
group by 1,2,3,4,5,6,7;
