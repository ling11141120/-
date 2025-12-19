create or replace view dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view (
     id
    ,ad_id
    ,create_time
    ,pay_list
    ,reg_num
    ,impressions
    ,link_clicks
    ,installs
    ,cost_amount
    ,product_id
    ,pay_num
    ,update_time
    ,pay_list_by_days
    ,check_sum
    ,login_num2
    ,login_num3
    ,login_num7
    ,core
    ,mt
    ,fb_account
    ,ad_set_id
    ,ad_camp_id
    ,dev_num
    ,group_id
    ,source_chl
    ,chl2
    ,row_version
    ,current_language2
    ,ads_quality
    ,updater
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
    ,day31_amount
    ,day32_amount
    ,day33_amount
    ,day34_amount
    ,day35_amount
    ,day36_amount
    ,day37_amount
    ,day38_amount
    ,day39_amount
    ,day40_amount
    ,day41_amount
    ,day42_amount
    ,day43_amount
    ,day44_amount
    ,day45_amount
    ,day46_amount
    ,day47_amount
    ,day48_amount
    ,day49_amount
    ,day50_amount
    ,day51_amount
    ,day52_amount
    ,day53_amount
    ,day54_amount
    ,day55_amount
    ,day56_amount
    ,day57_amount
    ,day58_amount
    ,day59_amount
    ,day60_amount
    ,day61_amount
    ,day62_amount
    ,day63_amount
    ,day64_amount
    ,day65_amount
    ,day66_amount
    ,day67_amount
    ,day68_amount
    ,day69_amount
    ,day70_amount
    ,day71_amount
    ,day72_amount
    ,day73_amount
    ,day74_amount
    ,day75_amount
    ,day76_amount
    ,day77_amount
    ,day78_amount
    ,day79_amount
    ,day80_amount
    ,day81_amount
    ,day82_amount
    ,day83_amount
    ,day84_amount
    ,day85_amount
    ,day86_amount
    ,day87_amount
    ,day88_amount
    ,day89_amount
    ,day90_amount
    ,day120_amount
    ,day150_amount
    ,day180_amount
    ,day210_amount
    ,day240_amount
    ,day270_amount
    ,day300_amount
    ,day330_amount
    ,day360_amount
    ,day0_amount_by_ad
    ,day1_amount_by_ad
    ,day2_amount_by_ad
    ,day3_amount_by_ad
    ,day4_amount_by_ad
    ,day5_amount_by_ad
    ,day6_amount_by_ad
    ,day7_amount_by_ad
    ,day8_amount_by_ad
    ,day9_amount_by_ad
    ,day10_amount_by_ad
    ,day11_amount_by_ad
    ,day12_amount_by_ad
    ,day13_amount_by_ad
    ,day14_amount_by_ad
    ,day15_amount_by_ad
    ,day16_amount_by_ad
    ,day17_amount_by_ad
    ,day18_amount_by_ad
    ,day19_amount_by_ad
    ,day20_amount_by_ad
    ,day21_amount_by_ad
    ,day22_amount_by_ad
    ,day23_amount_by_ad
    ,day24_amount_by_ad
    ,day25_amount_by_ad
    ,day26_amount_by_ad
    ,day27_amount_by_ad
    ,day28_amount_by_ad
    ,day29_amount_by_ad
    ,day30_amount_by_ad
    ,day31_amount_by_ad
    ,day32_amount_by_ad
    ,day33_amount_by_ad
    ,day34_amount_by_ad
    ,day35_amount_by_ad
    ,day36_amount_by_ad
    ,day37_amount_by_ad
    ,day38_amount_by_ad
    ,day39_amount_by_ad
    ,day40_amount_by_ad
    ,day41_amount_by_ad
    ,day42_amount_by_ad
    ,day43_amount_by_ad
    ,day44_amount_by_ad
    ,day45_amount_by_ad
    ,day46_amount_by_ad
    ,day47_amount_by_ad
    ,day48_amount_by_ad
    ,day49_amount_by_ad
    ,day50_amount_by_ad
    ,day51_amount_by_ad
    ,day52_amount_by_ad
    ,day53_amount_by_ad
    ,day54_amount_by_ad
    ,day55_amount_by_ad
    ,day56_amount_by_ad
    ,day57_amount_by_ad
    ,day58_amount_by_ad
    ,day59_amount_by_ad
    ,day60_amount_by_ad
    ,day61_amount_by_ad
    ,day62_amount_by_ad
    ,day63_amount_by_ad
    ,day64_amount_by_ad
    ,day65_amount_by_ad
    ,day66_amount_by_ad
    ,day67_amount_by_ad
    ,day68_amount_by_ad
    ,day69_amount_by_ad
    ,day70_amount_by_ad
    ,day71_amount_by_ad
    ,day72_amount_by_ad
    ,day73_amount_by_ad
    ,day74_amount_by_ad
    ,day75_amount_by_ad
    ,day76_amount_by_ad
    ,day77_amount_by_ad
    ,day78_amount_by_ad
    ,day79_amount_by_ad
    ,day80_amount_by_ad
    ,day81_amount_by_ad
    ,day82_amount_by_ad
    ,day83_amount_by_ad
    ,day84_amount_by_ad
    ,day85_amount_by_ad
    ,day86_amount_by_ad
    ,day87_amount_by_ad
    ,day88_amount_by_ad
    ,day89_amount_by_ad
    ,day90_amount_by_ad
    ,day120_amount_by_ad
    ,day150_amount_by_ad
    ,day180_amount_by_ad
    ,day210_amount_by_ad
    ,day240_amount_by_ad
    ,day270_amount_by_ad
    ,day300_amount_by_ad
    ,day330_amount_by_ad
    ,day360_amount_by_ad
    ,day0_first_pay_num
    ,day1_first_pay_num
    ,day2_first_pay_num
    ,day3_first_pay_num
    ,day4_first_pay_num
    ,day5_first_pay_num
    ,day6_first_pay_num
    ,day7_first_pay_num
    ,day8_first_pay_num
    ,day9_first_pay_num
    ,day10_first_pay_num
    ,day11_first_pay_num
    ,day12_first_pay_num
    ,day13_first_pay_num
    ,day14_first_pay_num
    ,day15_first_pay_num
    ,day16_first_pay_num
    ,day17_first_pay_num
    ,day18_first_pay_num
    ,day19_first_pay_num
    ,day20_first_pay_num
    ,day21_first_pay_num
    ,day22_first_pay_num
    ,day23_first_pay_num
    ,day24_first_pay_num
    ,day25_first_pay_num
    ,day26_first_pay_num
    ,day27_first_pay_num
    ,day28_first_pay_num
    ,day29_first_pay_num
    ,day30_first_pay_num
    ,day31_first_pay_num
    ,day32_first_pay_num
    ,day33_first_pay_num
    ,day34_first_pay_num
    ,day35_first_pay_num
    ,day36_first_pay_num
    ,day37_first_pay_num
    ,day38_first_pay_num
    ,day39_first_pay_num
    ,day40_first_pay_num
    ,day41_first_pay_num
    ,day42_first_pay_num
    ,day43_first_pay_num
    ,day44_first_pay_num
    ,day45_first_pay_num
    ,day46_first_pay_num
    ,day47_first_pay_num
    ,day48_first_pay_num
    ,day49_first_pay_num
    ,day50_first_pay_num
    ,day51_first_pay_num
    ,day52_first_pay_num
    ,day53_first_pay_num
    ,day54_first_pay_num
    ,day55_first_pay_num
    ,day56_first_pay_num
    ,day57_first_pay_num
    ,day58_first_pay_num
    ,day59_first_pay_num
    ,day60_first_pay_num
    ,day61_first_pay_num
    ,day62_first_pay_num
    ,day63_first_pay_num
    ,day64_first_pay_num
    ,day65_first_pay_num
    ,day66_first_pay_num
    ,day67_first_pay_num
    ,day68_first_pay_num
    ,day69_first_pay_num
    ,day70_first_pay_num
    ,day71_first_pay_num
    ,day72_first_pay_num
    ,day73_first_pay_num
    ,day74_first_pay_num
    ,day75_first_pay_num
    ,day76_first_pay_num
    ,day77_first_pay_num
    ,day78_first_pay_num
    ,day79_first_pay_num
    ,day80_first_pay_num
    ,day81_first_pay_num
    ,day82_first_pay_num
    ,day83_first_pay_num
    ,day84_first_pay_num
    ,day85_first_pay_num
    ,day86_first_pay_num
    ,day87_first_pay_num
    ,day88_first_pay_num
    ,day89_first_pay_num
    ,day90_first_pay_num
    ,day120_first_pay_num
    ,day150_first_pay_num
    ,day180_first_pay_num
    ,day210_first_pay_num
    ,day240_first_pay_num
    ,day270_first_pay_num
    ,day300_first_pay_num
    ,day330_first_pay_num
    ,day360_first_pay_num
    ,day0_pay_num
    ,day1_pay_num
    ,day2_pay_num
    ,day3_pay_num
    ,day4_pay_num
    ,day5_pay_num
    ,day6_pay_num
    ,day7_pay_num
    ,day8_pay_num
    ,day9_pay_num
    ,day10_pay_num
    ,day11_pay_num
    ,day12_pay_num
    ,day13_pay_num
    ,day14_pay_num
    ,day15_pay_num
    ,day16_pay_num
    ,day17_pay_num
    ,day18_pay_num
    ,day19_pay_num
    ,day20_pay_num
    ,day21_pay_num
    ,day22_pay_num
    ,day23_pay_num
    ,day24_pay_num
    ,day25_pay_num
    ,day26_pay_num
    ,day27_pay_num
    ,day28_pay_num
    ,day29_pay_num
    ,day30_pay_num
    ,day31_pay_num
    ,day32_pay_num
    ,day33_pay_num
    ,day34_pay_num
    ,day35_pay_num
    ,day36_pay_num
    ,day37_pay_num
    ,day38_pay_num
    ,day39_pay_num
    ,day40_pay_num
    ,day41_pay_num
    ,day42_pay_num
    ,day43_pay_num
    ,day44_pay_num
    ,day45_pay_num
    ,day46_pay_num
    ,day47_pay_num
    ,day48_pay_num
    ,day49_pay_num
    ,day50_pay_num
    ,day51_pay_num
    ,day52_pay_num
    ,day53_pay_num
    ,day54_pay_num
    ,day55_pay_num
    ,day56_pay_num
    ,day57_pay_num
    ,day58_pay_num
    ,day59_pay_num
    ,day60_pay_num
    ,day61_pay_num
    ,day62_pay_num
    ,day63_pay_num
    ,day64_pay_num
    ,day65_pay_num
    ,day66_pay_num
    ,day67_pay_num
    ,day68_pay_num
    ,day69_pay_num
    ,day70_pay_num
    ,day71_pay_num
    ,day72_pay_num
    ,day73_pay_num
    ,day74_pay_num
    ,day75_pay_num
    ,day76_pay_num
    ,day77_pay_num
    ,day78_pay_num
    ,day79_pay_num
    ,day80_pay_num
    ,day81_pay_num
    ,day82_pay_num
    ,day83_pay_num
    ,day84_pay_num
    ,day85_pay_num
    ,day86_pay_num
    ,day87_pay_num
    ,day88_pay_num
    ,day89_pay_num
    ,day90_pay_num
    ,day120_pay_num
    ,day150_pay_num
    ,day180_pay_num
    ,day210_pay_num
    ,day240_pay_num
    ,day270_pay_num
    ,day300_pay_num
    ,day330_pay_num
    ,day360_pay_num
    ,pay_num_by_at
    ,pay_user_by_at
    ,day0_first_pay_times
    ,minus1_day0_amount
    ,minus1_cost_amount
    ,minus2_day0_amount
    ,minus2_cost_amount
    ,pay_order_num
    ,minus3_day0_amount
    ,minus3_cost_amount
    ,minus4_day0_amount
    ,minus4_cost_amount
    ,minus5_day0_amount
    ,minus5_cost_amount
    ,minus6_day0_amount
    ,minus6_cost_amount
    ,minus7_day0_amount
    ,minus7_cost_amount
    ,sr_createtime
    ,sr_updatetime
)
as
select Id                as id
     , AdId              as ad_id
     , CreateTime        as create_time
     , PayList           as pay_list
     , RegNum            as reg_num
     , Impressions       as impressions
     , LinkClicks        as link_clicks
     , Installs          as installs
     , CostAmount        as cost_amount
     , ProductId         as product_id
     , PayNum            as pay_num
     , UpdateTime        as update_time
     , PayListByDays     as pay_list_by_days
     , CheckSum          as check_sum
     , LoginNum2         as login_num2
     , LoginNum3         as login_num3
     , LoginNum7         as login_num7
     , Core              as core
     , Mt                as mt
     , FbAccount         as fb_account
     , AdSetId           as ad_set_id
     , AdCampId          as ad_camp_id
     , DevNum            as dev_num
     , GroupId           as group_id
     , SourceChl         as source_chl
     , Chl2              as chl2
     , RowVersion        as row_version
     , CurrentLanguage2  as current_language2
     , AdsQuality        as ads_quality
     , Updater           as updater
     , Day0Amount        as day0_amount
     , Day1Amount        as day1_amount
     , Day2Amount        as day2_amount
     , Day3Amount        as day3_amount
     , Day4Amount        as day4_amount
     , Day5Amount        as day5_amount
     , Day6Amount        as day6_amount
     , Day7Amount        as day7_amount
     , Day8Amount        as day8_amount
     , Day9Amount        as day9_amount
     , Day10Amount       as day10_amount
     , Day11Amount       as day11_amount
     , Day12Amount       as day12_amount
     , Day13Amount       as day13_amount
     , Day14Amount       as day14_amount
     , Day15Amount       as day15_amount
     , Day16Amount       as day16_amount
     , Day17Amount       as day17_amount
     , Day18Amount       as day18_amount
     , Day19Amount       as day19_amount
     , Day20Amount       as day20_amount
     , Day21Amount       as day21_amount
     , Day22Amount       as day22_amount
     , Day23Amount       as day23_amount
     , Day24Amount       as day24_amount
     , Day25Amount       as day25_amount
     , Day26Amount       as day26_amount
     , Day27Amount       as day27_amount
     , Day28Amount       as day28_amount
     , Day29Amount       as day29_amount
     , Day30Amount       as day30_amount
     , Day31Amount       as day31_amount
     , Day32Amount       as day32_amount
     , Day33Amount       as day33_amount
     , Day34Amount       as day34_amount
     , Day35Amount       as day35_amount
     , Day36Amount       as day36_amount
     , Day37Amount       as day37_amount
     , Day38Amount       as day38_amount
     , Day39Amount       as day39_amount
     , Day40Amount       as day40_amount
     , Day41Amount       as day41_amount
     , Day42Amount       as day42_amount
     , Day43Amount       as day43_amount
     , Day44Amount       as day44_amount
     , Day45Amount       as day45_amount
     , Day46Amount       as day46_amount
     , Day47Amount       as day47_amount
     , Day48Amount       as day48_amount
     , Day49Amount       as day49_amount
     , Day50Amount       as day50_amount
     , Day51Amount       as day51_amount
     , Day52Amount       as day52_amount
     , Day53Amount       as day53_amount
     , Day54Amount       as day54_amount
     , Day55Amount       as day55_amount
     , Day56Amount       as day56_amount
     , Day57Amount       as day57_amount
     , Day58Amount       as day58_amount
     , Day59Amount       as day59_amount
     , Day60Amount       as day60_amount
     , Day61Amount       as day61_amount
     , Day62Amount       as day62_amount
     , Day63Amount       as day63_amount
     , Day64Amount       as day64_amount
     , Day65Amount       as day65_amount
     , Day66Amount       as day66_amount
     , Day67Amount       as day67_amount
     , Day68Amount       as day68_amount
     , Day69Amount       as day69_amount
     , Day70Amount       as day70_amount
     , Day71Amount       as day71_amount
     , Day72Amount       as day72_amount
     , Day73Amount       as day73_amount
     , Day74Amount       as day74_amount
     , Day75Amount       as day75_amount
     , Day76Amount       as day76_amount
     , Day77Amount       as day77_amount
     , Day78Amount       as day78_amount
     , Day79Amount       as day79_amount
     , Day80Amount       as day80_amount
     , Day81Amount       as day81_amount
     , Day82Amount       as day82_amount
     , Day83Amount       as day83_amount
     , Day84Amount       as day84_amount
     , Day85Amount       as day85_amount
     , Day86Amount       as day86_amount
     , Day87Amount       as day87_amount
     , Day88Amount       as day88_amount
     , Day89Amount       as day89_amount
     , Day90Amount       as day90_amount
     , Day120Amount      as day120_amount
     , Day150Amount      as day150_amount
     , Day180Amount      as day180_amount
     , Day210Amount      as day210_amount
     , Day240Amount      as day240_amount
     , Day270Amount      as day270_amount
     , Day300Amount      as day300_amount
     , Day330Amount      as day330_amount
     , Day360Amount      as day360_amount
     , Day0AmountByAd    as day0_amount_by_ad
     , Day1AmountByAd    as day1_amount_by_ad
     , Day2AmountByAd    as day2_amount_by_ad
     , Day3AmountByAd    as day3_amount_by_ad
     , Day4AmountByAd    as day4_amount_by_ad
     , Day5AmountByAd    as day5_amount_by_ad
     , Day6AmountByAd    as day6_amount_by_ad
     , Day7AmountByAd    as day7_amount_by_ad
     , Day8AmountByAd    as day8_amount_by_ad
     , Day9AmountByAd    as day9_amount_by_ad
     , Day10AmountByAd   as day10_amount_by_ad
     , Day11AmountByAd   as day11_amount_by_ad
     , Day12AmountByAd   as day12_amount_by_ad
     , Day13AmountByAd   as day13_amount_by_ad
     , Day14AmountByAd   as day14_amount_by_ad
     , Day15AmountByAd   as day15_amount_by_ad
     , Day16AmountByAd   as day16_amount_by_ad
     , Day17AmountByAd   as day17_amount_by_ad
     , Day18AmountByAd   as day18_amount_by_ad
     , Day19AmountByAd   as day19_amount_by_ad
     , Day20AmountByAd   as day20_amount_by_ad
     , Day21AmountByAd   as day21_amount_by_ad
     , Day22AmountByAd   as day22_amount_by_ad
     , Day23AmountByAd   as day23_amount_by_ad
     , Day24AmountByAd   as day24_amount_by_ad
     , Day25AmountByAd   as day25_amount_by_ad
     , Day26AmountByAd   as day26_amount_by_ad
     , Day27AmountByAd   as day27_amount_by_ad
     , Day28AmountByAd   as day28_amount_by_ad
     , Day29AmountByAd   as day29_amount_by_ad
     , Day30AmountByAd   as day30_amount_by_ad
     , Day31AmountByAd   as day31_amount_by_ad
     , Day32AmountByAd   as day32_amount_by_ad
     , Day33AmountByAd   as day33_amount_by_ad
     , Day34AmountByAd   as day34_amount_by_ad
     , Day35AmountByAd   as day35_amount_by_ad
     , Day36AmountByAd   as day36_amount_by_ad
     , Day37AmountByAd   as day37_amount_by_ad
     , Day38AmountByAd   as day38_amount_by_ad
     , Day39AmountByAd   as day39_amount_by_ad
     , Day40AmountByAd   as day40_amount_by_ad
     , Day41AmountByAd   as day41_amount_by_ad
     , Day42AmountByAd   as day42_amount_by_ad
     , Day43AmountByAd   as day43_amount_by_ad
     , Day44AmountByAd   as day44_amount_by_ad
     , Day45AmountByAd   as day45_amount_by_ad
     , Day46AmountByAd   as day46_amount_by_ad
     , Day47AmountByAd   as day47_amount_by_ad
     , Day48AmountByAd   as day48_amount_by_ad
     , Day49AmountByAd   as day49_amount_by_ad
     , Day50AmountByAd   as day50_amount_by_ad
     , Day51AmountByAd   as day51_amount_by_ad
     , Day52AmountByAd   as day52_amount_by_ad
     , Day53AmountByAd   as day53_amount_by_ad
     , Day54AmountByAd   as day54_amount_by_ad
     , Day55AmountByAd   as day55_amount_by_ad
     , Day56AmountByAd   as day56_amount_by_ad
     , Day57AmountByAd   as day57_amount_by_ad
     , Day58AmountByAd   as day58_amount_by_ad
     , Day59AmountByAd   as day59_amount_by_ad
     , Day60AmountByAd   as day60_amount_by_ad
     , Day61AmountByAd   as day61_amount_by_ad
     , Day62AmountByAd   as day62_amount_by_ad
     , Day63AmountByAd   as day63_amount_by_ad
     , Day64AmountByAd   as day64_amount_by_ad
     , Day65AmountByAd   as day65_amount_by_ad
     , Day66AmountByAd   as day66_amount_by_ad
     , Day67AmountByAd   as day67_amount_by_ad
     , Day68AmountByAd   as day68_amount_by_ad
     , Day69AmountByAd   as day69_amount_by_ad
     , Day70AmountByAd   as day70_amount_by_ad
     , Day71AmountByAd   as day71_amount_by_ad
     , Day72AmountByAd   as day72_amount_by_ad
     , Day73AmountByAd   as day73_amount_by_ad
     , Day74AmountByAd   as day74_amount_by_ad
     , Day75AmountByAd   as day75_amount_by_ad
     , Day76AmountByAd   as day76_amount_by_ad
     , Day77AmountByAd   as day77_amount_by_ad
     , Day78AmountByAd   as day78_amount_by_ad
     , Day79AmountByAd   as day79_amount_by_ad
     , Day80AmountByAd   as day80_amount_by_ad
     , Day81AmountByAd   as day81_amount_by_ad
     , Day82AmountByAd   as day82_amount_by_ad
     , Day83AmountByAd   as day83_amount_by_ad
     , Day84AmountByAd   as day84_amount_by_ad
     , Day85AmountByAd   as day85_amount_by_ad
     , Day86AmountByAd   as day86_amount_by_ad
     , Day87AmountByAd   as day87_amount_by_ad
     , Day88AmountByAd   as day88_amount_by_ad
     , Day89AmountByAd   as day89_amount_by_ad
     , Day90AmountByAd   as day90_amount_by_ad
     , Day120AmountByAd  as day120_amount_by_ad
     , Day150AmountByAd  as day150_amount_by_ad
     , Day180AmountByAd  as day180_amount_by_ad
     , Day210AmountByAd  as day210_amount_by_ad
     , Day240AmountByAd  as day240_amount_by_ad
     , Day270AmountByAd  as day270_amount_by_ad
     , Day300AmountByAd  as day300_amount_by_ad
     , Day330AmountByAd  as day330_amount_by_ad
     , Day360AmountByAd  as day360_amount_by_ad
     , Day0FirstPayNum   as day0_first_pay_num
     , Day1FirstPayNum   as day1_first_pay_num
     , Day2FirstPayNum   as day2_first_pay_num
     , Day3FirstPayNum   as day3_first_pay_num
     , Day4FirstPayNum   as day4_first_pay_num
     , Day5FirstPayNum   as day5_first_pay_num
     , Day6FirstPayNum   as day6_first_pay_num
     , Day7FirstPayNum   as day7_first_pay_num
     , Day8FirstPayNum   as day8_first_pay_num
     , Day9FirstPayNum   as day9_first_pay_num
     , Day10FirstPayNum  as day10_first_pay_num
     , Day11FirstPayNum  as day11_first_pay_num
     , Day12FirstPayNum  as day12_first_pay_num
     , Day13FirstPayNum  as day13_first_pay_num
     , Day14FirstPayNum  as day14_first_pay_num
     , Day15FirstPayNum  as day15_first_pay_num
     , Day16FirstPayNum  as day16_first_pay_num
     , Day17FirstPayNum  as day17_first_pay_num
     , Day18FirstPayNum  as day18_first_pay_num
     , Day19FirstPayNum  as day19_first_pay_num
     , Day20FirstPayNum  as day20_first_pay_num
     , Day21FirstPayNum  as day21_first_pay_num
     , Day22FirstPayNum  as day22_first_pay_num
     , Day23FirstPayNum  as day23_first_pay_num
     , Day24FirstPayNum  as day24_first_pay_num
     , Day25FirstPayNum  as day25_first_pay_num
     , Day26FirstPayNum  as day26_first_pay_num
     , Day27FirstPayNum  as day27_first_pay_num
     , Day28FirstPayNum  as day28_first_pay_num
     , Day29FirstPayNum  as day29_first_pay_num
     , Day30FirstPayNum  as day30_first_pay_num
     , Day31FirstPayNum  as day31_first_pay_num
     , Day32FirstPayNum  as day32_first_pay_num
     , Day33FirstPayNum  as day33_first_pay_num
     , Day34FirstPayNum  as day34_first_pay_num
     , Day35FirstPayNum  as day35_first_pay_num
     , Day36FirstPayNum  as day36_first_pay_num
     , Day37FirstPayNum  as day37_first_pay_num
     , Day38FirstPayNum  as day38_first_pay_num
     , Day39FirstPayNum  as day39_first_pay_num
     , Day40FirstPayNum  as day40_first_pay_num
     , Day41FirstPayNum  as day41_first_pay_num
     , Day42FirstPayNum  as day42_first_pay_num
     , Day43FirstPayNum  as day43_first_pay_num
     , Day44FirstPayNum  as day44_first_pay_num
     , Day45FirstPayNum  as day45_first_pay_num
     , Day46FirstPayNum  as day46_first_pay_num
     , Day47FirstPayNum  as day47_first_pay_num
     , Day48FirstPayNum  as day48_first_pay_num
     , Day49FirstPayNum  as day49_first_pay_num
     , Day50FirstPayNum  as day50_first_pay_num
     , Day51FirstPayNum  as day51_first_pay_num
     , Day52FirstPayNum  as day52_first_pay_num
     , Day53FirstPayNum  as day53_first_pay_num
     , Day54FirstPayNum  as day54_first_pay_num
     , Day55FirstPayNum  as day55_first_pay_num
     , Day56FirstPayNum  as day56_first_pay_num
     , Day57FirstPayNum  as day57_first_pay_num
     , Day58FirstPayNum  as day58_first_pay_num
     , Day59FirstPayNum  as day59_first_pay_num
     , Day60FirstPayNum  as day60_first_pay_num
     , Day61FirstPayNum  as day61_first_pay_num
     , Day62FirstPayNum  as day62_first_pay_num
     , Day63FirstPayNum  as day63_first_pay_num
     , Day64FirstPayNum  as day64_first_pay_num
     , Day65FirstPayNum  as day65_first_pay_num
     , Day66FirstPayNum  as day66_first_pay_num
     , Day67FirstPayNum  as day67_first_pay_num
     , Day68FirstPayNum  as day68_first_pay_num
     , Day69FirstPayNum  as day69_first_pay_num
     , Day70FirstPayNum  as day70_first_pay_num
     , Day71FirstPayNum  as day71_first_pay_num
     , Day72FirstPayNum  as day72_first_pay_num
     , Day73FirstPayNum  as day73_first_pay_num
     , Day74FirstPayNum  as day74_first_pay_num
     , Day75FirstPayNum  as day75_first_pay_num
     , Day76FirstPayNum  as day76_first_pay_num
     , Day77FirstPayNum  as day77_first_pay_num
     , Day78FirstPayNum  as day78_first_pay_num
     , Day79FirstPayNum  as day79_first_pay_num
     , Day80FirstPayNum  as day80_first_pay_num
     , Day81FirstPayNum  as day81_first_pay_num
     , Day82FirstPayNum  as day82_first_pay_num
     , Day83FirstPayNum  as day83_first_pay_num
     , Day84FirstPayNum  as day84_first_pay_num
     , Day85FirstPayNum  as day85_first_pay_num
     , Day86FirstPayNum  as day86_first_pay_num
     , Day87FirstPayNum  as day87_first_pay_num
     , Day88FirstPayNum  as day88_first_pay_num
     , Day89FirstPayNum  as day89_first_pay_num
     , Day90FirstPayNum  as day90_first_pay_num
     , Day120FirstPayNum as day120_first_pay_num
     , Day150FirstPayNum as day150_first_pay_num
     , Day180FirstPayNum as day180_first_pay_num
     , Day210FirstPayNum as day210_first_pay_num
     , Day240FirstPayNum as day240_first_pay_num
     , Day270FirstPayNum as day270_first_pay_num
     , Day300FirstPayNum as day300_first_pay_num
     , Day330FirstPayNum as day330_first_pay_num
     , Day360FirstPayNum as day360_first_pay_num
     , Day0PayNum        as day0_pay_num
     , Day1PayNum        as day1_pay_num
     , Day2PayNum        as day2_pay_num
     , Day3PayNum        as day3_pay_num
     , Day4PayNum        as day4_pay_num
     , Day5PayNum        as day5_pay_num
     , Day6PayNum        as day6_pay_num
     , Day7PayNum        as day7_pay_num
     , Day8PayNum        as day8_pay_num
     , Day9PayNum        as day9_pay_num
     , Day10PayNum       as day10_pay_num
     , Day11PayNum       as day11_pay_num
     , Day12PayNum       as day12_pay_num
     , Day13PayNum       as day13_pay_num
     , Day14PayNum       as day14_pay_num
     , Day15PayNum       as day15_pay_num
     , Day16PayNum       as day16_pay_num
     , Day17PayNum       as day17_pay_num
     , Day18PayNum       as day18_pay_num
     , Day19PayNum       as day19_pay_num
     , Day20PayNum       as day20_pay_num
     , Day21PayNum       as day21_pay_num
     , Day22PayNum       as day22_pay_num
     , Day23PayNum       as day23_pay_num
     , Day24PayNum       as day24_pay_num
     , Day25PayNum       as day25_pay_num
     , Day26PayNum       as day26_pay_num
     , Day27PayNum       as day27_pay_num
     , Day28PayNum       as day28_pay_num
     , Day29PayNum       as day29_pay_num
     , Day30PayNum       as day30_pay_num
     , Day31PayNum       as day31_pay_num
     , Day32PayNum       as day32_pay_num
     , Day33PayNum       as day33_pay_num
     , Day34PayNum       as day34_pay_num
     , Day35PayNum       as day35_pay_num
     , Day36PayNum       as day36_pay_num
     , Day37PayNum       as day37_pay_num
     , Day38PayNum       as day38_pay_num
     , Day39PayNum       as day39_pay_num
     , Day40PayNum       as day40_pay_num
     , Day41PayNum       as day41_pay_num
     , Day42PayNum       as day42_pay_num
     , Day43PayNum       as day43_pay_num
     , Day44PayNum       as day44_pay_num
     , Day45PayNum       as day45_pay_num
     , Day46PayNum       as day46_pay_num
     , Day47PayNum       as day47_pay_num
     , Day48PayNum       as day48_pay_num
     , Day49PayNum       as day49_pay_num
     , Day50PayNum       as day50_pay_num
     , Day51PayNum       as day51_pay_num
     , Day52PayNum       as day52_pay_num
     , Day53PayNum       as day53_pay_num
     , Day54PayNum       as day54_pay_num
     , Day55PayNum       as day55_pay_num
     , Day56PayNum       as day56_pay_num
     , Day57PayNum       as day57_pay_num
     , Day58PayNum       as day58_pay_num
     , Day59PayNum       as day59_pay_num
     , Day60PayNum       as day60_pay_num
     , Day61PayNum       as day61_pay_num
     , Day62PayNum       as day62_pay_num
     , Day63PayNum       as day63_pay_num
     , Day64PayNum       as day64_pay_num
     , Day65PayNum       as day65_pay_num
     , Day66PayNum       as day66_pay_num
     , Day67PayNum       as day67_pay_num
     , Day68PayNum       as day68_pay_num
     , Day69PayNum       as day69_pay_num
     , Day70PayNum       as day70_pay_num
     , Day71PayNum       as day71_pay_num
     , Day72PayNum       as day72_pay_num
     , Day73PayNum       as day73_pay_num
     , Day74PayNum       as day74_pay_num
     , Day75PayNum       as day75_pay_num
     , Day76PayNum       as day76_pay_num
     , Day77PayNum       as day77_pay_num
     , Day78PayNum       as day78_pay_num
     , Day79PayNum       as day79_pay_num
     , Day80PayNum       as day80_pay_num
     , Day81PayNum       as day81_pay_num
     , Day82PayNum       as day82_pay_num
     , Day83PayNum       as day83_pay_num
     , Day84PayNum       as day84_pay_num
     , Day85PayNum       as day85_pay_num
     , Day86PayNum       as day86_pay_num
     , Day87PayNum       as day87_pay_num
     , Day88PayNum       as day88_pay_num
     , Day89PayNum       as day89_pay_num
     , Day90PayNum       as day90_pay_num
     , Day120PayNum      as day120_pay_num
     , Day150PayNum      as day150_pay_num
     , Day180PayNum      as day180_pay_num
     , Day210PayNum      as day210_pay_num
     , Day240PayNum      as day240_pay_num
     , Day270PayNum      as day270_pay_num
     , Day300PayNum      as day300_pay_num
     , Day330PayNum      as day330_pay_num
     , Day360PayNum      as day360_pay_num
     , PayNumByAt        as pay_num_by_at
     , PayUserByAt       as pay_user_by_at
     , Day0FirstPayTimes as day0_first_pay_times
     , Minus1Day0Amount  as minus1_day0_amount
     , Minus1CostAmount  as minus1_cost_amount
     , Minus2Day0Amount  as minus2_day0_amount
     , Minus2CostAmount  as minus2_cost_amount
     , PayOrderNum       as pay_order_num
     , Minus3Day0Amount  as minus3_day0_amount
     , Minus3CostAmount  as minus3_cost_amount
     , Minus4Day0Amount  as minus4_day0_amount
     , Minus4CostAmount  as minus4_cost_amount
     , Minus5Day0Amount  as minus5_day0_amount
     , Minus5CostAmount  as minus5_cost_amount
     , Minus6Day0Amount  as minus6_day0_amount
     , Minus6CostAmount  as minus6_cost_amount
     , Minus7Day0Amount  as minus7_day0_amount
     , Minus7CostAmount  as minus7_cost_amount
     , sr_createtime
     , sr_updatetime
  from ods.ods_tidb_sharpengine_ads_global_FbAdRoiInstallReferrerTimeZone_di
;