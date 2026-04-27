create or replace view dwd.dwd_sensors_cd_video_elmentclick_view (
     dt                 comment "分区日期"
    ,id                 comment "主键"
    ,rid                comment "记录ID"
    ,track_id           comment "track_id"
    ,event              comment "事件"
    ,event_tm           comment "事件时间"
    ,app_channel        comment "渠道编号"
    ,app_id             comment "app_id"
    ,core               comment "core"
    ,mt                 comment "mt"
    ,app_lang_id        comment "界面语言"
    ,device_lang        comment "设备语言"
    ,user_id            comment "用户ID"
    ,product_id         comment "产品ID"
    ,app_version        comment "应用版本"
    ,os                 comment "操作系统"
    ,ip                 comment "IP"
    ,city               comment "城市"
    ,province           comment "省份"
    ,country            comment "国家"
    ,lib                comment "lib"
    ,page_id            comment "页面ID"
    ,page_name          comment "页面名称"
    ,element_id         comment "控件ID"
    ,element_name       comment "控件名称"
    ,first_tag          comment "一级标签"
    ,second_tag         comment "二级标签"
    ,third_tag          comment "三级标签"
    ,element_type       comment "控件类型"
    ,shortplay_id       comment "短剧ID"
    ,episode_id         comment "剧集ID"
    ,watch_episode_sort comment "内容页剧集ID序号"
    ,button_status      comment "按钮状态"
    ,element_content    comment "元素内容"
    ,project_id         comment "5阅读 8 短剧"
    ,ad_src             comment "广告来源"
    ,etl_tm             comment "清洗时间"
)
comment "event=elementClick 控件点击事件"
as
select a1.dt                                        as dt                 -- 分区日期
      ,a1.id                                        as id                 -- 主键
      ,a1.rid                                       as rid                -- 记录ID
      ,a1.track_id                                  as track_id           -- track_id
      ,a1.event                                     as event              -- 事件
      ,a1.event_tm                                  as event_tm           -- 事件时间
      ,a1.app_channel                               as app_channel        -- 渠道编号
      ,a1.app_id                                    as app_id             -- app_id
      ,CAST((substring(a1.app_id, 4, 3)) as int)    as core               -- core
      ,lib                                          as mt                 -- mt
      ,a1.app_lang_id                               as app_lang_id        -- 界面语言
      ,a1.device_lang                               as device_lang        -- 设备语言
      ,a1.login_id                                  as login_id           -- 用户ID
      ,a1.product_id                                as product_id         -- 产品ID
      ,a1.app_version                               as app_version        -- 应用版本
      ,a1.os                                        as os                 -- 操作系统
      ,a1.ip                                        as ip                 -- IP
      ,a1.city                                      as city               -- 城市
      ,a1.province                                  as province           -- 省份
      ,a1.country                                   as country            -- 国家
      ,a1.lib                                       as lib                -- lib
      ,a1.page_id                                   as page_id            -- 页面ID
      ,a1.page_name                                 as page_name          -- 页面名称
      ,a1.element_id                                as element_id         -- 控件ID
      ,a1.element_name                              as element_name       -- 控件名称
      ,a1.first_tag                                 as first_tag          -- 一级标签
      ,a1.second_tag                                as second_tag         -- 二级标签
      ,a1.third_tag                                 as third_tag          -- 三级标签
      ,a1.element_type                              as element_type       -- 控件类型
      ,a1.shortplay_id                              as shortplay_id       -- 短剧ID
      ,a1.episode_id                                as episode_id         -- 剧集ID
      ,a1.watch_episode_sort                        as watch_episode_sort -- 内容页剧集ID序号
      ,a1.button_status                             as button_status      -- 按钮状态
      ,a1.element_content                           as element_content    -- 元素内容
      ,a1.project_id                                as project_id         -- 5阅读 8 短剧
      ,if(element_type='123' and element_id='210063'
         ,'10'
         ,null
         )                                          as ad_src             -- 广告来源
      ,a1.etl_tm                                    as etl_tm             -- 清洗时间
  from ods_log.ods_sensors_cd_video_elmentclick    as a1
;
