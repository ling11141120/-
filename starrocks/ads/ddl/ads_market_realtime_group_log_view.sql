create or replace view ads.ads_market_realtime_group_log_view (
     dt              comment "createtime 分区"
    ,id              comment "自增id"
    ,product_id      comment "产品ID"
    ,user_id         comment "用户ID"
    ,group_id        comment "人群包ID"
    ,op_type         comment "操作类型 0:入包 3:出包"
    ,start_time      comment "开始时间"
    ,end_time        comment "结束时间"
    ,create_time     comment "创建时间"
    ,appid           comment "应用ID"
    ,parent_group_id comment "父人群包ID"
    ,group_type      comment "人群包类型 0:父 1:子"
    ,hash_id         comment "哈希ID"
    ,groups_detail   comment "取模明细"
    ,sr_createtime   comment "StarRocks数据注入时间"
    ,sr_updatetime   comment "StarRocks数据更新时间"
)
comment "人群包用户实时数据"
as
select dt
     , id
     , productid     as product_id
     , userid        as user_id
     , groupid       as group_id
     , optype        as op_type
     , starttime     as start_time
     , endtime       as end_time
     , createtime    as create_time
     , appid
     , parentgroupid as parent_group_id
     , grouptype     as group_type
     , hashid        as hash_id
     , groupsdetail  as groups_detail
     , sr_createtime
     , sr_updatetime
  from ods_log.ods_tidb_readerlog_log_realtimegrouplog
;