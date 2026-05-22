----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ensp
-- task_version     : 14
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ensp
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_mul  where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}';

-- SQL语句
insert into ads.ads_report_AB_experiment_mul
select rec.dt,rec.source_types as types,rec.product_id,rec.lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,
       bitmap_union(a.total_read_chpts) as total_read_chpts,
       sum(a.consume_amount) as consume_amount,
       bitmap_union(a.consume_chpts) as consume_chpts,
       sum(a.consume_money_amount) as consume_money_amount,
       sum(a.charge_money) as charge_monet,
       now() as etl_time
from ads.ads_report_AB_experiment_mul_base_mid rec
left join (
    select dt,types,product_id as app_product_id,user_id,book_id,is_read,total_read_chpts,consume_amount,consume_chpts,consume_money_amount,charge_money
    from ads.ads_report_AB_experiment_mul_tmp
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and product_id in(3388,3366)
    ) a  on rec.dt=a.dt and rec.source_types=a.types and rec.product_id=a.app_product_id and rec.user_id=a.user_id and rec.book_id=a.book_id
left join ads.ads_report_AB_experiment_mul_group_tmp gr
    on rec.product_id=gr.product_id and rec.user_id=gr.user_id
where rec.dt>=date_sub('${dt}',interval 10 day) and rec.dt<'${dt}' and rec.product_id in(3388,3366)
group by 1,2,3,4,5,6;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_other
-- task_version     : 13
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_other
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mul
select rec.dt,rec.source_types as types,rec.product_id,rec.lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,
       bitmap_union(a.total_read_chpts) as total_read_chpts,
       sum(a.consume_amount) as consume_amount,
       bitmap_union(a.consume_chpts) as consume_chpts,
       sum(a.consume_money_amount) as consume_money_amount,
       sum(a.charge_money) as charge_monet,
       now() as etl_time
from ads.ads_report_AB_experiment_mul_base_mid rec
left join (
    select dt,types,product_id as app_product_id,user_id,book_id,is_read,total_read_chpts,consume_amount,consume_chpts,consume_money_amount,charge_money
    from ads.ads_report_AB_experiment_mul_tmp
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and product_id not in(3388,3366)
    ) a  on rec.dt=a.dt and rec.source_types=a.types and rec.product_id=a.app_product_id and rec.user_id=a.user_id and rec.book_id=a.book_id
left join ads.ads_report_AB_experiment_mul_group_tmp gr
    on rec.product_id=gr.product_id and rec.user_id=gr.user_id
where rec.dt>=date_sub('${dt}',interval 10 day) and rec.dt<'${dt}' and rec.product_id not in(3388,3366)
group by 1,2,3,4,5,6;
