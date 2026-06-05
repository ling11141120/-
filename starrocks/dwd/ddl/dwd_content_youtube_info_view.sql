create or replace view dwd.dwd_content_youtube_info_view (
     id               comment "Id"
    ,email            comment "邮箱账号"
    ,channel_name     comment "渠道名称"
    ,authorization    comment "authorization"
    ,refresh_token    comment "refreshtoken"
    ,add_time         comment "添加时间"
    ,cilent_id        comment "cilentid"
    ,status           comment "1启用"
    ,sr_createtime    comment "starrocks入库时间"
    ,sr_updatetime    comment "starrocks数据更新时间"
)
comment "youtube配置信息"
as
select a1.id               as id              -- Id
      ,a1.email            as email           -- 邮箱账号
      ,a1.channename       as channel_name    -- 渠道名称
      ,a1.authorization    as authorization   -- authorization
      ,a1.refreshtoken     as refresh_token   -- refreshtoken
      ,a1.addtime          as add_time        -- 添加时间
      ,a1.cilentid         as cilent_id       -- cilentid
      ,a1.status           as status          -- 1启用
      ,a1.sr_createtime    as sr_createtime   -- starrocks入库时间
      ,a1.sr_updatetime    as sr_updatetime   -- starrocks数据更新时间
  from ods.ods_tidb_cdmoney_report_tidb_cn_youtube_info    as a1
;
