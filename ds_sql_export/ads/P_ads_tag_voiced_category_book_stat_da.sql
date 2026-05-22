----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_tag_voiced_category_book_stat_da
-- workflow_version : 16
-- create_user      : xixg
-- task_name        : ads_tag_voiced_category_book_stat_da
-- task_version     : 11
-- update_time      : 2025-02-26 19:45:39
-- sql_path         : \starrocks\tbl_ads_tag_voiced_category_book_stat_da\ads_tag_voiced_category_book_stat_da
----------------------------------------------------------------
-- SQL语句
insert overwrite  ads.ads_tag_voiced_category_book_stat_da
with consume_nd_tmp as (
select
       book_info.book_id,
       consume_nd.site_id AS site_id,
       book_info.new_cid,
       book_info.is_full,
       book_info.is_putaway,
       book_info.build_time,
       book_info.update_time,
       consume_nd.consume_1d,
       consume_nd.consume_7d,
       consume_nd.consume_30d
from (
         select (VoiceBookId * 1000 +990) AS book_id,Categore AS new_cid,CreateTime AS build_time,UpdateTime AS update_time,IsFull AS is_full,Sexy AS is_putaway, `Status` as Status
         from ods.ods_voice_book
     ) book_info
inner join (
    select book_id,
           if(site_id in (775, 885), 777, site_id) site_id,
           sum(if(dt = date_sub('${today}', interval 1 day), amount, 0)) as consume_1d,
           sum(if(dt >= date_sub('${today}', interval 7 day), amount, 0)) as consume_7d,
           sum(amount) as consume_30d
    from dws.dws_consume_book_consume_ed
    where dt >= date_sub('${today}', interval 30 day)
      and dt < '${today}' and types in(1,2)
    group by 1,2
) consume_nd on book_info.book_id = consume_nd.book_id
),

consume_td_tmp as (
select
       book_info.book_id,
       consume_td.site_id AS site_id,
       book_info.new_cid,
       book_info.is_full,
       book_info.is_putaway,
       book_info.build_time,
       book_info.update_time,
       consume_td.consume_td
from (
         select (VoiceBookId * 1000 +990) AS book_id,Categore AS new_cid,CreateTime AS build_time,UpdateTime AS update_time,IsFull AS is_full,Sexy AS is_putaway, `Status` as Status
         from ods.ods_voice_book
     ) book_info
inner join (
    select book_id,site_id, sum(consume_td) consume_td
    from (
             select book_id, if(site_id in (775, 885), 777, site_id) site_id, consume_td
             from dws.dws_consume_book_consume_a
             where dt = '${today}'
               and types in (1, 2)
         ) td
    group by 1,2
) consume_td on book_info.book_id = consume_td.book_id
),

all_results as (
       select 'SyncBi_ads_tag_voiced_category_book_stat_da' as tn,
              ifnull(a.book_id,b.book_id) as book_id,
              ifnull(a.site_id,b.site_id) as site_id,
              ifnull(a.new_cid,b.new_cid) as new_cid,
              ifnull(a.is_full,b.is_full) as is_full,
              ifnull(a.is_putaway,b.is_putaway) as is_putaway,
              ifnull(a.build_time,b.build_time) as build_time,
              ifnull(a.update_time,b.update_time) as update_time,
              a.consume_1d,
              a.consume_7d,
              a.consume_30d,
              b.consume_td
       FROM consume_nd_tmp a
       FULL JOIN consume_td_tmp b
       ON a.book_id = b.book_id
),

all_books AS (
       select 'SyncBi_ads_tag_voiced_category_book_stat_da' as tn,(VoiceBookId * 1000 +990) AS book_id,Categore AS new_cid,CreateTime AS build_time,UpdateTime AS update_time,IsFull AS is_full,Sexy AS is_putaway, `Status` as Status
         from ods.ods_voice_book
)

SELECT  tstatus.UpdateTime    as dt,
        b.book_id,
        CASE
            WHEN a.site_id = 777 THEN 1
            ELSE 2
            END as language_id,
        b.new_cid,
        b.is_full,
        b.is_putaway,
        b.Status,
        b.build_time,
        b.update_time,
        a.consume_1d,
        a.consume_7d,
        a.consume_30d,
        a.consume_td,
        now() as etl_time
FROM all_books b
LEFT JOIN all_results a
       ON b.book_id = a.book_id
inner join (
    select TableName, UpdateTime
    from ads.ads_SyncBi_update_status
    where TableName = 'SyncBi_ads_tag_voiced_category_book_stat_da'
        limit 1
) tstatus
on b.tn = tstatus.TableName
-- left join dim.DIM_ProductType c
-- ON a.site_id = c.book_langid;
