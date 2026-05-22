----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_epis_consume_ed
-- workflow_version : 14
-- create_user      : zhengtt
-- task_name        : dws_consume_short_video_epis_consume_ed
-- task_version     : 14
-- update_time      : 2025-05-30 11:38:36
-- sql_path         : \starrocks\tbl_dws_consume_short_video_epis_consume_ed\dws_consume_short_video_epis_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_consume_short_video_epis_consume_ed where dt >= date_sub('${bf_1_dt}',interval 2 day);

-- SQL语句
insert into dws.dws_consume_short_video_epis_consume_ed
-- 获取版权方收入统计模式
with sv_story as (
    select
        series_id,
        sum(divide_type) as divide_type
    from (
             select
                 c.series_id,
                 max(if(a.is_source=1 and b.is_main = 1,divide_type,0)) over(partition by a.story_code_source order by status desc) as divide_type
             from dim.dim_sr_cp_story_view a
             join dim.dim_short_video_source_series_view b on a.story_code = b.series_code and a.story_id = b.series_id
             join dim.dim_short_video_series_view c on b.series_id = c.source_series_id
             where product_type = 1 and story_type = 2
             union all
             select series_id, 0 as divide_type from dim.dim_sv_series_hi
         ) a group by series_id
),
-- 获取海剧dt-1 koc归因周期内的数据
     sv_koc as (
         select
             user_id,
             begin_time,
             koc_text,
             end_time,
             resource_id
         from dwd.dwd_srsv_advertisement_koc_attribution_record_view
         where product_id = 6833
     ),
-- KOC机构合作信息-短剧
     koc_institutioncfg as (
         select
             InstitutionId,
             SplitRatio/100 as split_ratio
         from ods.ods_tidb_koc_institutioncfg_da
         where ProjectType = 2
     ),
-- 根据剧名、用户和koc归因周期剔除koc分成
     sv_consume_production as (
         select
             a.dt,
             a.id,
             a.series_id,
             a.epis_num,
             a.account_id,
             a.consume_type,
             a.consume_value * (1 - coalesce(d.split_ratio, 0)) as consume_value
         from (
                  select
                      a.dt,
                      a.id,
                      a.series_id,
                      a.epis_num,
                      a.account_id,
                      a.consume_type,
                      a.consume_value,
                      a.create_time
                  from dwd.dwd_video_short_video_consume_production a
                           join sv_story b on a.series_id = b.series_id and a.type = coalesce(b.divide_type, 0)
                  where dt = date_sub('${bf_1_dt}',interval 2 day) and a.type = 0
                  union all
                  select
                      a.dt,
                      null as id,
                      a.series_id,
                      a.epis_num,
                      a.account_id,
                      0 as consume_type,
                      b.day_charge/ count(1) over (partition by b.user_id, b.order_id) as day_charge,
                      a.create_time
                  from (
                      -- 付费观看
                      select
                          a.dt,
                          a.account_id,
                          a.series_id,
                          a.epis_id,
                          b.epis_num,
                          a.create_time
                      from (
                          select
                              dt,
                              account_id,
                              series_id,
                              epis_id,
                              min(create_time) as create_time
                          from dwd.dwd_video_short_video_epis_history
                          where dt = date_sub('${bf_1_dt}',interval 2 day)
                          group by dt, account_id, series_id, epis_id
                      ) a
                      left join dim.dim_short_video_epis_view b on a.epis_id = b.epis_id
                      where b.is_free = 0
                  ) a
                  join (
                      -- SVIP用户
                      select
                          a.user_id,
                          order_id,
                          after_charge/(datediff(vip_expire_time, vip_start_time)+1) as day_charge,
                          vip_start_time,
                          vip_expire_time
                      from ads.ads_bi_short_video_trade_user_subscribe_di a
                      where shop_item = 810 and ((dt >= '2024-10-01' and core = 1) or dt < '2024-10-01') and date(vip_start_time) <= date_sub('${bf_1_dt}',interval 2 day) and date(vip_expire_time) >= date_sub('${bf_1_dt}',interval 2 day)
                  ) b
                  on a.account_id = b.user_id and a.create_time >= b.vip_start_time and a.create_time <= b.vip_expire_time
              ) a
                  -- 订单关联归因表，确认归属koc的订单
                  left join sv_koc b
                            on a.account_id = b.user_id
                                and a.series_id = b.resource_id
                                and a.create_time >= b.begin_time and a.create_time <= b.end_time
                  left join ods.ods_tidb_koc_codeinfo c
                            on c.KocCode = b.koc_text
                  left join koc_institutioncfg d
                            on c.InstitutionId = d.InstitutionId
     )
select
    dt,
    a.series_id,
    a.epis_num,
    bitmap_union(to_bitmap(a.account_id)) as consume_user_bitmap,
    sum(a.consume_value) as consume_amt,
    count(distinct a.id) as consume_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 0, a.account_id, null))) as consume_money_user_bitmap,
    sum(if(a.consume_type = 0, a.consume_value, 0)) as consume_money_amt,
    sum(if(a.consume_type = 0, 1, 0)) as consume_money_cnt,
    bitmap_union(to_bitmap(if(a.consume_type = 1, a.account_id, null))) as consume_cert_user_bitmap,
    sum(if(a.consume_type = 1, a.consume_value, 0)) as consume_cert_amt,
    sum(if(a.consume_type = 1, 1, 0)) as consume_cert_cnt,
    now() as etl_time
from sv_consume_production a
group by a.dt, a.series_id, a.epis_num;
