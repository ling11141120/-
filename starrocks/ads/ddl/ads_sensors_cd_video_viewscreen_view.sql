create or replace view ads.ads_sensors_cd_video_viewscreen_view(
     dt                       comment "分区日期"
    ,id                       comment "主键"
    ,rid                      comment "记录ID"
    ,track_id                 comment "track_id"
    ,event                    comment "事件"
    ,event_tm                 comment "事件时间"
    ,app_channel              comment "渠道编号"
    ,app_id                   comment "app_id"
    ,app_lang_id              comment "界面语言"
    ,device_lang              comment "设备语言"
    ,login_id                 comment "用户ID"
    ,product_id               comment "产品ID"
    ,app_version              comment "应用版本"
    ,os                       comment "操作系统"
    ,ip                       comment "IP"
    ,city                     comment "城市"
    ,province                 comment "省份"
    ,country                  comment "国家"
    ,lib                      comment "lib"
    ,page_id                  comment "页面ID"
    ,page_name                comment "页面名称"
    ,project_id               comment "5阅读 8 短剧"
    ,etl_tm                   comment "清洗时间"
    ,dollar_url               comment "$url"
)
comment "event=viewscreen 页面曝光 "
as
select dt             as dt             -- 分区日期
      ,id             as id             -- 主键
      ,rid            as rid            -- 记录ID
      ,track_id       as track_id       -- track_id
      ,event          as event          -- 事件
      ,event_tm       as event_tm       -- 事件时间
      ,app_channel    as app_channel    -- 渠道编号
      ,app_id         as app_id         -- app_id
      ,app_lang_id    as app_lang_id    -- 界面语言
      ,device_lang    as device_lang    -- 设备语言
      ,login_id       as login_id       -- 用户ID
      ,product_id     as product_id     -- 产品ID
      ,app_version    as app_version    -- 应用版本
      ,os             as os             -- 操作系统
      ,ip             as ip             -- IP
      ,city           as city           -- 城市
      ,province       as province       -- 省份
      ,country        as country        -- 国家
      ,lib            as lib            -- lib
      ,page_id        as page_id        -- 页面ID
      ,page_name      as page_name      -- 页面名称
      ,project_id     as project_id     -- 5阅读 8 短剧
      ,etl_tm         as etl_tm         -- 清洗时间
      ,dollar_url     as dollar_url     -- $url
  from ods_log.ods_sensors_cd_video_viewscreen    as a1
;