----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_chapter_length
-- workflow_version : 5
-- create_user      : admin
-- task_name        : dws_content_book_chapter_length
-- task_version     : 5
-- update_time      : 2023-10-27 17:55:29
-- sql_path         : \starrocks\tbl_dws_content_book_chapter_length\dws_content_book_chapter_length
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_content_book_chapter_length
SELECT '${dt}'                                                                dt,
       site_id,
       (book_id * 1000 + site_id)                                                  book_id,
       sum(if(timer >= date_sub('${dt}', interval 1 day), chapter_length, 0)) chapter_length_1d,
       sum(if(timer >= date_sub('${dt}', interval 7 day), chapter_length, 0)) chapter_length_7d,
       sum(chapter_length)                                                         chapter_length_30d
        ,now() as etl_time
FROM ods.ods_edit_shuangwen_chapter
where timer >= date_sub('${dt}', interval 30 day)
  and timer < '${dt}'
  AND Status = 1 and site_id<>0
group by 1, 2, 3
union all
SELECT '${dt}'                                                                dt,
       333 as                                                                      site_id,
       book_id,
       sum(if(timer >= date_sub('${dt}', interval 1 day), chapter_length, 0)) chapter_length_1d,
       sum(if(timer >= date_sub('${dt}', interval 7 day), chapter_length, 0)) chapter_length_7d,
       sum(chapter_length)                                                         chapter_length_30d
        ,now() as etl_time
FROM ods.ods_book_novel_chaptersync
where timer >= date_sub('${dt}', interval 30 day)
  and timer < '${dt}'
  AND Status = 1
group by 1, 2, 3
union all
SELECT '${dt}'                                                                dt,
       777 as                                                                      site_id,
       book_id,
       sum(if(timer >= date_sub('${dt}', interval 1 day), chapter_length, 0)) chapter_length_1d,
       sum(if(timer >= date_sub('${dt}', interval 7 day), chapter_length, 0)) chapter_length_7d,
       sum(chapter_length)                                                         chapter_length_30d
        ,now() as etl_time
FROM ods.ods_book_novel_chaptersync
where timer >= date_sub('${dt}', interval 30 day)
  and timer < '${dt}'
  AND Status = 1
group by 1, 2, 3;
