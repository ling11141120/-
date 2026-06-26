create or replace view ads.ads_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour (
     dt                 comment "分区日期，西五区date_start"
    ,id                 comment "主键"
    ,client_key         comment "tiktok oauth client_key"
    ,core               comment "core数值"
    ,core_name          comment "core展示名称"
    ,minis_name         comment "小程序名称"
    ,product_id         comment "产品id"
    ,date_start         comment "西五区小时开始时间"
    ,date_start_est8    comment "东八区小时开始时间"
    ,dt_start_est8      comment "东八区小时开始日期"
    ,date_stop          comment "西五区小时结束时间"
    ,date_stop_est8     comment "东八区小时结束时间"
    ,dt_stop_est8       comment "东八区小时结束日期"
    ,ads_click          comment "ads_click.value"
    ,ads_click_rate     comment "ads_click_rate.value"
    ,ads_exposure       comment "ads_exposure.value"
    ,ads_request        comment "ads_request.value"
    ,ecpm               comment "ecpm.value"
    ,iaa_revenue        comment "iaa_revenue.value"
    ,create_time        comment "创建时间"
    ,update_time        comment "更新时间"
)
comment "TikTok小程序/小游戏IAA小时数据"
as
select a1.dt            as dt                -- 分区日期，西五区date_start
      ,a1.id            as id                -- 主键
      ,a1.clientkey     as client_key        -- tiktok oauth client_key
      ,a1.core          as core              -- core数值
      ,a1.corename      as core_name         -- core展示名称
      ,a1.minisname     as minis_name        -- 小程序名称
      ,a1.productid     as product_id        -- 产品id
      ,a1.date_start    as date_start        -- 小时开始时间
      ,date_add(a1.date_start, interval 13 hour)
                        as date_start_est8   -- 东八区小时开始时间
      ,date(date_add(a1.date_start, interval 13 hour))
                        as dt_start_est8     -- 东八区小时开始日期
      ,a1.date_stop     as date_stop         -- 小时结束时间
      ,date_add(a1.date_stop, interval 13 hour)
                        as date_stop_est8    -- 东八区小时结束时间
      ,date(date_add(a1.date_stop, interval 13 hour))
                        as dt_stop_est8      -- 东八区小时结束日期
      ,a1.adsclick      as ads_click         -- ads_click.value
      ,a1.adsclickrate  as ads_click_rate    -- ads_click_rate.value
      ,a1.adsexposure   as ads_exposure      -- ads_exposure.value
      ,a1.adsrequest    as ads_request       -- ads_request.value
      ,a1.ecpm          as ecpm              -- ecpm.value
      ,a1.iaarevenue    as iaa_revenue       -- iaa_revenue.value
      ,a1.createtime    as create_time       -- 创建时间
      ,a1.updatetime    as update_time       -- 更新时间
  from ods.ods_tidb_sharpengine_ads_global_tiktokminisiaadailyinsightbyhour as a1
;
