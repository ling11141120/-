create or replace view ads.ads_sensors_cd_video_itemexposure_view (
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
    ,core                  comment "core版本，目前有1，2，3"
    ,current_language2     comment "注册时语言"
    ,ip                    comment "IP"
    ,city                  comment "城市"
    ,province              comment "省份"
    ,country               comment "国家"
    ,lib                   comment "lib"
    ,page_id               comment "页面ID"
    ,page_name             comment "页面名称"
    ,element_id            comment "控件ID，当页面有下钻控件时上报，目前包括：榜单集合、浏览历史、我的追剧"
    ,element_name          comment "控件名称，当页面有下钻控件时上报，目前包括：榜单集合、浏览历史、我的追剧"
    ,element_type          comment "控件类型，只有运营位为控件或特殊对象时记录，例如：普通弹窗、底部弹窗等"
    ,shortplay_id          comment "整部短剧的ID"
    ,is_shortplayshelf     comment "若短剧已主动加入追剧页面记录为\" 1-是\"，不在为\" 0-否\""
    ,channel_id            comment "频道id，在首页里不同频道分页id"
    ,channel_id1           comment "新频道id"
    ,channel_name          comment "频道名称，在首页里不同频道分页名称：找剧 /发现/Discover"
    ,list_id               comment "榜单id，从后台获取榜单id，暂时没有"
    ,list_id1              comment "新榜单id"
    ,send_id               comment "转换来源"
    ,list_style            comment "榜单样式，从后台获取榜单id的“榜单样式”"
    ,list_name             comment "榜单名称，如：热门短剧/主编力荐/人气排行/新剧上线/完结精选（回传榜单的title）"
    ,list_index            comment "榜单位序，用户看到的榜单信息中的位序，比如榜单第三个，就是3"
    ,activity_id           comment "活动id"
    ,event_strategy_id     comment "策略id"
    ,group_id              comment "用户分组id"
    ,keyword               comment "搜索词，在搜索结果页面上报"
    ,search_mode           comment "{1：主动搜索，2：猜你想搜，3：历史搜索} 根据上次搜索方式上报，搜索结果页面上报"
    ,search_hit_type       comment "{1：短剧标题、2：短剧描述、3：短剧标签、4：短剧字幕} 搜索结果页面上报"
    ,project_id            comment "5阅读 8 短剧"
    ,label_type            comment "角标类型"
    ,list_class            comment "榜单分类"
    ,etl_tm                comment "清洗时间"
)
comment "event=itemExposure 短剧 曝光事件"
as
select a1.dt                                      as dt                             -- 日期
      ,a1.id                                      as id                             -- 主键
      ,a1.rid                                     as rid                            -- 记录ID
      ,a1.track_id                                as track_id                       -- track_id
      ,a1.event                                   as event                          -- 事件
      ,a1.event_tm                                as event_tm                       -- 事件时间
      ,a1.app_channel                             as app_channel                    -- 渠道编号
      ,a1.app_id                                  as app_id                         -- app_id
      ,a1.app_lang_id                             as app_lang_id                    -- 界面语言
      ,a1.device_lang                             as device_lang                    -- 设备语言
      ,a1.login_id                                as login_id                       -- 用户ID
      ,a1.product_id                              as product_id                     -- 产品ID
      ,a1.app_version                             as app_version                    -- 应用版本
      ,a1.os                                      as os                             -- 操作系统
      ,cast(substring(a1.app_id, 4, 3) as int)    as core                           -- core版本，目前有1，2，3
      ,a2.CurrentLanguage2                        as current_language2              -- 注册时语言
      ,a1.ip                                      as ip                             -- IP
      ,a1.city                                    as city                           -- 城市
      ,a1.province                                as province                       -- 省份
      ,a1.country                                 as country                        -- 国家
      ,a1.lib                                     as lib                            -- lib
      ,a1.page_id                                 as page_id                        -- 页面ID
      ,a1.page_name                               as page_name                      -- 页面名称
      ,a1.element_id                              as element_id                     -- 控件ID，当页面有下钻控件时上报，目前包括：榜单集合、浏览历史、我的追剧
      ,a1.element_name                            as element_name                   -- 控件名称，当页面有下钻控件时上报，目前包括：榜单集合、浏览历史、我的追剧
      ,a1.element_type                            as element_type                   -- 控件类型，只有运营位为控件或特殊对象时记录，例如：普通弹窗、底部弹窗等
      ,a1.shortplay_id                            as shortplay_id                   -- 整部短剧的ID
      ,a1.is_shortplayshelf                       as is_shortplayshelf              -- 若短剧已主动加入追剧页面记录为" 1-是"，不在为" 0-否"
      ,a1.channel_id                              as channel_id                     -- 频道id，在首页里不同频道分页id
      ,a1.channel_id1                             as channel_id1                    -- 新频道id
      ,a1.channel_name                            as channel_name                   -- 频道名称，在首页里不同频道分页名称：找剧 /发现/Discover
      ,a1.list_id                                 as list_id                        -- 榜单id，从后台获取榜单id，暂时没有
      ,a1.list_id1                                as list_id1                       -- 新榜单id
      ,a1.send_id                                 as send_id                        -- 转换来源
      ,a1.list_style                              as list_style                     -- 榜单样式，从后台获取榜单id的“榜单样式”
      ,a1.list_name                               as list_name                      -- 榜单名称，如：热门短剧/主编力荐/人气排行/新剧上线/完结精选（回传榜单的title）
      ,a1.list_index                              as list_index                     -- 榜单位序，用户看到的榜单信息中的位序，比如榜单第三个，就是3
      ,a1.activity_id                             as activity_id                    -- 活动id
      ,a1.event_strategy_id                       as event_strategy_id              -- 策略id
      ,a1.group_id                                as group_id                       -- 用户分组id
      ,a1.keyword                                 as keyword                        -- 搜索词，在搜索结果页面上报
      ,a1.search_mode                             as search_mode                    -- {1：主动搜索，2：猜你想搜，3：历史搜索} 根据上次搜索方式上报，搜索结果页面上报
      ,a1.search_hit_type                         as search_hit_type                -- {1：短剧标题、2：短剧描述、3：短剧标签、4：短剧字幕} 搜索结果页面上报
      ,a1.project_id                              as project_id                     -- 5阅读 8 短剧
      ,a1.label_type                              as label_type                     -- 角标类型
      ,a1.list_class                              as list_class                     -- 榜单分类
      ,a1.etl_tm                                  as etl_tm                         -- 清洗时间
  from ods_log.ods_sensors_cd_video_production_itemexposure    as a1
  left join ods.ods_tidb_short_video_accountinfo               as a2
    on a1.login_id = a2.Id
 where a1.project_id = '8'
;