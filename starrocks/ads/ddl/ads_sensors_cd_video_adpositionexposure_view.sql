create or replace view ads.ads_sensors_cd_video_adpositionexposure_view (
     dt                   comment "分区日期"
    ,id                   comment "nvl(rid,track_id)"
    ,track_id             comment "跟踪id"
    ,rid                  comment "记录ID"
    ,event_tm             comment "事件时间"
    ,device_id            comment "设备id"
    ,login_id             comment "登录id"
    ,product_id           comment "产品ID"
    ,identity_login_id    comment "identity_login_id"
    ,device_lang          comment "设备语言"
    ,event                comment "事件"
    ,distinct_id          comment "去重id"
    ,identity_user_id     comment "用户验证id"
    ,app_product_id       comment "包体ID"
    ,send_id              comment "转化来源"
    ,core                 comment "core"
    ,app_channel          comment "渠道编号"
    ,app_product_x        comment "应用程序ID"
    ,app_lang_id          comment "界面语言"
    ,lib_version          comment "lib版本"
    ,app_version          comment "app版本"
    ,page_id              comment "页面ID"
    ,page_name            comment "页面名称"
    ,ad_position_id       comment "广告位ID"
    ,ad_position_id1      comment "广告位ID_new"
    ,app_id               comment "app_id"
    ,os                   comment "操作系统"
    ,ip                   comment "IP"
    ,city                 comment "城市"
    ,ad_type              comment "广告类型"
    ,element_id           comment "控件ID"
    ,element_name         comment "控件名称"
    ,element_type         comment "控件类型"
    ,current_language2    comment "当前语言"
    ,ad_strategy_id       comment "广告策略ID"
    ,ad_group_id          comment "广告人群包ID"
    ,event_strategy_id    comment "策略ID"
    ,main_strategy_id     comment "主策略ID"
    ,ad_src               comment "广告来源"
) 
comment "event=ADPositionExposure 资源位曝光"
as 
select
     a1.dt                   as dt                   -- 分区日期
    ,a1.id                   as id                   -- nvl(rid,track_id)
    ,a1.track_id             as track_id             -- 跟踪id
    ,a1.rid                  as rid                  -- 记录ID
    ,a1.event_tm             as event_tm             -- 事件时间
    ,a1.device_id            as device_id            -- 设备id
    ,a1.login_id             as login_id             -- 登录id
    ,6833                    as product_id           -- 产品ID
    ,a1.identity_login_id    as identity_login_id    -- 登录验证id
    ,a1.device_lang          as device_lang          -- 设备语言
    ,a1.event                as event                -- 事件
    ,a1.distinct_id          as distinct_id          -- 去重id
    ,a1.identity_user_id     as identity_user_id     -- 用户验证id
    ,a1.app_product_id       as app_product_id       -- 包体ID
    ,a1.send_id              as send_id              -- 转化来源
    ,case when (length(a1.app_id) = 9) then substring(a1.app_id, 6, 1)
          when (a1.app_id is null) then ''
          else a1.app_id
      end                    as core                 -- core
    ,a1.app_channel          as app_channel          -- 渠道编号
    ,a1.app_product_x        as app_product_x        -- 应用程序ID
    ,a1.app_lang_id          as app_lang_id          -- 界面语言
    ,a1.lib_version          as lib_version          -- lib版本
    ,a1.app_version          as app_version          -- app版本
    ,a1.page_id              as page_id              -- 页面ID
    ,a1.page_name            as page_name            -- 页面名称
    ,a1.ad_position_id       as ad_position_id       -- 广告位ID
    ,a1.ad_position_id1      as ad_position_id1      -- 广告位ID_new
    ,a1.app_id               as app_id               -- app_id
    ,a1.os                   as os                   -- 操作系统
    ,a1.ip                   as ip                   -- IP
    ,a1.city                 as city                 -- 城市
    ,a1.ad_type              as ad_type              -- 广告类型
    ,a1.element_id           as element_id           -- 控件ID
    ,a1.element_name         as element_name         -- 控件名称
    ,a1.element_type         as element_type         -- 控件类型
    ,a2.current_language2    as current_language2    -- 当前语言
    ,a1.ad_strategy_id       as ad_strategy_id       -- 广告策略ID
    ,a1.ad_group_id          as ad_group_id          -- 广告人群包ID
    ,a1.event_strategy_id    as event_strategy_id    -- 策略ID
    ,a1.main_strategy_id     as main_strategy_id     -- 主策略ID
    ,a1.ad_source            as ad_src               -- 广告来源
  from ods_log.ods_sensors_production_adpositionexposure    as a1
  left join dim.dim_short_video_user_accountinfo    as a2
    on a1.login_id = a2.user_id
 where a1.project_id = 8
;