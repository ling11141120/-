create or replace view dwd.dwd_readerlog_commonactionlog_view (
     dt            comment "创建时间分区"
    ,product_id    comment "产品id "
    ,id            comment "自增id"
    ,user_id       comment "用户id"
    ,action        comment "事件"
    ,prodid        comment "X值（没用了）"
    ,chl           comment "渠道值"
    ,imei          comment "设备信息imei"
    ,mt            comment "终端"
    ,appver        comment "版本"
    ,smallpt
    ,f0
    ,f1
    ,f2
    ,f3
    ,f4
    ,f5
    ,f6
    ,f7
    ,f8
    ,f9
    ,s0
    ,s1
    ,s2
    ,s3
    ,s4
    ,s5
    ,s6
    ,s7
    ,s8
    ,s9
    ,create_time    comment "创建时间"
    ,appid          comment "应用程序id"
    ,sr_createtime
    ,sr_updatetime
)
comment "服务端旧埋点事件记录表"
as
select dt
     , productid  as product_id
     , id
     , userid     as user_id
     , action
     , prodid
     , chl
     , imei
     , mt
     , appver
     , smallpt
     , f0
     , f1
     , f2
     , f3
     , f4
     , f5
     , f6
     , f7
     , f8
     , f9
     , s0
     , s1
     , s2
     , s3
     , s4
     , s5
     , s6
     , s7
     , s8
     , s9
     , createtime as create_time
     , appid
     , sr_createtime
     , sr_updatetime
  from ods_log.ods_readerlog_xx_log_commonactionlog
;
