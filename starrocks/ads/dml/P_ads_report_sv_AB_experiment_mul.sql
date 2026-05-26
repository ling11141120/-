----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul
-- task_version     : 7
-- update_time      : 2025-04-27 19:34:19
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_sv_AB_experiment_mul where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}';

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul
select rec.dt,rec.source_types,rec.push_type,rec.is_toufang,rec.product_id,rec.lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       max(a.is_watch) as is_watch,
       bitmap_union(a.total_watch_epis) as total_watch_epis,
       sum(a.consume_amount) as consume_amount,
       bitmap_union(a.consume_epis) as consume_chpts,
       sum(a.consume_money_amount) as consume_money_amount,
       sum(a.charge_money) as charge_monet,
       now() as etl_time
from ads.ads_report_sv_AB_experiment_mul_base_mid rec
left join (
    select dt,source_types,product_id,user_id,series_id,is_watch,total_watch_epis,consume_amount,consume_epis,consume_money_amount,charge_money
    from ads.ads_report_sv_AB_experiment_mul_mid
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}'
) a  on rec.dt=a.dt and rec.source_types=a.source_types and rec.product_id=a.product_id and rec.user_id=a.user_id and rec.series_id=a.series_id
left join ads.ads_report_sv_AB_experiment_mul_group_tmp gr
    on rec.product_id=gr.product_id and rec.user_id=gr.user_id
where rec.dt>=date_sub('${dt}',interval 10 day) and rec.dt<'${dt}'
group by 1,2,3,4,5,6,7,8;
