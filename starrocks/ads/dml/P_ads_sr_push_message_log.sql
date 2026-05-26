----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_push_message_log
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sr_push_message_log
-- task_version     : 3
-- update_time      : 2025-04-08 15:45:02
-- sql_path         : \starrocks\tbl_ads_sr_push_message_log\ads_sr_push_message_log
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_push_message_log`
SELECT a.`dt`,
       a.`product_id`,
       a.`id`,
       a.`createtime`   AS `create_time`,
       a.`userid`       AS `user_id`,
       b.user_id as active_user_id,
       a.`prodid`       AS `prod_id`,
       a.`mt`,
       a.`title`,
       a.`tokenid`      AS `token_id`,
       a.`token`,
       a.`body`,
       a.`customers`,
       a.`param`,
       a.`batchid`      AS `batch_id`,
       a.`state`,
       a.`updatetime`   AS `update_time`,
       a.`pushresponse` AS `push_response`,
       a.`pushtype`     AS `push_type`,
       a.`pushtime`     AS `push_time`,
       a.`messageid`    AS `message_id`,
       a.`tokentype`    AS `task_type`,
       a.`tasktype`     AS `task_type`,
       a.`imageurl`     AS `image_url`,
       a.`issilent`     AS `is_silent`,
       now() as etl_time
FROM (
    select
        *,
        date(UpdateTime) as update_date
    from `ods_log`.`ods_tidb_readerlog_Log_PushMessageLog`
    where UpdateTime >= '${bf_1_dt}'
) a
left join (
    select
        dt,
        user_id
    from dws.dws_user_wide_active_period_ed
    where dt >= '${bf_1_dt}'
    group by dt, user_id
) b
on update_date = b.dt and a.UserId = b.user_id;
