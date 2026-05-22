----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_content_translate_remuneration_plan_p_da
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_bi_content_translate_remuneration_plan
-- task_version     : 1
-- update_time      : 2025-05-06 15:35:46
-- sql_path         : \starrocks\sch_ads_content_translate_remuneration_plan_p_da\ads_bi_content_translate_remuneration_plan
----------------------------------------------------------------
-- SQL语句
INSERT INTO `ads`.`ads_bi_content_translate_remuneration_plan`
SELECT
    a.dt,
    a.ToBookId*1000+a.ToLanguage,
    b.first_translate_day, -- 第一次翻译时间
    DATEDIFF(CURRENT_DATE(),b.first_translate_day),  -- 翻译天数
    CASE WHEN a.PublishLength > 300000 AND e.ChapterPlusNumByDay >= 1 THEN (e.ChapterPlusNumByDay*30 + 20 - e.PublishingCount) * (CASE WHEN a.PublishNumber = 0 THEN 0 ELSE ROUND(a.PublishLength / PublishNumber,0) END)
         WHEN a.PublishLength > 300000 AND e.ChapterPlusNumByDay < 1 THEN (e.ChapterPlusNumByDay*30 + 5 - e.PublishingCount) * (CASE WHEN a.PublishNumber = 0 THEN 0 ELSE ROUND(a.PublishLength / PublishNumber,0) END)
         WHEN a.PublishLength > 300000 AND d.amount_7/7*30 < 1000 THEN '建议停更'
         WHEN a.PublishLength > 300000 AND d.amount_7/7*30 < 5000 THEN '建议减少国稿'
        END,
    e.ChapterPlusNumByDay,  -- 每日常规章节
    e.ChapterPlusNumByWeek,  -- 周期加更数
    a.ToLanguage,  -- 语种
    a.ProofreadName, -- 二校
    a.BookCode, -- 书编码
    a.CNBookName, -- 书中文名称
    CASE a.PublishNumber WHEN  0 THEN 0 ELSE a.PublishLength / PublishNumber END, -- 章均字数
    a.PublishLength, -- 发布字数
    a.ProofreadLength, -- 精修字数
    b.amount_curmon_sort,  -- 本月收入排名
    b.amount_YTD_sort,  -- 累计收入排名
    e.interpreterNumber,  -- 已质检
    e.foreignNumber,  -- 已一校
    e.proofreadNumber, -- 已精修
    e.editPublishNumber, -- 已发布
    e.proofreadNumber - e.editPublishNumber,  -- 囤稿量章节
    d.amount_7, -- 近7天收入
    d.amount_30, -- 近30天收入
    d.amount_7/7*30, -- 7天折30天收入
    d.read_30d_unt, -- 30天阅读人数
    d.consume_30d_unt, -- 30天消费人数
    now() as etl_time
FROM  ods.ods_tidb_shuangwen_en_bookcapacitymonitoring a
LEFT JOIN  ads.ads_report_book_capacity_rate_stat b
 ON  a.dt = b.dt
 AND  a.ToBookId*1000+a.ToLanguage = b.book_id
LEFT JOIN  dwd.dwd_content_book_capacity_daily c
 ON  a.dt = c.dt
AND a.ToBookId*1000+a.ToLanguage = c.to_book_id
LEFT JOIN ads.ads_report_cost_income_read_stat d
 ON a.dt = d.dt
AND a.ToBookId*1000+a.ToLanguage = d.book_id
LEFT JOIN (
            select a.tobookid, a.ToLanguage,a.interpreterNumber,a.foreignNumber,a.proofreadNumber,a.editPublishNumber,a.ChapterPlusNumByDay,a.ChapterPlusNumByWeek,a.PublishingCount,a.UpdateTime
            from(
                    select tobookid*1000+tolanguage as tobookid,ToLanguage,interpreterNumber,foreignNumber,proofreadNumber,editPublishNumber,ChapterPlusNumByDay,ChapterPlusNumByWeek,PublishingCount,max(UpdateTime) as UpdateTime
                    from ods.ods_edit_book_LanguageBookTotal
                    where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                    group by 1,2,3,4,5,6,7,8,9
                )a
            inner join
                      (
                          select tobookid*1000+tolanguage as tobookid,max(UpdateTime) as UpdateTime
                          from ods.ods_edit_book_LanguageBookTotal
                          where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                          group by 1
                      )b
            on a.tobookid=b.tobookid
            and a.UpdateTime=b.UpdateTime
        ) e
ON a.ToBookId*1000+a.ToLanguage = e.tobookid
WHERE a.dt = '${dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_content_translate_remuneration_plan
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : ads_bi_content_translate_remuneration_plan
-- task_version     : 8
-- update_time      : 2025-05-06 15:28:58
-- sql_path         : \starrocks\tbl_ads_bi_content_translate_remuneration_plan\ads_bi_content_translate_remuneration_plan
----------------------------------------------------------------
-- SQL语句
INSERT INTO `ads`.`ads_bi_content_translate_remuneration_plan`
SELECT
    a.dt,
    a.ToBookId*1000+a.ToLanguage,
    b.first_translate_day, -- 第一次翻译时间
    DATEDIFF(CURRENT_DATE(),b.first_translate_day),  -- 翻译天数
    CASE WHEN a.PublishLength > 300000 AND e.ChapterPlusNumByDay >= 1 THEN (e.ChapterPlusNumByDay*30 + 20 - e.PublishingCount) * (CASE WHEN a.PublishNumber = 0 THEN 0 ELSE ROUND(a.PublishLength / PublishNumber,0) END)
         WHEN a.PublishLength > 300000 AND e.ChapterPlusNumByDay < 1 THEN (e.ChapterPlusNumByDay*30 + 5 - e.PublishingCount) * (CASE WHEN a.PublishNumber = 0 THEN 0 ELSE ROUND(a.PublishLength / PublishNumber,0) END)
         WHEN a.PublishLength > 300000 AND d.amount_7/7*30 < 1000 THEN '建议停更'
         WHEN a.PublishLength > 300000 AND d.amount_7/7*30 < 5000 THEN '建议减少国稿'
        END,
    e.ChapterPlusNumByDay,  -- 每日常规章节
    e.ChapterPlusNumByWeek,  -- 周期加更数
    a.ToLanguage,  -- 语种
    a.ProofreadName, -- 二校
    a.BookCode, -- 书编码
    a.CNBookName, -- 书中文名称
    CASE a.PublishNumber WHEN  0 THEN 0 ELSE a.PublishLength / PublishNumber END, -- 章均字数
    a.PublishLength, -- 发布字数
    a.ProofreadLength, -- 精修字数
    b.amount_curmon_sort,  -- 本月收入排名
    b.amount_YTD_sort,  -- 累计收入排名
    e.interpreterNumber,  -- 已质检
    e.foreignNumber,  -- 已一校
    e.proofreadNumber, -- 已精修
    e.editPublishNumber, -- 已发布
    e.proofreadNumber - e.editPublishNumber,  -- 囤稿量章节
    d.amount_7, -- 近7天收入
    d.amount_30, -- 近30天收入
    d.amount_7/7*30, -- 7天折30天收入
    d.read_30d_unt, -- 30天阅读人数
    d.consume_30d_unt, -- 30天消费人数
    now() as etl_time
FROM  ods.ods_tidb_shuangwen_en_bookcapacitymonitoring a
LEFT JOIN  ads.ads_report_book_capacity_rate_stat b
 ON  a.dt = b.dt
 AND  a.ToBookId*1000+a.ToLanguage = b.book_id
LEFT JOIN  dwd.dwd_content_book_capacity_daily c
 ON  a.dt = c.dt
AND a.ToBookId*1000+a.ToLanguage = c.to_book_id
LEFT JOIN ads.ads_report_cost_income_read_stat d
 ON a.dt = d.dt
AND a.ToBookId*1000+a.ToLanguage = d.book_id
LEFT JOIN (
            select a.tobookid, a.ToLanguage,a.interpreterNumber,a.foreignNumber,a.proofreadNumber,a.editPublishNumber,a.ChapterPlusNumByDay,a.ChapterPlusNumByWeek,a.PublishingCount,a.UpdateTime
            from(
                    select tobookid*1000+tolanguage as tobookid,ToLanguage,interpreterNumber,foreignNumber,proofreadNumber,editPublishNumber,ChapterPlusNumByDay,ChapterPlusNumByWeek,PublishingCount,max(UpdateTime) as UpdateTime
                    from ods.ods_edit_book_LanguageBookTotal
                    where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                    group by 1,2,3,4,5,6,7,8,9
                )a
            inner join
                      (
                          select tobookid*1000+tolanguage as tobookid,max(UpdateTime) as UpdateTime
                          from ods.ods_edit_book_LanguageBookTotal
                          where (case when FromBookId in (92641090,168177,104925090)  then ToLanguage != 375 else 1 = 1 end) and date(StatisticsDate) < '${dt}'
                          group by 1
                      )b
            on a.tobookid=b.tobookid
            and a.UpdateTime=b.UpdateTime
        ) e
ON a.ToBookId*1000+a.ToLanguage = e.tobookid
WHERE a.dt = '${bf_1_dt}';
