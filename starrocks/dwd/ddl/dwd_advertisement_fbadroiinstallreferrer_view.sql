create or replace view dwd.dwd_advertisement_fbadroiinstallreferrer_view (
     id                  comment "id"
    ,dt                  comment "createtime 分区"
    ,ad_id               comment "广告id"
    ,create_time         comment "创建时间"
    ,pay_list            comment "充值信息"
    ,reg_num             comment "注册数"
    ,cost_amount         comment "成本"
    ,product_id          comment "产品id"
    ,pay_num             comment "充值数"
    ,update_time         comment "更新时间"
    ,paylist_by_days     comment "充值信息列表"
    ,check_sum           comment "检查总数"
    ,login_num2          comment "login_num2"
    ,login_num3          comment "login_num3"
    ,login_num7          comment "login_num7"
    ,core                comment "core"
    ,mt                  comment "设备类型"
    ,fb_account          comment "fb账户"
    ,ad_set_id           comment "广告setid"
    ,ad_camp_id          comment "广告campid"
    ,dev_num             comment "dev_num"
    ,group_id            comment "组id"
    ,source_chl          comment "渠道"
    ,chl2                comment "渠道2"
    ,row_version         comment "版本"
    ,current_language2   comment "当前语言"
    ,ads_quality         comment "质量"
    ,updater             comment "更新人员"
    ,day0_amount         comment "从创建到第x天的总充值金额"
    ,day1_amount         comment "从创建到第x天的总充值金额"
    ,day2_amount         comment "从创建到第x天的总充值金额"
    ,day3_amount         comment "从创建到第x天的总充值金额"
    ,day4_amount         comment "从创建到第x天的总充值金额"
    ,day5_amount         comment "从创建到第x天的总充值金额"
    ,day6_amount         comment "从创建到第x天的总充值金额"
    ,day7_amount         comment "从创建到第x天的总充值金额"
    ,day8_amount         comment "从创建到第x天的总充值金额"
    ,day9_amount         comment "从创建到第x天的总充值金额"
    ,day10_amount        comment "从创建到第x天的总充值金额"
    ,day11_amount        comment "从创建到第x天的总充值金额"
    ,day12_amount        comment "从创建到第x天的总充值金额"
    ,day13_amount        comment "从创建到第x天的总充值金额"
    ,day14_amount        comment "从创建到第x天的总充值金额"
    ,day15_amount        comment "从创建到第x天的总充值金额"
    ,day16_amount        comment "从创建到第x天的总充值金额"
    ,day17_amount        comment "从创建到第x天的总充值金额"
    ,day18_amount        comment "从创建到第x天的总充值金额"
    ,day19_amount        comment "从创建到第x天的总充值金额"
    ,day20_amount        comment "从创建到第x天的总充值金额"
    ,day21_amount        comment "从创建到第x天的总充值金额"
    ,day22_amount        comment "从创建到第x天的总充值金额"
    ,day23_amount        comment "从创建到第x天的总充值金额"
    ,day24_amount        comment "从创建到第x天的总充值金额"
    ,day25_amount        comment "从创建到第x天的总充值金额"
    ,day26_amount        comment "从创建到第x天的总充值金额"
    ,day27_amount        comment "从创建到第x天的总充值金额"
    ,day28_amount        comment "从创建到第x天的总充值金额"
    ,day29_amount        comment "从创建到第x天的总充值金额"
    ,day30_amount        comment "从创建到第x天的总充值金额"
    ,day31_amount        comment "从创建到第x天的总充值金额"
    ,day32_amount        comment "从创建到第x天的总充值金额"
    ,day33_amount        comment "从创建到第x天的总充值金额"
    ,day34_amount        comment "从创建到第x天的总充值金额"
    ,day35_amount        comment "从创建到第x天的总充值金额"
    ,day36_amount        comment "从创建到第x天的总充值金额"
    ,day37_amount        comment "从创建到第x天的总充值金额"
    ,day38_amount        comment "从创建到第x天的总充值金额"
    ,day39_amount        comment "从创建到第x天的总充值金额"
    ,day40_amount        comment "从创建到第x天的总充值金额"
    ,day41_amount        comment "从创建到第x天的总充值金额"
    ,day42_amount        comment "从创建到第x天的总充值金额"
    ,day43_amount        comment "从创建到第x天的总充值金额"
    ,day44_amount        comment "从创建到第x天的总充值金额"
    ,day45_amount        comment "从创建到第x天的总充值金额"
    ,day46_amount        comment "从创建到第x天的总充值金额"
    ,day47_amount        comment "从创建到第x天的总充值金额"
    ,day48_amount        comment "从创建到第x天的总充值金额"
    ,day49_amount        comment "从创建到第x天的总充值金额"
    ,day50_amount        comment "从创建到第x天的总充值金额"
    ,day51_amount        comment "从创建到第x天的总充值金额"
    ,day52_amount        comment "从创建到第x天的总充值金额"
    ,day53_amount        comment "从创建到第x天的总充值金额"
    ,day54_amount        comment "从创建到第x天的总充值金额"
    ,day55_amount        comment "从创建到第x天的总充值金额"
    ,day56_amount        comment "从创建到第x天的总充值金额"
    ,day57_amount        comment "从创建到第x天的总充值金额"
    ,day58_amount        comment "从创建到第x天的总充值金额"
    ,day59_amount        comment "从创建到第x天的总充值金额"
    ,day60_amount        comment "从创建到第x天的总充值金额"
    ,day61_amount        comment "从创建到第x天的总充值金额"
    ,day62_amount        comment "从创建到第x天的总充值金额"
    ,day63_amount        comment "从创建到第x天的总充值金额"
    ,day64_amount        comment "从创建到第x天的总充值金额"
    ,day65_amount        comment "从创建到第x天的总充值金额"
    ,day66_amount        comment "从创建到第x天的总充值金额"
    ,day67_amount        comment "从创建到第x天的总充值金额"
    ,day68_amount        comment "从创建到第x天的总充值金额"
    ,day69_amount        comment "从创建到第x天的总充值金额"
    ,day70_amount        comment "从创建到第x天的总充值金额"
    ,day71_amount        comment "从创建到第x天的总充值金额"
    ,day72_amount        comment "从创建到第x天的总充值金额"
    ,day73_amount        comment "从创建到第x天的总充值金额"
    ,day74_amount        comment "从创建到第x天的总充值金额"
    ,day75_amount        comment "从创建到第x天的总充值金额"
    ,day76_amount        comment "从创建到第x天的总充值金额"
    ,day77_amount        comment "从创建到第x天的总充值金额"
    ,day78_amount        comment "从创建到第x天的总充值金额"
    ,day79_amount        comment "从创建到第x天的总充值金额"
    ,day80_amount        comment "从创建到第x天的总充值金额"
    ,day81_amount        comment "从创建到第x天的总充值金额"
    ,day82_amount        comment "从创建到第x天的总充值金额"
    ,day83_amount        comment "从创建到第x天的总充值金额"
    ,day84_amount        comment "从创建到第x天的总充值金额"
    ,day85_amount        comment "从创建到第x天的总充值金额"
    ,day86_amount        comment "从创建到第x天的总充值金额"
    ,day87_amount        comment "从创建到第x天的总充值金额"
    ,day88_amount        comment "从创建到第x天的总充值金额"
    ,day89_amount        comment "从创建到第x天的总充值金额"
    ,day90_amount        comment "从创建到第x天的总充值金额"
    ,day120_amount       comment "从创建到第x天的总充值金额"
    ,day150_amount       comment "从创建到第x天的总充值金额"
    ,day180_amount       comment "从创建到第x天的总充值金额"
    ,day210_amount       comment "从创建到第x天的总充值金额"
    ,day240_amount       comment "从创建到第x天的总充值金额"
    ,day270_amount       comment "从创建到第x天的总充值金额"
    ,day300_amount       comment "从创建到第x天的总充值金额"
    ,day330_amount       comment "从创建到第x天的总充值金额"
    ,day360_amount       comment "从创建到第x天的总充值金额"
    ,day0_amount_byad    comment "从创建到第x天的广告总收入"
    ,day1_amount_byad    comment "从创建到第x天的广告总收入"
    ,day2_amount_byad    comment "从创建到第x天的广告总收入"
    ,day3_amount_byad    comment "从创建到第x天的广告总收入"
    ,day4_amount_byad    comment "从创建到第x天的广告总收入"
    ,day5_amount_byad    comment "从创建到第x天的广告总收入"
    ,day6_amount_byad    comment "从创建到第x天的广告总收入"
    ,day7_amount_byad    comment "从创建到第x天的广告总收入"
    ,day8_amount_byad    comment "从创建到第x天的广告总收入"
    ,day9_amount_byad    comment "从创建到第x天的广告总收入"
    ,day10_amount_byad   comment "从创建到第x天的广告总收入"
    ,day11_amount_byad   comment "从创建到第x天的广告总收入"
    ,day12_amount_byad   comment "从创建到第x天的广告总收入"
    ,day13_amount_byad   comment "从创建到第x天的广告总收入"
    ,day14_amount_byad   comment "从创建到第x天的广告总收入"
    ,day15_amount_byad   comment "从创建到第x天的广告总收入"
    ,day16_amount_byad   comment "从创建到第x天的广告总收入"
    ,day17_amount_byad   comment "从创建到第x天的广告总收入"
    ,day18_amount_byad   comment "从创建到第x天的广告总收入"
    ,day19_amount_byad   comment "从创建到第x天的广告总收入"
    ,day20_amount_byad   comment "从创建到第x天的广告总收入"
    ,day21_amount_byad   comment "从创建到第x天的广告总收入"
    ,day22_amount_byad   comment "从创建到第x天的广告总收入"
    ,day23_amount_byad   comment "从创建到第x天的广告总收入"
    ,day24_amount_byad   comment "从创建到第x天的广告总收入"
    ,day25_amount_byad   comment "从创建到第x天的广告总收入"
    ,day26_amount_byad   comment "从创建到第x天的广告总收入"
    ,day27_amount_byad   comment "从创建到第x天的广告总收入"
    ,day28_amount_byad   comment "从创建到第x天的广告总收入"
    ,day29_amount_byad   comment "从创建到第x天的广告总收入"
    ,day30_amount_byad   comment "从创建到第x天的广告总收入"
    ,day31_amount_byad   comment "从创建到第x天的广告总收入"
    ,day32_amount_byad   comment "从创建到第x天的广告总收入"
    ,day33_amount_byad   comment "从创建到第x天的广告总收入"
    ,day34_amount_byad   comment "从创建到第x天的广告总收入"
    ,day35_amount_byad   comment "从创建到第x天的广告总收入"
    ,day36_amount_byad   comment "从创建到第x天的广告总收入"
    ,day37_amount_byad   comment "从创建到第x天的广告总收入"
    ,day38_amount_byad   comment "从创建到第x天的广告总收入"
    ,day39_amount_byad   comment "从创建到第x天的广告总收入"
    ,day40_amount_byad   comment "从创建到第x天的广告总收入"
    ,day41_amount_byad   comment "从创建到第x天的广告总收入"
    ,day42_amount_byad   comment "从创建到第x天的广告总收入"
    ,day43_amount_byad   comment "从创建到第x天的广告总收入"
    ,day44_amount_byad   comment "从创建到第x天的广告总收入"
    ,day45_amount_byad   comment "从创建到第x天的广告总收入"
    ,day46_amount_byad   comment "从创建到第x天的广告总收入"
    ,day47_amount_byad   comment "从创建到第x天的广告总收入"
    ,day48_amount_byad   comment "从创建到第x天的广告总收入"
    ,day49_amount_byad   comment "从创建到第x天的广告总收入"
    ,day50_amount_byad   comment "从创建到第x天的广告总收入"
    ,day51_amount_byad   comment "从创建到第x天的广告总收入"
    ,day52_amount_byad   comment "从创建到第x天的广告总收入"
    ,day53_amount_byad   comment "从创建到第x天的广告总收入"
    ,day54_amount_byad   comment "从创建到第x天的广告总收入"
    ,day55_amount_byad   comment "从创建到第x天的广告总收入"
    ,day56_amount_byad   comment "从创建到第x天的广告总收入"
    ,day57_amount_byad   comment "从创建到第x天的广告总收入"
    ,day58_amount_byad   comment "从创建到第x天的广告总收入"
    ,day59_amount_byad   comment "从创建到第x天的广告总收入"
    ,day60_amount_byad   comment "从创建到第x天的广告总收入"
    ,day61_amount_byad   comment "从创建到第x天的广告总收入"
    ,day62_amount_byad   comment "从创建到第x天的广告总收入"
    ,day63_amount_byad   comment "从创建到第x天的广告总收入"
    ,day64_amount_byad   comment "从创建到第x天的广告总收入"
    ,day65_amount_byad   comment "从创建到第x天的广告总收入"
    ,day66_amount_byad   comment "从创建到第x天的广告总收入"
    ,day67_amount_byad   comment "从创建到第x天的广告总收入"
    ,day68_amount_byad   comment "从创建到第x天的广告总收入"
    ,day69_amount_byad   comment "从创建到第x天的广告总收入"
    ,day70_amount_byad   comment "从创建到第x天的广告总收入"
    ,day71_amount_byad   comment "从创建到第x天的广告总收入"
    ,day72_amount_byad   comment "从创建到第x天的广告总收入"
    ,day73_amount_byad   comment "从创建到第x天的广告总收入"
    ,day74_amount_byad   comment "从创建到第x天的广告总收入"
    ,day75_amount_byad   comment "从创建到第x天的广告总收入"
    ,day76_amount_byad   comment "从创建到第x天的广告总收入"
    ,day77_amount_byad   comment "从创建到第x天的广告总收入"
    ,day78_amount_byad   comment "从创建到第x天的广告总收入"
    ,day79_amount_byad   comment "从创建到第x天的广告总收入"
    ,day80_amount_byad   comment "从创建到第x天的广告总收入"
    ,day81_amount_byad   comment "从创建到第x天的广告总收入"
    ,day82_amount_byad   comment "从创建到第x天的广告总收入"
    ,day83_amount_byad   comment "从创建到第x天的广告总收入"
    ,day84_amount_byad   comment "从创建到第x天的广告总收入"
    ,day85_amount_byad   comment "从创建到第x天的广告总收入"
    ,day86_amount_byad   comment "从创建到第x天的广告总收入"
    ,day87_amount_byad   comment "从创建到第x天的广告总收入"
    ,day88_amount_byad   comment "从创建到第x天的广告总收入"
    ,day89_amount_byad   comment "从创建到第x天的广告总收入"
    ,day90_amount_byad   comment "从创建到第x天的广告总收入"
    ,day120_amount_byad  comment "从创建到第x天的广告总收入"
    ,day150_amount_byad  comment "从创建到第x天的广告总收入"
    ,day180_amount_byad  comment "从创建到第x天的广告总收入"
    ,day210_amount_byad  comment "从创建到第x天的广告总收入"
    ,day240_amount_byad  comment "从创建到第x天的广告总收入"
    ,day270_amount_byad  comment "从创建到第x天的广告总收入"
    ,day300_amount_byad  comment "从创建到第x天的广告总收入"
    ,day330_amount_byad  comment "从创建到第x天的广告总收入"
    ,day360_amount_byad  comment "从创建到第x天的广告总收入"
    ,day0_first_paynum   comment "从创建到第x天首充人数"
    ,day1_first_paynum   comment "从创建到第x天首充人数"
    ,day2_first_paynum   comment "从创建到第x天首充人数"
    ,day3_first_paynum   comment "从创建到第x天首充人数"
    ,day4_first_paynum   comment "从创建到第x天首充人数"
    ,day5_first_paynum   comment "从创建到第x天首充人数"
    ,day6_first_paynum   comment "从创建到第x天首充人数"
    ,day7_first_paynum   comment "从创建到第x天首充人数"
    ,day8_first_paynum   comment "从创建到第x天首充人数"
    ,day9_first_paynum   comment "从创建到第x天首充人数"
    ,day10_first_paynum  comment "从创建到第x天首充人数"
    ,day11_first_paynum  comment "从创建到第x天首充人数"
    ,day12_first_paynum  comment "从创建到第x天首充人数"
    ,day13_first_paynum  comment "从创建到第x天首充人数"
    ,day14_first_paynum  comment "从创建到第x天首充人数"
    ,day15_first_paynum  comment "从创建到第x天首充人数"
    ,day16_first_paynum  comment "从创建到第x天首充人数"
    ,day17_first_paynum  comment "从创建到第x天首充人数"
    ,day18_first_paynum  comment "从创建到第x天首充人数"
    ,day19_first_paynum  comment "从创建到第x天首充人数"
    ,day20_first_paynum  comment "从创建到第x天首充人数"
    ,day21_first_paynum  comment "从创建到第x天首充人数"
    ,day22_first_paynum  comment "从创建到第x天首充人数"
    ,day23_first_paynum  comment "从创建到第x天首充人数"
    ,day24_first_paynum  comment "从创建到第x天首充人数"
    ,day25_first_paynum  comment "从创建到第x天首充人数"
    ,day26_first_paynum  comment "从创建到第x天首充人数"
    ,day27_first_paynum  comment "从创建到第x天首充人数"
    ,day28_first_paynum  comment "从创建到第x天首充人数"
    ,day29_first_paynum  comment "从创建到第x天首充人数"
    ,day30_first_paynum  comment "从创建到第x天首充人数"
    ,day31_first_paynum  comment "从创建到第x天首充人数"
    ,day32_first_paynum  comment "从创建到第x天首充人数"
    ,day33_first_paynum  comment "从创建到第x天首充人数"
    ,day34_first_paynum  comment "从创建到第x天首充人数"
    ,day35_first_paynum  comment "从创建到第x天首充人数"
    ,day36_first_paynum  comment "从创建到第x天首充人数"
    ,day37_first_paynum  comment "从创建到第x天首充人数"
    ,day38_first_paynum  comment "从创建到第x天首充人数"
    ,day39_first_paynum  comment "从创建到第x天首充人数"
    ,day40_first_paynum  comment "从创建到第x天首充人数"
    ,day41_first_paynum  comment "从创建到第x天首充人数"
    ,day42_first_paynum  comment "从创建到第x天首充人数"
    ,day43_first_paynum  comment "从创建到第x天首充人数"
    ,day44_first_paynum  comment "从创建到第x天首充人数"
    ,day45_first_paynum  comment "从创建到第x天首充人数"
    ,day46_first_paynum  comment "从创建到第x天首充人数"
    ,day47_first_paynum  comment "从创建到第x天首充人数"
    ,day48_first_paynum  comment "从创建到第x天首充人数"
    ,day49_first_paynum  comment "从创建到第x天首充人数"
    ,day50_first_paynum  comment "从创建到第x天首充人数"
    ,day51_first_paynum  comment "从创建到第x天首充人数"
    ,day52_first_paynum  comment "从创建到第x天首充人数"
    ,day53_first_paynum  comment "从创建到第x天首充人数"
    ,day54_first_paynum  comment "从创建到第x天首充人数"
    ,day55_first_paynum  comment "从创建到第x天首充人数"
    ,day56_first_paynum  comment "从创建到第x天首充人数"
    ,day57_first_paynum  comment "从创建到第x天首充人数"
    ,day58_first_paynum  comment "从创建到第x天首充人数"
    ,day59_first_paynum  comment "从创建到第x天首充人数"
    ,day60_first_paynum  comment "从创建到第x天首充人数"
    ,day61_first_paynum  comment "从创建到第x天首充人数"
    ,day62_first_paynum  comment "从创建到第x天首充人数"
    ,day63_first_paynum  comment "从创建到第x天首充人数"
    ,day64_first_paynum  comment "从创建到第x天首充人数"
    ,day65_first_paynum  comment "从创建到第x天首充人数"
    ,day66_first_paynum  comment "从创建到第x天首充人数"
    ,day67_first_paynum  comment "从创建到第x天首充人数"
    ,day68_first_paynum  comment "从创建到第x天首充人数"
    ,day69_first_paynum  comment "从创建到第x天首充人数"
    ,day70_first_paynum  comment "从创建到第x天首充人数"
    ,day71_first_paynum  comment "从创建到第x天首充人数"
    ,day72_first_paynum  comment "从创建到第x天首充人数"
    ,day73_first_paynum  comment "从创建到第x天首充人数"
    ,day74_first_paynum  comment "从创建到第x天首充人数"
    ,day75_first_paynum  comment "从创建到第x天首充人数"
    ,day76_first_paynum  comment "从创建到第x天首充人数"
    ,day77_first_paynum  comment "从创建到第x天首充人数"
    ,day78_first_paynum  comment "从创建到第x天首充人数"
    ,day79_first_paynum  comment "从创建到第x天首充人数"
    ,day80_first_paynum  comment "从创建到第x天首充人数"
    ,day81_first_paynum  comment "从创建到第x天首充人数"
    ,day82_first_paynum  comment "从创建到第x天首充人数"
    ,day83_first_paynum  comment "从创建到第x天首充人数"
    ,day84_first_paynum  comment "从创建到第x天首充人数"
    ,day85_first_paynum  comment "从创建到第x天首充人数"
    ,day86_first_paynum  comment "从创建到第x天首充人数"
    ,day87_first_paynum  comment "从创建到第x天首充人数"
    ,day88_first_paynum  comment "从创建到第x天首充人数"
    ,day89_first_paynum  comment "从创建到第x天首充人数"
    ,day90_first_paynum  comment "从创建到第x天首充人数"
    ,day120_first_paynum comment "从创建到第x天首充人数"
    ,day150_first_paynum comment "从创建到第x天首充人数"
    ,day180_first_paynum comment "从创建到第x天首充人数"
    ,day210_first_paynum comment "从创建到第x天首充人数"
    ,day240_first_paynum comment "从创建到第x天首充人数"
    ,day270_first_paynum comment "从创建到第x天首充人数"
    ,day300_first_paynum comment "从创建到第x天首充人数"
    ,day330_first_paynum comment "从创建到第x天首充人数"
    ,day360_first_paynum comment "从创建到第x天首充人数"
    ,day0_paynum         comment "从创建到第x天充值数"
    ,day1_paynum         comment "从创建到第x天充值数"
    ,day2_paynum         comment "从创建到第x天充值数"
    ,day3_paynum         comment "从创建到第x天充值数"
    ,day4_paynum         comment "从创建到第x天充值数"
    ,day5_paynum         comment "从创建到第x天充值数"
    ,day6_paynum         comment "从创建到第x天充值数"
    ,day7_paynum         comment "从创建到第x天充值数"
    ,day8_paynum         comment "从创建到第x天充值数"
    ,day9_paynum         comment "从创建到第x天充值数"
    ,day10_paynum        comment "从创建到第x天充值数"
    ,day11_paynum        comment "从创建到第x天充值数"
    ,day12_paynum        comment "从创建到第x天充值数"
    ,day13_paynum        comment "从创建到第x天充值数"
    ,day14_paynum        comment "从创建到第x天充值数"
    ,day15_paynum        comment "从创建到第x天充值数"
    ,day16_paynum        comment "从创建到第x天充值数"
    ,day17_paynum        comment "从创建到第x天充值数"
    ,day18_paynum        comment "从创建到第x天充值数"
    ,day19_paynum        comment "从创建到第x天充值数"
    ,day20_paynum        comment "从创建到第x天充值数"
    ,day21_paynum        comment "从创建到第x天充值数"
    ,day22_paynum        comment "从创建到第x天充值数"
    ,day23_paynum        comment "从创建到第x天充值数"
    ,day24_paynum        comment "从创建到第x天充值数"
    ,day25_paynum        comment "从创建到第x天充值数"
    ,day26_paynum        comment "从创建到第x天充值数"
    ,day27_paynum        comment "从创建到第x天充值数"
    ,day28_paynum        comment "从创建到第x天充值数"
    ,day29_paynum        comment "从创建到第x天充值数"
    ,day30_paynum        comment "从创建到第x天充值数"
    ,day31_paynum        comment "从创建到第x天充值数"
    ,day32_paynum        comment "从创建到第x天充值数"
    ,day33_paynum        comment "从创建到第x天充值数"
    ,day34_paynum        comment "从创建到第x天充值数"
    ,day35_paynum        comment "从创建到第x天充值数"
    ,day36_paynum        comment "从创建到第x天充值数"
    ,day37_paynum        comment "从创建到第x天充值数"
    ,day38_paynum        comment "从创建到第x天充值数"
    ,day39_paynum        comment "从创建到第x天充值数"
    ,day40_paynum        comment "从创建到第x天充值数"
    ,day41_paynum        comment "从创建到第x天充值数"
    ,day42_paynum        comment "从创建到第x天充值数"
    ,day43_paynum        comment "从创建到第x天充值数"
    ,day44_paynum        comment "从创建到第x天充值数"
    ,day45_paynum        comment "从创建到第x天充值数"
    ,day46_paynum        comment "从创建到第x天充值数"
    ,day47_paynum        comment "从创建到第x天充值数"
    ,day48_paynum        comment "从创建到第x天充值数"
    ,day49_paynum        comment "从创建到第x天充值数"
    ,day50_paynum        comment "从创建到第x天充值数"
    ,day51_paynum        comment "从创建到第x天充值数"
    ,day52_paynum        comment "从创建到第x天充值数"
    ,day53_paynum        comment "从创建到第x天充值数"
    ,day54_paynum        comment "从创建到第x天充值数"
    ,day55_paynum        comment "从创建到第x天充值数"
    ,day56_paynum        comment "从创建到第x天充值数"
    ,day57_paynum        comment "从创建到第x天充值数"
    ,day58_paynum        comment "从创建到第x天充值数"
    ,day59_paynum        comment "从创建到第x天充值数"
    ,day60_paynum        comment "从创建到第x天充值数"
    ,day61_paynum        comment "从创建到第x天充值数"
    ,day62_paynum        comment "从创建到第x天充值数"
    ,day63_paynum        comment "从创建到第x天充值数"
    ,day64_paynum        comment "从创建到第x天充值数"
    ,day65_paynum        comment "从创建到第x天充值数"
    ,day66_paynum        comment "从创建到第x天充值数"
    ,day67_paynum        comment "从创建到第x天充值数"
    ,day68_paynum        comment "从创建到第x天充值数"
    ,day69_paynum        comment "从创建到第x天充值数"
    ,day70_paynum        comment "从创建到第x天充值数"
    ,day71_paynum        comment "从创建到第x天充值数"
    ,day72_paynum        comment "从创建到第x天充值数"
    ,day73_paynum        comment "从创建到第x天充值数"
    ,day74_paynum        comment "从创建到第x天充值数"
    ,day75_paynum        comment "从创建到第x天充值数"
    ,day76_paynum        comment "从创建到第x天充值数"
    ,day77_paynum        comment "从创建到第x天充值数"
    ,day78_paynum        comment "从创建到第x天充值数"
    ,day79_paynum        comment "从创建到第x天充值数"
    ,day80_paynum        comment "从创建到第x天充值数"
    ,day81_paynum        comment "从创建到第x天充值数"
    ,day82_paynum        comment "从创建到第x天充值数"
    ,day83_paynum        comment "从创建到第x天充值数"
    ,day84_paynum        comment "从创建到第x天充值数"
    ,day85_paynum        comment "从创建到第x天充值数"
    ,day86_paynum        comment "从创建到第x天充值数"
    ,day87_paynum        comment "从创建到第x天充值数"
    ,day88_paynum        comment "从创建到第x天充值数"
    ,day89_paynum        comment "从创建到第x天充值数"
    ,day90_paynum        comment "从创建到第x天充值数"
    ,day120_paynum       comment "从创建到第x天充值数"
    ,day150_paynum       comment "从创建到第x天充值数"
    ,day180_paynum       comment "从创建到第x天充值数"
    ,day210_paynum       comment "从创建到第x天充值数"
    ,day240_paynum       comment "从创建到第x天充值数"
    ,day270_paynum       comment "从创建到第x天充值数"
    ,day300_paynum       comment "从创建到第x天充值数"
    ,day330_paynum       comment "从创建到第x天充值数"
    ,day360_paynum       comment "从创建到第x天充值数"
    ,paynum_byat         comment "充值数"
    ,payuser_byat        comment "充值数"
    ,day0firstpaytimes   comment "第0天充值数"
    ,day0_amount_admob   comment "从创建到第x天的AdMob广告收入"
    ,day0_amount_max     comment "从创建到第x天的Max广告收入"
    ,day0_amount_h5      comment "从创建到第x天的H5广告收入"
)
as
select a1.Id                                    as id
      ,a1.dt                                    as dt                  -- createtime 分区
      ,a1.AdId                                  as ad_id               -- 广告id
      ,a1.CreateTime                            as create_time         -- 创建时间
      ,a1.PayList                               as pay_list            -- 充值信息
      ,a1.RegNum                                as reg_num             -- 注册数
      ,a1.CostAmount                            as cost_amount         -- 成本
      ,a1.ProductId                             as product_id          -- 产品id
      ,a1.PayNum                                as pay_num             -- 充值数
      ,a1.UpdateTime                            as update_time         -- 更新时间
      ,a1.PayListByDays                         as paylist_by_days     -- 充值信息列表
      ,a1.CheckSum                              as check_sum           -- 检查总数
      ,a1.LoginNum2                             as login_num2
      ,a1.LoginNum3                             as login_num3
      ,a1.LoginNum7                             as login_num7
      ,a1.Core                                  as core                -- core
      ,a1.Mt                                    as mt                  -- 设备类型
      ,a1.FbAccount                             as fb_account          -- fb账户
      ,a1.AdSetId                               as ad_set_id           -- 广告setid
      ,a1.AdCampId                              as ad_camp_id          -- 广告campid
      ,a1.DevNum                                as dev_num
      ,a1.GroupId                               as group_id            -- 组id
      ,a1.SourceChl                             as source_chl          -- 渠道
      ,a1.Chl2                                  as chl2                -- 渠道2
      ,a1.RowVersion                            as row_version         -- 版本
      ,a1.CurrentLanguage2                      as current_language2   -- 当前语言
      ,a1.AdsQuality                            as ads_quality         -- 质量
      ,a1.Updater                               as updater
      ,a1.Day0Amount                            as day0_amount         -- 从创建到第x天的总充值金额
      ,a1.Day1Amount                            as day1_amount         -- 从创建到第x天的总充值金额
      ,a1.Day2Amount                            as day2_amount         -- 从创建到第x天的总充值金额
      ,a1.Day3Amount                            as day3_amount         -- 从创建到第x天的总充值金额
      ,a1.Day4Amount                            as day4_amount         -- 从创建到第x天的总充值金额
      ,a1.Day5Amount                            as day5_amount         -- 从创建到第x天的总充值金额
      ,a1.Day6Amount                            as day6_amount         -- 从创建到第x天的总充值金额
      ,a1.Day7Amount                            as day7_amount         -- 从创建到第x天的总充值金额
      ,a1.Day8Amount                            as day8_amount         -- 从创建到第x天的总充值金额
      ,a1.Day9Amount                            as day9_amount         -- 从创建到第x天的总充值金额
      ,a1.Day10Amount                           as day10_amount        -- 从创建到第x天的总充值金额
      ,a1.Day11Amount                           as day11_amount        -- 从创建到第x天的总充值金额
      ,a1.Day12Amount                           as day12_amount        -- 从创建到第x天的总充值金额
      ,a1.Day13Amount                           as day13_amount        -- 从创建到第x天的总充值金额
      ,a1.Day14Amount                           as day14_amount        -- 从创建到第x天的总充值金额
      ,a1.Day15Amount                           as day15_amount        -- 从创建到第x天的总充值金额
      ,a1.Day16Amount                           as day16_amount        -- 从创建到第x天的总充值金额
      ,a1.Day17Amount                           as day17_amount        -- 从创建到第x天的总充值金额
      ,a1.Day18Amount                           as day18_amount        -- 从创建到第x天的总充值金额
      ,a1.Day19Amount                           as day19_amount        -- 从创建到第x天的总充值金额
      ,a1.Day20Amount                           as day20_amount        -- 从创建到第x天的总充值金额
      ,a1.Day21Amount                           as day21_amount        -- 从创建到第x天的总充值金额
      ,a1.Day22Amount                           as day22_amount        -- 从创建到第x天的总充值金额
      ,a1.Day23Amount                           as day23_amount        -- 从创建到第x天的总充值金额
      ,a1.Day24Amount                           as day24_amount        -- 从创建到第x天的总充值金额
      ,a1.Day25Amount                           as day25_amount        -- 从创建到第x天的总充值金额
      ,a1.Day26Amount                           as day26_amount        -- 从创建到第x天的总充值金额
      ,a1.Day27Amount                           as day27_amount        -- 从创建到第x天的总充值金额
      ,a1.Day28Amount                           as day28_amount        -- 从创建到第x天的总充值金额
      ,a1.Day29Amount                           as day29_amount        -- 从创建到第x天的总充值金额
      ,a1.Day30Amount                           as day30_amount        -- 从创建到第x天的总充值金额
      ,a1.Day31Amount                           as day31_amount        -- 从创建到第x天的总充值金额
      ,a1.Day32Amount                           as day32_amount        -- 从创建到第x天的总充值金额
      ,a1.Day33Amount                           as day33_amount        -- 从创建到第x天的总充值金额
      ,a1.Day34Amount                           as day34_amount        -- 从创建到第x天的总充值金额
      ,a1.Day35Amount                           as day35_amount        -- 从创建到第x天的总充值金额
      ,a1.Day36Amount                           as day36_amount        -- 从创建到第x天的总充值金额
      ,a1.Day37Amount                           as day37_amount        -- 从创建到第x天的总充值金额
      ,a1.Day38Amount                           as day38_amount        -- 从创建到第x天的总充值金额
      ,a1.Day39Amount                           as day39_amount        -- 从创建到第x天的总充值金额
      ,a1.Day40Amount                           as day40_amount        -- 从创建到第x天的总充值金额
      ,a1.Day41Amount                           as day41_amount        -- 从创建到第x天的总充值金额
      ,a1.Day42Amount                           as day42_amount        -- 从创建到第x天的总充值金额
      ,a1.Day43Amount                           as day43_amount        -- 从创建到第x天的总充值金额
      ,a1.Day44Amount                           as day44_amount        -- 从创建到第x天的总充值金额
      ,a1.Day45Amount                           as day45_amount        -- 从创建到第x天的总充值金额
      ,a1.Day46Amount                           as day46_amount        -- 从创建到第x天的总充值金额
      ,a1.Day47Amount                           as day47_amount        -- 从创建到第x天的总充值金额
      ,a1.Day48Amount                           as day48_amount        -- 从创建到第x天的总充值金额
      ,a1.Day49Amount                           as day49_amount        -- 从创建到第x天的总充值金额
      ,a1.Day50Amount                           as day50_amount        -- 从创建到第x天的总充值金额
      ,a1.Day51Amount                           as day51_amount        -- 从创建到第x天的总充值金额
      ,a1.Day52Amount                           as day52_amount        -- 从创建到第x天的总充值金额
      ,a1.Day53Amount                           as day53_amount        -- 从创建到第x天的总充值金额
      ,a1.Day54Amount                           as day54_amount        -- 从创建到第x天的总充值金额
      ,a1.Day55Amount                           as day55_amount        -- 从创建到第x天的总充值金额
      ,a1.Day56Amount                           as day56_amount        -- 从创建到第x天的总充值金额
      ,a1.Day57Amount                           as day57_amount        -- 从创建到第x天的总充值金额
      ,a1.Day58Amount                           as day58_amount        -- 从创建到第x天的总充值金额
      ,a1.Day59Amount                           as day59_amount        -- 从创建到第x天的总充值金额
      ,a1.Day60Amount                           as day60_amount        -- 从创建到第x天的总充值金额
      ,a1.Day61Amount                           as day61_amount        -- 从创建到第x天的总充值金额
      ,a1.Day62Amount                           as day62_amount        -- 从创建到第x天的总充值金额
      ,a1.Day63Amount                           as day63_amount        -- 从创建到第x天的总充值金额
      ,a1.Day64Amount                           as day64_amount        -- 从创建到第x天的总充值金额
      ,a1.Day65Amount                           as day65_amount        -- 从创建到第x天的总充值金额
      ,a1.Day66Amount                           as day66_amount        -- 从创建到第x天的总充值金额
      ,a1.Day67Amount                           as day67_amount        -- 从创建到第x天的总充值金额
      ,a1.Day68Amount                           as day68_amount        -- 从创建到第x天的总充值金额
      ,a1.Day69Amount                           as day69_amount        -- 从创建到第x天的总充值金额
      ,a1.Day70Amount                           as day70_amount        -- 从创建到第x天的总充值金额
      ,a1.Day71Amount                           as day71_amount        -- 从创建到第x天的总充值金额
      ,a1.Day72Amount                           as day72_amount        -- 从创建到第x天的总充值金额
      ,a1.Day73Amount                           as day73_amount        -- 从创建到第x天的总充值金额
      ,a1.Day74Amount                           as day74_amount        -- 从创建到第x天的总充值金额
      ,a1.Day75Amount                           as day75_amount        -- 从创建到第x天的总充值金额
      ,a1.Day76Amount                           as day76_amount        -- 从创建到第x天的总充值金额
      ,a1.Day77Amount                           as day77_amount        -- 从创建到第x天的总充值金额
      ,a1.Day78Amount                           as day78_amount        -- 从创建到第x天的总充值金额
      ,a1.Day79Amount                           as day79_amount        -- 从创建到第x天的总充值金额
      ,a1.Day80Amount                           as day80_amount        -- 从创建到第x天的总充值金额
      ,a1.Day81Amount                           as day81_amount        -- 从创建到第x天的总充值金额
      ,a1.Day82Amount                           as day82_amount        -- 从创建到第x天的总充值金额
      ,a1.Day83Amount                           as day83_amount        -- 从创建到第x天的总充值金额
      ,a1.Day84Amount                           as day84_amount        -- 从创建到第x天的总充值金额
      ,a1.Day85Amount                           as day85_amount        -- 从创建到第x天的总充值金额
      ,a1.Day86Amount                           as day86_amount        -- 从创建到第x天的总充值金额
      ,a1.Day87Amount                           as day87_amount        -- 从创建到第x天的总充值金额
      ,a1.Day88Amount                           as day88_amount        -- 从创建到第x天的总充值金额
      ,a1.Day89Amount                           as day89_amount        -- 从创建到第x天的总充值金额
      ,a1.Day90Amount                           as day90_amount        -- 从创建到第x天的总充值金额
      ,a1.Day120Amount                          as day120_amount       -- 从创建到第x天的总充值金额
      ,a1.Day150Amount                          as day150_amount       -- 从创建到第x天的总充值金额
      ,a1.Day180Amount                          as day180_amount       -- 从创建到第x天的总充值金额
      ,a1.Day210Amount                          as day210_amount       -- 从创建到第x天的总充值金额
      ,a1.Day240Amount                          as day240_amount       -- 从创建到第x天的总充值金额
      ,a1.Day270Amount                          as day270_amount       -- 从创建到第x天的总充值金额
      ,a1.Day300Amount                          as day300_amount       -- 从创建到第x天的总充值金额
      ,a1.Day330Amount                          as day330_amount       -- 从创建到第x天的总充值金额
      ,a1.Day360Amount                          as day360_amount       -- 从创建到第x天的总充值金额
      ,a1.Day0AmountByAd                        as day0_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day1AmountByAd                        as day1_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day2AmountByAd                        as day2_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day3AmountByAd                        as day3_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day4AmountByAd                        as day4_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day5AmountByAd                        as day5_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day6AmountByAd                        as day6_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day7AmountByAd                        as day7_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day8AmountByAd                        as day8_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day9AmountByAd                        as day9_amount_byad    -- 从创建到第x天的广告总收入
      ,a1.Day10AmountByAd                       as day10_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day11AmountByAd                       as day11_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day12AmountByAd                       as day12_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day13AmountByAd                       as day13_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day14AmountByAd                       as day14_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day15AmountByAd                       as day15_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day16AmountByAd                       as day16_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day17AmountByAd                       as day17_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day18AmountByAd                       as day18_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day19AmountByAd                       as day19_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day20AmountByAd                       as day20_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day21AmountByAd                       as day21_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day22AmountByAd                       as day22_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day23AmountByAd                       as day23_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day24AmountByAd                       as day24_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day25AmountByAd                       as day25_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day26AmountByAd                       as day26_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day27AmountByAd                       as day27_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day28AmountByAd                       as day28_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day29AmountByAd                       as day29_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day30AmountByAd                       as day30_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day31AmountByAd                       as day31_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day32AmountByAd                       as day32_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day33AmountByAd                       as day33_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day34AmountByAd                       as day34_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day35AmountByAd                       as day35_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day36AmountByAd                       as day36_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day37AmountByAd                       as day37_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day38AmountByAd                       as day38_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day39AmountByAd                       as day39_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day40AmountByAd                       as day40_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day41AmountByAd                       as day41_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day42AmountByAd                       as day42_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day43AmountByAd                       as day43_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day44AmountByAd                       as day44_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day45AmountByAd                       as day45_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day46AmountByAd                       as day46_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day47AmountByAd                       as day47_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day48AmountByAd                       as day48_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day49AmountByAd                       as day49_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day50AmountByAd                       as day50_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day51AmountByAd                       as day51_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day52AmountByAd                       as day52_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day53AmountByAd                       as day53_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day54AmountByAd                       as day54_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day55AmountByAd                       as day55_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day56AmountByAd                       as day56_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day57AmountByAd                       as day57_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day58AmountByAd                       as day58_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day59AmountByAd                       as day59_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day60AmountByAd                       as day60_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day61AmountByAd                       as day61_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day62AmountByAd                       as day62_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day63AmountByAd                       as day63_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day64AmountByAd                       as day64_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day65AmountByAd                       as day65_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day66AmountByAd                       as day66_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day67AmountByAd                       as day67_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day68AmountByAd                       as day68_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day69AmountByAd                       as day69_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day70AmountByAd                       as day70_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day71AmountByAd                       as day71_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day72AmountByAd                       as day72_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day73AmountByAd                       as day73_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day74AmountByAd                       as day74_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day75AmountByAd                       as day75_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day76AmountByAd                       as day76_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day77AmountByAd                       as day77_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day78AmountByAd                       as day78_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day79AmountByAd                       as day79_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day80AmountByAd                       as day80_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day81AmountByAd                       as day81_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day82AmountByAd                       as day82_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day83AmountByAd                       as day83_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day84AmountByAd                       as day84_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day85AmountByAd                       as day85_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day86AmountByAd                       as day86_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day87AmountByAd                       as day87_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day88AmountByAd                       as day88_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day89AmountByAd                       as day89_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day90AmountByAd                       as day90_amount_byad   -- 从创建到第x天的广告总收入
      ,a1.Day120AmountByAd                      as day120_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day150AmountByAd                      as day150_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day180AmountByAd                      as day180_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day210AmountByAd                      as day210_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day240AmountByAd                      as day240_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day270AmountByAd                      as day270_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day300AmountByAd                      as day300_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day330AmountByAd                      as day330_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day360AmountByAd                      as day360_amount_byad  -- 从创建到第x天的广告总收入
      ,a1.Day0FirstPayNum                       as day0_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day1FirstPayNum                       as day1_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day2FirstPayNum                       as day2_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day3FirstPayNum                       as day3_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day4FirstPayNum                       as day4_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day5FirstPayNum                       as day5_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day6FirstPayNum                       as day6_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day7FirstPayNum                       as day7_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day8FirstPayNum                       as day8_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day9FirstPayNum                       as day9_first_paynum   -- 从创建到第x天首充人数
      ,a1.Day10FirstPayNum                      as day10_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day11FirstPayNum                      as day11_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day12FirstPayNum                      as day12_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day13FirstPayNum                      as day13_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day14FirstPayNum                      as day14_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day15FirstPayNum                      as day15_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day16FirstPayNum                      as day16_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day17FirstPayNum                      as day17_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day18FirstPayNum                      as day18_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day19FirstPayNum                      as day19_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day20FirstPayNum                      as day20_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day21FirstPayNum                      as day21_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day22FirstPayNum                      as day22_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day23FirstPayNum                      as day23_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day24FirstPayNum                      as day24_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day25FirstPayNum                      as day25_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day26FirstPayNum                      as day26_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day27FirstPayNum                      as day27_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day28FirstPayNum                      as day28_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day29FirstPayNum                      as day29_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day30FirstPayNum                      as day30_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day31FirstPayNum                      as day31_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day32FirstPayNum                      as day32_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day33FirstPayNum                      as day33_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day34FirstPayNum                      as day34_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day35FirstPayNum                      as day35_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day36FirstPayNum                      as day36_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day37FirstPayNum                      as day37_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day38FirstPayNum                      as day38_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day39FirstPayNum                      as day39_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day40FirstPayNum                      as day40_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day41FirstPayNum                      as day41_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day42FirstPayNum                      as day42_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day43FirstPayNum                      as day43_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day44FirstPayNum                      as day44_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day45FirstPayNum                      as day45_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day46FirstPayNum                      as day46_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day47FirstPayNum                      as day47_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day48FirstPayNum                      as day48_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day49FirstPayNum                      as day49_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day50FirstPayNum                      as day50_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day51FirstPayNum                      as day51_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day52FirstPayNum                      as day52_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day53FirstPayNum                      as day53_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day54FirstPayNum                      as day54_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day55FirstPayNum                      as day55_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day56FirstPayNum                      as day56_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day57FirstPayNum                      as day57_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day58FirstPayNum                      as day58_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day59FirstPayNum                      as day59_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day60FirstPayNum                      as day60_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day61FirstPayNum                      as day61_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day62FirstPayNum                      as day62_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day63FirstPayNum                      as day63_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day64FirstPayNum                      as day64_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day65FirstPayNum                      as day65_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day66FirstPayNum                      as day66_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day67FirstPayNum                      as day67_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day68FirstPayNum                      as day68_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day69FirstPayNum                      as day69_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day70FirstPayNum                      as day70_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day71FirstPayNum                      as day71_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day72FirstPayNum                      as day72_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day73FirstPayNum                      as day73_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day74FirstPayNum                      as day74_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day75FirstPayNum                      as day75_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day76FirstPayNum                      as day76_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day77FirstPayNum                      as day77_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day78FirstPayNum                      as day78_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day79FirstPayNum                      as day79_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day80FirstPayNum                      as day80_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day81FirstPayNum                      as day81_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day82FirstPayNum                      as day82_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day83FirstPayNum                      as day83_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day84FirstPayNum                      as day84_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day85FirstPayNum                      as day85_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day86FirstPayNum                      as day86_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day87FirstPayNum                      as day87_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day88FirstPayNum                      as day88_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day89FirstPayNum                      as day89_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day90FirstPayNum                      as day90_first_paynum  -- 从创建到第x天首充人数
      ,a1.Day120FirstPayNum                     as day120_first_paynum -- 从创建到第x天首充人数
      ,a1.Day150FirstPayNum                     as day150_first_paynum -- 从创建到第x天首充人数
      ,a1.Day180FirstPayNum                     as day180_first_paynum -- 从创建到第x天首充人数
      ,a1.Day210FirstPayNum                     as day210_first_paynum -- 从创建到第x天首充人数
      ,a1.Day240FirstPayNum                     as day240_first_paynum -- 从创建到第x天首充人数
      ,a1.Day270FirstPayNum                     as day270_first_paynum -- 从创建到第x天首充人数
      ,a1.Day300FirstPayNum                     as day300_first_paynum -- 从创建到第x天首充人数
      ,a1.Day330FirstPayNum                     as day330_first_paynum -- 从创建到第x天首充人数
      ,a1.Day360FirstPayNum                     as day360_first_paynum -- 从创建到第x天首充人数
      ,a1.Day0PayNum                            as day0_paynum         -- 从创建到第x天充值数
      ,a1.Day1PayNum                            as day1_paynum         -- 从创建到第x天充值数
      ,a1.Day2PayNum                            as day2_paynum         -- 从创建到第x天充值数
      ,a1.Day3PayNum                            as day3_paynum         -- 从创建到第x天充值数
      ,a1.Day4PayNum                            as day4_paynum         -- 从创建到第x天充值数
      ,a1.Day5PayNum                            as day5_paynum         -- 从创建到第x天充值数
      ,a1.Day6PayNum                            as day6_paynum         -- 从创建到第x天充值数
      ,a1.Day7PayNum                            as day7_paynum         -- 从创建到第x天充值数
      ,a1.Day8PayNum                            as day8_paynum         -- 从创建到第x天充值数
      ,a1.Day9PayNum                            as day9_paynum         -- 从创建到第x天充值数
      ,a1.Day10PayNum                           as day10_paynum        -- 从创建到第x天充值数
      ,a1.Day11PayNum                           as day11_paynum        -- 从创建到第x天充值数
      ,a1.Day12PayNum                           as day12_paynum        -- 从创建到第x天充值数
      ,a1.Day13PayNum                           as day13_paynum        -- 从创建到第x天充值数
      ,a1.Day14PayNum                           as day14_paynum        -- 从创建到第x天充值数
      ,a1.Day15PayNum                           as day15_paynum        -- 从创建到第x天充值数
      ,a1.Day16PayNum                           as day16_paynum        -- 从创建到第x天充值数
      ,a1.Day17PayNum                           as day17_paynum        -- 从创建到第x天充值数
      ,a1.Day18PayNum                           as day18_paynum        -- 从创建到第x天充值数
      ,a1.Day19PayNum                           as day19_paynum        -- 从创建到第x天充值数
      ,a1.Day20PayNum                           as day20_paynum        -- 从创建到第x天充值数
      ,a1.Day21PayNum                           as day21_paynum        -- 从创建到第x天充值数
      ,a1.Day22PayNum                           as day22_paynum        -- 从创建到第x天充值数
      ,a1.Day23PayNum                           as day23_paynum        -- 从创建到第x天充值数
      ,a1.Day24PayNum                           as day24_paynum        -- 从创建到第x天充值数
      ,a1.Day25PayNum                           as day25_paynum        -- 从创建到第x天充值数
      ,a1.Day26PayNum                           as day26_paynum        -- 从创建到第x天充值数
      ,a1.Day27PayNum                           as day27_paynum        -- 从创建到第x天充值数
      ,a1.Day28PayNum                           as day28_paynum        -- 从创建到第x天充值数
      ,a1.Day29PayNum                           as day29_paynum        -- 从创建到第x天充值数
      ,a1.Day30PayNum                           as day30_paynum        -- 从创建到第x天充值数
      ,a1.Day31PayNum                           as day31_paynum        -- 从创建到第x天充值数
      ,a1.Day32PayNum                           as day32_paynum        -- 从创建到第x天充值数
      ,a1.Day33PayNum                           as day33_paynum        -- 从创建到第x天充值数
      ,a1.Day34PayNum                           as day34_paynum        -- 从创建到第x天充值数
      ,a1.Day35PayNum                           as day35_paynum        -- 从创建到第x天充值数
      ,a1.Day36PayNum                           as day36_paynum        -- 从创建到第x天充值数
      ,a1.Day37PayNum                           as day37_paynum        -- 从创建到第x天充值数
      ,a1.Day38PayNum                           as day38_paynum        -- 从创建到第x天充值数
      ,a1.Day39PayNum                           as day39_paynum        -- 从创建到第x天充值数
      ,a1.Day40PayNum                           as day40_paynum        -- 从创建到第x天充值数
      ,a1.Day41PayNum                           as day41_paynum        -- 从创建到第x天充值数
      ,a1.Day42PayNum                           as day42_paynum        -- 从创建到第x天充值数
      ,a1.Day43PayNum                           as day43_paynum        -- 从创建到第x天充值数
      ,a1.Day44PayNum                           as day44_paynum        -- 从创建到第x天充值数
      ,a1.Day45PayNum                           as day45_paynum        -- 从创建到第x天充值数
      ,a1.Day46PayNum                           as day46_paynum        -- 从创建到第x天充值数
      ,a1.Day47PayNum                           as day47_paynum        -- 从创建到第x天充值数
      ,a1.Day48PayNum                           as day48_paynum        -- 从创建到第x天充值数
      ,a1.Day49PayNum                           as day49_paynum        -- 从创建到第x天充值数
      ,a1.Day50PayNum                           as day50_paynum        -- 从创建到第x天充值数
      ,a1.Day51PayNum                           as day51_paynum        -- 从创建到第x天充值数
      ,a1.Day52PayNum                           as day52_paynum        -- 从创建到第x天充值数
      ,a1.Day53PayNum                           as day53_paynum        -- 从创建到第x天充值数
      ,a1.Day54PayNum                           as day54_paynum        -- 从创建到第x天充值数
      ,a1.Day55PayNum                           as day55_paynum        -- 从创建到第x天充值数
      ,a1.Day56PayNum                           as day56_paynum        -- 从创建到第x天充值数
      ,a1.Day57PayNum                           as day57_paynum        -- 从创建到第x天充值数
      ,a1.Day58PayNum                           as day58_paynum        -- 从创建到第x天充值数
      ,a1.Day59PayNum                           as day59_paynum        -- 从创建到第x天充值数
      ,a1.Day60PayNum                           as day60_paynum        -- 从创建到第x天充值数
      ,a1.Day61PayNum                           as day61_paynum        -- 从创建到第x天充值数
      ,a1.Day62PayNum                           as day62_paynum        -- 从创建到第x天充值数
      ,a1.Day63PayNum                           as day63_paynum        -- 从创建到第x天充值数
      ,a1.Day64PayNum                           as day64_paynum        -- 从创建到第x天充值数
      ,a1.Day65PayNum                           as day65_paynum        -- 从创建到第x天充值数
      ,a1.Day66PayNum                           as day66_paynum        -- 从创建到第x天充值数
      ,a1.Day67PayNum                           as day67_paynum        -- 从创建到第x天充值数
      ,a1.Day68PayNum                           as day68_paynum        -- 从创建到第x天充值数
      ,a1.Day69PayNum                           as day69_paynum        -- 从创建到第x天充值数
      ,a1.Day70PayNum                           as day70_paynum        -- 从创建到第x天充值数
      ,a1.Day71PayNum                           as day71_paynum        -- 从创建到第x天充值数
      ,a1.Day72PayNum                           as day72_paynum        -- 从创建到第x天充值数
      ,a1.Day73PayNum                           as day73_paynum        -- 从创建到第x天充值数
      ,a1.Day74PayNum                           as day74_paynum        -- 从创建到第x天充值数
      ,a1.Day75PayNum                           as day75_paynum        -- 从创建到第x天充值数
      ,a1.Day76PayNum                           as day76_paynum        -- 从创建到第x天充值数
      ,a1.Day77PayNum                           as day77_paynum        -- 从创建到第x天充值数
      ,a1.Day78PayNum                           as day78_paynum        -- 从创建到第x天充值数
      ,a1.Day79PayNum                           as day79_paynum        -- 从创建到第x天充值数
      ,a1.Day80PayNum                           as day80_paynum        -- 从创建到第x天充值数
      ,a1.Day81PayNum                           as day81_paynum        -- 从创建到第x天充值数
      ,a1.Day82PayNum                           as day82_paynum        -- 从创建到第x天充值数
      ,a1.Day83PayNum                           as day83_paynum        -- 从创建到第x天充值数
      ,a1.Day84PayNum                           as day84_paynum        -- 从创建到第x天充值数
      ,a1.Day85PayNum                           as day85_paynum        -- 从创建到第x天充值数
      ,a1.Day86PayNum                           as day86_paynum        -- 从创建到第x天充值数
      ,a1.Day87PayNum                           as day87_paynum        -- 从创建到第x天充值数
      ,a1.Day88PayNum                           as day88_paynum        -- 从创建到第x天充值数
      ,a1.Day89PayNum                           as day89_paynum        -- 从创建到第x天充值数
      ,a1.Day90PayNum                           as day90_paynum        -- 从创建到第x天充值数
      ,a1.Day120PayNum                          as day120_paynum       -- 从创建到第x天充值数
      ,a1.Day150PayNum                          as day150_paynum       -- 从创建到第x天充值数
      ,a1.Day180PayNum                          as day180_paynum       -- 从创建到第x天充值数
      ,a1.Day210PayNum                          as day210_paynum       -- 从创建到第x天充值数
      ,a1.Day240PayNum                          as day240_paynum       -- 从创建到第x天充值数
      ,a1.Day270PayNum                          as day270_paynum       -- 从创建到第x天充值数
      ,a1.Day300PayNum                          as day300_paynum       -- 从创建到第x天充值数
      ,a1.Day330PayNum                          as day330_paynum       -- 从创建到第x天充值数
      ,a1.Day360PayNum                          as day360_paynum       -- 从创建到第x天充值数
      ,a1.PayNumByAt                            as paynum_byat         -- 充值数
      ,a1.PayUserByAt                           as payuser_byat        -- 充值数
      ,a1.Day0FirstPayTimes                     as day0firstpaytimes   -- 第0天充值数
      ,a1.Day0AmountAdMob                       as day0_amount_admob   -- 从创建到第x天的AdMob广告收入
      ,a1.Day0AmountMax                         as day0_amount_max     -- 从创建到第x天的Max广告收入
      ,a1.Day0AmountH5                          as day0_amount_h5      -- 从创建到第x天的H5广告收入
  from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer as a1
;
