create or replace view dwd.dwd_srsv_advertisement_koc_attribution_record_view (
     id                  comment "自增id"
    ,product_id          comment "产品id"
    ,user_id             comment "用户id"
    ,mt                  comment "mt"
    ,core                comment "core"
    ,chl                 comment "渠道"
    ,current_language    comment "语言"
    ,begin_time          comment "开始时间"
    ,end_time            comment "结束时间"
    ,resource_id         comment "书籍id"
    ,koc_text            comment "口令"
    ,ad_id               comment "adid"
    ,create_time         comment "创建时间"
    ,update_time         comment "更新时间"
    ,sr_createtime       comment "starrocks数据注入时间"
    ,sr_updatetime       comment "starrocks数据更新时间"
)
as
select a.Id                 as id
      ,a.product_id         as product_id
      ,a.Pid                as user_id
      ,a.Mt                 as mt
      ,a.Core               as core
      ,a.Chl                as chl
      ,a.CurrentLanguage    as current_language
      ,a.BeginTime          as begin_time
      ,a.EndTime            as end_time
      ,a.ResourceId         as resource_id
      ,a.KocText            as koc_text
      ,a.AdId               as ad_id
      ,a.CreateTime         as create_time
      ,a.UpdateTime         as update_time
      ,a.sr_createtime      as sr_createtime
      ,a.sr_updatetime      as sr_updatetime
  from ods.ods_tidb_readernovel_tidb_kocattributionrecord_di    as a
;