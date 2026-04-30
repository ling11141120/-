create or replace view dwd.dwd_market_realtimegrouplog_view (
     dt              comment "createtime 分区"
    ,id              comment ""
    ,product_id      comment "productid"
    ,user_id         comment "userid"
    ,group_id        comment "groupid"
    ,op_type         comment "操作类型 0:入包 3:出包"
    ,start_time      comment "开始时间"
    ,end_time        comment "结束时间"
    ,create_time     comment "创建时间"
    ,appid           comment "appid"
    ,parent_group_id comment "父人群包id"
    ,group_type      comment "0父 1子"
    ,hash_id         comment "hashid"
    ,groups_detail   comment "取模明细"
    ,sr_createtime   comment "starrocks数据注入时间"
    ,sr_updatetime   comment "starrocks数据更新时间"
)
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