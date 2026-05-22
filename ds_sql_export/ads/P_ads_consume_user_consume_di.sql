----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_consume_user_consume_di
-- workflow_version : 11
-- create_user      : lxz
-- task_name        : ads.ads_consume_user_consume_di
-- task_version     : 11
-- update_time      : 2024-10-24 21:29:15
-- sql_path         : \starrocks\tbl_ads_consume_user_consume_di\ads.ads_consume_user_consume_di
----------------------------------------------------------------
-- SQL语句
---===================调度======================
insert into ads.ads_consume_user_consume_di

SELECT `dwd`.`dwd_consume_user_consume`.`dt`,
       `dwd`.`dwd_consume_user_consume`.`product_id`,
       `dwd`.`dwd_consume_user_consume`.`auto_id`,
       `dwd`.`dwd_consume_user_consume`.`types`,
       `dwd`.`dwd_consume_user_consume`.`user_id`,
       `dwd`.`dwd_consume_user_consume`.`amount`,
       `dwd`.`dwd_consume_user_consume`.`remain_amount`,
       `dwd`.`dwd_consume_user_consume`.`book_id`,
       `dwd`.`dwd_consume_user_consume`.`chapter_ids`,
       `dwd`.`dwd_consume_user_consume`.`chapter_num`,
       `dwd`.`dwd_consume_user_consume`.`createtime`,
       `dwd`.`dwd_consume_user_consume`.`pay_type`,
       `dwd`.`dwd_consume_user_consume`.`mt`,
       `dwd`.`dwd_consume_user_consume`.`seq`,
       `dwd`.`dwd_consume_user_consume`.`app_id`,
       `dwd`.`dwd_consume_user_consume`.`position_id`,
       `dwd`.`dwd_consume_user_consume`.`app_game_id`,
       `dwd`.`dwd_consume_user_consume`.`send_id`,
       `dwd`.`dwd_consume_user_consume`.`isFirst`,
       ifnull(`dws`.`dws_read_90_first_all_read_mid2`.`is_source`, 0) as is_source,
       `dwd`.`dwd_consume_user_consume`.`etl_time`
FROM `dwd`.`dwd_consume_user_consume`
left join dws.dws_read_90_first_all_read_mid2
on dwd_consume_user_consume.dt = dws_read_90_first_all_read_mid2.dt
and dwd_consume_user_consume.user_id = dws_read_90_first_all_read_mid2.user_id
and dwd_consume_user_consume.book_id = dws_read_90_first_all_read_mid2.book_id
and
(case when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 322 then 322
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 375 then 375
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 409 then 409
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 410 then 410
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 418 then 418
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 419 then 419
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 414 then 414
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 433 then 433
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 435 then 435
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 436 then 436
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 445 then 445
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 412 then 412
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 413 then 413
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 415 then 415
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 447 then 447
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 448 then 448

                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 491 then 491
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 492 then 492
                 when dwd_consume_user_consume.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and dwd_consume_user_consume.book_id % 1000 = 1 then 1
                 when dwd_consume_user_consume.product_id in (8858) then 885 when dwd_consume_user_consume.product_id in (7757) then 775
                 else 	333 end ) = dws_read_90_first_all_read_mid2.site_id
                 and dws_read_90_first_all_read_mid2.dt >= '${bf_1_dt}'  and dws_read_90_first_all_read_mid2.dt<='${dt}'
where dwd_consume_user_consume.dt >= '${bf_1_dt}'  and dwd_consume_user_consume.dt<='${dt}';
