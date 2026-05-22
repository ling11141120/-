----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_edm_automated_recommend
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : ads_sr_edm_automated_recommend
-- task_version     : 3
-- update_time      : 2025-12-05 14:23:29
-- sql_path         : \starrocks\tbl_ads_sr_edm_automated_recommend\ads_sr_edm_automated_recommend
----------------------------------------------------------------
-- SQL语句
-- 每日调度执行
insert into ads.ads_sr_edm_automated_recommend
select
    a.batch_id,
    a.user_id,
    a.lang_id,
    a.second_lang_id,
    a.value,
    now() as etl_time
from (
    select
        batch_id, user_id, lang_id, second_lang_id,
        group_concat(if(chapter_id > 0, concat(book_id, '|', chapter_id), book_id) order by book_id, chapter_id) as value
    from (
        select
            batch_id, user_id, lang_id, second_lang_id, book_id, chapter_id
        from dwd.dwd_sr_tag_center_action_log
        where dt >= date_sub('${bf_1_dt}', interval 30 day) and book_id > 0
        group by batch_id, user_id, lang_id, second_lang_id, book_id, chapter_id
    ) a
    group by batch_id, user_id, lang_id, second_lang_id
) a
left join ads.ads_sr_edm_automated_recommend b
on a.batch_id = b.batch_id and a.user_id = b.user_id and a.lang_id = b.lang_id and a.second_lang_id = b.second_lang_id
where a.value != ifnull(b.value, 0);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_edm_automated_recommend
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : 每天随便更新十条，确保海阅正常运行
-- task_version     : 2
-- update_time      : 2025-06-21 10:05:28
-- sql_path         : \starrocks\tbl_ads_sr_edm_automated_recommend\每天随便更新十条，确保海阅正常运行
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_edm_automated_recommend
select
    batch_id,
    user_id,
    lang_id,
    second_lang_id,
    value,
    now() as etl_time
from ads.ads_sr_edm_automated_recommend
limit 10;
