----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_content_translate_remuneration_plan_p_da
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_content_translate_remuneration_plan_p_da
-- task_version     : 3
-- update_time      : 2025-05-29 13:54:06
-- sql_path         : \starrocks\sch_ads_content_translate_remuneration_plan_p_da\ads_content_translate_remuneration_plan_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO `ads`.`ads_content_translate_remuneration_plan_p_da`

with tmp_language_book_total AS (
    SELECT
        DATE(StatisticsDate) AS dt,
        (ToBookId*1000+ToLanguage) AS to_book_id,
        MAX(tobookname) AS to_book_name,
        MAX(BookStatus) AS book_status,
        MAX(ForeigningCount) AS foreigning_count,
        MAX(ProofreadingCount) AS proofreading_count,
        MAX(CollectionByForeign) AS collecting_by_foreign,
        MAX(Remark) AS remark
FROM ods.ods_edit_book_LanguageBookTotal
    GROUP BY  DATE(StatisticsDate), (ToBookId*1000+ToLanguage)   -- 同一个统计日期有多条数据，取MAX值
)

SELECT
    a.dt,
    a.target_book_id,
    a.first_translate_day, -- 第一次翻译时间
    a.translate_days,  -- 翻译天数
    a.sug_straw_words,
    a.chapter_plus_by_day,  -- 每日常规章节
    a.chapter_plus_by_week,  -- 周期加更数
    a.book_language_id,  -- 语种
    a.second_checkout_person, -- 二校
    a.book_code, -- 书编码
    a.book_cn_name, -- 书中文名称
    a.avg_chapter_words, -- 章均字数
    a.published_words, -- 发布字数
    a.proofread_words, -- 精修字数
    a.income_rank_last_30day,  -- 本月收入排名
    a.total_income_rank,  -- 累计收入排名
    a.interpreter_number,  -- 已质检
    a.foreign_number,  -- 已一校
    a.proofread_number, -- 已精修
    a.published_number, -- 已发布
    a.has_straw_chapters,  -- 囤稿量章节
    d.public_fontlength AS source_published_words, -- 源书发布字数
    d.normal_chapter_num_f AS source_published_chapters, -- 源书发布章节数
    a.income_last_7d, -- 近7天收入
    a.income_last_30d, -- 近30天收入
    a.income_last_7d_30d, -- 7天折30天收入
    b.chapters_l20_publish_l7d, -- 最近7天以上发布的末尾20章--发布日期后的7天内的阅币消耗
    b.chapters_l20_last_7d, -- 最近7天以上发布的末尾20章-最近7天内的阅币消耗
    a.read_last_30d, -- 30天阅读人数
    a.consume_last_30d, -- 30天消费人数
    f.to_book_name,
    f.book_status,
    f.foreigning_count,
    f.proofreading_count,
    f.collecting_by_foreign,
    e.no_proofread_length,
    g.cost_amt_curmon,
    g.amount_curmon,
    f.remark,
    now() as etl_time
FROM  `ads`.`ads_bi_content_translate_remuneration_plan` a
LEFT JOIN (
            SELECT
                a.book_id,
                SUM(case WHEN days_diff(c.createtime,a.public_time) < 7 THEN c.amount end) chapters_l20_publish_l7d, --发布7天内消费
                SUM(case WHEN days_diff(current_timestamp(),c.createtime) < 7 THEN c.amount end) chapters_l20_last_7d --近7天内消费
            FROM (
                     SELECT  book_id,
                             chapter_id,
                             public_time,
                             ROW_NUMBER() over(PARTITION BY book_id ORDER BY  serial_number DESC) rn
                     FROM dim.dim_book_chapter_info
                     WHERE is_full = 0
                       AND Free_Chapter_Num = 1
                       AND days_diff(current_timestamp(), public_time) > 7
                 ) a
                     LEFT JOIN (
                SELECT  pay_type,
                        book_id,
                        cast(chapter_ids   AS array < bigint > ) chapter_ids,
                        types,
                        amount/chapter_num AS amount,
                        createtime,
                        unnest.chapter_id chapter_id
                FROM dwd.dwd_consume_user_consume, unnest (cast(chapter_ids AS array < bigint > )) AS unnest(chapter_id)
                WHERE amount > 0
                  AND dt >= days_add(current_timestamp(), -60)
                  AND types = 1
            ) c
                               ON a.book_id = c.book_id
                                   AND a.chapter_id = c.chapter_id
            WHERE a.rn < 21
    GROUP BY a.book_id
) b
ON a.target_book_id = b.book_id
LEFT JOIN (
            select a.tobookid, a.ToLanguage, a.frombookid,a.interpreterNumber,a.foreignNumber,a.proofreadNumber,a.editPublishNumber,a.ChapterPlusNumByDay,a.ChapterPlusNumByWeek,a.PublishingCount,a.UpdateTime
            from(
                    select tobookid*1000+tolanguage as tobookid,ToLanguage,CASE WHEN FromLanguage = 0 THEN FromBookId ELSE FromBookId*1000+FromLanguage END as frombookid,
                           interpreterNumber,foreignNumber,proofreadNumber,editPublishNumber,ChapterPlusNumByDay,ChapterPlusNumByWeek,PublishingCount,max(UpdateTime) as UpdateTime
                    from ods.ods_edit_book_LanguageBookTotal
                    where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                    group by 1,2,3,4,5,6,7,8,9,10
                 )a
            inner join(
                          select tobookid*1000+tolanguage as tobookid,max(UpdateTime) as UpdateTime
                          from ods.ods_edit_book_LanguageBookTotal
                          where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                          group by 1
                      )b
            on a.tobookid=b.tobookid
            and a.UpdateTime=b.UpdateTime
    ) c
ON a.target_book_id = c.tobookid
LEFT JOIN dim.dim_shuangwen_book_read_consume_info d
    ON c.frombookid = d.book_id
LEFT JOIN tmp_language_book_total f
    ON a.dt = f.dt
    AND a.target_book_id = f.to_book_id
LEFT JOIN (
            SELECT dt, (ToBookId*1000+ToLanguage) AS to_book_id, NoProofreadLength AS no_proofread_length
            FROM ods.ods_tidb_shuangwen_en_bookcapacitymonitoring
            where dt > '2023-03-26'
          ) e   -- 2023-03-26这天后端系统上线， 有脏数据
    ON a.dt = e.dt
    AND a.target_book_id = e.to_book_id
LEFT JOIN (
            SELECT dt,book_id,cost_amt_curmon,amount_curmon
            FROM ads.ads_report_cost_income_read_stat
          ) g
    ON a.dt = g.dt
    AND a.target_book_id = g.book_id
WHERE a.dt = '${dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_translate_remuneration_plan_p_da
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_content_translate_remuneration_plan_p_da
-- task_version     : 4
-- update_time      : 2025-05-29 13:52:51
-- sql_path         : \starrocks\tbl_ads_content_translate_remuneration_plan_p_da\ads_content_translate_remuneration_plan_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO `ads`.`ads_content_translate_remuneration_plan_p_da`

with tmp_language_book_total AS (
    SELECT
        DATE(StatisticsDate) AS dt,
        (ToBookId*1000+ToLanguage) AS to_book_id,
        MAX(tobookname) AS to_book_name,
        MAX(BookStatus) AS book_status,
        MAX(ForeigningCount) AS foreigning_count,
        MAX(ProofreadingCount) AS proofreading_count,
        MAX(CollectionByForeign) AS collecting_by_foreign,
        MAX(Remark) AS remark
FROM ods.ods_edit_book_LanguageBookTotal
    GROUP BY  DATE(StatisticsDate), (ToBookId*1000+ToLanguage)   -- 同一个统计日期有多条数据，取MAX值
)

SELECT
    a.dt,
    a.target_book_id,
    a.first_translate_day, -- 第一次翻译时间
    a.translate_days,  -- 翻译天数
    a.sug_straw_words,
    a.chapter_plus_by_day,  -- 每日常规章节
    a.chapter_plus_by_week,  -- 周期加更数
    a.book_language_id,  -- 语种
    a.second_checkout_person, -- 二校
    a.book_code, -- 书编码
    a.book_cn_name, -- 书中文名称
    a.avg_chapter_words, -- 章均字数
    a.published_words, -- 发布字数
    a.proofread_words, -- 精修字数
    a.income_rank_last_30day,  -- 本月收入排名
    a.total_income_rank,  -- 累计收入排名
    a.interpreter_number,  -- 已质检
    a.foreign_number,  -- 已一校
    a.proofread_number, -- 已精修
    a.published_number, -- 已发布
    a.has_straw_chapters,  -- 囤稿量章节
    d.public_fontlength AS source_published_words, -- 源书发布字数
    d.normal_chapter_num_f AS source_published_chapters, -- 源书发布章节数
    a.income_last_7d, -- 近7天收入
    a.income_last_30d, -- 近30天收入
    a.income_last_7d_30d, -- 7天折30天收入
    b.chapters_l20_publish_l7d, -- 最近7天以上发布的末尾20章--发布日期后的7天内的阅币消耗
    b.chapters_l20_last_7d, -- 最近7天以上发布的末尾20章-最近7天内的阅币消耗
    a.read_last_30d, -- 30天阅读人数
    a.consume_last_30d, -- 30天消费人数
    f.to_book_name,
    f.book_status,
    f.foreigning_count,
    f.proofreading_count,
    f.collecting_by_foreign,
    e.no_proofread_length,
    g.cost_amt_curmon,
    g.amount_curmon,
    f.remark,
    now() as etl_time
FROM  `ads`.`ads_bi_content_translate_remuneration_plan` a
LEFT JOIN (
            SELECT
                a.book_id,
                SUM(case WHEN days_diff(c.createtime,a.public_time) < 7 THEN c.amount end) chapters_l20_publish_l7d, --发布7天内消费
                SUM(case WHEN days_diff(current_timestamp(),c.createtime) < 7 THEN c.amount end) chapters_l20_last_7d --近7天内消费
            FROM (
                     SELECT  book_id,
                             chapter_id,
                             public_time,
                             ROW_NUMBER() over(PARTITION BY book_id ORDER BY  serial_number DESC) rn
                     FROM dim.dim_book_chapter_info
                     WHERE is_full = 0
                       AND Free_Chapter_Num = 1
                       AND days_diff(current_timestamp(), public_time) > 7
                 ) a
                     LEFT JOIN (
                SELECT  pay_type,
                        book_id,
                        cast(chapter_ids   AS array < bigint > ) chapter_ids,
                        types,
                        amount/chapter_num AS amount,
                        createtime,
                        unnest.chapter_id chapter_id
                FROM dwd.dwd_consume_user_consume, unnest (cast(chapter_ids AS array < bigint > )) AS unnest(chapter_id)
                WHERE amount > 0
                  AND dt >= days_add(current_timestamp(), -60)
                  AND types = 1
            ) c
                               ON a.book_id = c.book_id
                                   AND a.chapter_id = c.chapter_id
            WHERE a.rn < 21
    GROUP BY a.book_id
) b
ON a.target_book_id = b.book_id
LEFT JOIN (
            select a.tobookid, a.ToLanguage, a.frombookid,a.interpreterNumber,a.foreignNumber,a.proofreadNumber,a.editPublishNumber,a.ChapterPlusNumByDay,a.ChapterPlusNumByWeek,a.PublishingCount,a.UpdateTime
            from(
                    select tobookid*1000+tolanguage as tobookid,ToLanguage,CASE WHEN FromLanguage = 0 THEN FromBookId ELSE FromBookId*1000+FromLanguage END as frombookid,
                           interpreterNumber,foreignNumber,proofreadNumber,editPublishNumber,ChapterPlusNumByDay,ChapterPlusNumByWeek,PublishingCount,max(UpdateTime) as UpdateTime
                    from ods.ods_edit_book_LanguageBookTotal
                    where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                    group by 1,2,3,4,5,6,7,8,9,10
                 )a
            inner join(
                          select tobookid*1000+tolanguage as tobookid,max(UpdateTime) as UpdateTime
                          from ods.ods_edit_book_LanguageBookTotal
                          where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                          group by 1
                      )b
            on a.tobookid=b.tobookid
            and a.UpdateTime=b.UpdateTime
    ) c
ON a.target_book_id = c.tobookid
LEFT JOIN dim.dim_shuangwen_book_read_consume_info d
    ON c.frombookid = d.book_id
LEFT JOIN tmp_language_book_total f
    ON a.dt = f.dt
    AND a.target_book_id = f.to_book_id
LEFT JOIN (
            SELECT dt, (ToBookId*1000+ToLanguage) AS to_book_id, NoProofreadLength AS no_proofread_length
            FROM ods.ods_tidb_shuangwen_en_bookcapacitymonitoring
            where dt > '2023-03-26'
          ) e   -- 2023-03-26这天后端系统上线， 有脏数据
    ON a.dt = e.dt
    AND a.target_book_id = e.to_book_id
LEFT JOIN (
            SELECT dt,book_id,cost_amt_curmon,amount_curmon
            FROM ads.ads_report_cost_income_read_stat
          ) g
    ON a.dt = g.dt
    AND a.target_book_id = g.book_id
WHERE a.dt = '${bf_1_dt}';
