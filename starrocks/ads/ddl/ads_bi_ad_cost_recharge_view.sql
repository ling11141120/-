create or replace view ads.ads_bi_ad_cost_recharge_view (
     dt                     comment "日期，广告投放日期"
    ,product_id             comment "产品id"
    ,ad_id                  comment "广告id"
    ,fb_account             comment "Facebook账户"
    ,source_chl             comment "投放渠道"
    ,ads_type               comment "广告类型"
    ,ads_quality            comment "广告质量"
    ,ad_name                comment "广告名称"
    ,product_name           comment "产品账号名"
    ,ad_campname            comment "广告系列名称"
    ,ad_camp_id             comment "广告系列"
    ,ad_set_id              comment "广告组id"
    ,ad_setname             comment "广告组名称"
    ,book_id                comment "书籍id"
    ,book_name              comment "书籍名称"
    ,book_channel           comment "书籍类型"
    ,book_nature            comment "书籍来源"
    ,ads_optimizer          comment "优化师"
    ,ads_optimizer_group    comment "优化师组"
    ,core                   comment "core"
    ,mt                     comment "设备类型"
    ,current_language2      comment "当前语言"
    ,reg_num                comment "注册数"
    ,dev_num                comment "激活数"
    ,cost_amount            comment "花费"
    ,day0_amount            comment "投放当天的充值总金额"
    ,day1_amount            comment "day1的充值总金额"
    ,day2_amount            comment "day2的充值总金额"
    ,day3_amount            comment "day3的充值总金额"
    ,day4_amount            comment "day4的充值总金额"
    ,day5_amount            comment "day5的充值总金额"
    ,day6_amount            comment "day6的充值总金额"
    ,day7_amount            comment "day7的充值总金额"
    ,day8_amount            comment "day8的充值总金额"
    ,day9_amount            comment "day9的充值总金额"
    ,day10_amount           comment "day10的充值总金额"
    ,day11_amount           comment "day11的充值总金额"
    ,day12_amount           comment "day12的充值总金额"
    ,day13_amount           comment "day13的充值总金额"
    ,day14_amount           comment "day14的充值总金额"
    ,day15_amount           comment "day15的充值总金额"
    ,day16_amount           comment "day16的充值总金额"
    ,day17_amount           comment "day17的充值总金额"
    ,day18_amount           comment "day18的充值总金额"
    ,day19_amount           comment "day19的充值总金额"
    ,day20_amount           comment "day20的充值总金额"
    ,day21_amount           comment "day21的充值总金额"
    ,day22_amount           comment "day22的充值总金额"
    ,day23_amount           comment "day23的充值总金额"
    ,day24_amount           comment "day24的充值总金额"
    ,day25_amount           comment "day25的充值总金额"
    ,day26_amount           comment "day26的充值总金额"
    ,day27_amount           comment "day27的充值总金额"
    ,day28_amount           comment "day28的充值总金额"
    ,day29_amount           comment "day29的充值总金额"
    ,day30_amount           comment "day30的充值总金额"
    ,day60_amount           comment "day60的充值总金额"
    ,day90_amount           comment "day90的充值总金额"
    ,day120_amount          comment "day120当天的充值总金额"
)
comment "广告花费充值统计表"
as
select dt
      ,product_id
      ,ad_id
      ,fb_account
      ,source_chl
      ,ads_type
      ,ads_quality
      ,ad_name
      ,product_name
      ,ad_campname
      ,ad_camp_id
      ,ad_set_id
      ,ad_setname
      ,book_id
      ,book_name
      ,book_channel
      ,book_nature
      ,ads_optimizer
      ,ads_optimizer_group
      ,core
      ,mt
      ,current_language2
      ,reg_num
      ,dev_num
      ,cost_amount
      ,day0_amount
      ,day1_amount
      ,day2_amount
      ,day3_amount
      ,day4_amount
      ,day5_amount
      ,day6_amount
      ,day7_amount
      ,day8_amount
      ,day9_amount
      ,day10_amount
      ,day11_amount
      ,day12_amount
      ,day13_amount
      ,day14_amount
      ,day15_amount
      ,day16_amount
      ,day17_amount
      ,day18_amount
      ,day19_amount
      ,day20_amount
      ,day21_amount
      ,day22_amount
      ,day23_amount
      ,day24_amount
      ,day25_amount
      ,day26_amount
      ,day27_amount
      ,day28_amount
      ,day29_amount
      ,day30_amount
      ,day60_amount
      ,day90_amount
      ,day120_amount
  from dws.dws_advertisement_ad_cost_recharge_ed
;