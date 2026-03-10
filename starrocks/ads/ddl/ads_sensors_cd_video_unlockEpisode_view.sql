create or replace view ads.ads_sensors_cd_video_unlockEpisode_view (
     dt               comment "日期"
    ,id               comment "主键"
    ,rid              comment "记录ID"
    ,track_id         comment "track_id"
    ,event            comment "事件"
    ,event_tm         comment "事件时间"
    ,app_channel      comment "渠道编号"
    ,app_id           comment "app_id"
    ,app_lang_id      comment "界面语言"
    ,device_lang      comment "设备语言"
    ,login_id         comment "用户ID"
    ,product_id       comment "产品ID"
    ,send_id          comment "产品ID"
    ,app_version      comment "应用版本"
    ,os               comment "操作系统"
    ,ip               comment "IP"
    ,city             comment "城市"
    ,province         comment "省份"
    ,country          comment "国家"
    ,lib              comment "lib"
    ,shortplay_id     comment "短剧ID"
    ,episode_id       comment "剧集ID"
    ,coin_consume     comment "消耗充值货币"
    ,gift_consume     comment "消耗赠送货币"
    ,current_coin     comment "当前账户付费货币余额"
    ,current_gift     comment "当前账户免费货币余额"
    ,unlock_type      comment "解锁类型"
    ,project_id       comment "5阅读 8 短剧"
    ,activity_link    comment "活动链路"
    ,etl_tm           comment "清洗时间"
)
comment "event=unlockEpisode 解锁剧集事件"
as
select a.dt               as dt               -- 日期
     , a.id               as id               -- 主键
     , a.rid              as rid              -- 记录ID
     , a.track_id         as track_id         -- track_id
     , a.event            as event            -- 事件
     , a.event_tm         as event_tm         -- 事件时间
     , a.app_channel      as app_channel      -- 渠道编号
     , a.app_id           as app_id           -- app_id
     , a.app_lang_id      as app_lang_id      -- 界面语言
     , a.device_lang      as device_lang      -- 设备语言
     , a.login_id         as login_id         -- 用户ID
     , a.product_id       as product_id       -- 产品ID
     , a.send_id          as send_id          -- 产品ID
     , a.app_version      as app_version      -- 应用版本
     , a.os               as os               -- 操作系统
     , a.ip               as ip               -- IP
     , a.city             as city             -- 城市
     , a.province         as province         -- 省份
     , a.country          as country          -- 国家
     , a.lib              as lib              -- lib
     , a.shortplay_id     as shortplay_id     -- 短剧ID
     , a.episode_id       as episode_id       -- 剧集ID
     , a.coin_consume     as coin_consume     -- 消耗充值货币
     , a.gift_consume     as gift_consume     -- 消耗赠送货币
     , a.current_coin     as current_coin     -- 当前账户付费货币余额
     , a.current_gift     as current_gift     -- 当前账户免费货币余额
     , a.unlock_type      as unlock_type      -- 解锁类型
     , a.project_id       as project_id       -- 5阅读 8 短剧
     , a.activity_link    as activity_link    -- 活动链路
     , a.etl_tm           as etl_tm           -- 清洗时间
  from ods_log.ods_sensors_cd_video_unlockEpisode as a
;