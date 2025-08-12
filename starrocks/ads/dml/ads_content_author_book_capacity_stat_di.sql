INSERT INTO ads.ads_content_author_book_capacity_stat_di
-- 短剧翻译（取字数）
WITH type1_tmp AS (
    SELECT
        CONCAT(SUBSTRING(CAST(a.BillDate AS VARCHAR),1,4),'-',SUBSTRING(CAST(a.BillDate AS VARCHAR),5,2),'-01') AS dt,
        a.AuthorId AS author_id,
        a.SourceBookId AS book_id,
        a.ToLanguage AS language_id,
        a.SourceBookName AS book_name,
        MAX(1) AS type_id,
        MAX(a.PenName) AS pen_name,
        MAX(ifnull(a.RealName,a.PenName)) AS real_name,
        SUM(a.FontLength) AS capacity_value
    FROM ods.ods_tidb_shuangwen_en_translateremuneration a
    WHERE a.RoleType = 1   -- 过滤译员
      AND a.BookType = 3   -- 过滤短剧
      AND a.SourceBookName NOT LIKE '%素材%'  -- 过滤书籍名称不包含素材
      AND a.SourceBookName NOT LIKE '%短剧剧名&简介%'  -- 过滤书籍名称不包含短剧剧名&简介
      AND a.SourceBookName is not  null
      AND a.SourceBookName != ''
GROUP BY 1,2,3,4,5

    ),

-- 短剧审核抽查&初译审核（取字数）
    type2_tmp AS (
SELECT
    CONCAT(SUBSTRING(CAST(a.BillDate AS VARCHAR),1,4),'-',SUBSTRING(CAST(a.BillDate AS VARCHAR),5,2),'-01')  AS dt,
    a.AuthorId AS author_id,
    a.SourceBookId AS book_id,
    a.ToLanguage AS language_id,
    a.SourceBookName AS book_name,
    MAX(2) AS type_id,
    MAX(case when a.PenName='王靖怡-意语(766935)' THEN '王靖怡(766935)' ELSE a.PenName END) AS pen_name,
    MAX(ifnull(a.RealName,a.PenName)) AS real_name,
    SUM(a.FontLength) AS capacity_value
FROM ods.ods_tidb_shuangwen_en_translateremuneration a
WHERE a.RoleType in(6,12)    -- 质检抽查与初译审核
  AND a.BookType = 3   -- 过滤短剧
  AND a.SourceBookName is not  null
  AND a.SourceBookName != ''
GROUP BY 1,2,3,4,5

    ),

-- 测试稿审核（取数据条数）
    type3_tmp AS (
SELECT
    CONCAT(SUBSTRING(CAST(a.BillDate AS VARCHAR),1,4),'-',SUBSTRING(CAST(a.BillDate AS VARCHAR),5,2),'-01')  AS dt,
    a.AuthorId AS author_id,
    a.SourceBookId AS book_id,
    a.ToLanguage AS language_id,
    a.SourceBookName AS book_name,
    MAX(3) AS type_id,
    MAX(case when a.PenName='王靖怡-意语(766935)' THEN '王靖怡(766935)' ELSE a.PenName END ) AS pen_name,
    MAX(ifnull(a.RealName,a.PenName)) AS real_name,
    COUNT(1) AS capacity_value
FROM ods.ods_tidb_shuangwen_en_translateremuneration a
WHERE a.RoleType in(8,9)    -- 国内测试稿审核，国外测试稿审核
GROUP BY 1,2,3,4,5
    ),

-- 素材翻译（取字数）
    type4_tmp AS (
SELECT
    CONCAT(SUBSTRING(CAST(a.BillDate AS VARCHAR),1,4),'-',SUBSTRING(CAST(a.BillDate AS VARCHAR),5,2),'-01')  AS dt,
    a.AuthorId AS author_id,
    a.SourceBookId AS book_id,
    a.ToLanguage AS language_id,
    a.SourceBookName AS book_name,
    MAX(4) AS type_id,
    MAX(a.PenName) AS pen_name,
    MAX(ifnull(a.RealName,a.PenName)) AS real_name,
    SUM(a.FontLength) AS capacity_value
FROM ods.ods_tidb_shuangwen_en_translateremuneration a
WHERE a.RoleType = 1   -- 过滤译员
  AND a.BookType = 3   -- 过滤短剧
  AND (a.SourceBookName  LIKE '%素材%'  -- 过滤书籍名称包含素材
  OR a.SourceBookName  LIKE '%短剧剧名&简介%')  -- 过滤书籍名称包含素材
  AND a.SourceBookName is not  null
  AND a.SourceBookName != ''
GROUP BY 1,2,3,4,5
    ),

-- 词条翻译（取完成字数）
    type5_tmp0 AS (
SELECT
    CAST(DATE(a.ComplteTime) AS VARCHAR) AS dt,
    a.InterpreterId AS author_id,
    0 AS book_id,
    a.FLanguage AS language_id,
    MAX(5) AS type_id,
    MAX(CONCAT(a.InterpreterName,'(',a.Interpreter,')')) AS pen_name,
    MAX(a.InterpreterName) AS real_name,
    MAX(NULL) AS book_name,
    SUM(a.NumberWord) AS capacity_value
FROM ods.ods_mysql_AppTranslationDB_TranslationTask_da a
WHERE a.TaskStatus = 1  -- 翻译状态已完成
  and a.ComplteTime is not null
  and a.InterpreterId is not null
  and a.InterpreterName is not null
GROUP BY 1,2,3,4
    ),

    type5_tmp AS (
SELECT
    a.dt,
    a.author_id,
    a.book_id,
    a.language_id,
    a.type_id,
    IFNULL(b.PenName,a.real_name) AS pen_name,
    IFNULL(b.real_name,a.real_name) AS real_name,
    a.book_name,
    a.capacity_value
FROM type5_tmp0 a
    LEFT JOIN (select PenName ,MAX(RealName) AS real_name FROM ods.ods_tidb_shuangwen_xx_objectauthor GROUP BY PenName)  b
ON a.real_name = split(b.PenName,'(')[1]
    ),

    type6_tmp AS (
SELECT
    a.CreateTime AS dt,
    a.AuthorId AS author_id,
    a.bookId AS book_id,
    a.ToLanguage AS language_id,
    6 AS type_id,
    b.PenName AS pen_name,
    b.RealName AS real_name,
    c.BookName AS book_name,
    a.FontLength AS capacity_value
FROM ods.ods_edit_book_RemunerationDetail a
    INNER JOIN ods.ods_tidb_shuangwen_en_objectbook c
ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
    AND c.ObjectBookType = 1   -- 短剧项目
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
    ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
WHERE RoleType = 18  -- 词典创建
    )

SELECT  md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type1_tmp
UNION ALL
SELECT md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type2_tmp
UNION ALL
SELECT md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type3_tmp
UNION ALL
SELECT md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type4_tmp
UNION ALL
SELECT md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type5_tmp
UNION ALL
SELECT md5(concat_ws('_',date(dt),author_id,book_name,language_id,type_id,book_id)) as md5_key,date(dt),author_id,book_id,language_id,type_id,case when pen_name='王靖怡-意语(766935)' THEN '王靖怡(766935)' when pen_name='陈佳慧' THEN '陈佳慧(540469)' ELSE pen_name END as pen_name,real_name,book_name,capacity_value, NOW() FROM type6_tmp
