----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_short_novel_income_p_di
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_short_novel_income_p_di
-- task_version     : 8
-- update_time      : 2024-09-19 15:15:24
-- sql_path         : \starrocks\tbl_ads_short_novel_income_p_di\ads_short_novel_income_p_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_short_novel_income_p_di
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
),
-- 过滤出符合条件的用户订单数据
tmp_user_order AS (
    SELECT
        a.orderid AS order_id,
        a.productid AS product_id,
        a.userid AS user_id,
        a.createtime AS create_time,
        a.VipExpireTime AS vip_expire_time,
        a.itemcount AS order_amount,
        ROW_NUMBER() OVER (PARTITION BY a.productid,a.userid ORDER BY  a.createtime DESC ) rank_num                  -- 当某天有两条订单数据时，取create_time更大的那条数据
    from ods.ods_book_user_payorder a
    WHERE a.ShopItem = '850'
      and a.TestFlag = 0                                                                                             -- 0正式账号充值   1测试账号充值
      and a.VipExpireTime != 'FacServiceId=mobo&Fa'
    and date('${bf_1_dt}') >= date(a.createtime)
    and date('${bf_1_dt}') <= date(a.VipExpireTime)

),

-- 通过订单金额计算出这笔订单平均每天多少钱
tmp_every_day_money AS (
SELECT
        product_id,
        user_id,
        create_time,
        vip_expire_time,
        CASE WHEN order_id = '240618-338895-3388-4ccdd72d01b0412fbf5538ed1b1a6b70' AND '${bf_1_dt}' > '2024-10-19' THEN 0 ELSE order_amount END AS order_amount,    -- 跟产品杨鲁健确认了 240618-338895-3388-4ccdd72d01b0412fbf5538ed1b1a6b70这条年卡订单在这个季卡240719-338895-3388-9fb64348b830453a928d29b138ea42e0到期后年卡失效
        datediff(date(a.vip_expire_time), date(a.create_time)) AS  expire_days
from tmp_user_order a
WHERE rank_num = 1
),

-- 每个用户每天阅读的VIP章节数
tmp_vip_chapters AS (
    SELECT
            a.product_id AS product_id,
            a.user_id AS user_id,
            SUM(con_chapter_nums) AS vip_chapter_num
    FROM dws.dws_consume_user_consume_ed a
    WHERE a.types = 4
     AND a.dt = '${bf_1_dt}'
    GROUP BY 1,2
),

-- 每个用户每天阅读的短篇小说章节数
tmp_short_novel_chapters AS (
    SELECT
            b.product_id AS product_id,
            b.user_id AS user_id,
            b.book_id AS book_id,
            SUM(b.con_chapter_nums) AS short_novel_chapter_num
    FROM short_novel a
    INNER JOIN dws.dws_consume_user_consume_ed b
    ON a.product_id = b.product_id
    AND a.book_id = b.book_id
    WHERE b.types = 4
      AND b.dt = '${bf_1_dt}'
    GROUP BY 1,2,3
),

-- 每本短篇小说每个用户的收入
tmp_book_user_income AS (
    SELECT
         b.product_id AS product_id,
         b.book_id AS book_id,
         b.user_id AS user_id,
         ifnull(((d.order_amount / d.expire_days)/c.vip_chapter_num) * b.short_novel_chapter_num, 0) AS income
     FROM tmp_short_novel_chapters b
     LEFT JOIN tmp_vip_chapters c
        ON b.product_id = c.product_id
        AND b.user_id = c.user_id
    LEFT JOIN tmp_every_day_money d
        ON b.product_id = d.product_id
        AND b.user_id = d.user_id
)

-- 每本书每天所有用户的收入
SELECT
        '${bf_1_dt}' AS dt,
        a.product_id,
        a.book_id,
        IFNULL(SUM(income),0),
        NOW()
FROM short_novel a
INNER JOIN tmp_book_user_income b
    ON a.product_id = b.product_id
    AND a.book_id = b.book_id
    AND b.income > 0
GROUP BY 1,2,3;
