----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_ad_cost_recharge_ed
-- workflow_version : 18
-- create_user      : admin
-- task_name        : dws_advertisement_ad_cost_recharge_ed_part1
-- task_version     : 17
-- update_time      : 2024-03-04 16:55:26
-- sql_path         : \starrocks\tbl_dws_advertisement_ad_cost_recharge_ed\dws_advertisement_ad_cost_recharge_ed_part1
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_advertisement_ad_cost_recharge_ed where dt  >='${bf_180_dt}' and dt < '${dt}'  and product_id != 6883;

-- SQL语句
insert into dws.dws_advertisement_ad_cost_recharge_ed
select  a.dt,a.product_id,a.ad_id,b.fb_account,b.source_chl,b.ads_type,b.ads_quality,b.ad_name,c.product_name,
        b.ad_campname,b.ad_camp_id,b.ad_set_id,b.ad_setname,b.book_id,b.book_name,
        b.book_channel,b.book_nature,b.ad_optimizer_uid,d.ads_optimizer_group,a.core,a.mt,ifnull(c.current_language2,a.current_language2),
        sum(a.reg_num) as reg_num,sum(a.dev_num) as dev_num,sum(a.cost_amount) as cost_amount,
        sum(a.day0_amount) as day0_amount,sum(a.day1_amount) as day1_amount,sum(a.day2_amount) as day2_amount,
        sum(a.day3_amount) as day3_amount,sum(a.day4_amount) as day4_amount,sum(a.day5_amount) as day5_amount,
        sum(a.day6_amount) as day6_amount,sum(a.day7_amount) as day7_amount,sum(a.day8_amount) as day8_amount,
        sum(a.day9_amount) as day9_amount,sum(a.day10_amount) as day10_amount,sum(a.day11_amount) as day11_amount,
        sum(a.day12_amount) as day12_amount,sum(a.day13_amount) as day13_amount,sum(a.day14_amount) as day14_amount,
        sum(a.day15_amount) as day15_amount,sum(a.day16_amount) as day16_amount,sum(a.day17_amount) as day17_amount,
        sum(a.day18_amount) as day18_amount,sum(a.day19_amount) as day19_amount,sum(a.day20_amount) as day20_amount,
        sum(a.day21_amount) as day21_amount,sum(a.day22_amount) as day22_amount,sum(a.day23_amount) as day23_amount,
        sum(a.day24_amount) as day24_amount,sum(a.day25_amount) as day25_amount,sum(a.day26_amount) as day26_amount,
        sum(a.day27_amount) as day27_amount,sum(a.day28_amount) as day28_amount,sum(a.day29_amount) as day29_amount,
        sum(a.day30_amount) as day30_amount,sum(a.day60_amount) as day60_amount,sum(a.day90_amount) as day90_amount,
        sum(a.day120_amount) as day120_amount,
        now() as etl_time
from dwd.dwd_advertisement_fbadroiinstallreferrer_view a
         left join dwd.dwd_advertisement_adext_view b
                   on a.ad_id = b.ad_id and a.product_id = b.product_id
         left join dim.dim_ad_account c
                   on  b.fb_account = c.account
         left join (   select dt, optimizer_group_type, ads_optimizer_group, ads_optimizer
                       from dim.dim_optimizergroups
                       where dt = '${bf_1_dt}'
                         and optimizer_group_type = 0) d
                   on b.ad_optimizer_uid = d.ads_optimizer
where a.dt >= '${bf_180_dt}' and a.dt < '${dt}' and (c.fb_account_type = 0 or c.fb_account_type is null)
  and a.product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
union all
select  a.dt,a.product_id,a.ad_id,b.fb_account,b.source_chl,b.ads_type,b.ads_quality,b.ad_name,c.product_name,
        b.ad_campname,b.ad_camp_id,b.ad_set_id,b.ad_setname,b.book_id,b.book_name,
        b.book_channel,b.book_nature,b.ad_optimizer_uid,d.ads_optimizer_group,a.core,a.mt,ifnull(c.current_language2,a.current_language2),
        sum(a.reg_num) as reg_num,sum(a.dev_num) as dev_num,sum(a.cost_amount) as cost_amount,
        sum(a.day0_amount) as day0_amount,sum(a.day1_amount) as day1_amount,sum(a.day2_amount) as day2_amount,
        sum(a.day3_amount) as day3_amount,sum(a.day4_amount) as day4_amount,sum(a.day5_amount) as day5_amount,
        sum(a.day6_amount) as day6_amount,sum(a.day7_amount) as day7_amount,sum(a.day8_amount) as day8_amount,
        sum(a.day9_amount) as day9_amount,sum(a.day10_amount) as day10_amount,sum(a.day11_amount) as day11_amount,
        sum(a.day12_amount) as day12_amount,sum(a.day13_amount) as day13_amount,sum(a.day14_amount) as day14_amount,
        sum(a.day15_amount) as day15_amount,sum(a.day16_amount) as day16_amount,sum(a.day17_amount) as day17_amount,
        sum(a.day18_amount) as day18_amount,sum(a.day19_amount) as day19_amount,sum(a.day20_amount) as day20_amount,
        sum(a.day21_amount) as day21_amount,sum(a.day22_amount) as day22_amount,sum(a.day23_amount) as day23_amount,
        sum(a.day24_amount) as day24_amount,sum(a.day25_amount) as day25_amount,sum(a.day26_amount) as day26_amount,
        sum(a.day27_amount) as day27_amount,sum(a.day28_amount) as day28_amount,sum(a.day29_amount) as day29_amount,
        sum(a.day30_amount) as day30_amount,sum(a.day60_amount) as day60_amount,sum(a.day90_amount) as day90_amount,
        sum(a.day120_amount) as day120_amount,
        now() as etl_time
from dwd.dwd_advertisement_fbadroiinstallreferrer_view a
         left join dwd.dwd_advertisement_adext_view b
                   on a.ad_id = b.ad_id and a.product_id = b.product_id
         left join dim.dim_ad_account c
                   on  b.fb_account = c.account
         left join (   select dt, optimizer_group_type, ads_optimizer_group, ads_optimizer
                       from dim.dim_optimizergroups
                       where dt = '${bf_1_dt}'
                         and optimizer_group_type = 1) d
                   on b.ad_optimizer_uid = d.ads_optimizer
where a.dt >= '${bf_180_dt}' and a.dt < '${dt}' and (c.fb_account_type = 0 or c.fb_account_type is null) and a.product_id = 6833
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_ad_cost_recharge_ed
-- workflow_version : 18
-- create_user      : admin
-- task_name        : dws_advertisement_ad_cost_recharge_ed_part2
-- task_version     : 2
-- update_time      : 2024-03-04 16:55:26
-- sql_path         : \starrocks\tbl_dws_advertisement_ad_cost_recharge_ed\dws_advertisement_ad_cost_recharge_ed_part2
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_advertisement_ad_cost_recharge_ed where dt  >='${bf_180_dt}' and dt < '${dt}' and product_id = 6883;

-- SQL语句
insert into dws.dws_advertisement_ad_cost_recharge_ed
select  date(a.create_time) as dt,a.product_id,a.ad_id,b.fb_account,b.source_chl,b.ads_type,b.ads_quality,b.ad_name,c.product_name,
        b.ad_campname,b.ad_camp_id,b.ad_set_id,b.ad_setname,b.book_id,b.book_name,
        b.book_channel,b.book_nature,b.ad_optimizer_uid,null as ads_optimizer_group,a.corever,a.mt,ifnull(c.current_language2,a.current_language2),
        sum(a.reg_num) as reg_num,sum(a.dev_num) as dev_num,sum(a.cost_amount) as cost_amount,
        sum(a.day0_amount) as day0_amount,sum(a.day1_amount) as day1_amount,sum(a.day2_amount) as day2_amount,
        sum(a.day3_amount) as day3_amount,sum(a.day4_amount) as day4_amount,sum(a.day5_amount) as day5_amount,
        sum(a.day6_amount) as day6_amount,sum(a.day7_amount) as day7_amount,sum(a.day8_amount) as day8_amount,
        sum(a.day9_amount) as day9_amount,sum(a.day10_amount) as day10_amount,sum(a.day11_amount) as day11_amount,
        sum(a.day12_amount) as day12_amount,sum(a.day13_amount) as day13_amount,sum(a.day14_amount) as day14_amount,
        sum(a.day15_amount) as day15_amount,sum(a.day16_amount) as day16_amount,sum(a.day17_amount) as day17_amount,
        sum(a.day18_amount) as day18_amount,sum(a.day19_amount) as day19_amount,sum(a.day20_amount) as day20_amount,
        sum(a.day21_amount) as day21_amount,sum(a.day22_amount) as day22_amount,sum(a.day23_amount) as day23_amount,
        sum(a.day24_amount) as day24_amount,sum(a.day25_amount) as day25_amount,sum(a.day26_amount) as day26_amount,
        sum(a.day27_amount) as day27_amount,sum(a.day28_amount) as day28_amount,sum(a.day29_amount) as day29_amount,
        sum(a.day30_amount) as day30_amount,sum(a.day60_amount) as day60_amount,sum(a.day90_amount) as day90_amount,
        sum(a.day120_amount) as day120_amount,
        now() as etl_time
from dwd.dwd_FbAdRoiInstallReferrerVideo_view a
         left join dwd.dwd_advertisement_adext_view b
                   on a.ad_id = b.ad_id and a.product_id = b.product_id
         left join
     (   select  account,fb_account_type,current_language2,product_name
         from dim.dim_advertisement_third_ad_account_view
         where product_id = 6883 and  ad_platform_id > 0
     ) c
     on  b.fb_account = c.account
where date(a.create_time) >= '${bf_180_dt}' and date(a.create_time) < '${dt}'
    and  (c.fb_account_type = 0 or c.fb_account_type is null) and a.product_id = 6883
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22;
