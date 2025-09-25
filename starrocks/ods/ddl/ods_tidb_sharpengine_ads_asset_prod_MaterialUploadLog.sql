----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog
-- 来源实例： old_starrocks_source
-- 来源表： sharpengine_ads_asset_prod.MaterialUploadLog
-- 来源负责： 
-- 采集工具： 极光-定时批量
-- 开发人： wx
-- 开发日期： 2025-09-25
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog (
     Id                      BIGINT(20)    NOT NULL                  COMMENT "主键ID"
    ,MaterialId              BIGINT(20)    NOT NULL                  COMMENT "素材Id"
    ,MaterialName            STRING                                  COMMENT "素材名称"
    ,MaterialUrl             STRING                                  COMMENT "素材生成后视频地址"
    ,CosKey                  STRING                                  COMMENT "COS KEY"
    ,CosPath                 STRING                                  COMMENT "COS 地址"
    ,UploadStatus            INT(11)       NOT NULL DEFAULT "0"      COMMENT "上传状态"
    ,UploadRemark            STRING                                  COMMENT "上传日志信息"
    ,MetaInfo                STRING                                  COMMENT "视频信息"
    ,Folder                  STRING                                  COMMENT "目录Id"
    ,UploadId                STRING                                  COMMENT "素材生成后的Id"
    ,UploadVideoId           STRING                                  COMMENT "素材生成后视频Id"
    ,Sort                    INT(11)       NOT NULL DEFAULT "0"      COMMENT "排序"
    ,CreateTime              DATETIME                                COMMENT "写入时间"
    ,UpdateTime              DATETIME                                COMMENT "更新时间"
    ,LanguageName            STRING                                  COMMENT "语言"
    ,MaterialType            STRING                                  COMMENT "素材类型"
    ,Editor                  STRING                                  COMMENT "剪辑师缩写"
    ,Tag1                    STRING                                  COMMENT "一级标签"
    ,Tag2                    STRING                                  COMMENT "二级标签"
    ,Tag3                    STRING                                  COMMENT "三级标签"
    ,Code                    STRING                                  COMMENT "剧代号"
    ,Ratio                   STRING                                  COMMENT "尺寸"
    ,CosStartTime            DATETIME                                COMMENT "COS上传时间"
    ,CosCompeleteTime        DATETIME                                COMMENT "COS上传完成时间"
    ,BmStartTime             DATETIME                                COMMENT "BM上传开始时间"
    ,BmCompeleteTime         DATETIME                                COMMENT "BM上传结束时间"
    ,FileSize                BIGINT(20)                              COMMENT "文件大小"
    ,IsPriority              INT(11)       DEFAULT "0"               COMMENT "是否优先"
    ,MaterialFullName        STRING                                  COMMENT "素材名称"
    ,MakeDate                STRING                                  COMMENT "素材发布日期"
    ,ImageUrl                STRING                                  COMMENT "素材BM图片地址"
    ,ImageHash               STRING                                  COMMENT "FB的图片Hash值"
    ,AssetGuid               STRING                                  COMMENT "素材唯一标识"
    ,SellingPoint            STRING                                  COMMENT "卖点"
    ,RegionFolder            STRING                                  COMMENT "区域文件夹"
    ,AssetId                 STRING                                  COMMENT "素材中心唯一Id"
    ,BatchId                 STRING                                  COMMENT "批次Id"
    ,FileMd5                 STRING                                  COMMENT "MD5"
    ,ThumbnailUrl            STRING                                  COMMENT "生成缩略图的地址"
    ,TgtType                 INT(11)                                 COMMENT "目标类型 1=书|2=短剧|3=国剧"
    ,MaterialTime            DATETIME                                COMMENT "任务提交时间"
    ,CurrentLanguage         INT(11)                                 COMMENT "语言"
    ,LeaderUid               STRING                                  COMMENT "组长工号"
    ,MateriaUid              STRING                                  COMMENT "剪辑师工号"
    ,SourceChlType           INT(11)       NOT NULL DEFAULT "0"      COMMENT "媒体类型 0=未知|1=Facebook|2=Tiktok"
    ,SyncMaterialUploadLogId BIGINT(20)    NOT NULL DEFAULT "0"      COMMENT "同步的素材上传记录ID"
    ,FissionLang             VARCHAR(500)                            COMMENT "素材视频已裂变语言多个逗号分隔"
    ,TgtName                 VARCHAR(500)                            COMMENT "目标名称TaskType=1=书籍ID|TaskType=2=书籍代号"
    ,FissionParentId         BIGINT(20)                              COMMENT "裂变父级ID"
    ,FissionJobId            BIGINT(20)                              COMMENT "裂变作业Id"
    ,LogType                 INT(11)                                 COMMENT "上传类型,0=默认|1=批量上传忽略MD5"
    ,Level                   INT(11)                                 COMMENT "素材等级"
    ,BmId                    VARCHAR(1000)                           COMMENT "Business Manager Id"
    ,ResSourceType           INT(11)                                 COMMENT "素材来源"
    ,ResSourceId             BIGINT(20)                              COMMENT "来源ID"
    ,FbSyncStatus            INT(11)                                 COMMENT "同步状态"
    ,sr_createtime           DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime           DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(Id)
COMMENT "素材上传日志表"
DISTRIBUTED BY HASH(Id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "AssetId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;