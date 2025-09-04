create or replace view dim.dim_admobapp_view (
     id              comment "自增id"
    ,name            comment "名字"
    ,appid           comment "appid"
    ,display_name    comment "名称"
    ,account         comment "广告账户"
    ,plat_form       comment "平台"
    ,create_time     comment "创建时间"
    ,update_time     comment "更新时间"
    ,mt              comment "设备"
    ,core            comment "core"
    ,product_id      comment "产品id"
    ,appname         comment "关联app信息"
    ,appstore_id     comment "关联app包名"
)
comment "admobapp信息表"
as
select AppId
      ,Name
      ,AppId
      ,DisplayName    as display_name
      ,Account
      ,Platform       as plat_form
      ,CreatedTime    as create_time
      ,UpdatedTime    as update_time
      ,Mt
      ,Core
      ,ProductId      as product_id
      ,AppName
      ,AppStoreId     as appstore_id
  from ods.ods_tidb_sharpengine_ads_global_admobapp
;