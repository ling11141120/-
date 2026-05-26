----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_consume_ensp
-- task_version     : 17
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_consume_ensp
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_AB_experiment_mul_ltv where (dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
       or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day);

-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv
with rec as(
    select dt,source_types,product_id as app_product_id,lang_id as app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,send_id,active_point_id,element_id,element_type,activity_id
    from ads.ads_report_AB_experiment_mul_base_mid
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
        or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and product_id in(3388,3366)
)
select rec.dt,rec.process_types,rec.source_types,rec.app_product_id,rec.app_lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,sum(a.ltv0) as ltv0,sum(a.ltv1) as ltv1,sum(a.ltv3) as ltv3,sum(a.ltv5) as ltv5,sum(a.ltv7) as ltv7,
       sum(a.ltv15) as ltv15,sum(a.ltv30) as ltv30,
       sum(CASE WHEN b.ltv60 is null THEN a.ltv30 ELSE b.ltv60 END ) as ltv60,
       sum(CASE WHEN b.ltv90 is null THEN a.ltv30 ELSE b.ltv90 END) as ltv90,
       sum(CASE WHEN b.ltv120 is null THEN a.ltv30 ELSE b.ltv120 END) as ltv120,
       now() as etl_time
from (
         select dt,1 as process_types,source_types,app_product_id,app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,
                send_id,active_point_id,element_id,element_type,activity_id
         from rec
     )rec
         left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30
    from ads.ads_report_AB_experiment_mul_ltv_mid1
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}') or
           dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
      and process_types=1 and product_id in(3388,3366)
) a  on rec.dt=a.dt and rec.process_types=a.process_types and rec.source_types=a.source_types and rec.app_product_id=a.app_product_id
    and rec.user_id=a.user_id and rec.book_id=a.book_id
         left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv60,ltv90,ltv120
    from ads.ads_report_AB_experiment_mul_ltv_mid2
    where (dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and process_types=1 and product_id in(3388,3366)
) b  on rec.dt=b.dt and rec.process_types=b.process_types and rec.source_types=b.source_types and rec.app_product_id=b.app_product_id
    and rec.user_id=b.user_id and rec.book_id=b.book_id
         left join ads.ads_report_AB_experiment_mul_group_tmp gr
                   on rec.app_product_id=gr.product_id and rec.user_id=gr.user_id
group by 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_consume_other
-- task_version     : 15
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_consume_other
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv
with rec as(
    select dt,source_types,product_id as app_product_id,lang_id as app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,send_id,active_point_id,element_id,element_type,activity_id
    from ads.ads_report_AB_experiment_mul_base_mid
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
       or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and product_id not in(3388,3366)
)
select rec.dt,rec.process_types,rec.source_types,rec.app_product_id,rec.app_lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,sum(a.ltv0) as ltv0,sum(a.ltv1) as ltv1,sum(a.ltv3) as ltv3,sum(a.ltv5) as ltv5,sum(a.ltv7) as ltv7,
       sum(a.ltv15) as ltv15,sum(a.ltv30) as ltv30,
       sum(if(b.ltv60 is null,a.ltv30,b.ltv60)) as ltv60,
       sum(if(b.ltv90 is null,a.ltv30,b.ltv90)) as ltv90,
       sum(if(b.ltv120 is null,a.ltv30,b.ltv120)) as ltv120,
       now() as etl_time
from (
    select dt,1 as process_types,source_types,app_product_id,app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,
           send_id,active_point_id,element_id,element_type,activity_id
    from rec
     )rec
left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30
    from ads.ads_report_AB_experiment_mul_ltv_mid1
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}') or
          dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
      and process_types=1 and product_id not in(3388,3366)
    ) a  on rec.dt=a.dt and rec.process_types=a.process_types and rec.source_types=a.source_types and rec.app_product_id=a.app_product_id
                and rec.user_id=a.user_id and rec.book_id=a.book_id
left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv60,ltv90,ltv120
    from ads.ads_report_AB_experiment_mul_ltv_mid2
    where (dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and process_types=1 and product_id not in(3388,3366)
    ) b  on rec.dt=b.dt and rec.process_types=b.process_types and rec.source_types=b.source_types and rec.app_product_id=b.app_product_id
                and rec.user_id=b.user_id and rec.book_id=b.book_id
left join ads.ads_report_AB_experiment_mul_group_tmp gr
    on rec.app_product_id=gr.product_id and rec.user_id=gr.user_id
group by 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_recharge_ensp
-- task_version     : 13
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_recharge_ensp
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv
with rec as(
    select dt,source_types,product_id as app_product_id,lang_id as app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,send_id,active_point_id,element_id,element_type,activity_id
    from ads.ads_report_AB_experiment_mul_base_mid
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
       or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and product_id in(3388,3366)
)
select rec.dt,rec.process_types,rec.source_types,rec.app_product_id,rec.app_lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,sum(a.ltv0) as ltv0,sum(a.ltv1) as ltv1,sum(a.ltv3) as ltv3,sum(a.ltv5) as ltv5,sum(a.ltv7) as ltv7,
       sum(a.ltv15) as ltv15,sum(a.ltv30) as ltv30,
       sum(if(b.ltv60 is null,a.ltv30,b.ltv60)) as ltv60,
       sum(if(b.ltv90 is null,a.ltv30,b.ltv90)) as ltv90,
       sum(if(b.ltv120 is null,a.ltv30,b.ltv120)) as ltv120,
       now() as etl_time
from (
    select dt,2 as process_types,source_types,app_product_id,app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,
           send_id,active_point_id,element_id,element_type,activity_id
    from rec
     )rec
left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30
    from ads.ads_report_AB_experiment_mul_ltv_mid1
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}') or
          dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
      and process_types=2 and product_id in(3388,3366)
    ) a  on rec.dt=a.dt and rec.process_types=a.process_types and rec.source_types=a.source_types and rec.app_product_id=a.app_product_id
                and rec.user_id=a.user_id and rec.book_id=a.book_id
left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv60,ltv90,ltv120
    from ads.ads_report_AB_experiment_mul_ltv_mid2
    where (dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
    and process_types=2 and product_id in(3388,3366)
    ) b  on rec.dt=b.dt and rec.process_types=b.process_types and rec.source_types=b.source_types and rec.app_product_id=b.app_product_id
                and rec.user_id=b.user_id and rec.book_id=b.book_id
left join ads.ads_report_AB_experiment_mul_group_tmp gr
    on rec.app_product_id=gr.product_id and rec.user_id=gr.user_id
group by 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_ltv_recharge_other
-- task_version     : 13
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_ltv_recharge_other
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mul_ltv
with rec as(
    select dt,source_types,product_id as app_product_id,lang_id as app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,send_id,active_point_id,element_id,element_type,activity_id
    from ads.ads_report_AB_experiment_mul_base_mid
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}')
        or dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day)) and product_id not in(3388,3366)
)
select rec.dt,rec.process_types,rec.source_types,rec.app_product_id,rec.app_lang_id,rec.user_id,group_ids,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.page_name,',')),','),',')),x->x is not null and x !='') as page_name,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.list_id,',')),','),',')),x->x is not null and x !='') as list_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.module_channel_id,',')),','),',')),x->x is not null and x !='') as module_channel_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.send_id,',')),','),',')),x->x is not null and x !='') as send_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.active_point_id,',')),','),',')),x->x is not null and x !='') as active_point_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_id,',')),','),',')),x->x is not null and x !='') as element_id,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.element_type,',')),','),',')),x->x is not null and x !='') as element_type,
       array_filter(array_distinct(split(array_join(array_agg(array_join(rec.activity_id,',')),','),',')),x->x is not null and x !='') as activity_id,
       max(a.is_read) as is_read,sum(a.ltv0) as ltv0,sum(a.ltv1) as ltv1,sum(a.ltv3) as ltv3,sum(a.ltv5) as ltv5,sum(a.ltv7) as ltv7,
       sum(a.ltv15) as ltv15,sum(a.ltv30) as ltv30,
       sum(CASE WHEN b.ltv60 is null THEN a.ltv30 ELSE b.ltv60 END ) as ltv60,
       sum(CASE WHEN b.ltv90 is null THEN a.ltv30 ELSE b.ltv90 END) as ltv90,
       sum(CASE WHEN b.ltv120 is null THEN a.ltv30 ELSE b.ltv120 END) as ltv120,
       now() as etl_time
from (
         select dt,2 as process_types,source_types,app_product_id,app_lang_id,user_id,book_id,page_name,list_id,module_channel_id,
                send_id,active_point_id,element_id,element_type,activity_id
         from rec
     )rec
         left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv0,ltv1,ltv3,ltv5,ltv7,ltv15,ltv30
    from ads.ads_report_AB_experiment_mul_ltv_mid1
    where ((dt>=date_sub('${bf_1_dt}',interval 30 day) and dt<='${bf_1_dt}') or
           dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
      and process_types=2 and product_id not in(3388,3366)
) a  on rec.dt=a.dt and rec.process_types=a.process_types and rec.source_types=a.source_types and rec.app_product_id=a.app_product_id
    and rec.user_id=a.user_id and rec.book_id=a.book_id
         left join (
    select dt,process_types,source_types,product_id as app_product_id,user_id,book_id,is_read,ltv60,ltv90,ltv120
    from ads.ads_report_AB_experiment_mul_ltv_mid2
    where (dt = date_sub('${bf_1_dt}', interval 60 day) or dt = date_sub('${bf_1_dt}', interval 90 day) or dt = date_sub('${bf_1_dt}', interval 120 day))
      and process_types=2 and product_id not in(3388,3366)
) b  on rec.dt=b.dt and rec.process_types=b.process_types and rec.source_types=b.source_types and rec.app_product_id=b.app_product_id
    and rec.user_id=b.user_id and rec.book_id=b.book_id
         left join ads.ads_report_AB_experiment_mul_group_tmp gr
                   on rec.app_product_id=gr.product_id and rec.user_id=gr.user_id
group by 1,2,3,4,5,6,7;
