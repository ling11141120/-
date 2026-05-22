----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_short_novel_ad_tf_p_di
-- workflow_version : 9
-- create_user      : xixg
-- task_name        : ads_short_novel_ad_tf_p_di
-- task_version     : 5
-- update_time      : 2024-09-19 15:14:28
-- sql_path         : \starrocks\tbl_ads_short_novel_ad_tf_p_di\ads_short_novel_ad_tf_p_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_short_novel_ad_tf_p_di
-- 过滤出短篇小说的书
WITH short_novel AS (
    SELECT
        a.productid AS product_id,
        a.BookID AS book_id
    FROM ods.`ods_book_novel_book_m` a
    WHERE (
        a.StoryType = 1
            AND (
            (a.productid = 3311 and a.siteid=410)
                OR (a.productid = 3322 and a.siteid=409)
                OR (a.productid = 3366 and a.siteid in (322,436,445,491))
                or (a.productid = 3371 and a.siteid=418)
                OR (a.productid = 3388 and a.siteid=375)
                OR (a.productid = 3501 and a.siteid=414)
                OR (a.productid = 3511 and a.siteid=433)
                OR (a.productid = 3399 and a.siteid in (419,491))
            )
        )
       OR (a.productid =3333 and a.SiteID  = 449 )
)

SELECT
        '${bf_1_dt}',
        a.book_id,
        SUM(b.cost_amt) AS ad_tf_amount,
        NOW()
 FROM short_novel a
INNER JOIN dws.dws_advertisement_book_cost_amt_cst_ed b
 ON a.book_id = b.book_id
WHERE dt = '${bf_1_dt}'
GROUP BY a.book_id;
