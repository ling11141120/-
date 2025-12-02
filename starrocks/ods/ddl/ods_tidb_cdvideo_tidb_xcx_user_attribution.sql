----------------------------------------------------------------
-- 目标表： ods.ods_tidb_cdvideo_tidb_xcx_user_attribution
-- 来源实例： old_tidb_source
-- 来源表： cdvideo_tidb_xcx.user_attribution
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_cdvideo_tidb_xcx_user_attribution;
create table ods.ods_tidb_cdvideo_tidb_xcx_user_attribution (
     Id                         bigint(20)     not null                  comment "id"
    ,ProductId                  int(11)                                  comment "产品id"
    ,UserId                     bigint(20)                               comment "用户id"
    ,Source                     string                                   comment "媒体值"
    ,AdId                       string                                   comment "广告id"
    ,AdType                     int(11)                                  comment "广告类型"
    ,InstallDate                datetime                                 comment "激活安装时间"
    ,AdAccountId                string                                   comment "广告账户id"
    ,AdSetId                    string                                   comment "广告系列id"
    ,BookId                     string                                   comment "书籍id"
    ,Creative                   string                                   comment "广告创意"
    ,InstallOriginalRequest     string                                   comment "安装原始请求"
    ,Login                      string                                   comment "登录信息"
    ,UniqueCdReaderId           string                                   comment "设备信息"
    ,Country                    string                                   comment "国家"
    ,Mt                         int(11)                                  comment "终端"
    ,Core                       int(11)                                  comment "core"
    ,DataInsertDate             string                                   comment "插入时间"
    ,Networkname                string                                   comment "媒体值"
    ,Chl2                       string                                   comment "渠道值"
    ,CreateTime                 datetime                                 comment "新增时间"
    ,adgroup_name               string                                   comment "广告组名称"
    ,CurrentLanguage2           int(11)                                  comment "注册时语言"
    ,RemarketingTime            datetime                                 comment "再营销时间"
    ,AdQualityStatus            int(11)                                  comment "广告质量状态"
    ,InstallDateEst             date                                     comment "西五区激活安装时间"
    ,ReInstallDate              datetime                                 comment "再安装时间"
    ,AnalysisServerStatus       int(11)                                  comment "同步sharpengine_analysis_tidb数据服务处理状态 0=未处理|1=已处理"
    ,NextAttributeTime          datetime                                 comment "下一次归因时间"
    ,NextAttributeAdId          string                                   comment "下一次广告归因id"
    ,NextAttributeSource        string                                   comment "下一次归因来源"
    ,PreAttributeTime           datetime                                 comment "上一次归因来源时间"
    ,PreAttributeAdId           string                                   comment "上一次归因广告id"
    ,PreAttributeSource         string                                   comment "上一次归因来源"
    ,IsReInstall                int(11)                                  comment "是否再安装"
    ,PreAttributeDataId         bigint(20)                               comment "上一次归因的Id"
    ,NextAttributeDataId        bigint(20)                               comment "下一次归因的Id"
    ,RawAdId                    string                                   comment "未处理广告ID"
    ,TraceId                    string                                   comment "s2s的追踪Id"
    ,PixelId                    string                                   comment "fb的像素Id"
    ,At                         int(11)                                  comment "归因有效期"
    ,IsRemarketing              int(11)                                  comment "是否再营销 0=非再营销|1=再营销"
    ,NextAttributeIsRemarketing int(11)                                  comment "下一次归因是否再营销"
    ,PreAttributeIsRemarketing  int(11)                                  comment "上一次归因是否再营销"
    ,RemarkTimeSendToAppServer  int(11)                                  comment "发送RemarketingTime到AppServer状态"
    ,CustomAudiences            string                                   comment "自定义受众"
    ,MtRaw                      int(11)                                  comment "y原始记录的平台号,小程序统计去掉Mt这个参数"
    ,InviteCode                 string                                   comment ""
    ,Remark                     string                                   comment "备注"
    ,TfId                       string                                   comment "投放Id"
    ,IsDelete                   int(11)                                  comment "是否删除"
    ,sr_createtime              datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime              datetime       default current_timestamp comment "starrocks数据更新时间"
    ,index index1(ProductId)    using bitmap                             comment "index_ProductId"
    ,index index2(TraceId)      using bitmap                             comment "index_TraceId"
)
primary key(Id)
comment "国内短剧激活表"
distributed by hash(Id) buckets 5
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, InstallDateEst, CreateTime, TraceId, InstallDate, UniqueCdReaderId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;