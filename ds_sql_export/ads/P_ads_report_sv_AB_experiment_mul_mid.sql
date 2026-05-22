----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_sv_AB_experiment_mul
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_report_sv_AB_experiment_mul_mid
-- task_version     : 9
-- update_time      : 2025-04-27 19:34:19
-- sql_path         : \starrocks\tbl_ads_report_sv_AB_experiment_mul\ads_report_sv_AB_experiment_mul_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_report_sv_AB_experiment_mul_mid where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}';

-- SQL语句
insert into ads.ads_report_sv_AB_experiment_mul_mid
with watch_event as (
    select a.dt, a.product_id,a.login_id as user_id, a.shortplay_id as series_id,a.episode_id as epis,b.epis_num
    from dwd.dwd_sensors_cd_video_unlockEpisode_view a
    left join dim.dim_short_video_epis_view b on a.episode_id=b.epis_id
    where dt>=date_sub('${dt}',interval 10 day) and dt<'${dt}'
)
-- 观看
select r.dt,r.source_types, r.push_type, r.is_toufang, r.product_id,r.user_id,r.series_id,r1.is_watch,r1.total_watch_epis,csum.consume_amount,csum.consume_epis,
       csum.user_money_consume,charge.charge_money,now() as etl_time
from ads.ads_report_sv_AB_experiment_mul_base_watch_mid r
left join (
    select dt, product_id,user_id ,series_id,1 as is_watch,bitmap_union(to_bitmap(concat(series_id,epis_num))) as total_watch_epis
    from watch_event
    group by 1,2,3,4
)r1 on r.dt=r1.dt and r.product_id=r1.product_id and r.user_id=r1.user_id and r.series_id=r1.series_id
left join (
    -- 消耗
    select a.dt, 6833 as product_id,a.account_id as user_id ,a.series_id,
           sum(a.consume_value) as consume_amount,
           bitmap_union(to_bitmap(concat(a.series_id,a.epis_num))) as consume_epis,
           sum(if(consume_type=0,consume_value,0)) as user_money_consume
    from dwd.dwd_sv_consume_user_consume_bill_pdi a
    -- left join dim.dim_short_video_epis_view b on a.epis_id=b.epis_id
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and consume_type in(0,1)
    group by 1,2,3,4
)csum on r.dt=csum.dt and r.product_id=csum.product_id and r.user_id=csum.user_id and r.series_id=csum.series_id
left join (
    select dt,product_id,user_id,cast(get_json_string(custom_data,'$.seriesId') as bigint) as series_id,round(sum(base_amount)/100,2) as charge_money
    from dwd.dwd_trade_short_video_payorder
    where dt >=date_sub('${dt}',interval 10 day) and dt<'${dt}' and test_flag=0 and status=0
      and cast(get_json_string(custom_data,'$.seriesId') as bigint)>0
    group by 1,2,3,4
) charge on r.dt=charge.dt and r.product_id=charge.product_id and r.user_id=charge.user_id and r.series_id=charge.series_id
where r.dt >=date_sub('${dt}',interval 10 day) and r.dt<'${dt}';
