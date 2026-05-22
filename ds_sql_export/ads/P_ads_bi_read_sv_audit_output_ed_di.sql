----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_read_sv_audit_output_ed_di
-- workflow_version : 9
-- create_user      : linq
-- task_name        : ads_bi_read_sv_audit_output_ed_di_new
-- task_version     : 2
-- update_time      : 2026-01-27 20:55:37
-- sql_path         : \starrocks\tbl_ads_bi_read_sv_audit_output_ed_di\ads_bi_read_sv_audit_output_ed_di_new
----------------------------------------------------------------
-- SQL语句
INSERT OVERWRITE  ads.ads_bi_read_sv_audit_output_ed_di
WITH d AS (
    -- 译员配置表
    SELECT SiteId, AuthorId, MonthTime, SUM(monthtarget) AS monthtarget
    FROM (
             SELECT siteid, authorid, monthtime, monthtarget,
                    ROW_NUMBER() OVER (PARTITION BY SiteId, AuthorId, RoleType, MonthTime ORDER BY id DESC) rn
             FROM ods.ods_tidb_shuangwen_en_viscauthorconfig
             WHERE monthtime >= '2024-01-01' AND RoleType = 16 -- 角色只要修改审核的
         ) t1
    WHERE rn = 1
    GROUP BY SiteId, AuthorId, MonthTime
),
     author AS (
         -- 直接查询所有数据，不做任何限制
         SELECT DISTINCT
             ToLanguage,
             AccountId,
             RealName,
             PenName
         FROM
             ods.ods_tidb_shuangwen_xx_objectauthor
     ),
     edit AS (
         SELECT dt, to_language, author_id, author.PenName AS pen_name, author.RealName AS real_name,
                MAX(book_product) AS book_product,
                MAX(book_choucha_product) AS book_choucha_product,
                MAX(book_chuyi_product) AS book_chuyi_product,
                MAX(short_video_product) AS short_video_product,
                MAX(short_video_choucha_product) AS short_video_choucha_product,
                MAX(short_video_chuyi_product) AS short_video_chuyi_product,
                MAX(test_draft) AS test_draft,
                MAX(monthtarget) AS monthtarget
         FROM (
                  -- 网文
                  SELECT a.dt, a.to_language, a.author_id, a.pen_name, a.real_name,
                         a.book_product, a.book_choucha_product, a.book_chuyi_product,
                         a.short_video_product, a.short_video_choucha_product, a.short_video_chuyi_product,
                         a.test_draft, d.monthtarget
                  FROM (
                           SELECT dt, to_language, author_id, pen_name,
                                  IFNULL(real_name, -99) AS real_name,
                                  SUM(font_length) AS book_product,
                                  SUM(IF(role_type IN (10,11,12), font_length, 0)) AS book_choucha_product,
                                  SUM(IF(role_type IN (6,7,4), font_length, 0)) AS book_chuyi_product,
                                  0 AS short_video_product,
                                  0 AS short_video_choucha_product,
                                  0 AS short_video_chuyi_product,
                                  0 AS test_draft
                           FROM dwd.dwd_content_translate_remuneration
                           WHERE role_type IN (10,11,12,6,7,4)
                             AND book_type != 3
              AND dt >= '2024-01-01'
                           GROUP BY dt, to_language, author_id, pen_name, real_name
                       ) a
                           LEFT JOIN d ON a.to_language = d.siteid
                      AND a.author_id = d.authorid
                      AND SUBSTR(a.dt,1,7) = SUBSTR(d.monthtime,1,7)

                  UNION ALL

                  -- 短剧
                  SELECT a.dt, a.to_language, a.author_id, a.pen_name, a.real_name,
                         a.book_product, a.book_choucha_product, a.book_chuyi_product,
                         a.short_video_product, a.short_video_choucha_product, a.short_video_chuyi_product,
                         a.test_draft, d.monthtarget
                  FROM (
                           SELECT dt, to_language, author_id, pen_name,
                                  IFNULL(real_name, -99) AS real_name,
                                  0 AS book_product,
                                  0 AS book_choucha_product,
                                  0 AS book_chuyi_product,
                                  SUM(font_length) AS short_video_product,
                                  SUM(IF(role_type IN (12), font_length, 0)) AS short_video_choucha_product,
                                  SUM(IF(role_type IN (6), font_length, 0)) AS short_video_chuyi_product,
                                  0 AS test_draft
                           FROM dwd.dwd_content_translate_remuneration
                           WHERE role_type IN (12,6)
                             AND book_type = 3
                             AND dt >= '2024-01-01'
                           GROUP BY dt, to_language, author_id, pen_name, real_name
                       ) a
                           LEFT JOIN d ON a.to_language = d.siteid
                      AND a.author_id = d.authorid
                      AND SUBSTR(a.dt,1,7) = SUBSTR(d.monthtime,1,7)

                  UNION ALL

                  -- 测试稿
                  SELECT a.dt, a.to_language, a.author_id, a.pen_name, a.real_name,
                         a.book_product, a.book_choucha_product, a.book_chuyi_product,
                         a.short_video_product, a.short_video_choucha_product, a.short_video_chuyi_product,
                         a.test_draft, d.monthtarget
                  FROM (
                           SELECT dt, to_language, author_id, pen_name,
                                  IFNULL(real_name, -99) AS real_name,
                                  0 AS book_product,
                                  0 AS book_choucha_product,
                                  0 AS book_chuyi_product,
                                  0 AS short_video_product,
                                  0 AS short_video_choucha_product,
                                  0 AS short_video_chuyi_product,
                                  COUNT(1) AS test_draft
                           FROM dwd.dwd_content_translate_remuneration
                           WHERE role_type IN (8,9)
                             AND dt >= '2024-01-01'
                           GROUP BY dt, to_language, author_id, pen_name, real_name
                       ) a
                           LEFT JOIN d ON a.to_language = d.siteid
                      AND a.author_id = d.authorid
                      AND SUBSTR(a.dt,1,7) = SUBSTR(d.monthtime,1,7)
              ) t1
                  LEFT JOIN author ON t1.to_language = author.ToLanguage
             AND t1.author_id = author.AccountId
         GROUP BY dt, to_language, author_id, author.PenName, author.RealName
     )
SELECT dt, to_language, real_name,
       MAX(pen_name) AS pen_name,
       MAX(book_product) AS book_product,
       MAX(book_choucha_product) AS book_choucha_product,
       MAX(book_chuyi_product) AS book_chuyi_product,
       MAX(short_video_product) AS short_video_product,
       MAX(short_video_choucha_product) AS short_video_choucha_product,
       MAX(short_video_chuyi_product) AS short_video_chuyi_product,
       MAX(test_draft) AS test_draft,
       MAX(monthtarget) AS monthtarget,
       MAX(translate_num) AS translate_num,
       MAX(clean_water_cnt) AS clean_water_cnt,
       NOW() AS etl_time
FROM (
         SELECT COALESCE(a.dt, b.dt, c.dt) AS dt,
                COALESCE(a.to_language, b.f_language, c.to_language) AS to_language,
                COALESCE(a.real_name, b.interpreter_name, c.update_by, -99) AS real_name,
                a.pen_name, a.book_product, a.book_choucha_product, a.book_chuyi_product,
                a.short_video_product, a.short_video_choucha_product, a.short_video_chuyi_product,
                a.test_draft, a.monthtarget,
                b.translate_num,
                c.clean_water_cnt
         FROM (
                  SELECT dt, to_language, real_name,
                         ARRAY_JOIN(ARRAY_AGG(pen_name), ',') AS pen_name,
                         SUM(book_product) AS book_product,
                         SUM(book_choucha_product) AS book_choucha_product,
                         SUM(book_chuyi_product) AS book_chuyi_product,
                         SUM(short_video_product) AS short_video_product,
                         SUM(short_video_choucha_product) AS short_video_choucha_product,
                         SUM(short_video_chuyi_product) AS short_video_chuyi_product,
                         SUM(test_draft) AS test_draft,
                         SUM(monthtarget) AS monthtarget
                  FROM edit
                  GROUP BY dt, to_language, real_name
              ) a
                  FULL JOIN (
             -- simple后台 词条翻译
             SELECT DATE(complte_time) AS dt, f_language, interpreter_name, SUM(number_word) AS translate_num
             FROM dwd.dwd_read_content_translation_task_da_view
         WHERE complte_time >= '2024-01-01' AND task_status = 1
         GROUP BY DATE(complte_time), f_language, interpreter_name
     ) b ON a.dt = b.dt AND a.to_language = b.f_language AND a.real_name = b.interpreter_name
FULL JOIN (
        -- c: 清水表
        SELECT
            tmp.dt,
            tmp.update_by, -- 确保这里选出了 update_by
            d2.cd_val AS to_language,
            COUNT(*) AS clean_water_cnt
        FROM (
            SELECT
                DATE(t.update_time) AS dt,
                t.update_by,
                REPLACE(
                    CASE
                        WHEN d1.cd_val_desc = '繁体畅读' THEN '繁体'
                        WHEN RIGHT(d1.cd_val_desc, 2) = '阅读' THEN LEFT(d1.cd_val_desc, LENGTH(d1.cd_val_desc) - 2)
                        ELSE d1.cd_val_desc
                    END, '英文', '英语') AS clean_lang_name
            FROM dwd.dwd_read_sv_content_AdCopyInfo_da_view t
            LEFT JOIN dim.dim_pub_code_mapping_dict d1
                ON t.product_id = d1.cd_val
                AND d1.app_plat = 'pub'
                AND d1.cd_col = 'product_id'
            WHERE t.update_time >= '2024-01-01'
              AND t.status = 1
        ) tmp
        LEFT JOIN dim.dim_pub_code_mapping_dict d2
            ON d2.app_plat = 'pub'
            AND d2.cd_col = 'book_lang_cd'
            AND tmp.clean_lang_name = d2.cd_val_desc
            AND tmp.clean_lang_name <> '国内'
        WHERE d2.cd_val IS NOT NULL
        GROUP BY tmp.dt, tmp.update_by, d2.cd_val
    ) c ON a.dt = c.dt AND a.to_language = c.to_language AND a.real_name = c.update_by
    ) t1
GROUP BY dt, to_language, real_name;
