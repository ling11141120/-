----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_separate_chapter_book_cost_stat
-- workflow_version : 17
-- create_user      : xixg
-- task_name        : ads_report_separate_chapter_book_cost_stat
-- task_version     : 17
-- update_time      : 2024-05-11 19:48:42
-- sql_path         : \starrocks\tbl_ads_report_separate_chapter_book_cost_stat\ads_report_separate_chapter_book_cost_stat
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_report_separate_chapter_book_cost_stat

-- 根书的相关信息
WITH tmp_root_book AS (
    SELECT 	'${dt}' AS dates,
            a.product_id AS product_id,
            a.book_id AS book_id,
            NULL AS root_book_id,
            e.book_name AS book_name,
            b.book_code AS book_code,
            e.from_book_name AS origin_bookname,
            e.to_book_name AS object_bookname,
            1 AS if_root_book,
            b.public_fontlength AS public_fontlength,
              c.cost_amt_7 AS cost_amt_7,
              d.amount_7 AS amount_7,
              c.cost_amt_30 AS cost_amt_30,
              d.amount_30 AS amount_30,
              c.cost_amt_curmon AS cost_amt_curmon,
              d.amount_curmon AS amount_curmon,
              0 AS separate_chapter_book_income,
              c.cost_amt_YTD AS cost_amt_YTD,
              d.amount_YTD AS amount_YTD,
              now() as etl_time
    FROM  (SELECT product_id, root_parent_book_id AS book_id FROM dwm.dwm_content_book_parentbook_relation GROUP BY product_id, root_parent_book_id) a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
     ON a.book_id = b.book_id
    LEFT JOIN
                (
                    select 	s1.product_id,
                            s1.book_id AS book_id ,
                              sum(case when dt>= '${bf_7_dt}'  then cost_amt_all end) as cost_amt_7,
                              sum(case when dt>= '${bf_30_dt}' then cost_amt_all end) as cost_amt_30,
                              sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') then cost_amt_all end) as cost_amt_curmon,
                              sum(cost_amt_all) as cost_amt_YTD
                    from (
                             select dt,product_id,book_id,sum(cost_amt) as cost_amt_all
                             from dws.dws_content_translate_remuneration_ed where dt >= '2021-01-01' and dt < '${dt}'
                             group by 1,2,3
                         )s1
                    group by 1,2
                )c
    on a.book_id = c.book_id
    left join
        (
            select 	book_id AS book_id,
                      sum(case when dt>= '${bf_7_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_7,
                      sum(case when dt>= '${bf_30_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_30,
                      sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') and dt< '${dt}' then amount end)/100*6.5 as amount_curmon,
                      sum(amount)/100*6.5 as amount_YTD
            from dws.dws_consume_user_consume_ed
            where dt >='2021-01-01' and dt < '${dt}'
              and  types in (1)
            group by 1
        )d
    on a.book_id = d.book_id
    LEFT JOIN (
                select
                    a.tobookid AS book_id,
                    a.ToBookName AS to_book_name,
                    a.FromBookName AS from_book_name,
                    a.cnbookname AS book_name
                from (
                        select
                            tobookid * 1000 + tolanguage as tobookid,
                            ToBookName,
                            FromBookId,
                            FromBookName,
                            ToLanguage,
                            cnbookname,
                            max(UpdateTime) as UpdateTime
                        from
                            ods.ods_edit_book_LanguageBookTotal
                        where
                            (case
                                 when FromBookId in (92641090, 168177, 104925090) then ToLanguage != 375
                                 else 1 = 1
                                end)
                          and date(StatisticsDate) < '${dt}'
                        group by 1,2,3,4,5,6
                    )a
                inner join (
                              select
                                      tobookid * 1000 + tolanguage as tobookid,
                                      max(UpdateTime) as UpdateTime
                               from  ods.ods_edit_book_LanguageBookTotal
                              where  (case when FromBookId in (92641090, 168177, 104925090) then ToLanguage != 375
                                       else 1 = 1 end)
                                and date(StatisticsDate) < '${dt}'
                              group by  1
                            )b
                    on a.tobookid = b.tobookid
                    and a.UpdateTime = b.UpdateTime
    ) e
    on a.book_id = e.book_id
),

tmp_son_book AS (
    SELECT
        '${dt}' AS dates,
        a.product_id AS product_id,
        a.book_id AS book_id,
        f.root_parent_book_id AS root_book_id,
        e.book_name AS book_name,
        b.book_code AS book_code,
        e.to_book_name AS origin_bookname,
        b.book_name AS object_bookname,
        0 AS if_root_book,
        b.public_fontlength,
        NULL AS cost_amt_7,
        d.amount_7 AS amount_7,
        NULL AS cost_amt_30,
        d.amount_30 AS amount_30,
        NULL AS cost_amt_curmon,
        d.amount_curmon AS amount_curmon,
        NULL AS separate_chapter_book_income,
        NULL AS cost_amt_YTD,
        d.amount_YTD AS amount_YTD,
        now() as etl_time
    FROM  (SELECT product_id, book_id_language_id AS book_id, root_parent_book_id AS from_book_id FROM dwm.dwm_content_book_parentbook_relation GROUP BY product_id, book_id_language_id,root_parent_book_id) a
    LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
    ON a.book_id = b.book_id
    left join
                (
                select
                    book_id AS book_id,
                    sum(case when dt>= '${bf_7_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_7,
                    sum(case when dt>= '${bf_30_dt}' and dt< '${dt}' then amount end)/100*6.5 as amount_30,
                    sum(case when date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m') and dt< '${dt}' then amount end)/100*6.5 as amount_curmon,
                    sum(amount)/100*6.5 as amount_YTD
                from dws.dws_consume_user_consume_ed
                where dt >='2021-01-01' and dt < '${dt}'
                and  types in (1)
                group by 1
                )d
        on a.book_id = d.book_id
        LEFT JOIN (
                    select
                        a.tobookid AS book_id,
                        a.ToBookName AS to_book_name,
                        a.FromBookName AS from_book_name,
                        a.cnbookname AS book_name
                    from (
                            select
                                tobookid * 1000 + tolanguage as tobookid,
                                ToBookName,
                                FromBookId,
                                FromBookName,
                                ToLanguage,
                                cnbookname,
                                max(UpdateTime) as UpdateTime
                            from  ods.ods_edit_book_LanguageBookTotal
                            where
                            (case  when FromBookId in (92641090, 168177, 104925090) then ToLanguage != 375
                            else 1 = 1  end)
                            and date(StatisticsDate) < '${dt}'
                            group by 1,2,3,4,5,6
                            )a
                    inner join (
                                select
                                    tobookid * 1000 + tolanguage as tobookid,
                                    max(UpdateTime) as UpdateTime
                                from  ods.ods_edit_book_LanguageBookTotal
                                where  (case when FromBookId in (92641090, 168177, 104925090) then ToLanguage != 375  else 1 = 1 end)
                                and date(StatisticsDate) < '${dt}'
                                group by  1
                                )b
                    on a.tobookid = b.tobookid
                    and a.UpdateTime = b.UpdateTime
                ) e
        on a.from_book_id = e.book_id
        LEFT JOIN dwm.dwm_content_book_parentbook_relation f
        on a.book_id = f.book_id_language_id
    )

SELECT 	 dates,
          product_id,
          book_id,
          root_book_id,
          book_name,
          book_code,
          origin_bookname,
          object_bookname,
          if_root_book,
          public_fontlength,
          cost_amt_7,
          amount_7,
          cost_amt_30,
          amount_30,
          cost_amt_curmon,
          amount_curmon,
          separate_chapter_book_income,
          cost_amt_YTD,
          amount_YTD,
          etl_time
FROM tmp_root_book
UNION ALL
SELECT 	 dates,
           product_id,
           book_id,
           root_book_id,
           book_name,
           book_code,
           origin_bookname,
           object_bookname,
           if_root_book,
           public_fontlength,
           cost_amt_7,
           amount_7,
           cost_amt_30,
           amount_30,
           cost_amt_curmon,
           amount_curmon,
           separate_chapter_book_income,
           cost_amt_YTD,
           amount_YTD,
           etl_time
FROM tmp_son_book;
