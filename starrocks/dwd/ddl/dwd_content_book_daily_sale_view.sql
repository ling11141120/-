create or replace view dwd.dwd_content_book_daily_sale_view (
     dt                  comment "日期"
    ,product_id          comment "产品id"
    ,id                  comment "自增id"
    ,book_id             comment "书籍id"
    ,static_date         comment "统计日期"
    ,money_sale          comment "阅币金额"
    ,money_count         comment "阅币消费次数"
    ,money_person        comment "阅毕消费人数"
    ,money_orgin_sale    comment "授权书籍阅币金额"
    ,money_orgin_count   comment "授权书籍阅币消费次数"
    ,money_orgin_person  comment "授权书籍阅币消费人数"
    ,money_pirate_sale   comment "非授权书籍阅币金额"
    ,money_pirate_count  comment "非授权书籍阅币消费次数"
    ,money_pirate_person comment "非授权书籍阅币消费人数"
    ,gift_sale           comment "礼券金额"
    ,gift_count          comment "礼券消费次数"
    ,gift_person         comment "礼券消费人数"
    ,reward              comment "打赏阅币"
    ,tick_total          comment "月票数"
    ,award_money         comment "赠送币金额"
    ,award_person        comment "赠送币消费人数"
    ,award_count         comment "赠送币消费次数"
    ,award_reward        comment "打赏赠送币"
    ,cps_money           comment "Cps金额"
    ,money_package       comment "money_package"
    ,size_package        comment "size_package"
    ,free_package        comment "free_package"
)
as
select dt
      ,product_id
      ,id
      ,bookid as book_id
      ,static_date
      ,money_sale
      ,money_count
      ,money_person
      ,money_orgin_sale
      ,money_orgin_count
      ,money_orgin_person
      ,money_pirate_sale
      ,money_pirate_count
      ,money_pirate_person
      ,gift_sale
      ,gift_count
      ,gift_person
      ,reward
      ,tick_total
      ,award_money
      ,award_person
      ,award_count
      ,award_reward
      ,cps_money
      ,money_package
      ,size_package
      ,free_package
  from ods.ods_tidb_readernovel_tidb_book_daily_sale
;