----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cv_gdt_ad_roi_warning
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_cv_gdt_ad_roi_warning
-- task_version     : 3
-- update_time      : 2024-08-12 17:44:39
-- sql_path         : \starrocks\tbl_ads_cv_gdt_ad_roi_warning\ads_cv_gdt_ad_roi_warning
----------------------------------------------------------------
-- SQL语句
INSERT INTO  ads.ads_cv_gdt_ad_roi_warning

--1小时前的广告投放与收入
WITH bf_1_h_consume_income AS (
    SELECT
            AdId AS ad_id,
            date_start AS start_hour,
            date_stop AS end_hour,
            SUM(Spend) AS ad_consume,
            SUM(Amount) AS ad_income
    FROM ods.ods_tidb_cv_sharpengine_ads_global_AdIncomeDailyInsight_da
    WHERE SourceChl  = 'tengxun'                                                                                        -- 过滤出广点通的广告
     AND  date_start >= DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H')                                     --  过滤出以当前时间为准的3小时之前的数据
     AND  date_start < DATE_FORMAT(NOW(),'%Y-%m-%d %H')
    GROUP BY  1,2,3
) ,

--2小时前的广告投放与收入
bf_2_h_consume_income AS (
    SELECT
            AdId AS ad_id,
            date_start AS start_hour,
            date_stop AS end_hour,
            SUM(Spend) AS ad_consume,
            SUM(Amount) AS ad_income
    FROM ods.ods_tidb_cv_sharpengine_ads_global_AdIncomeDailyInsight_da
    WHERE SourceChl  = 'tengxun'                                                                                        -- 过滤出广点通的广告
    AND  date_start >= DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H')                                     --  过滤出以当前时间为准的3小时之前的数据
    AND  date_start < DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H')
    GROUP BY  1,2,3
) ,

--3小时前的广告投放与收入
bf_3_h_consume_income AS (
    SELECT
        AdId AS ad_id,
        date_start AS start_hour,
        date_stop AS end_hour,
        SUM(Spend) AS ad_consume,
        SUM(Amount) AS ad_income
    FROM ods.ods_tidb_cv_sharpengine_ads_global_AdIncomeDailyInsight_da
    WHERE SourceChl  = 'tengxun'                                                                                        -- 过滤出广点通的广告
    AND  date_start >= DATE_FORMAT(date_sub(NOW(), INTERVAL 3 HOUR),'%Y-%m-%d %H')                                     --  过滤出以当前时间为准的3小时之前的数据
    AND  date_start < DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H')
    GROUP BY  1,2,3
) ,
--
day_consume_ad_income AS (
    SELECT
        AdId AS ad_id,
        SUM(Spend) AS day_ad_consume,
        SUM(Amount) AS day_ad_income
    FROM ods.ods_tidb_cv_sharpengine_ads_global_AdIncomeDailyInsight_da
    WHERE SourceChl  = 'tengxun'                                                                                        -- 过滤出广点通的广告
      AND  date_start >= DATE_FORMAT(NOW(),'%Y-%m-%d')                                     --  过滤出以当前时间为准的3小时之前的数据
      AND  date_start < DATE_FORMAT(date_sub(NOW(), INTERVAL -1 DAY),'%Y-%m-%d')
    GROUP BY  1
),

--广告投放与收入  前1个小时与前2个小时合并
ad_consume_income_bf1_bf2 AS (
    SELECT
            coalesce(a.ad_id,b.ad_id)  AS ad_id,
            a.start_hour AS bf_1_h_start,
            a.end_hour AS bf_1_h_end,
            a.ad_consume AS bf_1_h_consume,
            a.ad_income AS bf_1_h_ad_income,
            b.start_hour AS bf_2_h_start,
            b.end_hour AS bf_2_h_end,
            b.ad_consume AS bf_2_h_consume,
            b.ad_income AS bf_2_h_ad_income
    FROM bf_1_h_consume_income  a
    FULL JOIN bf_2_h_consume_income b
    ON a.ad_id = b.ad_id
) ,

--广告投放与收入 前1个小时与前2个小时合并后的结果再与前3个小时的合并
ad_consume_income AS (
 SELECT
     coalesce(a.ad_id,b.ad_id)  AS ad_id,
     a.bf_1_h_start AS bf_1_h_start,
     a.bf_1_h_end AS bf_1_h_end,
     a.bf_1_h_consume AS bf_1_h_consume,
     a.bf_1_h_ad_income AS bf_1_h_ad_income,
     a.bf_2_h_start AS bf_2_h_start,
     a.bf_2_h_end AS bf_2_h_end,
     a.bf_2_h_consume AS bf_2_h_consume,
     a.bf_2_h_ad_income AS bf_2_h_ad_income,
     b.start_hour AS bf_3_h_start,
     b.end_hour AS bf_3_h_end,
     b.ad_consume AS bf_3_h_consume,
     b.ad_income AS bf_3_h_ad_income
 FROM ad_consume_income_bf1_bf2  a
          FULL JOIN bf_3_h_consume_income b
                    ON a.ad_id = b.ad_id
) ,

tmp_ad_user_install AS (
    SELECT
            user_id,
            core,
            install_date,
            remarketing_time,                                                                                           -- --再营销时间
            CASE
                WHEN ((ad_id IS NULL) OR (ad_id = '')) THEN (concat('AdId=none|SourceChl=', CASE WHEN ((`Source` IS NULL) OR (`Source` = '')) THEN 'none' ELSE `Source` END, '|Mt=', concat(`Mt`, ''), '|Core=', concat(`Core`, ''), '|Chl2=', CASE WHEN ((`Chl2` IS NULL) OR (`Chl2` = '')) THEN 'none' ELSE `Chl2` END, '|CurrentLanguage2=', concat(`Current_Language2`, '')))
                ELSE ad_id
            END AS `ad_id`,
            next_attribute_time,     --下一次归因时间
            Unique_CdReaderId        -- 设备信息
        FROM  dwd.dwd_user_install_info_ed_view
        WHERE  is_remarketing = 0  --非再营销
               AND adaccount_id !='6498009b0c801c4baafeb622'
               AND product_id = '6883'
               AND user_id > 0
               AND dt >= date_format(date_sub(current_time(), INTERVAL 4 HOUR), '%Y-%m-%d')
),
-- 充值
recharge AS (
    SELECT
            a.ad_id AS ad_id,
            SUM(CASE WHEN (a.install_date >= DATE_FORMAT(NOW(),'%Y-%m-%d')) THEN a.amount ELSE 0 END) AS day_recharge_income,
            SUM(CASE WHEN (a.install_date >= DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H')) AND (a.install_date < DATE_FORMAT(NOW(),'%Y-%m-%d %H')) THEN a.amount ELSE 0 END) AS bf_1_h_recharge_income,   -- 前1个小时的充值收入
            SUM(CASE WHEN (a.install_date >= DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H')) AND (a.install_date < DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H')) THEN a.amount ELSE 0 END) AS bf_2_h_recharge_income,   -- 前2个小时的充值收入
            SUM(CASE WHEN (a.install_date >= DATE_FORMAT(date_sub(NOW(), INTERVAL 3 HOUR),'%Y-%m-%d %H')) AND (a.install_date < DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H')) THEN a.amount ELSE 0 END) AS bf_3_h_recharge_income   -- 前3个小时的充值收入
    FROM (
            SELECT
                    base_amount_rmb AS amount,
                    video_user_id,
                    b.install_date AS install_date,
                    b.ad_id AS ad_id
             FROM dwd.dwd_trade_video_cn_payorder_view pay                                                               --消耗域国内短剧支付明细视图
            INNER JOIN tmp_ad_user_install b
                ON  pay.video_user_id = b.Unique_CdReaderId
                    AND pay.core = b.core
                    AND pay.create_time >= b.install_date                                              --支付时间大于激活安装时间
                    AND pay.create_time <= b.next_attribute_time                                               --支付时间小于下一次归因时间
                    AND pay.create_time <= b.remarketing_time                                                    --支付时间小于等于再营销时间
            WHERE  pay.dt >= date_format(date_sub(current_time(), INTERVAL 4 HOUR), '%Y-%m-%d')
                AND pay.coo_order_status = 1
                AND pay.test_flag = 0
                AND pay.product_id = '6883'                                                                        --产品为国内短剧
        ) a
  GROUP BY  a.ad_id
) ,
-- 广告账户相关信息
ad_info AS (
    SELECT
            a.ad_id,
            a.ad_name,
            b.nick_name,
            c.campaign_name,
            d.product_name,
            a.fb_account,
            f.ding_user_id
    FROM  (
                SELECT
                    ad_id,
                    create_time,
                    ad_name,                                                                                        --广告名称
                    invite_code,                                                                                    --代理编码
                    ad_camp_id,                                                                                     --广告系统
                    fb_account
                FROM  dwd.dwd_advertisement_adext_view                                                              --广告信息表
                WHERE  product_id = 6883
            ) a
    LEFT OUTER JOIN dim.dim_ads_role_users_view  b                                                                  --国剧账户信息表
          ON  a.invite_code = b.ref_id
    LEFT OUTER JOIN (
                        SELECT
                            campaign_name,
                            camp_id
                        FROM dim.dim_advertisement_third_ad_campaign_view                                           --广告项目表
                        WHERE  ad_platform_id > 0
                    ) c
            ON  a.ad_camp_id = c.camp_id
    LEFT OUTER JOIN (
                        SELECT
                            account,
                            product_name
                        FROM  dim.dim_advertisement_third_ad_account_view                                           --苹果和国内短剧的投放账号表
                        WHERE  (ad_platform_id > 0)
                        AND (product_id = 6883)
                    ) d
            ON  a.fb_account = d.account
    LEFT OUTER JOIN (
                    SELECT
                        nick_name,
                        ding_user_id
                    FROM  dim.dim_kpi_user_info_view
                    WHERE  (del_flag = 0)
                    AND (ding_user_id IS NOT NULL)
              ) f
            ON  b.nick_name = f.nick_name
)

SELECT
        res.stat_date_h,
        res.ad_id,
        res.ad_name,
        res.nick_name,
        res.product_name,
        res.campaign_name,
        res.account_id,
        res.ding_user_id,
        res.bf_1_h_start,
        res.bf_1_h_end,
        res.bf_1_h_consume,
        res.bf_1_h_ad_income,
        ifnull(round((res.bf_1_h_ad_income / res.bf_1_h_consume) * 100, 2), 0.00) AS bf_1_h_ad_roi,
        res.bf_1_h_recharge_income,
        ifnull(round((res.bf_1_h_recharge_income / res.bf_1_h_consume) * 100, 2), 0.00) AS bf_1_h_recharge_roi,
        res.bf_2_h_start,
        res.bf_2_h_end,
        res.bf_2_h_consume,
        res.bf_2_h_ad_income,
        ifnull(round((res.bf_2_h_ad_income / res.bf_2_h_consume) * 100, 2), 0.00) AS bf_2_h_ad_roi,
        res.bf_2_h_recharge_income,
        ifnull(round((res.bf_2_h_recharge_income / res.bf_2_h_consume) * 100, 2), 0.00) AS bf_2_h_recharge_roi,
        res.bf_3_h_start,
        res.bf_3_h_end,
        res.bf_3_h_consume,
        res.bf_3_h_ad_income,
        ifnull(round((res.bf_3_h_ad_income / res.bf_3_h_consume) * 100, 2), 0.00) AS bf_3_h_ad_roi,
        res.bf_3_h_recharge_income,
        ifnull(round((res.bf_3_h_recharge_income / res.bf_3_h_consume) * 100, 2), 0.00) AS bf_3_h_recharge_roi,
        res.day_consume,
        res.day_ad_income,
        ifnull(round((res.day_ad_income / res.day_consume) * 100, 2), 0.00) AS day_ad_roi,
        res.day_recharge_income,
        ifnull(round((res.day_recharge_income / res.day_consume) * 100, 2), 0.00) AS day_recharge_roi,
        now() AS etl_tm
FROM (
        SELECT
                DATE_FORMAT(NOW(),'%Y-%m-%d %H') AS stat_date_h,
                a.ad_id,
                c.ad_name,
                c.nick_name,
                c.product_name,
                c.campaign_name,
                c.fb_account AS account_id,
                c.ding_user_id,
                DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H:00') AS bf_1_h_start,
                DATE_FORMAT(date_sub(NOW(), INTERVAL 1 HOUR),'%Y-%m-%d %H:59') AS bf_1_h_end,
                ifnull(round(a.bf_1_h_consume, 2), 0.00) AS bf_1_h_consume,
                ifnull(round(a.bf_1_h_ad_income, 2), 0.00) AS bf_1_h_ad_income,
                ifnull(round(b.bf_1_h_recharge_income, 2), 0.00) AS bf_1_h_recharge_income,
                DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H:00') AS bf_2_h_start,
                DATE_FORMAT(date_sub(NOW(), INTERVAL 2 HOUR),'%Y-%m-%d %H:59') AS bf_2_h_end,
                ifnull(round(a.bf_2_h_consume, 2), 0.00) AS bf_2_h_consume,
                ifnull(round(a.bf_2_h_ad_income, 2), 0.00) AS bf_2_h_ad_income,
                ifnull(round(b.bf_2_h_recharge_income, 2), 0.00) AS bf_2_h_recharge_income,
                a.bf_3_h_start,
                a.bf_3_h_end,
                ifnull(round(a.bf_3_h_consume, 2), 0.00) AS bf_3_h_consume,
                ifnull(round(a.bf_3_h_ad_income, 2), 0.00) AS bf_3_h_ad_income,
                ifnull(round(b.bf_3_h_recharge_income, 2), 0.00) AS bf_3_h_recharge_income,
                ifnull(round(d.day_ad_consume, 2), 0.00) AS day_consume,
                ifnull(round(d.day_ad_income, 2), 0.00) AS day_ad_income,
                ifnull(round(b.day_recharge_income, 2), 0.00) AS day_recharge_income
        FROM ad_consume_income  a
        LEFT OUTER JOIN recharge b
            ON a.ad_id = b.ad_id
        LEFT OUTER JOIN ad_info c
            ON a.ad_id = c.ad_id
        LEFT OUTER JOIN day_consume_ad_income d
            ON a.ad_id = d.ad_id
    ) res;
