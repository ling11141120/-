----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_automation_new_book_ranking_est
-- workflow_version : 12
-- create_user      : chenmo
-- task_name        : ads_sr_automation_new_book_ranking_est
-- task_version     : 8
-- update_time      : 2026-03-23 17:13:39
-- sql_path         : \starrocks\tbl_ads_sr_automation_new_book_ranking_est\ads_sr_automation_new_book_ranking_est
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_automation_new_book_ranking_est
select '${bf_1_dt}'                 as dt
     , a.BookId
     , a.LangId
     , ifnull(c.reader_num, 0)      as reader_num      -- 阅读人数
     , ifnull(d.consume_num, 0)     as consume_num     -- 阅币消耗
     , ifnull(e.exposure_num, 0)    as exposure_num    -- 曝光人数
     , now()                        as etl_time
  from ods.ods_tidb_readernovel_tidb_tag_center_climb_new_book_pool as a
  left join dim.dim_shuangwen_book_read_consume_info                as b
    on a.BookId = b.book_id
   and a.LangId = b.languageid
  left join (select book_id
--                   , product_id
                  , count(distinct user_id) as reader_num
               from dwd.dwd_read_user_chapter_view
              where create_time >= date_add('${bf_1_dt}', interval 13 hour)
                and create_time <= date_add('${dt}', interval 13 hour)
              group by book_id-- , product_id
             )                                                      as c
    on a.BookId = c.book_id
--    and b.product_id = c.product_id
  left join (select book_id
--                   , product_id
                  , sum(amount) as consume_num
               from dwd.dwd_consume_user_consume
              where createtime >= date_add('${bf_1_dt}', interval 13 hour)
                and createtime <= date_add('${dt}', interval 13 hour) and types = 1
              group by book_id-- , product_id
             )                                                      as d
    on a.BookId = d.book_id
--    and b.product_id = d.product_id
  left join (select book_id
--                   , app_product_id
                  , count(distinct login_id) as exposure_num
               from ads.ads_sensors_production_itemexposure_view
              where event_tm >= date_add('${bf_1_dt}', interval 13 hour)
                and event_tm <= date_add('${dt}', interval 13 hour)
              group by book_id-- , app_product_id
             )                                                      as e
    on a.BookId = e.book_id
--    and b.product_id = e.app_product_id
;
