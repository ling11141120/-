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
CREATE TABLE ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog (
     Id                         bigint(20)      NOT NULL               COMMENT '主键ID'
    ,MaterialId                 bigint(20)      NOT NULL               COMMENT '素材Id'
    ,AssetGuid                  varchar(255)                           COMMENT '素材唯一标识'
    ,AssetId                    varchar(255)                           COMMENT '素材中心唯一Id'
    ,MaterialName               varchar(255)                           COMMENT '素材名称'
    ,MaterialFullName           varchar(255)                           COMMENT '素材名称'
    ,MaterialType               varchar(255)                           COMMENT '素材类型'
    ,MakeDate                   varchar(255)                           COMMENT '素材发布日期'
    ,Ratio                      varchar(255)                           COMMENT '尺寸',
    ,FileSize                   bigint(20)                             COMMENT '文件大小',
    ,FileMd5                    varchar(255)                           COMMENT 'MD5',
    ,MaterialUrl                varchar(2048)                          COMMENT '素材生成后视频地址'
    ,CosKey                     varchar(2048)                          COMMENT 'COS KEY'
    ,CosPath                    varchar(2048)                          COMMENT 'COS 地址'
    ,ImageUrl                   varchar(2048)                          COMMENT '素材BM图片地址'
    ,ThumbnailUrl               varchar(2048)                          COMMENT '生成缩略图的地址'
    ,ImageHash                  varchar(255)                           COMMENT 'FB的图片Hash值'
    ,UploadStatus               int(11)          NOT NULL DEFAULT 0    COMMENT '上传状态'
    ,UploadRemark               varchar(2048)                          COMMENT '上传日志信息'
    ,UploadId                   varchar(255)                           COMMENT '素材生成后的Id'
    ,UploadVideoId              varchar(255)                           COMMENT '素材生成后视频Id'
    ,CosStartTime               datetime                               COMMENT 'COS上传时间',
    ,CosCompleteTime            datetime                               COMMENT 'COS上传完成时间'
    ,BmStartTime                datetime                               COMMENT 'BM上传开始时间'
    ,BmStartTime                datetime                               COMMENT 'BM上传结束时间'
    ,LogType                    int(11)                                COMMENT '上传类型,0=默认|1=批量上传忽略MD5'
    ,Folder                     varchar(255)                           COMMENT '目录Id',
    ,RegionFolder               varchar(255)                           COMMENT '区域文件夹'
    ,Tag1                       varchar(255)                           COMMENT '一级标签'
    ,Tag2                       varchar(255)                           COMMENT '二级标签'
    ,Tag3                       varchar(255)                           COMMENT '三级标签'
    ,TgtType                    int(11)                                COMMENT '目标类型 1=书|2=短剧|3=国剧'
    ,TgtName                    varchar(500)                           COMMENT '目标名称TaskType=1=书籍ID|TaskType=2=书籍代号'
    ,MaterialTime               datetime                               COMMENT '任务提交时间'
    ,BatchId                    varchar(255)                           COMMENT '批次Id',
    ,FissionLang                varchar(500)                           COMMENT '素材视频已裂变语言多个逗号分隔'
    ,FissionParentId            bigint(20)                             COMMENT '裂变父级ID'
    ,FissionJobId               bigint(20)                             COMMENT '裂变作业Id'
    ,Editor                     varchar(255)                           COMMENT '剪辑师缩写'
    ,LeaderUid                  varchar(255)                           COMMENT '组长工号'
    ,MateriaUid                 varchar(255)                           COMMENT '剪辑师工号'
    ,LanguageName               varchar(255)                           COMMENT '语言',
    ,CurrentLanguage            int(11)                                COMMENT '语言'
    ,Code                       varchar(255)                           COMMENT '剧代号'
    ,SellingPoint               varchar(2048)                          COMMENT '卖点'
    ,IsPriority                 int(11)                   DEFAULT 0    COMMENT '是否优先'
    ,BmId                       varchar(1000)                          COMMENT 'Businesz Manager Id'
    ,ResSourceType              int(11)                                COMMENT '素材来源'
    ,ResSourceId                bigint(20)                             COMMENT '来源ID'
    ,FbSyncStatus               int(11)                                COMMENT '同步状态'
    ,Level                      int(11)                                COMMENT '素材等级'
    ,SourceChlType              int(11)          NOT NULL DEFAULT 0    COMMENT '媒体类型 0=未知|1=Facebook|2=Tiktok'
    ,SyncMaterialUploadLogId    bigint(20)       NOT NULL DEFAULT 0    COMMENT '同步的素材上传记录ID'
    ,CreateTime                 datetime                               COMMENT '写入时间'
    ,UpdateTime                 datetime                               COMMENT '更新时间'
    ,sr_createtime              datetime    DEFAULT CURRENT_TIMESTAMP  COMMENT 'starrocks数据注入时间'
    ,sr_updatetime              datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
PRIMARY KEY (Id)
COMMENT '素材上传日志表'
DISTRIBUTED BY HASH (Id) BUCKETS 3
PROPERTIES (
    'replication_num'          = '3',
    'bloom_filter_columns'     = 'AssetId',
    'in_memory'                = 'false',
    'enable_persistent_index'  = 'true',
    'replicated_storage'       = 'true',
    'compression'              = 'LZ4'
)
;
