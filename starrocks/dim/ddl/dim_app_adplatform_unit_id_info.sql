drop table if exists dim.dim_app_adplatform_unit_id_info;
create table dim.dim_app_adplatform_unit_id_info (
     unit_adid          string            comment "广告单元id"
    ,id                 int(11)  not null comment "主键"
    ,attribute          int(11)  not null comment "属性(0通用,1降权)"
    ,core               int(11)  not null comment "core(1core1,2core2,3core3,4core4)"
    ,mt                 int(11)  not null comment "平台(1ios,4android)"
    ,applang_id         int(11)  not null comment "app语言id(1简体,2繁体,3英语,4西语,5葡语,6法语,8俄语,9日语,11印尼语,12泰语)"
    ,product_id         int(11)  not null comment "产品id"
    ,ad_show_type       int(11)  not null comment "广告类型(1banner,2原生广告,3激励视频,4开屏广告,6插屏广告)"
    ,ad_position        int(11)  not null comment "广告位置(8阅读页底部横幅,22阅读页弹窗激励视频任务,23每日任务领取奖励,35积分排行榜,26福利中心首页激励视频,18半屏(n个激励视频),9章节末,17阅读页插页广告,15书架,44福利中心补签视频,33邀请活动,5积分大厅激励任务,30积分中心-吃饭,29积分中心-宝箱,19签到弹窗-额外签到奖励,21书架激励视频任务,16开屏,52限免卡-半屏banner,53限免卡-弹窗,54限免卡-阅读器返回推,50限免卡首页激励视频,51限免卡砍价激励视频,37种树游戏激励视频,27积分抽奖激励视频,28积分挖宝激励视频,24拼图活动激励视频,42打赏弹层激励视频,41打赏活动激励视频,34邀请码,38手速游戏激励视频,)"
    ,ad_plat_form       int(11)  not null comment "广告平台(1admob激励广告,100华为激励广告,101google adsense展示广告,20tradplus聚合广告,102xh-ad广告,103topon聚合平台,104max聚合平台)"
    ,scene_id           string            comment "广告场景id"
    ,jgroup_ids         string            comment "极光人群包"
    ,exclude_jgroup_ids string            comment "剔除极光人群包"
    ,minver             int(11)  not null comment "最小服务端版本号"
    ,maxver             int(11)  not null comment "最大服务端版本号"
    ,is_shield_author   int(11)  not null comment "是否屏蔽作者(0否,1是)"
    ,sort               int(11)  not null comment "排序"
    ,status             int(11)  not null comment "状态(0关闭,1开启)"
    ,create_tm          datetime not null comment "创建时间"
    ,update_tm          datetime not null comment "更新时间"
    ,etl_tm             datetime not null comment "etl清洗时间"
)
duplicate key (unit_adid)
comment "app内各广告平台的广告单元id信息表"
distributed by hash (unit_adid) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;