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
      left join dim.dim_pub_code_mapping_dict                  as a3
        on a3.app_plat = 'beidou'
       and a3.cd_col = 'product_id'
       and a1.product_id = a3.cd_val
     where a1.dt = '${bf_1_dt}'
       and a1.period_type = 'ctt'
       and a1.product_id = 6833
     group by 1,2,3,4,5
     union all
    select a4.dt
          ,a4.corever                                           as core
          ,a5.device                                            as dev_mdl
          ,a6.p_cd_val                                          as biz_type_cd
          ,a4.product_id                                        as product_id
          ,bitmap_count(bitmap_union(to_bitmap(a4.user_id)))    as svr_dau
      from dws.dws_user_wide_active_period_ed                   as a4    -- 阅读活跃用户表
      join dim.dim_user_userdata_view                           as a5    -- 阅读用户信息表
        on a5.product_id in (3366,3388,3333,3322,3311,3371,3399,3501,3511)
       and a5.device is not null
       and a4.user_id = a5.id
       and a4.product_id = a5.product_id
      left join dim.dim_pub_code_mapping_dict                   as a6
        on a6.app_plat = 'beidou'
       and a6.cd_col = 'product_id'
       and a4.product_id = a6.cd_val
     where a4.dt = '${bf_1_dt}'
       and a4.period_type = 'ctt'
       and a4.product_id in (3366,3388,3333,3322,3311,3371,3399,3501,3511)
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
              left join dim.dim_user_all_info                                                      as b3
                on b3.device is not null
               and b1.user_id = b3.user_id
               and b1.product_id = b3.product_id
               and b1.corever = b3.corever
              join dws.dws_advertisement_user_position_amt_ed                                      as b4
                on b4.dt = '${bf_1_dt}'
               and b1.product_id = b4.product_id
               and b1.corever = b4.core
               and b1.user_id = b4.user_id
              left join dim.dim_pub_code_mapping_dict                                              as b5
                on b5.app_plat = 'beidou'
               and b5.cd_col = 'product_id'
               and b1.product_id = b5.cd_val
             where b1.user_period = 2
               and b1.dt = '${bf_1_dt}'
               and coalesce(b2.device2, b3.device) is not null
               and b1.product_id in (3366,3388,3333,3322,3311,3371,3399,3501,3511,6833)
             group by 1, 2, 3, 4, 5, 6
           )                                                                                       as a1
     group by 1, 2, 3, 4, 5
)
,mdl_dau_ad as (
    select a1.dt
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
      from dau             as a1
      left join ad_info    as a2
        on a1.dt = a2.dt
       and a1.biz_type_cd = a2.biz_type_cd
       and a1.core = a2.core
       and a1.dev_mdl = a2.dev_mdl
)
,mdl_anr as (
    select date(a1.AnrTime)      as dt
          ,a2.p_cd_val           as biz_type_cd
          ,a1.ProductId          as product_id
          ,a1.Core               as core
          ,split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1) as mfr
          ,substr(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1)
                 ,length(split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)) + 2
                 )               as dev_mdl
          ,date(a1.AnrTime)      as anr_ocr_dt
          ,date(a1.StartTime)    as anr_fch_dt
          ,a1.DeviceGuid         as dev_guid
          ,a1.AnrCount           as imp_num
          ,a1.SessionCount       as sess_num
          ,a1.AnrRate            as imp_pct
          ,a1.AnrGlobalRate      as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_version_device_anr    as a1
      left join dim.dim_pub_code_mapping_dict               as a2
        on a2.app_plat = 'beidou'
       and a2.cd_col = 'product_id'
       and a1.ProductId = a2.cd_val
     where a1.AnrTime = '${bf_1_dt}'
       and a1.ProductId in (3366,3388,3333,3322,3311,3371,3399,3501,3511,6833)
)
select coalesce(a1.dt,a2.dt)                      as dt                  -- 日期
      ,coalesce(a1.biz_type_cd,a2.biz_type_cd)    as biz_type_cd         -- 业务类型编码
      ,coalesce(a1.product_id,a2.product_id)      as product_id          -- product_id
      ,coalesce(a1.core,a2.core)                  as core                -- core
      ,coalesce(a1.dev_mdl,a2.dev_mdl)            as dev_mdl             -- 设备型号
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
  from mdl_anr                                    as a1
  full join mdl_dau_ad                            as a2
    on a1.dt = a2.dt
   and a1.biz_type_cd = a2.biz_type_cd
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
  left join dim.dim_pub_code_mapping_dict         as a3
    on a3.app_plat = 'beidou'
   and a3.cd_col = 'biz_type_cd'
   and coalesce(a1.biz_type_cd,a2.biz_type_cd) = a3.cd_val
  left join dim.dim_pub_code_mapping_dict         as a4
    on a4.app_plat = 'pub'
   and a4.cd_col = 'product_id'
   and coalesce(a1.product_id,a2.product_id) = a4.cd_val
 where coalesce(a1.core,a2.core) is not null
;

-- 前10日
insert into ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval
with mdl_anr as (
    select date(a1.AnrTime)      as dt
          ,a2.p_cd_val           as biz_type_cd
          ,a1.ProductId          as product_id
          ,a1.Core               as core
          ,split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1) as mfr
          ,substr(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1)
                 ,length(split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)) + 2
                 )               as dev_mdl
          ,date(a1.AnrTime)      as anr_ocr_dt
          ,date(a1.StartTime)    as anr_fch_dt
          ,a1.DeviceGuid         as dev_guid
          ,a1.AnrCount           as imp_num
          ,a1.SessionCount       as sess_num
          ,a1.AnrRate            as imp_pct
          ,a1.AnrGlobalRate      as hist_anr_usr_rat
      from ods.ods_tidb_qadata_gp_app_version_device_anr    as a1
      left join dim.dim_pub_code_mapping_dict               as a2
        on a2.app_plat = 'beidou'
       and a2.cd_col = 'product_id'
       and a1.ProductId = a2.cd_val
     where a1.AnrTime >= date_sub('${bf_1_dt}', interval 10 day)
       and a1.AnrTime < '${bf_1_dt}'
       and a1.ProductId in (3366,3388,3333,3322,3311,3371,3399,3501,3511,6833)
)
select a1.dt                  -- 日期
      ,a1.biz_type_cd         -- 业务类型编码
      ,a1.product_id          -- product_id
      ,a1.core                -- core
      ,a1.dev_mdl             -- 设备型号
      ,a1.biz_type_name       -- 业务类型名称
      ,a1.prd_name            -- 产品名称
      ,a1.mfr                 -- 厂商
      ,a1.anr_ocr_dt          -- ANR发生日期
      ,a1.anr_fch_dt          -- ANR抓取日期
      ,a1.dev_guid            -- 设备GUID
      ,a1.imp_num             -- 影响数
      ,a1.sess_num            -- 会话数
      ,a1.imp_pct             -- 受影响占比
      ,a1.hist_anr_usr_rat    -- 历史ANR用户比例
      ,a2.svr_dau             -- 服务端日活
      ,a2.ad_uv               -- 广告uv
      ,a2.ad_ttl_amt          -- 广告总收入
      ,a2.ad_rpc              -- 广告人均单价
      ,a2.web_ad_amt          -- web广告收入
      ,a2.web_rpc             -- web广告人均单价
      ,a2.med_sdk_ad_amt      -- 聚合SDK广告收入
      ,a2.med_sdk_rpc         -- 聚合SDK广告人均单价
  from mdl_anr    as a1
  left join ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval    as a2
    on a2.dt >= date_sub('${bf_1_dt}', interval 10 day)
   and a2.dt < '${bf_1_dt}'
   and a1.dt = a2.dt
   and a1.biz_type_cd = a2.biz_type_cd
   and a1.product_id = a2.product_id
   and a1.core = a2.core
   and a1.dev_mdl = a2.dev_mdl
;