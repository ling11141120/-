CREATE or REPLACE VIEW dim.dim_admobapp_view (
     id              COMMENT "自增id"
    ,name            COMMENT "名字"
    ,appid           COMMENT "appid"
    ,display_name    COMMENT "名称"
    ,account         COMMENT "广告账户"
    ,plat_form       COMMENT "平台"
    ,create_time     COMMENT "创建时间"
    ,update_time     COMMENT "更新时间"
    ,mt              COMMENT "设备"
    ,core            COMMENT "core"
    ,product_id      COMMENT "产品id"
    ,appname         COMMENT "关联App信息"
    ,appstore_id     COMMENT "关联App包名"
)
COMMENT "admobapp信息表" AS
SELECT AppId
      ,Name
      ,AppId
      ,DisplayName    AS display_name
      ,Account
      ,Platform       AS plat_form
      ,CreatedTime    AS create_time
      ,UpdatedTime    AS update_time
      ,Mt
      ,Core
      ,ProductId      AS product_id
      ,AppName
      ,AppStoreId     AS appstore_id
 FROM ods.ods_tidb_sharpengine_ads_global_admobapp
;