----------------------------------------------------------------
-- 程序功能： 神农-机型ANR日活广告影响评估
-- 程序名： P_ads_shennong_dev_mdl_anr_dau_ad_imp_eval
-- 目标表： ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval
-- 负责人： qhr
-- 开发日期： 2023-08-19
----------------------------------------------------------------

-- 昨日
insert into ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval
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
                  ,coalesce(b2.device2, b3.device)                                                 as dev_mdl
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
               and coalesce(b2.device2, b3.device) is not null
               and b1.product_id <> 6883
               and b1.mt = 4
             group by 1, 2, 3, 4, 5, 6
           )                                                                                       as a1
     group by 1, 2, 3, 4, 5
)
,mdl_dau_ad_uv as (
    select a1.dt
          ,0               as dem_type
          ,'NoANR'         as dem_type_name
          ,a1.biz_type_cd
          ,a1.product_id
          ,a1.core
          ,a1.dev_mdl
          ,a1.svr_dau
          ,a2.ad_uv
          ,a2.ad_ttl_amt
          ,a2.ad_rpc
          ,a2.web_ad_amt
          ,a2.web_rpc
          ,a2.med_sdk_ad_amt
          ,a2.med_sdk_rpc
          ,a3.clk_uv
          ,null            as push_act_clk_uv
      from dau             as a1
      left join ad_info    as a2
        on a1.dt = a2.dt
       and a1.biz_type_cd = a2.biz_type_cd
       and a1.core = a2.core
       and a1.dev_mdl = a2.dev_mdl
      left join srsv_uv    as a3
        on a1.dt = a3.dt
       and a1.biz_type_cd = a3.biz_type_cd
       and a1.core = a3.core
       and a1.dev_mdl = a3.dev_mdl
)
,mdl_anr as (
    -- 广告降权
    select date(a1.AnrTime)                                                                as dt
          ,1                                                                               as dem_type
          ,'ADs'                                                                           as dem_type_name
          ,a2.p_cd_val                                                                     as biz_type_cd
          ,a1.ProductId                                                                    as product_id
          ,a1.Core                                                                         as core
          ,split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)    as mfr
          ,substr(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1)
                 ,length(split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)) + 2
                 )                                                                         as dev_mdl
          ,date(a1.AnrTime)                                                                as anr_ocr_dt
          ,date(a1.StartTime)                                                              as anr_fch_dt
          ,a1.DeviceGuid                                                                   as dev_guid
          ,a1.AnrCount                                                                     as imp_num
          ,a1.SessionCount                                                                 as sess_num
          ,a1.AnrRate                                                                      as imp_pct
          ,a1.AnrGlobalRate                                                                as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_version_device_anr    as a1
      join dim.dim_pub_code_mapping_dict                    as a2
        on a2.app_plat = 'beidou'
       and a2.cd_col = 'product_id'
       and a2.p_cd_val is not null
       and a1.ProductId = a2.cd_val
     where date(a1.AnrTime) = '${bf_1_dt}'
       and a1.ProductId <> 6883
     union all
    -- PUSH降权
    select date(a3.AnrTime)                              as dt
          ,2                                             as dem_type
          ,'PUSH'                                        as dem_type_name
          ,a4.p_cd_val                                   as biz_type_cd
          ,a3.ProductId                                  as product_id
          ,a3.Core                                       as core
          ,substring_index(a3.DeviceName, ' ', 1)        as mfr
          ,substring_index(a3.DeviceName, ' ', -1)       as dev_mdl
          ,date(a3.AnrTime)                              as anr_ocr_dt
          ,date(a3.StartTime)                            as anr_fch_dt
          ,a3.DeviceGuid                                 as dev_guid
          ,a3.AnrCount                                   as imp_num
          ,null                                          as sess_num
          ,a3.AnrRate                                    as imp_pct
          ,a3.AnrGlobalRate                              as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_push_device_anr    as a3
      join dim.dim_pub_code_mapping_dict                 as a4
       on a4.app_plat = 'beidou'
      and a4.cd_col = 'product_id'
      and a4.p_cd_val is not null
      and a3.ProductId = a4.cd_val
    where date(a3.AnrTime) = '${bf_1_dt}'
)
-- ANR有数据，日活及广告可能没数据
select a1.dt                                      as dt                  -- 日期
      ,a1.dem_type                                as dem_type            -- 降权类型
      ,a1.biz_type_cd                             as biz_type_cd         -- 业务类型编码
      ,a1.product_id                              as product_id          -- product_id
      ,a1.core                                    as core                -- core
      ,a1.dev_mdl                                 as dev_mdl             -- 设备型号
      ,a1.dem_type_name                           as dem_type_name       -- 降权类型名称
      ,a3.cd_val_desc                             as biz_type_name       -- 业务类型名称
      ,a4.cd_val_desc                             as prd_name            -- 产品名称
      ,a1.mfr                                     as mfr                 -- 厂商
      ,a1.anr_ocr_dt                              as anr_ocr_dt          -- ANR发生日期
      ,a1.anr_fch_dt                              as anr_fch_dt          -- ANR抓取日期
      ,a1.dev_guid                                as dev_guid            -- 设备GUID
      ,a1.imp_num                                 as imp_num             -- 影响数
      ,a1.sess_num                                as sess_num            -- 会话数
      ,a1.imp_pct                                 as imp_pct             -- 受影响占比
      ,a1.hist_anr_usr_rat                        as hist_anr_usr_rat    -- 历史ANR用户比例
      ,a2.svr_dau                                 as svr_dau             -- 服务端日活
      ,a2.ad_uv                                   as ad_uv               -- 广告uv
      ,a2.ad_ttl_amt                              as ad_ttl_amt          -- 广告总收入
      ,a2.ad_rpc                                  as ad_rpc              -- 广告人均单价
      ,a2.web_ad_amt                              as web_ad_amt          -- web广告收入
      ,a2.web_rpc                                 as web_rpc             -- web广告人均单价
      ,a2.med_sdk_ad_amt                          as med_sdk_ad_amt      -- 聚合SDK广告收入
      ,a2.med_sdk_rpc                             as med_sdk_rpc         -- 聚合SDK广告人均单价
      ,a2.clk_uv                                  as clk_uv              -- 点击uv
      ,a2.push_act_clk_uv                         as push_act_clk_uv     -- 下发活跃点击uv
  from mdl_anr                                    as a1
  left join mdl_dau_ad_uv                         as a2
    on a1.dt = a2.dt
   and a1.biz_type_cd = a2.biz_type_cd
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
  left join dim.dim_pub_code_mapping_dict         as a3
    on a3.app_plat = 'beidou'
   and a3.cd_col = 'biz_type_cd'
   and a1.biz_type_cd = a3.cd_val
  left join dim.dim_pub_code_mapping_dict         as a4
    on a4.app_plat = 'pub'
   and a4.cd_col = 'product_id'
   and a1.product_id = a4.cd_val
 union all
-- 日活及广告有数据，ANR没数据
select a5.dt                                      as dt                  -- 日期
      ,a5.dem_type                                as dem_type            -- 降权类型
      ,a5.biz_type_cd                             as biz_type_cd         -- 业务类型编码
      ,a5.product_id                              as product_id          -- product_id
      ,a5.core                                    as core                -- core
      ,a5.dev_mdl                                 as dev_mdl             -- 设备型号
      ,a5.dem_type_name                           as dem_type_name       -- 降权类型名称
      ,a7.cd_val_desc                             as biz_type_name       -- 业务类型名称
      ,a8.cd_val_desc                             as prd_name            -- 产品名称
      ,null                                       as mfr                 -- 厂商
      ,null                                       as anr_ocr_dt          -- ANR发生日期
      ,null                                       as anr_fch_dt          -- ANR抓取日期
      ,null                                       as dev_guid            -- 设备GUID
      ,null                                       as imp_num             -- 影响数
      ,null                                       as sess_num            -- 会话数
      ,null                                       as imp_pct             -- 受影响占比
      ,null                                       as hist_anr_usr_rat    -- 历史ANR用户比例
      ,a5.svr_dau                                 as svr_dau             -- 服务端日活
      ,a5.ad_uv                                   as ad_uv               -- 广告uv
      ,a5.ad_ttl_amt                              as ad_ttl_amt          -- 广告总收入
      ,a5.ad_rpc                                  as ad_rpc              -- 广告人均单价
      ,a5.web_ad_amt                              as web_ad_amt          -- web广告收入
      ,a5.web_rpc                                 as web_rpc             -- web广告人均单价
      ,a5.med_sdk_ad_amt                          as med_sdk_ad_amt      -- 聚合SDK广告收入
      ,a5.med_sdk_rpc                             as med_sdk_rpc         -- 聚合SDK广告人均单价
      ,a5.clk_uv                                  as clk_uv              -- 点击uv
      ,a5.push_act_clk_uv                         as push_act_clk_uv     -- 下发活跃点击uv
  from mdl_dau_ad_uv                              as a5
  left join mdl_anr                               as a6
    on a5.dt = a6.dt
   and a5.biz_type_cd = a6.biz_type_cd
   and a5.core = a6.core
   and a5.dev_mdl = a6.dev_mdl
  left join dim.dim_pub_code_mapping_dict         as a7
    on a7.app_plat = 'beidou'
   and a7.cd_col = 'biz_type_cd'
   and a5.biz_type_cd = a7.cd_val
  left join dim.dim_pub_code_mapping_dict         as a8
    on a8.app_plat = 'pub'
   and a8.cd_col = 'product_id'
   and a5.product_id = a8.cd_val
 where a6.dt is null
;

-- 前10日
insert into ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval
with mdl_anr as (
    -- 广告降权
    select date(a1.AnrTime)                                                                as dt
          ,1                                                                               as dem_type
          ,'ADs'                                                                           as dem_type_name
          ,a2.p_cd_val                                                                     as biz_type_cd
          ,a1.ProductId                                                                    as product_id
          ,a1.Core                                                                         as core
          ,split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)    as mfr
          ,substr(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1)
                 ,length(split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)) + 2
                 )                                                                         as dev_mdl
          ,date(a1.AnrTime)                                                                as anr_ocr_dt
          ,date(a1.StartTime)                                                              as anr_fch_dt
          ,a1.DeviceGuid                                                                   as dev_guid
          ,a1.AnrCount                                                                     as imp_num
          ,a1.SessionCount                                                                 as sess_num
          ,a1.AnrRate                                                                      as imp_pct
          ,a1.AnrGlobalRate                                                                as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_version_device_anr    as a1
      join dim.dim_pub_code_mapping_dict                    as a2
        on a2.app_plat = 'beidou'
       and a2.cd_col = 'product_id'
       and a2.p_cd_val is not null
       and a1.ProductId = a2.cd_val
     where date(a1.AnrTime) >= date_sub('${bf_1_dt}', interval 10 day)
       and date(a1.AnrTime) < '${bf_1_dt}'
     union all
    -- PUSH降权
    select date(a3.AnrTime)                              as dt
          ,2                                             as dem_type
          ,'PUSH'                                        as dem_type_name
          ,a4.p_cd_val                                   as biz_type_cd
          ,a3.ProductId                                  as product_id
          ,a3.Core                                       as core
          ,substring_index(a3.DeviceName, ' ', 1)        as mfr
          ,substring_index(a3.DeviceName, ' ', -1)       as dev_mdl
          ,date(a3.AnrTime)                              as anr_ocr_dt
          ,date(a3.StartTime)                            as anr_fch_dt
          ,a3.DeviceGuid                                 as dev_guid
          ,a3.AnrCount                                   as imp_num
          ,null                                          as sess_num
          ,a3.AnrRate                                    as imp_pct
          ,a3.AnrGlobalRate                              as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_push_device_anr    as a3
      join dim.dim_pub_code_mapping_dict                 as a4
       on a4.app_plat = 'beidou'
      and a4.cd_col = 'product_id'
      and a4.p_cd_val is not null
      and a3.ProductId = a4.cd_val
    where date(a3.AnrTime) >= date_sub('${bf_1_dt}', interval 10 day)
      and date(a3.AnrTime) < '${bf_1_dt}'
)
select a1.dt                                          as dt                  -- 日期
      ,coalesce(a1.dem_type,a2.dem_type)              as dem_type            -- 降权类型
      ,a1.biz_type_cd                                 as biz_type_cd         -- 业务类型编码
      ,a1.product_id                                  as product_id          -- product_id
      ,a1.core                                        as core                -- core
      ,a1.dev_mdl                                     as dev_mdl             -- 设备型号
      ,coalesce(a1.dem_type_name,a2.dem_type_name)    as dem_type_name       -- 降权类型名称
      ,a3.cd_val_desc                                 as biz_type_name       -- 业务类型名称
      ,a4.cd_val_desc                                 as prd_name            -- 产品名称
      ,a1.mfr                                         as mfr                 -- 厂商
      ,a1.anr_ocr_dt                                  as anr_ocr_dt          -- ANR发生日期
      ,a1.anr_fch_dt                                  as anr_fch_dt          -- ANR抓取日期
      ,a1.dev_guid                                    as dev_guid            -- 设备GUID
      ,a1.imp_num                                     as imp_num             -- 影响数
      ,a1.sess_num                                    as sess_num            -- 会话数
      ,a1.imp_pct                                     as imp_pct             -- 受影响占比
      ,a1.hist_anr_usr_rat                            as hist_anr_usr_rat    -- 历史ANR用户比例
      ,a2.svr_dau                                     as svr_dau             -- 服务端日活
      ,a2.ad_uv                                       as ad_uv               -- 广告uv
      ,a2.ad_ttl_amt                                  as ad_ttl_amt          -- 广告总收入
      ,a2.ad_rpc                                      as ad_rpc              -- 广告人均单价
      ,a2.web_ad_amt                                  as web_ad_amt          -- web广告收入
      ,a2.web_ad_rpc                                  as web_ad_rpc          -- web广告人均单价
      ,a2.med_sdk_ad_amt                              as med_sdk_ad_amt      -- 聚合SDK广告收入
      ,a2.med_sdk_ad_rpc                              as med_sdk_ad_rpc      -- 聚合SDK广告人均单价
      ,a2.clk_uv                                      as clk_uv              -- 点击uv
      ,a2.push_act_clk_uv                             as push_act_clk_uv     -- 下发活跃点击uv
  from mdl_anr                                              as a1
  left join ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval    as a2
    on a2.dt >= date_sub('${bf_1_dt}', interval 10 day)
   and a2.dt < '${bf_1_dt}'
   and a1.dt = a2.dt
   and a1.biz_type_cd = a2.biz_type_cd
   and a1.product_id = a2.product_id
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
  left join dim.dim_pub_code_mapping_dict                   as a3
    on a3.app_plat = 'beidou'
   and a3.cd_col = 'biz_type_cd'
   and a1.biz_type_cd = a3.cd_val
  left join dim.dim_pub_code_mapping_dict                   as a4
    on a4.app_plat = 'pub'
   and a4.cd_col = 'product_id'
   and a1.product_id = a4.cd_val
;