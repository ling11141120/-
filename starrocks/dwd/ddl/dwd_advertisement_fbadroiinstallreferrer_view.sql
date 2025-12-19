create or replace view dwd.`dwd_advertisement_fbadroiinstallreferrer_view`
            (`id`, `dt` comment "createtime 分区", `ad_id` comment "广告id", `create_time` comment "创建时间",
             `pay_list` comment "充值信息", `reg_num` comment "注册数", `cost_amount` comment "成本",
             `product_id` comment "产品id", `pay_num` comment "充值数", `update_time` comment "更新时间",
             `paylist_by_days` comment "充值信息列表", `check_sum` comment "检查总数", `login_num2`, `login_num3`,
             `login_num7`, `core` comment "core", `mt` comment "设备类型", `fb_account` comment "fb账户",
             `ad_set_id` comment "广告setid", `ad_camp_id` comment "广告campid", `dev_num`, `group_id` comment "组id",
             `source_chl` comment "渠道", `chl2` comment "渠道2", `row_version` comment "版本",
             `current_language2` comment "当前语言", `ads_quality` comment "质量", `updater`,
             `day0_amount` comment "从创建到第x天的总充值金额", `day1_amount` comment "从创建到第x天的总充值金额",
             `day2_amount` comment "从创建到第x天的总充值金额", `day3_amount` comment "从创建到第x天的总充值金额",
             `day4_amount` comment "从创建到第x天的总充值金额", `day5_amount` comment "从创建到第x天的总充值金额",
             `day6_amount` comment "从创建到第x天的总充值金额", `day7_amount` comment "从创建到第x天的总充值金额",
             `day8_amount` comment "从创建到第x天的总充值金额", `day9_amount` comment "从创建到第x天的总充值金额",
             `day10_amount` comment "从创建到第x天的总充值金额", `day11_amount` comment "从创建到第x天的总充值金额",
             `day12_amount` comment "从创建到第x天的总充值金额", `day13_amount` comment "从创建到第x天的总充值金额",
             `day14_amount` comment "从创建到第x天的总充值金额", `day15_amount` comment "从创建到第x天的总充值金额",
             `day16_amount` comment "从创建到第x天的总充值金额", `day17_amount` comment "从创建到第x天的总充值金额",
             `day18_amount` comment "从创建到第x天的总充值金额", `day19_amount` comment "从创建到第x天的总充值金额",
             `day20_amount` comment "从创建到第x天的总充值金额", `day21_amount` comment "从创建到第x天的总充值金额",
             `day22_amount` comment "从创建到第x天的总充值金额", `day23_amount` comment "从创建到第x天的总充值金额",
             `day24_amount` comment "从创建到第x天的总充值金额", `day25_amount` comment "从创建到第x天的总充值金额",
             `day26_amount` comment "从创建到第x天的总充值金额", `day27_amount` comment "从创建到第x天的总充值金额",
             `day28_amount` comment "从创建到第x天的总充值金额", `day29_amount` comment "从创建到第x天的总充值金额",
             `day30_amount` comment "从创建到第x天的总充值金额", `day31_amount` comment "从创建到第x天的总充值金额",
             `day32_amount` comment "从创建到第x天的总充值金额", `day33_amount` comment "从创建到第x天的总充值金额",
             `day34_amount` comment "从创建到第x天的总充值金额", `day35_amount` comment "从创建到第x天的总充值金额",
             `day36_amount` comment "从创建到第x天的总充值金额", `day37_amount` comment "从创建到第x天的总充值金额",
             `day38_amount` comment "从创建到第x天的总充值金额", `day39_amount` comment "从创建到第x天的总充值金额",
             `day40_amount` comment "从创建到第x天的总充值金额", `day41_amount` comment "从创建到第x天的总充值金额",
             `day42_amount` comment "从创建到第x天的总充值金额", `day43_amount` comment "从创建到第x天的总充值金额",
             `day44_amount` comment "从创建到第x天的总充值金额", `day45_amount` comment "从创建到第x天的总充值金额",
             `day46_amount` comment "从创建到第x天的总充值金额", `day47_amount` comment "从创建到第x天的总充值金额",
             `day48_amount` comment "从创建到第x天的总充值金额", `day49_amount` comment "从创建到第x天的总充值金额",
             `day50_amount` comment "从创建到第x天的总充值金额", `day51_amount` comment "从创建到第x天的总充值金额",
             `day52_amount` comment "从创建到第x天的总充值金额", `day53_amount` comment "从创建到第x天的总充值金额",
             `day54_amount` comment "从创建到第x天的总充值金额", `day55_amount` comment "从创建到第x天的总充值金额",
             `day56_amount` comment "从创建到第x天的总充值金额", `day57_amount` comment "从创建到第x天的总充值金额",
             `day58_amount` comment "从创建到第x天的总充值金额", `day59_amount` comment "从创建到第x天的总充值金额",
             `day60_amount` comment "从创建到第x天的总充值金额", `day61_amount` comment "从创建到第x天的总充值金额",
             `day62_amount` comment "从创建到第x天的总充值金额", `day63_amount` comment "从创建到第x天的总充值金额",
             `day64_amount` comment "从创建到第x天的总充值金额", `day65_amount` comment "从创建到第x天的总充值金额",
             `day66_amount` comment "从创建到第x天的总充值金额", `day67_amount` comment "从创建到第x天的总充值金额",
             `day68_amount` comment "从创建到第x天的总充值金额", `day69_amount` comment "从创建到第x天的总充值金额",
             `day70_amount` comment "从创建到第x天的总充值金额", `day71_amount` comment "从创建到第x天的总充值金额",
             `day72_amount` comment "从创建到第x天的总充值金额", `day73_amount` comment "从创建到第x天的总充值金额",
             `day74_amount` comment "从创建到第x天的总充值金额", `day75_amount` comment "从创建到第x天的总充值金额",
             `day76_amount` comment "从创建到第x天的总充值金额", `day77_amount` comment "从创建到第x天的总充值金额",
             `day78_amount` comment "从创建到第x天的总充值金额", `day79_amount` comment "从创建到第x天的总充值金额",
             `day80_amount` comment "从创建到第x天的总充值金额", `day81_amount` comment "从创建到第x天的总充值金额",
             `day82_amount` comment "从创建到第x天的总充值金额", `day83_amount` comment "从创建到第x天的总充值金额",
             `day84_amount` comment "从创建到第x天的总充值金额", `day85_amount` comment "从创建到第x天的总充值金额",
             `day86_amount` comment "从创建到第x天的总充值金额", `day87_amount` comment "从创建到第x天的总充值金额",
             `day88_amount` comment "从创建到第x天的总充值金额", `day89_amount` comment "从创建到第x天的总充值金额",
             `day90_amount` comment "从创建到第x天的总充值金额", `day120_amount` comment "从创建到第x天的总充值金额",
             `day150_amount` comment "从创建到第x天的总充值金额", `day180_amount` comment "从创建到第x天的总充值金额",
             `day210_amount` comment "从创建到第x天的总充值金额", `day240_amount` comment "从创建到第x天的总充值金额",
             `day270_amount` comment "从创建到第x天的总充值金额", `day300_amount` comment "从创建到第x天的总充值金额",
             `day330_amount` comment "从创建到第x天的总充值金额", `day360_amount` comment "从创建到第x天的总充值金额",
             `day0_amount_byad` comment "从创建到第x天的广告总收入",
             `day1_amount_byad` comment "从创建到第x天的广告总收入",
             `day2_amount_byad` comment "从创建到第x天的广告总收入",
             `day3_amount_byad` comment "从创建到第x天的广告总收入",
             `day4_amount_byad` comment "从创建到第x天的广告总收入",
             `day5_amount_byad` comment "从创建到第x天的广告总收入",
             `day6_amount_byad` comment "从创建到第x天的广告总收入",
             `day7_amount_byad` comment "从创建到第x天的广告总收入",
             `day8_amount_byad` comment "从创建到第x天的广告总收入",
             `day9_amount_byad` comment "从创建到第x天的广告总收入",
             `day10_amount_byad` comment "从创建到第x天的广告总收入",
             `day11_amount_byad` comment "从创建到第x天的广告总收入",
             `day12_amount_byad` comment "从创建到第x天的广告总收入",
             `day13_amount_byad` comment "从创建到第x天的广告总收入",
             `day14_amount_byad` comment "从创建到第x天的广告总收入",
             `day15_amount_byad` comment "从创建到第x天的广告总收入",
             `day16_amount_byad` comment "从创建到第x天的广告总收入",
             `day17_amount_byad` comment "从创建到第x天的广告总收入",
             `day18_amount_byad` comment "从创建到第x天的广告总收入",
             `day19_amount_byad` comment "从创建到第x天的广告总收入",
             `day20_amount_byad` comment "从创建到第x天的广告总收入",
             `day21_amount_byad` comment "从创建到第x天的广告总收入",
             `day22_amount_byad` comment "从创建到第x天的广告总收入",
             `day23_amount_byad` comment "从创建到第x天的广告总收入",
             `day24_amount_byad` comment "从创建到第x天的广告总收入",
             `day25_amount_byad` comment "从创建到第x天的广告总收入",
             `day26_amount_byad` comment "从创建到第x天的广告总收入",
             `day27_amount_byad` comment "从创建到第x天的广告总收入",
             `day28_amount_byad` comment "从创建到第x天的广告总收入",
             `day29_amount_byad` comment "从创建到第x天的广告总收入",
             `day30_amount_byad` comment "从创建到第x天的广告总收入",
             `day31_amount_byad` comment "从创建到第x天的广告总收入",
             `day32_amount_byad` comment "从创建到第x天的广告总收入",
             `day33_amount_byad` comment "从创建到第x天的广告总收入",
             `day34_amount_byad` comment "从创建到第x天的广告总收入",
             `day35_amount_byad` comment "从创建到第x天的广告总收入",
             `day36_amount_byad` comment "从创建到第x天的广告总收入",
             `day37_amount_byad` comment "从创建到第x天的广告总收入",
             `day38_amount_byad` comment "从创建到第x天的广告总收入",
             `day39_amount_byad` comment "从创建到第x天的广告总收入",
             `day40_amount_byad` comment "从创建到第x天的广告总收入",
             `day41_amount_byad` comment "从创建到第x天的广告总收入",
             `day42_amount_byad` comment "从创建到第x天的广告总收入",
             `day43_amount_byad` comment "从创建到第x天的广告总收入",
             `day44_amount_byad` comment "从创建到第x天的广告总收入",
             `day45_amount_byad` comment "从创建到第x天的广告总收入",
             `day46_amount_byad` comment "从创建到第x天的广告总收入",
             `day47_amount_byad` comment "从创建到第x天的广告总收入",
             `day48_amount_byad` comment "从创建到第x天的广告总收入",
             `day49_amount_byad` comment "从创建到第x天的广告总收入",
             `day50_amount_byad` comment "从创建到第x天的广告总收入",
             `day51_amount_byad` comment "从创建到第x天的广告总收入",
             `day52_amount_byad` comment "从创建到第x天的广告总收入",
             `day53_amount_byad` comment "从创建到第x天的广告总收入",
             `day54_amount_byad` comment "从创建到第x天的广告总收入",
             `day55_amount_byad` comment "从创建到第x天的广告总收入",
             `day56_amount_byad` comment "从创建到第x天的广告总收入",
             `day57_amount_byad` comment "从创建到第x天的广告总收入",
             `day58_amount_byad` comment "从创建到第x天的广告总收入",
             `day59_amount_byad` comment "从创建到第x天的广告总收入",
             `day60_amount_byad` comment "从创建到第x天的广告总收入",
             `day61_amount_byad` comment "从创建到第x天的广告总收入",
             `day62_amount_byad` comment "从创建到第x天的广告总收入",
             `day63_amount_byad` comment "从创建到第x天的广告总收入",
             `day64_amount_byad` comment "从创建到第x天的广告总收入",
             `day65_amount_byad` comment "从创建到第x天的广告总收入",
             `day66_amount_byad` comment "从创建到第x天的广告总收入",
             `day67_amount_byad` comment "从创建到第x天的广告总收入",
             `day68_amount_byad` comment "从创建到第x天的广告总收入",
             `day69_amount_byad` comment "从创建到第x天的广告总收入",
             `day70_amount_byad` comment "从创建到第x天的广告总收入",
             `day71_amount_byad` comment "从创建到第x天的广告总收入",
             `day72_amount_byad` comment "从创建到第x天的广告总收入",
             `day73_amount_byad` comment "从创建到第x天的广告总收入",
             `day74_amount_byad` comment "从创建到第x天的广告总收入",
             `day75_amount_byad` comment "从创建到第x天的广告总收入",
             `day76_amount_byad` comment "从创建到第x天的广告总收入",
             `day77_amount_byad` comment "从创建到第x天的广告总收入",
             `day78_amount_byad` comment "从创建到第x天的广告总收入",
             `day79_amount_byad` comment "从创建到第x天的广告总收入",
             `day80_amount_byad` comment "从创建到第x天的广告总收入",
             `day81_amount_byad` comment "从创建到第x天的广告总收入",
             `day82_amount_byad` comment "从创建到第x天的广告总收入",
             `day83_amount_byad` comment "从创建到第x天的广告总收入",
             `day84_amount_byad` comment "从创建到第x天的广告总收入",
             `day85_amount_byad` comment "从创建到第x天的广告总收入",
             `day86_amount_byad` comment "从创建到第x天的广告总收入",
             `day87_amount_byad` comment "从创建到第x天的广告总收入",
             `day88_amount_byad` comment "从创建到第x天的广告总收入",
             `day89_amount_byad` comment "从创建到第x天的广告总收入",
             `day90_amount_byad` comment "从创建到第x天的广告总收入",
             `day120_amount_byad` comment "从创建到第x天的广告总收入",
             `day150_amount_byad` comment "从创建到第x天的广告总收入",
             `day180_amount_byad` comment "从创建到第x天的广告总收入",
             `day210_amount_byad` comment "从创建到第x天的广告总收入",
             `day240_amount_byad` comment "从创建到第x天的广告总收入",
             `day270_amount_byad` comment "从创建到第x天的广告总收入",
             `day300_amount_byad` comment "从创建到第x天的广告总收入",
             `day330_amount_byad` comment "从创建到第x天的广告总收入",
             `day360_amount_byad` comment "从创建到第x天的广告总收入",
             `day0_first_paynum` comment "从创建到第x天首充人数", `day1_first_paynum` comment "从创建到第x天首充人数",
             `day2_first_paynum` comment "从创建到第x天首充人数", `day3_first_paynum` comment "从创建到第x天首充人数",
             `day4_first_paynum` comment "从创建到第x天首充人数", `day5_first_paynum` comment "从创建到第x天首充人数",
             `day6_first_paynum` comment "从创建到第x天首充人数", `day7_first_paynum` comment "从创建到第x天首充人数",
             `day8_first_paynum` comment "从创建到第x天首充人数", `day9_first_paynum` comment "从创建到第x天首充人数",
             `day10_first_paynum` comment "从创建到第x天首充人数", `day11_first_paynum` comment "从创建到第x天首充人数",
             `day12_first_paynum` comment "从创建到第x天首充人数", `day13_first_paynum` comment "从创建到第x天首充人数",
             `day14_first_paynum` comment "从创建到第x天首充人数", `day15_first_paynum` comment "从创建到第x天首充人数",
             `day16_first_paynum` comment "从创建到第x天首充人数", `day17_first_paynum` comment "从创建到第x天首充人数",
             `day18_first_paynum` comment "从创建到第x天首充人数", `day19_first_paynum` comment "从创建到第x天首充人数",
             `day20_first_paynum` comment "从创建到第x天首充人数", `day21_first_paynum` comment "从创建到第x天首充人数",
             `day22_first_paynum` comment "从创建到第x天首充人数", `day23_first_paynum` comment "从创建到第x天首充人数",
             `day24_first_paynum` comment "从创建到第x天首充人数", `day25_first_paynum` comment "从创建到第x天首充人数",
             `day26_first_paynum` comment "从创建到第x天首充人数", `day27_first_paynum` comment "从创建到第x天首充人数",
             `day28_first_paynum` comment "从创建到第x天首充人数", `day29_first_paynum` comment "从创建到第x天首充人数",
             `day30_first_paynum` comment "从创建到第x天首充人数", `day31_first_paynum` comment "从创建到第x天首充人数",
             `day32_first_paynum` comment "从创建到第x天首充人数", `day33_first_paynum` comment "从创建到第x天首充人数",
             `day34_first_paynum` comment "从创建到第x天首充人数", `day35_first_paynum` comment "从创建到第x天首充人数",
             `day36_first_paynum` comment "从创建到第x天首充人数", `day37_first_paynum` comment "从创建到第x天首充人数",
             `day38_first_paynum` comment "从创建到第x天首充人数", `day39_first_paynum` comment "从创建到第x天首充人数",
             `day40_first_paynum` comment "从创建到第x天首充人数", `day41_first_paynum` comment "从创建到第x天首充人数",
             `day42_first_paynum` comment "从创建到第x天首充人数", `day43_first_paynum` comment "从创建到第x天首充人数",
             `day44_first_paynum` comment "从创建到第x天首充人数", `day45_first_paynum` comment "从创建到第x天首充人数",
             `day46_first_paynum` comment "从创建到第x天首充人数", `day47_first_paynum` comment "从创建到第x天首充人数",
             `day48_first_paynum` comment "从创建到第x天首充人数", `day49_first_paynum` comment "从创建到第x天首充人数",
             `day50_first_paynum` comment "从创建到第x天首充人数", `day51_first_paynum` comment "从创建到第x天首充人数",
             `day52_first_paynum` comment "从创建到第x天首充人数", `day53_first_paynum` comment "从创建到第x天首充人数",
             `day54_first_paynum` comment "从创建到第x天首充人数", `day55_first_paynum` comment "从创建到第x天首充人数",
             `day56_first_paynum` comment "从创建到第x天首充人数", `day57_first_paynum` comment "从创建到第x天首充人数",
             `day58_first_paynum` comment "从创建到第x天首充人数", `day59_first_paynum` comment "从创建到第x天首充人数",
             `day60_first_paynum` comment "从创建到第x天首充人数", `day61_first_paynum` comment "从创建到第x天首充人数",
             `day62_first_paynum` comment "从创建到第x天首充人数", `day63_first_paynum` comment "从创建到第x天首充人数",
             `day64_first_paynum` comment "从创建到第x天首充人数", `day65_first_paynum` comment "从创建到第x天首充人数",
             `day66_first_paynum` comment "从创建到第x天首充人数", `day67_first_paynum` comment "从创建到第x天首充人数",
             `day68_first_paynum` comment "从创建到第x天首充人数", `day69_first_paynum` comment "从创建到第x天首充人数",
             `day70_first_paynum` comment "从创建到第x天首充人数", `day71_first_paynum` comment "从创建到第x天首充人数",
             `day72_first_paynum` comment "从创建到第x天首充人数", `day73_first_paynum` comment "从创建到第x天首充人数",
             `day74_first_paynum` comment "从创建到第x天首充人数", `day75_first_paynum` comment "从创建到第x天首充人数",
             `day76_first_paynum` comment "从创建到第x天首充人数", `day77_first_paynum` comment "从创建到第x天首充人数",
             `day78_first_paynum` comment "从创建到第x天首充人数", `day79_first_paynum` comment "从创建到第x天首充人数",
             `day80_first_paynum` comment "从创建到第x天首充人数", `day81_first_paynum` comment "从创建到第x天首充人数",
             `day82_first_paynum` comment "从创建到第x天首充人数", `day83_first_paynum` comment "从创建到第x天首充人数",
             `day84_first_paynum` comment "从创建到第x天首充人数", `day85_first_paynum` comment "从创建到第x天首充人数",
             `day86_first_paynum` comment "从创建到第x天首充人数", `day87_first_paynum` comment "从创建到第x天首充人数",
             `day88_first_paynum` comment "从创建到第x天首充人数", `day89_first_paynum` comment "从创建到第x天首充人数",
             `day90_first_paynum` comment "从创建到第x天首充人数",
             `day120_first_paynum` comment "从创建到第x天首充人数",
             `day150_first_paynum` comment "从创建到第x天首充人数",
             `day180_first_paynum` comment "从创建到第x天首充人数",
             `day210_first_paynum` comment "从创建到第x天首充人数",
             `day240_first_paynum` comment "从创建到第x天首充人数",
             `day270_first_paynum` comment "从创建到第x天首充人数",
             `day300_first_paynum` comment "从创建到第x天首充人数",
             `day330_first_paynum` comment "从创建到第x天首充人数",
             `day360_first_paynum` comment "从创建到第x天首充人数", `day0_paynum` comment "从创建到第x天充值数",
             `day1_paynum` comment "从创建到第x天充值数", `day2_paynum` comment "从创建到第x天充值数",
             `day3_paynum` comment "从创建到第x天充值数", `day4_paynum` comment "从创建到第x天充值数",
             `day5_paynum` comment "从创建到第x天充值数", `day6_paynum` comment "从创建到第x天充值数",
             `day7_paynum` comment "从创建到第x天充值数", `day8_paynum` comment "从创建到第x天充值数",
             `day9_paynum` comment "从创建到第x天充值数", `day10_paynum` comment "从创建到第x天充值数",
             `day11_paynum` comment "从创建到第x天充值数", `day12_paynum` comment "从创建到第x天充值数",
             `day13_paynum` comment "从创建到第x天充值数", `day14_paynum` comment "从创建到第x天充值数",
             `day15_paynum` comment "从创建到第x天充值数", `day16_paynum` comment "从创建到第x天充值数",
             `day17_paynum` comment "从创建到第x天充值数", `day18_paynum` comment "从创建到第x天充值数",
             `day19_paynum` comment "从创建到第x天充值数", `day20_paynum` comment "从创建到第x天充值数",
             `day21_paynum` comment "从创建到第x天充值数", `day22_paynum` comment "从创建到第x天充值数",
             `day23_paynum` comment "从创建到第x天充值数", `day24_paynum` comment "从创建到第x天充值数",
             `day25_paynum` comment "从创建到第x天充值数", `day26_paynum` comment "从创建到第x天充值数",
             `day27_paynum` comment "从创建到第x天充值数", `day28_paynum` comment "从创建到第x天充值数",
             `day29_paynum` comment "从创建到第x天充值数", `day30_paynum` comment "从创建到第x天充值数",
             `day31_paynum` comment "从创建到第x天充值数", `day32_paynum` comment "从创建到第x天充值数",
             `day33_paynum` comment "从创建到第x天充值数", `day34_paynum` comment "从创建到第x天充值数",
             `day35_paynum` comment "从创建到第x天充值数", `day36_paynum` comment "从创建到第x天充值数",
             `day37_paynum` comment "从创建到第x天充值数", `day38_paynum` comment "从创建到第x天充值数",
             `day39_paynum` comment "从创建到第x天充值数", `day40_paynum` comment "从创建到第x天充值数",
             `day41_paynum` comment "从创建到第x天充值数", `day42_paynum` comment "从创建到第x天充值数",
             `day43_paynum` comment "从创建到第x天充值数", `day44_paynum` comment "从创建到第x天充值数",
             `day45_paynum` comment "从创建到第x天充值数", `day46_paynum` comment "从创建到第x天充值数",
             `day47_paynum` comment "从创建到第x天充值数", `day48_paynum` comment "从创建到第x天充值数",
             `day49_paynum` comment "从创建到第x天充值数", `day50_paynum` comment "从创建到第x天充值数",
             `day51_paynum` comment "从创建到第x天充值数", `day52_paynum` comment "从创建到第x天充值数",
             `day53_paynum` comment "从创建到第x天充值数", `day54_paynum` comment "从创建到第x天充值数",
             `day55_paynum` comment "从创建到第x天充值数", `day56_paynum` comment "从创建到第x天充值数",
             `day57_paynum` comment "从创建到第x天充值数", `day58_paynum` comment "从创建到第x天充值数",
             `day59_paynum` comment "从创建到第x天充值数", `day60_paynum` comment "从创建到第x天充值数",
             `day61_paynum` comment "从创建到第x天充值数", `day62_paynum` comment "从创建到第x天充值数",
             `day63_paynum` comment "从创建到第x天充值数", `day64_paynum` comment "从创建到第x天充值数",
             `day65_paynum` comment "从创建到第x天充值数", `day66_paynum` comment "从创建到第x天充值数",
             `day67_paynum` comment "从创建到第x天充值数", `day68_paynum` comment "从创建到第x天充值数",
             `day69_paynum` comment "从创建到第x天充值数", `day70_paynum` comment "从创建到第x天充值数",
             `day71_paynum` comment "从创建到第x天充值数", `day72_paynum` comment "从创建到第x天充值数",
             `day73_paynum` comment "从创建到第x天充值数", `day74_paynum` comment "从创建到第x天充值数",
             `day75_paynum` comment "从创建到第x天充值数", `day76_paynum` comment "从创建到第x天充值数",
             `day77_paynum` comment "从创建到第x天充值数", `day78_paynum` comment "从创建到第x天充值数",
             `day79_paynum` comment "从创建到第x天充值数", `day80_paynum` comment "从创建到第x天充值数",
             `day81_paynum` comment "从创建到第x天充值数", `day82_paynum` comment "从创建到第x天充值数",
             `day83_paynum` comment "从创建到第x天充值数", `day84_paynum` comment "从创建到第x天充值数",
             `day85_paynum` comment "从创建到第x天充值数", `day86_paynum` comment "从创建到第x天充值数",
             `day87_paynum` comment "从创建到第x天充值数", `day88_paynum` comment "从创建到第x天充值数",
             `day89_paynum` comment "从创建到第x天充值数", `day90_paynum` comment "从创建到第x天充值数",
             `day120_paynum` comment "从创建到第x天充值数", `day150_paynum` comment "从创建到第x天充值数",
             `day180_paynum` comment "从创建到第x天充值数", `day210_paynum` comment "从创建到第x天充值数",
             `day240_paynum` comment "从创建到第x天充值数", `day270_paynum` comment "从创建到第x天充值数",
             `day300_paynum` comment "从创建到第x天充值数", `day330_paynum` comment "从创建到第x天充值数",
             `day360_paynum` comment "从创建到第x天充值数", `paynum_byat` comment "充值数",
             `payuser_byat` comment "充值数", `day0firstpaytimes` comment "第0天充值数")
as
select `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`dt`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`AdId`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`CreateTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`PayList`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`RegNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`CostAmount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`ProductId`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`UpdateTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`PayListByDays`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`CheckSum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`LoginNum2`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`LoginNum3`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`LoginNum7`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Core`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Mt`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`FbAccount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`AdSetId`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`AdCampId`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`DevNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`GroupId`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`SourceChl`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Chl2`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`RowVersion`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`CurrentLanguage2`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`AdsQuality`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Updater`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day0Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day1Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day2Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day3Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day4Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day5Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day6Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day7Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day8Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day9Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day10Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day11Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day12Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day13Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day14Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day15Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day16Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day17Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day18Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day19Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day20Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day21Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day22Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day23Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day24Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day25Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day26Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day27Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day28Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day29Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day30Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day31Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day32Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day33Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day34Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day35Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day36Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day37Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day38Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day39Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day40Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day41Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day42Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day43Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day44Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day45Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day46Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day47Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day48Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day49Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day50Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day51Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day52Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day53Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day54Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day55Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day56Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day57Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day58Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day59Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day60Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day61Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day62Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day63Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day64Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day65Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day66Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day67Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day68Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day69Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day70Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day71Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day72Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day73Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day74Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day75Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day76Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day77Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day78Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day79Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day80Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day81Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day82Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day83Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day84Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day85Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day86Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day87Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day88Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day89Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day90Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day120Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day150Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day180Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day210Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day240Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day270Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day300Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day330Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day360Amount`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day0AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day1AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day2AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day3AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day4AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day5AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day6AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day7AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day8AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day9AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day10AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day11AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day12AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day13AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day14AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day15AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day16AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day17AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day18AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day19AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day20AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day21AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day22AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day23AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day24AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day25AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day26AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day27AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day28AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day29AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day30AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day31AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day32AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day33AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day34AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day35AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day36AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day37AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day38AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day39AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day40AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day41AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day42AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day43AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day44AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day45AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day46AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day47AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day48AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day49AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day50AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day51AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day52AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day53AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day54AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day55AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day56AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day57AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day58AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day59AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day60AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day61AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day62AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day63AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day64AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day65AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day66AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day67AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day68AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day69AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day70AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day71AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day72AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day73AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day74AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day75AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day76AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day77AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day78AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day79AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day80AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day81AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day82AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day83AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day84AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day85AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day86AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day87AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day88AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day89AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day90AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day120AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day150AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day180AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day210AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day240AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day270AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day300AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day330AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day360AmountByAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day0FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day1FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day2FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day3FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day4FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day5FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day6FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day7FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day8FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day9FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day10FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day11FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day12FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day13FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day14FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day15FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day16FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day17FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day18FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day19FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day20FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day21FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day22FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day23FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day24FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day25FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day26FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day27FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day28FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day29FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day30FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day31FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day32FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day33FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day34FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day35FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day36FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day37FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day38FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day39FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day40FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day41FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day42FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day43FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day44FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day45FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day46FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day47FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day48FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day49FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day50FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day51FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day52FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day53FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day54FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day55FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day56FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day57FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day58FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day59FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day60FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day61FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day62FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day63FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day64FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day65FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day66FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day67FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day68FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day69FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day70FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day71FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day72FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day73FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day74FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day75FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day76FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day77FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day78FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day79FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day80FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day81FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day82FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day83FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day84FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day85FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day86FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day87FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day88FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day89FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day90FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day120FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day150FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day180FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day210FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day240FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day270FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day300FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day330FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day360FirstPayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day0PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day1PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day2PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day3PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day4PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day5PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day6PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day7PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day8PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day9PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day10PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day11PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day12PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day13PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day14PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day15PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day16PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day17PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day18PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day19PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day20PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day21PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day22PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day23PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day24PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day25PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day26PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day27PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day28PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day29PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day30PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day31PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day32PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day33PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day34PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day35PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day36PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day37PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day38PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day39PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day40PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day41PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day42PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day43PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day44PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day45PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day46PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day47PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day48PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day49PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day50PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day51PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day52PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day53PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day54PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day55PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day56PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day57PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day58PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day59PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day60PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day61PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day62PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day63PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day64PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day65PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day66PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day67PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day68PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day69PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day70PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day71PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day72PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day73PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day74PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day75PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day76PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day77PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day78PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day79PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day80PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day81PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day82PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day83PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day84PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day85PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day86PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day87PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day88PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day89PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day90PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day120PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day150PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day180PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day210PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day240PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day270PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day300PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day330PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day360PayNum`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`PayNumByAt`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`PayUserByAt`
     , `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`.`Day0FirstPayTimes`
  from `ods`.`ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer`;