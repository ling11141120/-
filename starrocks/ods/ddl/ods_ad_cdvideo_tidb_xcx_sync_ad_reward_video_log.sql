----------------------------------------------------------------
-- 目标表： ods.ods_ad_cdvideo_tidb_xcx_sync_ad_reward_video_log
-- 来源实例： 
-- 来源表： 
-- 来源负责人： 
-- 开发人： qhr
-- 开发日期： 2026-04-21
----------------------------------------------------------------

drop table if exists ods.ods_ad_cdvideo_tidb_xcx_sync_ad_reward_video_log;
create table ods.ods_ad_cdvideo_tidb_xcx_sync_ad_reward_video_log (
     Id                bigint          not null  comment "自增ID"
    ,_id               varchar(200)    not null  comment "原表主键_id"
    ,ad_unit_id        varchar(200)              comment "平台广告资源位id"
    ,position_id       int                       comment "1-播放页 2-福利中心页"
    ,bonus_amount      int                       comment "奖励赠豆数量"
    ,user_id           varchar(200)              comment "用户id"
    ,tv_id             varchar(200)              comment "剧目id"
    ,appid             varchar(200)              comment "小程序id"
    ,series            int                       comment "当前第几集"
    ,series_id         varchar(200)              comment "剧集id"
    ,status            int                       comment "状态：1-开始播放 2-播放完毕"
    ,return_status     int                       comment "回传结果：-1 回传失败 2回传成功"
    ,pay_id            varchar(200)              comment "关联的解锁剧集记录Id"
    ,platform          varchar(200)              comment "激励视频广告平台：mp-toutiao 抖音,mp-weixin 微信"
    ,tfid              varchar(1000)             comment "投放链接ID"
    ,invite_code       varchar(1000)             comment "代理商id"
    ,middleman_id      varchar(1000)             comment "机构id"
    ,promotion_id      varchar(1000)             comment "广告计划ID"
    ,project_id        varchar(1000)             comment "广告项目ID"
    ,aid               varchar(1000)             comment "广告信息"
    ,cid               varchar(1000)             comment "广告信息"
    ,ad_id             varchar(1000)             comment "广告信息"
    ,clickid           varchar(1000)             comment "点击id"
    ,clue_token        varchar(1000)             comment "clue_token"
    ,user_active_time  datetime                  comment "用户激活时间"
    ,ecpm_time         datetime                  comment "获取ecpm的时间"
    ,ecpm              bigint                    comment "根据ecpm接口返回的cost，进行格式化的数据"
    ,ad_cost           varchar(1000)             comment "广告消耗，单位为：十万分之一元"
    ,ad_event_time     datetime                  comment "广告计费发生时间戳，单位秒"
    ,ad_type           varchar(1000)             comment "小程序广告类型"
    ,_add_time         datetime                  comment "添加时间"
    ,_update_time      datetime                  comment "更新时间"
    ,sync_update_time  datetime                  comment "数据更新时间戳"
    ,sr_createtime     datetime                  comment ""
    ,sr_updatetime     datetime                  comment ""
)
primary key(Id)
comment "广告激励视频播放记录,author:510161"
distributed by hash(Id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;