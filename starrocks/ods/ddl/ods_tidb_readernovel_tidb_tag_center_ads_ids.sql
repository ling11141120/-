----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_ads_ids
-- 来源实例： old_tidb_source
-- 来源表： readernovel_tidb_tag.center_ads_ids
-- 采集工具： 极光-定时批量
-- 开发人： 
-- 开发日期： 2024-02-22
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_tag_center_ads_ids;
CREATE TABLE ods.ods_tidb_readernovel_tidb_tag_center_ads_ids (
     Id               INT(11)          NOT NULL                  COMMENT "主键"
    ,Attribute        INT(11)          NOT NULL                  COMMENT "属性(0通用,1降权)"
    ,Core             INT(11)          NOT NULL                  COMMENT "Core(1core1,2core2,3core3,4core4)"
    ,Mt               INT(11)          NOT NULL                  COMMENT "平台(1iOS,4Android)"
    ,AppLangId        INT(11)          NOT NULL                  COMMENT "App语言Id(1简体,2繁体,3英语,4西语,5葡语,6法语,8俄语,9日语,11印尼语,12泰语)"
    ,AdShowType       INT(11)          NOT NULL                  COMMENT "广告类型(1banner,2原生广告,3激励视频,4开屏广告,6插屏广告)"
    ,AdPosition       INT(11)          NOT NULL                  COMMENT "广告位置(8阅读页底部横幅,22阅读页弹窗激励视频任务,23每日任务领取奖励,35积分排行榜,26福利中心首页激励视频,18半屏(N个激励视频),9章节末,17阅读页插页广告,15书架,44福利中心补签视频,33邀请活动,5积分大厅激励任务,30积分中心-吃饭,29积分中心-宝箱,19签到弹窗-额外签到奖励,21书架激励视频任务,16开屏,52限免卡-半屏banner,53限免卡-弹窗,54限免卡-阅读器返回推,50限免卡首页激励视频,51限免卡砍价激励视频,37种树游戏激励视频,27积分抽奖激励视频,28积分挖宝激励视频,24拼图活动激励视频,42打赏弹层激励视频,41打赏活动激励视频,34邀请码,38手速游戏激励视频,)"
    ,AdPlatform       INT(11)          NOT NULL                  COMMENT "广告平台(1Admob激励广告,100华为激励广告,101Google AdSense展示广告,20TradPlus聚合广告,102xh-ad广告,103TopOn聚合平台,104Max聚合平台)"
    ,SceneId          VARCHAR(65533)                             COMMENT "广告场景ID"
    ,AdIds            VARCHAR(65533)                             COMMENT "广告单元ID(Id&(0横1竖)|)"
    ,JGroupIds        VARCHAR(65533)                             COMMENT "极光人群包"
    ,ExcludeJGroupIds VARCHAR(65533)                             COMMENT "剔除极光人群包"
    ,MinVer           INT(11)          NOT NULL                  COMMENT "最小服务端版本号"
    ,MaxVer           INT(11)          NOT NULL                  COMMENT "最大服务端版本号"
    ,IsShieldAuthor   INT(11)          NOT NULL                  COMMENT "是否屏蔽作者(0否,1是)"
    ,Sort             INT(11)          NOT NULL                  COMMENT "排序"
    ,Status           INT(11)          NOT NULL                  COMMENT "状态(0关闭,1开启)"
    ,CreateTime       DATETIME         NOT NULL                  COMMENT "创建时间"
    ,UpdateTime       DATETIME         NOT NULL                  COMMENT "更新时间"
    ,sr_createtime    DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime    DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "app内各广告平台的广告单元id信息表"
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;