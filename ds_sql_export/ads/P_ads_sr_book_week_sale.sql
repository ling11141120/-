----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_book_week_sale
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sr_book_week_sale
-- task_version     : 1
-- update_time      : 2025-02-20 11:34:59
-- sql_path         : \starrocks\tbl_ads_sr_book_week_sale\ads_sr_book_week_sale
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_book_week_sale
select
    a.productid as product_id,
    a.Id as id,
    a.bookid as book_id,
    b.language_id as language_id,
    b.book_nature as book_nature,
    a.money_sale as money_sale,
    a.money_count as money_count,
    a.money_person as money_person,
    a.money_orgin_sale as money_orgin_sale,
    a.money_orgin_count as money_orgin_count,
    a.money_orgin_person as money_orgin_person,
    a.money_pirate_sale as money_pirate_sale,
    a.money_pirate_count as money_pirate_count,
    a.money_pirate_person as money_pirate_person,
    a.gift_sale as gift_sale,
    a.gift_count as gift_count,
    a.gift_person as gift_person,
    a.reward as reward,
    a.tick_total as tick_total,
    a.award_money as award_money,
    a.award_person as award_person,
    a.award_count as award_count,
    a.award_reward as award_reward,
    a.cps_money as cps_money,
    a.money_package as money_package,
    a.startTime as start_time,
    a.endTime as end_time,
    a.isDel as is_del,
    a.CID as cid,
    a.CName as cname,
    a.FullStat as full_stat,
    a.Channel as channel,
    a.BuildTime as build_time,
    a.NormalChapterNum as normal_chapter_num,
    a.Sexy as sexy,
    now() as etl_time
from ods.ods_tidb_readernovel_xx_mysql_bookweeksale a
left join dim.dim_novel_book_info_view b
on a.productid = b.product_id and a.bookid = b.book_id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35;
