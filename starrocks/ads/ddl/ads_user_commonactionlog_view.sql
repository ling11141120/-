create view `ads_user_commonactionlog_view`
            (`dt` comment "创建时间分区", `product_id` comment "产品id ", `id` comment "自增id",
             `user_id` comment "用户id", `action` comment "事件", `prodid` comment "X值（没用了）",
             `chl` comment "渠道值", `imei` comment "设备信息imei", `mt` comment "终端", `appver` comment "版本",
             `smallpt`, `f0`, `f1`, `f2`, `f3`, `f4`, `f5`, `f6`, `f7`, `f8`, `f9`, `s0`, `s1`, `s2`, `s3`, `s4`, `s5`,
             `s6`, `s7`, `s8`, `s9`, `create_time` comment "创建时间", `appid` comment "应用程序id", `sr_createtime`,
             `sr_updatetime`)
            comment "服务端旧埋点事件记录表"
as
select `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`dt`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`productid`  as `product_id`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`id`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`userid`     as `user_id`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`action`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`prodid`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`chl`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`imei`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`mt`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`appver`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`smallpt`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f0`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f1`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f2`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f3`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f4`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f5`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f6`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f7`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f8`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`f9`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s0`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s1`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s2`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s3`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s4`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s5`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s6`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s7`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s8`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`s9`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`createtime` as `create_time`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`appid`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`sr_createtime`
     , `ods_log`.`ods_readerlog_xx_log_commonactionlog`.`sr_updatetime`
  from `ods_log`.`ods_readerlog_xx_log_commonactionlog`;