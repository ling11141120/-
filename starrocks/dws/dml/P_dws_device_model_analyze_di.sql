----------------------------------------------------------------
-- 程序功能： 设备域-机型分析-每日增量
-- 程序名： P_dws_device_model_analyze_di
-- 目标表： dws.dws_device_model_analyze_di
-- 负责人： roger
-- 开发日期：2025/11/26
-- 版本号： v1.0
----------------------------------------------------------------


insert into dws.dws_device_model_analyze_di
with dau as (
    select a1.dt
          ,a1.corever                                           as core
          ,a2.device2                                           as dev_mdl
          ,a3.p_cd_val                                          as biz_type_cd
          ,a1.product_id                                        as product_id
          ,bitmap_count(bitmap_union(to_bitmap(a1.user_id)))    as svr_dau
      from dws.dws_user_short_video_wide_active_period_ed       as a1    -- 短剧活跃用户表
      join dim.dim_short_video_user_accountinfo                 as a2    -- 短剧用户信息表
        on a2.device2 is not null
       and a1.user_id = a2.user_id
       and a1.product_id = a2.product_id
       and a1.corever = a2.corever2
      join dim.dim_pub_code_mapping_dict                        as a3
        on a3.app_plat = 'beidou'
       and a3.cd_col = 'product_id'
       and a3.p_cd_val is not null
       and a1.product_id = a3.cd_val
     where a1.dt = '${bf_1_dt}'
       and a1.period_type = 'ctt'
       and a1.product_id = 6833
       and a1.mt = 4
     group by 1,2,3,4,5
     union all
    select a4.dt
          ,a4.corever                                           as core
          ,a5.dev_mdl                                           as dev_mdl
          ,a6.p_cd_val                                          as biz_type_cd
          ,a4.product_id                                        as product_id
          ,bitmap_count(bitmap_union(to_bitmap(a4.user_id)))    as svr_dau
      from dws.dws_user_wide_active_period_ed                   as a4    -- 阅读活跃用户表
      join dim.dim_user_userdata_view                           as a5    -- 阅读用户信息表
        on a5.product_id not in (6833,6883)
       and a5.dev_mdl is not null
       and a4.user_id = a5.id
       and a4.product_id = a5.product_id
      join dim.dim_pub_code_mapping_dict                        as a6
        on a6.app_plat = 'beidou'
       and a6.cd_col = 'product_id'
       and a6.p_cd_val is not null
       and a4.product_id = a6.cd_val
     where a4.dt = '${bf_1_dt}'
       and a4.period_type = 'ctt'
       and a4.mt = 4
     group by 1,2,3,4,5
)
,srsv_uv as (
    -- 海阅
    select a1.dt
          ,a2.corever                                                     as core
          ,a3.dev_mdl                                                     as dev_mdl
          ,a4.p_cd_val                                                    as biz_type_cd
          ,a1.app_product_id                                              as product_id
          ,bitmap_count(bitmap_union(to_bitmap(a1.identity_login_id)))    as clk_uv
      from (select b1.dt
                  ,b1.identity_login_id
                  ,b1.app_product_id
              from ods_log.ods_sensors_production_pushclick               as b1
             where b1.dt = '${bf_1_dt}'
               and b1.project_id = 5
             union all
            select b2.dt
                  ,b2.identity_login_id
                  ,b2.app_product_id
              from ods_log.ods_sensors_production_app_launch              as b2
             where b2.dt = '${bf_1_dt}'
               and regexp(b2.app_module, 'realtime')
           )                                                              as a1
      left join dim.dim_short_read_user_accountinfo_zip                   as a2
        on a1.identity_login_id = a2.user_id
       and a1.app_product_id = a2.product_id
       and a1.dt >= a2.start_dt
       and a1.dt <= a2.end_dt
      join dim.dim_user_userdata_view                                     as a3
        on a3.product_id not in (6833,6883)
       and a3.dev_mdl is not null
       and a1.identity_login_id = a3.id
       and a1.app_product_id = a3.product_id
      join dim.dim_pub_code_mapping_dict                                  as a4
        on a4.app_plat = 'beidou'
       and a4.cd_col = 'product_id'
       and a4.p_cd_val is not null
       and a1.app_product_id = a4.cd_val
     where a2.mt = 4
     group by 1,2,3,4,5
     union all
    -- 海剧
    select a5.dt
          ,a6.corever                                                     as core
          ,a6.device2                                                     as dev_mdl
          ,a7.p_cd_val                                                    as biz_type_cd
          ,a6.product_id                                                  as product_id
          ,bitmap_count(bitmap_union(to_bitmap(a5.login_id)))             as clk_uv
      from ods_log.ods_sensors_production_pushclick                       as a5
      join dim.dim_short_video_user_accountinfo                           as a6    -- 短剧用户信息表
        on a5.login_id = a6.user_id
       and a6.device2 is not null
       and a6.mt = 4
      join dim.dim_pub_code_mapping_dict                                  as a7
        on a7.app_plat = 'beidou'
       and a7.cd_col = 'product_id'
       and a7.p_cd_val is not null
       and a6.product_id = a7.cd_val
     where a5.dt = '${bf_1_dt}'
       and a5.project_id = 8
     group by 1,2,3,4,5
)
, ad_info as (
    select a1.dt
          ,a1.biz_type_cd
          ,a1.product_id
          ,a1.core
          ,a1.dev_mdl
          ,bitmap_count(bitmap_union(to_bitmap(a1.user_id)))                                       as ad_uv
          ,sum(a1.ad_ttl_amt)                                                                      as ad_ttl_amt
          ,sum(a1.ad_ttl_amt)
           / bitmap_count(bitmap_union(to_bitmap(if(a1.ad_ttl_amt > 0, a1.user_id, null))))        as ad_rpc
          ,sum(a1.web_ad_amt)                                                                      as web_ad_amt
          ,sum(a1.web_ad_amt)
           / bitmap_count(bitmap_union(to_bitmap(if(a1.web_ad_amt > 0, a1.user_id, null))))        as web_rpc
          ,sum(a1.med_sdk_ad_amt)                                                                  as med_sdk_ad_amt
          ,sum(a1.med_sdk_ad_amt)
           / bitmap_count(bitmap_union(to_bitmap(if(a1.med_sdk_ad_amt > 0, a1.user_id, null))))    as med_sdk_rpc
      from (select b1.dt
                  ,b5.p_cd_val                                                                     as biz_type_cd
                  ,b1.corever                                                                      as core
                  ,b1.product_id                                                                   as product_id
                  ,coalesce(b2.device2, b3.dev_mdl)                                                as dev_mdl
                  ,b1.user_id                                                                      as user_id
                  ,sum(b4.amt)                                                                     as ad_ttl_amt
                  ,sum(if(b4.ad_show_type = 6, b4.amt, 0))                                         as web_ad_amt
                  ,sum(if(b4.ad_show_type <> 6, b4.amt, 0))                                        as med_sdk_ad_amt
              from dws.dws_srsv_wide_user_type_info_di                                             as b1
              left join dim.dim_short_video_user_accountinfo                                       as b2
                on b2.device2 is not null
               and b1.user_id = b2.user_id
               and b1.product_id = b2.product_id
               and b1.corever = b2.corever
              left join dim.dim_user_userdata_view                                                 as b3
                on b3.dev_mdl is not null
               and b1.user_id = b3.id
               and b1.product_id = b3.product_id
              join dws.dws_advertisement_user_position_amt_ed                                      as b4
                on b4.dt = '${bf_1_dt}'
               and b1.product_id = b4.product_id
               and b1.corever = b4.core
               and b1.user_id = b4.user_id
              join dim.dim_pub_code_mapping_dict                                                   as b5
                on b5.app_plat = 'beidou'
               and b5.cd_col = 'product_id'
               and b1.product_id = b5.cd_val
               and b5.p_cd_val is not null
             where b1.user_period = 2
               and b1.dt = '${bf_1_dt}'
               and coalesce(b2.device2, b3.dev_mdl) is not null
               and b1.product_id <> 6883
               and b1.mt = 4
             group by 1, 2, 3, 4, 5, 6
           )                                                                                       as a1
     group by 1, 2, 3, 4, 5
)
, svsr_tp_rev as (
    -- 海剧
    select a1.dt
          ,a2.corever            as core
          ,a2.device2            as dev_mdl
          ,a3.p_cd_val           as biz_type_cd
          ,a1.product_id         as product_id
          ,sum(a1.item_count)    as tp_rev
          ,sum(if(hours_diff(a1.create_time, ospp1.event_tm) > 0 and hours_diff(a1.create_time, ospp1.event_tm) <= 1, a1.item_count, null)) as push_af_1h_tp_rev
      from dwd.dwd_trade_short_video_payorder            as a1
      left join dim.dim_short_video_user_accountinfo     as a2
        on a1.user_id = a2.user_id
       and a2.device2 is not null
      join dim.dim_pub_code_mapping_dict                 as a3
        on a3.app_plat = 'beidou'
       and a3.cd_col = 'product_id'
       and a3.p_cd_val is not null
       and a1.product_id = a3.cd_val
      left join ods_log.ods_sensors_production_pushclick as ospp1
        on a1.user_id = ospp1.login_id
       and a1.dt = ospp1.dt
     where a1.dt = '${bf_1_dt}'
       and a1.mt = 4
       and a1.product_id = 6833
     group by 1, 2, 3, 4, 5
     union all
    -- 海阅
    select a4.dt
          ,a4.corever            as core
          ,a5.dev_mdl            as dev_mdl
          ,a6.p_cd_val           as biz_type_cd
          ,a4.ProductId          as product_id
          ,sum(a4.ItemCount)     as tp_rev
          ,sum(if(hours_diff(a4.CreateTime, ospp2.event_tm) > 0 and hours_diff(a4.CreateTime, ospp2.event_tm) <= 1, a4.ItemCount, null)) as push_af_1h_tp_rev
      from dwd.dwd_trade_user_payorder                   as a4
      left join dim.dim_user_userdata_view               as a5
        on a5.product_id not in (6833, 6883)
       and a5.dev_mdl is not null
       and a4.UserId = a5.id
       and a4.ProductId = a5.product_id
      join dim.dim_pub_code_mapping_dict                 as a6
        on a6.app_plat = 'beidou'
       and a6.cd_col = 'product_id'
       and a6.p_cd_val is not null
       and a4.ProductId = a6.cd_val
      left join ods_log.ods_sensors_production_pushclick as ospp2
        on a4.UserId = ospp2.login_id
       and a4.dt = ospp2.dt
     where a4.dt = '${bf_1_dt}'
       and a4.MT = 4
     group by 1, 2, 3, 4, 5
)

select a1.dt
     , a1.biz_type_cd
     , a1.product_id
     , a1.core
     , a1.dev_mdl
     , a5.cd_val_desc         as biz_type_name
     , a1.svr_dau
     , a2.ad_uv
     , a2.ad_ttl_amt
     , a2.ad_rpc
     , a2.web_ad_amt
     , a2.web_rpc             as web_ad_rpc
     , a2.med_sdk_ad_amt
     , a2.med_sdk_rpc         as med_sdk_ad_rpc
     , a3.clk_uv
     , null                   as push_act_clk_uv
     , a4.tp_rev
     , a4.push_af_1h_tp_rev
     , now()                  as etl_dtm
from dau                   as a1
  left join ad_info        as a2
    on a1.dt = a2.dt
   and a1.product_id = a2.product_id
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
  left join srsv_uv        as a3
    on a1.dt = a3.dt
   and a1.product_id = a3.product_id
   and a1.core = a3.core
   and a1.dev_mdl = a3.dev_mdl
  left join svsr_tp_rev    as a4
    on a1.dt = a4.dt
   and a1.product_id = a4.product_id
   and a1.core = a4.core
   and a1.dev_mdl = a4.dev_mdl
  left join dim.dim_pub_code_mapping_dict as a5
    on a5.app_plat = 'beidou'
   and a5.cd_col = 'biz_type_cd'
   and a1.biz_type_cd = a5.cd_val
;
