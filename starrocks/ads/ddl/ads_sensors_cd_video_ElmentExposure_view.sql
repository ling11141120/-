create or replace view ads.ads_sensors_cd_video_ElmentExposure_view (
     dt                    comment "日期"
    ,id                    comment "主键"
    ,rid                   comment "记录ID"
    ,track_id              comment "track_id"
    ,event                 comment "事件"
    ,event_tm              comment "事件时间"
    ,app_channel           comment "渠道编号"
    ,app_id                comment "app_id"
    ,app_lang_id           comment "界面语言"
    ,device_lang           comment "设备语言"
    ,login_id              comment "用户ID"
    ,product_id            comment "产品ID"
    ,app_version           comment "应用版本"
    ,os                    comment "操作系统"
    ,ip                    comment "IP"
    ,city                  comment "城市"
    ,province              comment "省份"
    ,country               comment "国家"
    ,lib                   comment "lib"
    ,page_name             comment "页面名称"
    ,element_id            comment "控件ID"
    ,element_name          comment "控件名称"
    ,shortplay_id          comment "短剧ID（仅在视频播放页上报）"
    ,episode_id            comment "剧集ID（仅在视频播放页上报）"
    ,watch_episode_sort    comment "内容页剧集ID序号（仅在视频播放页上报）"
    ,button_status         comment "按钮状态（例如：开/关，适用于点赞、追剧等开关状态的按钮）"
    ,element_content       comment "元素内容（适用于类似倍速控件、选集控件等带有数值信息的控件或特殊对象时记录曝光/点击元素的内容）"
    ,project_id            comment "5阅读 8 短剧"
    ,zffs_list             comment "支付方式列表"
    ,sfzf_strategy_id      comment "三方支付策略id"
    ,element_index         comment "元素位序"
    ,activity_id           comment "活动ID"
    ,group_id              comment "分组ID"
    ,page_id               comment "页面id"
    ,first_tag_list        comment "一级标签列表"
    ,second_tag_list       comment "二级标签列表"
    ,third_tag_list        comment "三级标签列表"
    ,app_core_ver          comment "core"
    ,anonymous_id          comment "匿名ID"
    ,etl_tm                comment "清洗时间"
    ,element_type          comment "控件类型"
    ,push_type             comment "推送类型"
)
comment "event=elementExposure 控件曝光事件"
as
select a1.dt                    as dt                    -- 日期
      ,a1.id                    as id                    -- 主键
      ,a1.rid                   as rid                   -- 记录ID
      ,a1.track_id              as track_id              -- track_id
      ,a1.event                 as event                 -- 事件
      ,a1.event_tm              as event_tm              -- 事件时间
      ,a1.app_channel           as app_channel           -- 渠道编号
      ,a1.app_id                as app_id                -- app_id
      ,a1.app_lang_id           as app_lang_id           -- 界面语言
      ,a1.device_lang           as device_lang           -- 设备语言
      ,a1.login_id              as login_id              -- 用户ID
      ,a1.product_id            as product_id            -- 产品ID
      ,a1.app_version           as app_version           -- 应用版本
      ,a1.os                    as os                    -- 操作系统
      ,a1.ip                    as ip                    -- IP
      ,a1.city                  as city                  -- 城市
      ,a1.province              as province              -- 省份
      ,a1.country               as country               -- 国家
      ,a1.lib                   as lib                   -- lib
      ,a1.page_name             as page_name             -- 页面名称
      ,a1.element_id            as element_id            -- 控件ID
      ,a1.element_name          as element_name          -- 控件名称
      ,a1.shortplay_id          as shortplay_id          -- 短剧ID（仅在视频播放页上报）
      ,a1.episode_id            as episode_id            -- 剧集ID（仅在视频播放页上报）
      ,a1.watch_episode_sort    as watch_episode_sort    -- 内容页剧集ID序号（仅在视频播放页上报）
      ,a1.button_status         as button_status         -- 按钮状态（例如：开/关，适用于点赞、追剧等开关状态的按钮）
      ,a1.element_content       as element_content       -- 元素内容（适用于类似倍速控件、选集控件等带有数值信息的控件或特殊对象时记录曝光/点击元素的内容）
      ,a1.project_id            as project_id            -- 项目ID（例如：5阅读、8短剧等）
      ,a1.zffs_list             as zffs_list             -- 支付方式列表
      ,a1.sfzf_strategy_id      as sfzf_strategy_id      -- 三方支付策略ID
      ,a1.element_index         as element_index         -- 元素位序
      ,a1.activity_id           as activity_id           -- 活动ID
      ,a1.group_id              as group_id              -- 分组ID
      ,a1.page_id               as page_id               -- 页面ID（例如：视频播放页、短剧播放页等）
      ,a1.first_tag_list        as first_tag_list        -- 一级标签列表
      ,a1.second_tag_list       as second_tag_list       -- 二级标签列表
      ,a1.third_tag_list        as third_tag_list        -- 三级标签列表
      ,a1.app_core_ver          as app_core_ver          -- 应用核心版本
      ,a1.anonymous_id          as anonymous_id          -- 匿名ID
      ,a1.etl_tm                as etl_tm                -- 清洗时间
      ,a1.element_type          as element_type          -- 控件类型
      ,a1.push_type             as push_type             -- 推送类型
  from ods_log.ods_sensors_cd_video_ElmentExposure    as a1
;