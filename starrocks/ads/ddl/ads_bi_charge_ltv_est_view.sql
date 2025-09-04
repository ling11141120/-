CREATE VIEW `ads_bi_charge_ltv_est_view` (
  `dt` COMMENT "日期,来自stat_period",
  `user_period` COMMENT "用户类型 1：新用户 3：rmt(拉活用户)",
  `product_id` COMMENT "产品id",
  `which_weeks` COMMENT "第几周",
  `which_months` COMMENT "第几月",
  `corever` COMMENT "core",
  `mt` COMMENT "终端",
  `reg_country` COMMENT "国家",
  `country_level` COMMENT "国家等级",
  `current_language2` COMMENT "注册语言",
  `source` COMMENT "3是付费 2是官网  1 是自然和其他 条件：source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3 when source in ('officialsite','(not set)') then 2 else 1",
  `chl2` COMMENT "注册时渠道",
  `chl` COMMENT "最新渠道",
  `source_chl` COMMENT "最新引流渠道",
  `user_ad_source` COMMENT "广告投流用户：0：正常用户，1：vip投流用户",
  `unt`,
  `pay_user_cnt0`,
  `ltv0`,
  `pay_user_cnt1`,
  `ltv1`,
  `pay_user_cnt2`,
  `ltv2`,
  `pay_user_cnt3`,
  `ltv3`,
  `pay_user_cnt4`,
  `ltv4`,
  `pay_user_cnt5`,
  `ltv5`,
  `pay_user_cnt6`,
  `ltv6`,
  `pay_user_cnt7`,
  `ltv7`,
  `pay_user_cnt8`,
  `ltv8`,
  `pay_user_cnt9`,
  `ltv9`,
  `pay_user_cnt10`,
  `ltv10`,
  `pay_user_cnt11`,
  `ltv11`,
  `pay_user_cnt12`,
  `ltv12`,
  `pay_user_cnt13`,
  `ltv13`,
  `pay_user_cnt14`,
  `ltv14`,
  `pay_user_cnt15`,
  `ltv15`,
  `pay_user_cnt16`,
  `ltv16`,
  `pay_user_cnt17`,
  `ltv17`,
  `pay_user_cnt18`,
  `ltv18`,
  `pay_user_cnt19`,
  `ltv19`,
  `pay_user_cnt20`,
  `ltv20`,
  `pay_user_cnt21`,
  `ltv21`,
  `pay_user_cnt22`,
  `ltv22`,
  `pay_user_cnt23`,
  `ltv23`,
  `pay_user_cnt24`,
  `ltv24`,
  `pay_user_cnt25`,
  `ltv25`,
  `pay_user_cnt26`,
  `ltv26`,
  `pay_user_cnt27`,
  `ltv27`,
  `pay_user_cnt28`,
  `ltv28`,
  `pay_user_cnt29`,
  `ltv29`,
  `pay_user_cnt30`,
  `ltv30`,
  `pay_user_cnt45`,
  `ltv45`,
  `pay_user_cnt60`,
  `ltv60`,
  `pay_user_cnt90`,
  `ltv90`,
  `pay_user_cnt120`,
  `ltv120`
) AS
SELECT
  `ads`.`a`.`dt`,
  `ads`.`a`.`user_period`,
  `ads`.`a`.`product_id`,
  `ads`.`a`.`which_weeks`,
  `ads`.`a`.`which_months`,
  `ads`.`a`.`corever`,
  `ads`.`a`.`mt`,
  `ads`.`a`.`reg_country`,
  `ads`.`a`.`country_level`,
  CASE
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3311)
    ) THEN 6
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3322)
    ) THEN 5
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3333)
    ) THEN 2
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3366)
    ) THEN 3
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3371)
    ) THEN 7
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3388)
    ) THEN 4
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3501)
    ) THEN 11
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3511)
    ) THEN 12
    WHEN (
      (
        (`ads`.`a`.`current_language2` IS NULL)
        OR (`ads`.`a`.`current_language2` = 0)
      )
      AND (`ads`.`a`.`product_id` = 3399)
    ) THEN 9
    ELSE `ads`.`a`.`current_language2`
  END AS `current_language2`,
  `ads`.`a`.`source`,
  `dim`.`b`.`chl2`,
  `dim`.`b`.`chl`,
  `c`.`source_chl`,
  `dim`.`d`.`user_ad_source`,
  count(DISTINCT `ads`.`a`.`user_id`) AS `unt`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 0,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 0)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt0`,
  sum(if (`ads`.`a`.`pay_days` = 0, `ads`.`a`.`ltv`, 0)) AS `ltv0`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 1,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 1)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt1`,
  sum(if (`ads`.`a`.`pay_days` = 1, `ads`.`a`.`ltv`, 0)) AS `ltv1`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 2,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 2)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt2`,
  sum(if (`ads`.`a`.`pay_days` = 2, `ads`.`a`.`ltv`, 0)) AS `ltv2`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 3,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 3)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt3`,
  sum(if (`ads`.`a`.`pay_days` = 3, `ads`.`a`.`ltv`, 0)) AS `ltv3`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 4,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 4)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt4`,
  sum(if (`ads`.`a`.`pay_days` = 4, `ads`.`a`.`ltv`, 0)) AS `ltv4`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 5,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 5)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt5`,
  sum(if (`ads`.`a`.`pay_days` = 5, `ads`.`a`.`ltv`, 0)) AS `ltv5`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 6,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 6)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt6`,
  sum(if (`ads`.`a`.`pay_days` = 6, `ads`.`a`.`ltv`, 0)) AS `ltv6`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 7,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 7)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt7`,
  sum(if (`ads`.`a`.`pay_days` = 7, `ads`.`a`.`ltv`, 0)) AS `ltv7`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 8,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 8)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt8`,
  sum(if (`ads`.`a`.`pay_days` = 8, `ads`.`a`.`ltv`, 0)) AS `ltv8`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 9,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 9)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt9`,
  sum(if (`ads`.`a`.`pay_days` = 9, `ads`.`a`.`ltv`, 0)) AS `ltv9`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 10,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 10)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt10`,
  sum(
    if (`ads`.`a`.`pay_days` = 10, `ads`.`a`.`ltv`, 0)
  ) AS `ltv10`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 11,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 11)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt11`,
  sum(
    if (`ads`.`a`.`pay_days` = 11, `ads`.`a`.`ltv`, 0)
  ) AS `ltv11`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 12,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 12)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt12`,
  sum(
    if (`ads`.`a`.`pay_days` = 12, `ads`.`a`.`ltv`, 0)
  ) AS `ltv12`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 13,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 13)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt13`,
  sum(
    if (`ads`.`a`.`pay_days` = 13, `ads`.`a`.`ltv`, 0)
  ) AS `ltv13`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 14,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 14)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt14`,
  sum(
    if (`ads`.`a`.`pay_days` = 14, `ads`.`a`.`ltv`, 0)
  ) AS `ltv14`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 15,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 15)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt15`,
  sum(
    if (`ads`.`a`.`pay_days` = 15, `ads`.`a`.`ltv`, 0)
  ) AS `ltv15`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 16,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 16)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt16`,
  sum(
    if (`ads`.`a`.`pay_days` = 16, `ads`.`a`.`ltv`, 0)
  ) AS `ltv16`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 17,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 17)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt17`,
  sum(
    if (`ads`.`a`.`pay_days` = 17, `ads`.`a`.`ltv`, 0)
  ) AS `ltv17`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 18,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 18)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt18`,
  sum(
    if (`ads`.`a`.`pay_days` = 18, `ads`.`a`.`ltv`, 0)
  ) AS `ltv18`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 19,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 19)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt19`,
  sum(
    if (`ads`.`a`.`pay_days` = 19, `ads`.`a`.`ltv`, 0)
  ) AS `ltv19`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 20,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 20)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt20`,
  sum(
    if (`ads`.`a`.`pay_days` = 20, `ads`.`a`.`ltv`, 0)
  ) AS `ltv20`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 21,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 21)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt21`,
  sum(
    if (`ads`.`a`.`pay_days` = 21, `ads`.`a`.`ltv`, 0)
  ) AS `ltv21`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 22,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 22)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt22`,
  sum(
    if (`ads`.`a`.`pay_days` = 22, `ads`.`a`.`ltv`, 0)
  ) AS `ltv22`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 23,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 23)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt23`,
  sum(
    if (`ads`.`a`.`pay_days` = 23, `ads`.`a`.`ltv`, 0)
  ) AS `ltv23`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 24,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 24)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt24`,
  sum(
    if (`ads`.`a`.`pay_days` = 24, `ads`.`a`.`ltv`, 0)
  ) AS `ltv24`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 25,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 25)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt25`,
  sum(
    if (`ads`.`a`.`pay_days` = 25, `ads`.`a`.`ltv`, 0)
  ) AS `ltv25`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 26,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 26)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt26`,
  sum(
    if (`ads`.`a`.`pay_days` = 26, `ads`.`a`.`ltv`, 0)
  ) AS `ltv26`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 27,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 27)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt27`,
  sum(
    if (`ads`.`a`.`pay_days` = 27, `ads`.`a`.`ltv`, 0)
  ) AS `ltv27`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 28,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 28)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt28`,
  sum(
    if (`ads`.`a`.`pay_days` = 28, `ads`.`a`.`ltv`, 0)
  ) AS `ltv28`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 29,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 29)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt29`,
  sum(
    if (`ads`.`a`.`pay_days` = 29, `ads`.`a`.`ltv`, 0)
  ) AS `ltv29`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 30,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 30)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt30`,
  sum(
    if (`ads`.`a`.`pay_days` = 30, `ads`.`a`.`ltv`, 0)
  ) AS `ltv30`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 45,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 45)
        AND (`ads`.`a`.`amount` != 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt45`,
  sum(
    if (`ads`.`a`.`pay_days` = 45, `ads`.`a`.`ltv`, 0)
  ) AS `ltv45`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 60,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 60)
        AND (`ads`.`a`.`ltv` > 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt60`,
  sum(
    if (`ads`.`a`.`pay_days` = 60, `ads`.`a`.`ltv`, 0)
  ) AS `ltv60`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 90,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 90)
        AND (`ads`.`a`.`ltv` > 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt90`,
  sum(
    if (`ads`.`a`.`pay_days` = 90, `ads`.`a`.`ltv`, 0)
  ) AS `ltv90`,
  if (
    (datediff (now (), `ads`.`a`.`dt`)) >= 120,
    count(
      DISTINCT if (
        (`ads`.`a`.`pay_days` <= 120)
        AND (`ads`.`a`.`ltv` > 0),
        `ads`.`a`.`user_id`,
        NULL
      )
    ),
    NULL
  ) AS `pay_user_cnt120`,
  sum(
    if (`ads`.`a`.`pay_days` = 120, `ads`.`a`.`ltv`, 0)
  ) AS `ltv120`
FROM
  `ads`.`ads_trade_user_type_ltv_est_mid` AS `a`
  LEFT OUTER JOIN `dim`.`dim_short_video_user_accountinfo` AS `b` ON (`ads`.`a`.`product_id` = `dim`.`b`.`product_id`)
  AND (`ads`.`a`.`user_id` = `dim`.`b`.`user_id`)
  LEFT OUTER JOIN (
    SELECT
      `s1`.`product_id`,
      `s1`.`user_id`,
      `s1`.`last_source` AS `source_chl`
    FROM
      (
        SELECT
          `dws`.`t`.`product_id`,
          `dws`.`t`.`user_id`,
          `dws`.`t`.`last_source`,
          row_number() OVER (
            PARTITION BY
              `dws`.`t`.`product_id`,
              `dws`.`t`.`user_id`
            ORDER BY
              `dws`.`t`.`install_date` DESC,
              `dws`.`t`.`mt` ASC,
              `dws`.`t`.`corever` ASC,
              `dws`.`t`.`lang2` ASC
          ) AS `rn`
        FROM
          `dws`.`dws_user_market_channel_info_detail_est_da` AS `t`
        WHERE
          (
            `dws`.`t`.`dt` = (date_sub (current_date(), INTERVAL 1 DAY))
          )
          AND (`dws`.`t`.`product_id` IN (6833))
      ) `s1`
    WHERE
      `s1`.`rn` = 1
  ) `c` ON (`ads`.`a`.`product_id` = `c`.`product_id`)
  AND (`ads`.`a`.`user_id` = `c`.`user_id`)
  LEFT OUTER JOIN `dim`.`dim_user_other_info_view` AS `d` ON (`ads`.`a`.`product_id` = `dim`.`d`.`product_id`)
  AND (`ads`.`a`.`user_id` = `dim`.`d`.`id`)
GROUP BY
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15;