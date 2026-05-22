----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_bi_read_consume_p_di
-- workflow_version : 20
-- create_user      : yanxh
-- task_name        : ads_sr_bi_read_consume_p_di_external
-- task_version     : 2
-- update_time      : 2024-10-16 11:33:55
-- sql_path         : \starrocks\tbl_ads_sr_bi_read_consume_p_di\ads_sr_bi_read_consume_p_di_external
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_bi_read_consume_p_di_external`
select * from ads.`ads_sr_bi_read_consume_p_di`
where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${dt}';
