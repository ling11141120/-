----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_user_info_ed
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_wide_user_info_ed
-- task_version     : 7
-- update_time      : 2024-10-20 01:23:06
-- sql_path         : \starrocks\tbl_ads_wide_user_info_ed\ads_wide_user_info_ed
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_wide_user_info_ed`
select a.dt,a.product_id ,ifnull(a.user_id,-99) as user_id,
 acc.corever,acc.mt  ,acc.current_language,acc.current_language2,acc.reg_time,acc.reg_country,acc.country,acc.appver,acc.ver,
 if(c.`level` is null ,2,c.`level` ) as country_level, -- 注册国家时的国家等级
sum(consume_amt) as consume_amt,
sum(consume_cnt) as consume_cnt,
bitmap_union(consume_book_cnt) as consume_book_cnt,
bitmap_union(consume_chapter_cnt) as consume_chapter_cnt,
sum(consume_money_amt) as consume_money_amt,
sum(consume_money_cnt) as consume_money_cnt,
bitmap_union(consume_money_book_cnt) as consume_money_book_cnt,
bitmap_union(consume_money_chapter_cnt) as consume_money_chapter_cnt,
sum(consume_gift_amt) as consume_gift_amt,
sum(consume_gift_cnt) as consume_gift_cnt,
bitmap_union(consume_gift_book_cnt) as consume_gift_book_cnt,
bitmap_union(consume_gift_chapter_cnt) as consume_gift_chapter_cnt,
sum(consume_award_amt) as consume_award_amt,
sum(consume_award_cnt) as consume_award_cnt,
bitmap_union(consume_award_book_cnt) as consume_award_book_cnt,
bitmap_union(consume_award_chapter_cnt) as consume_award_chapter_cnt,
sum(consume_vip_amt) as consume_vip_amt,
sum(consume_vip_cnt) as consume_vip_cnt,
bitmap_union(consume_vip_book_cnt) as consume_vip_book_cnt,
bitmap_union(consume_vip_chapter_cnt) as consume_vip_chapter_cnt,
sum( bat_ulk_cnt) as bat_ulk_cnt,
sum(fix_ulk_cnt) as fix_ulk_cnt,
sum(sup_ulk_cnt) as sup_ulk_cnt,
sum(sup_ulk_amt) as sup_ulk_amt,
sum(bat_ulk_money_amt) as bat_ulk_money_amt,
sum(consume_point_amt) as consume_point_amt,
sum(consume_point_cnt) as consume_point_cnt,
sum(login_times) as login_time_cnt,
sum(ordinary_recharge_amt) ordinary_recharge_amt  ,
sum(ordinary_recharge_cnt) as ordinary_recharge_cnt,
sum(vip_recharge_amt) as vip_recharge_amt,
sum(vip_recharge_cnt) as vip_recharge_cnt,
sum(sub_recharge_amt) as sub_recharge_amt,
sum(sub_recharge_cnt) as sub_recharge_cnt,
sum(read_times) as read_times,
bitmap_union(read_book_cnt) as read_book_cnt,
bitmap_union(read_chapter_cnt) as read_chapter_cnt,
sum(read_cnt) as read_cnt,
sum(get_money_amt) as get_money_amt,
sum(get_gift_amt) as get_gift_amt,
sum(get_award_amt) as get_award_amt,
sum(get_point_amt) as get_point_amt,
sum(get_point_cnt) as get_point_cnt,
sum(produce_ads_amt) as produce_ads_amt,
sum(produce_ads_cnt) as produce_ads_cnt ,
acc.bal_money_amt,
acc.bal_gift_amt,
acc.bal_point_amt,
now() as etl_time
from
(

-- ----------------消耗货币指标--------------------
select
      dt,product_id,user_id,
      round(sum(con_chp_amount)) as consume_amt ,
      round(sum(con_book_cnt)) consume_cnt  ,
      bitmap_union(to_bitmap(if(book_id=0,null,book_id))) consume_book_cnt,
      bitmap_union(to_bitmap(CONCAT(if(book_id=0,null,book_id),chapter_id))) consume_chapter_cnt,
      round(sum(if(types=1, con_chp_amount,0))) as consume_money_amt ,
      round(sum(if(types=1,con_book_cnt,0)))  consume_money_cnt  ,
      bitmap_union(to_bitmap(if(types=1 and book_id>0,book_id,null))) consume_money_book_cnt,
      bitmap_union(to_bitmap(if(types=1 and book_id>0,CONCAT(book_id,chapter_id),null))) consume_money_chapter_cnt,
      round(sum(if(types=2, con_chp_amount,0))) as consume_gift_amt ,
      round(sum(if(types=2,con_book_cnt,0)))  consume_gift_cnt  ,
      bitmap_union(to_bitmap(if(types=2 and book_id>0,book_id,null))) consume_gift_book_cnt,
      bitmap_union(to_bitmap(if(types=2 and book_id>0,CONCAT(book_id,chapter_id),null))) consume_gift_chapter_cnt,
      round(sum(if(types=3, con_chp_amount,0))) as consume_award_amt ,
      round(sum(if(types=3,con_book_cnt,0)))  consume_award_cnt  ,
      bitmap_union(to_bitmap(if(types=3 and book_id>0,book_id,null))) consume_award_book_cnt,
      bitmap_union(to_bitmap(if(types=3 and book_id>0,CONCAT(book_id,chapter_id),null))) consume_award_chapter_cnt,
      round(sum(if(types=4, con_chp_amount,0))) as consume_vip_amt ,
      round(sum(if(types=4,con_book_cnt,0)))  consume_vip_cnt  ,
      bitmap_union(to_bitmap(if(types=4 and book_id>0,book_id,null))) consume_vip_book_cnt,
      bitmap_union(to_bitmap(if(types=4 and book_id>0,CONCAT(book_id,chapter_id),null))) consume_vip_chapter_cnt,
      round(sum(if(pay_type in (1,18,29,31,62),con_book_cnt,0)))  as  bat_ulk_cnt,  -- 批量解锁次数
      round(sum(if(pay_type = 91,con_book_cnt,0))) as  fix_ulk_cnt, -- 一口价解锁次数
      round(sum(if(pay_type in (45,46,63),con_book_cnt,0))) as  sup_ulk_cnt, -- 超点解锁次数
      round(sum(if(pay_type in (45,46,63),con_chp_amount,0))) as  sup_ulk_amt, -- 超点解锁货币数
      round(sum(if(pay_type in (1,18,29,31,62) and types = 1,con_chp_amount,0))) as  bat_ulk_money_amt ,-- 批量解锁货币数
null as consume_point_amt,
null as consume_point_cnt,
null as login_times,
null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as read_times,
to_bitmap(null) as read_book_cnt,
to_bitmap(null) as read_chapter_cnt,
null as read_cnt,
null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
from dwm.dwm_consume_user_consume_mild_ed
where dt>='${bf_1_dt}' and dt<'${dt}' and product_id not in (7777,8888,6833)
and pay_type <>1103
group by 1,2 ,3

union all
-- ----------------消耗积分指标--------------------
  select dt,product_id, user_id,
      null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null) as consume_book_cnt,
       to_bitmap(null) as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      sum(num)  as consume_point_amt , -- 消耗数量
      count(1) as consume_point_cnt , -- ----消耗次数
null as login_times,
null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as read_times,
to_bitmap(null) as read_book_cnt,
to_bitmap(null) as read_chapter_cnt,
null as read_cnt,
null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
   from dwd.dwd_grant_readerlog_jifenmonthlog_view   -- 积分消耗的记录表
         where  dt >= '${bf_1_dt}' and  dt < '${dt}' and product_id not in (7777,8888,6833) and op=2
         group by 1,2,3
union all
-- 登录指标
  SELECT dt,Productid as product_id, userid as user_id,
      null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      loginTimes as login_times,  -- -----每天的登录次数
      null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as read_times,
to_bitmap(null) as read_book_cnt,
to_bitmap(null) as read_chapter_cnt,
null as read_cnt,
null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
from dws.dws_user_login_ed
where dt>='${bf_1_dt}' and dt<'${dt}'and Productid not in (7777,8888,6833) and userid >0
        union  all   -- 充值指标
 SELECT  dt,Productid as product_id,  userid as user_id,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
sum(if(ShopItem=0,chargeitemcount,0)) as ordinary_recharge_amt,   -- 普通充值
sum(if(ShopItem=0,chargecount,0)) as ordinary_recharge_cnt,
sum(if(ShopItem in (810,820),chargeitemcount,0)) vip_recharge_amt, -- vip充值
sum(if(ShopItem in (810,820),chargecount,0)) vip_recharge_cnt,
sum(if(ShopItem not in (0,810,820),chargeitemcount,0)) sub_recharge_amt, -- 订阅项充值
sum(if(ShopItem not in (0,810,820),chargecount,0)) sub_recharge_cnt,
null as read_times,
to_bitmap(null) as read_book_cnt,
to_bitmap(null) as read_chapter_cnt,
null as read_cnt,
null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
from dws.dws_trade_user_shopitem_charge_ed
where dt>='${bf_1_dt}' and dt<'${dt}'and Productid not in (7777,8888,6833)
group by 1,2,3
union all
-- 阅读时长指标
select dt,product_id , user_id,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
 sum(read_times) as  read_times  ,
 to_bitmap(null) as read_book_cnt,
to_bitmap(null) as read_chapter_cnt,
null as read_cnt,
null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
       from dws.dws_read_user_book_readtime_ed
       where dt>='${bf_1_dt}' and dt<'${dt}' and product_id not in (7777,8888,6833)
group by 1,2,3

union all
-- 阅读书本数，阅读章节数
select dt,product_id , user_id,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as  read_times  ,
       bitmap_union(to_bitmap(book_id)) read_book_cnt, -- 阅读书本数
       bitmap_union(to_bitmap(concat(book_id,chapter_id))) read_chapter_cnt, -- 阅读章节数
       count(1) as read_cnt ,-- 阅读次数
       null as get_money_amt ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
       from dws.dws_read_user_read_book_chapter_info_ed
       where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id not in (7777,8888,6833)
group by 1,2,3

union all
--  阅币发放数
select dt,product_id,user_id ,
       null as consume_amt ,
      null as consume_cnt  ,
      to_bitmap(null)  as consume_book_cnt,
      to_bitmap(null) as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as  read_times  ,
to_bitmap(null) as  read_book_cnt, -- 阅读书本数
to_bitmap(null) as  read_chapter_cnt, -- 阅读章节数
null as  read_cnt ,-- 阅读次数
sum(money_amount) get_money_amt  ,
null as get_gift_amt  ,
null as get_award_amt ,
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
from  dws.dws_grant_user_getmoneylog_ed
 where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id not in (7777,8888,6833)
group by 1,2,3
union all
--  礼券发放数 \赠送币发放
select dt,product_id,user_id ,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as  read_times  ,
to_bitmap(null) as  read_book_cnt, -- 阅读书本数
to_bitmap(null) as  read_chapter_cnt, -- 阅读章节数
null as  read_cnt ,-- 阅读次数
null as  get_money_amt  ,
sum(if(gift_type =0,amount,0)) get_gift_amt,  -- 获取礼券
sum(if(gift_type =1,amount,0)) get_award_amt,   -- 获取赠送币
null as get_point_amt ,
null as get_point_cnt ,
null as produce_ads_amt,
null as produce_ads_cnt
from dws.dws_grant_user_giftlog_ed
where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id not in (7777,8888,6833) and op_type =1
group by 1,2,3

union all
--  积分发放数、次数
select dt,product_id,user_id ,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as  read_times  ,
to_bitmap(null) as  read_book_cnt, -- 阅读书本数
to_bitmap(null) as  read_chapter_cnt, -- 阅读章节数
null as  read_cnt ,-- 阅读次数
null as  get_money_amt  ,
null as  get_gift_amt,  -- 获取礼券
null as  get_award_amt,   -- 获取赠送币
sum(amt) get_point_amt,  -- 获取积分
sum(cnt) get_point_cnt ,  -- 获取积分次数
null as produce_ads_amt,
null as produce_ads_cnt
from dws.dws_grant_user_jifen_info_ed
where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id not in (7777,8888,6833)
group by 1,2,3

union all
-- ----app内 用户贡献的预估广告收益----------------
select dt,product_id,user_id ,
       null as consume_amt ,
      null as consume_cnt  ,
       to_bitmap(null)  as consume_book_cnt,
       to_bitmap(null)  as consume_chapter_cnt,
      null as consume_money_amt ,
      null as consume_money_cnt  ,
       to_bitmap(null)  as consume_money_book_cnt,
       to_bitmap(null)  as consume_money_chapter_cnt,
      null as consume_gift_amt ,
      null as consume_gift_cnt  ,
       to_bitmap(null)  as consume_gift_book_cnt,
       to_bitmap(null)  as consume_gift_chapter_cnt,
      null as consume_award_amt ,
      null as consume_award_cnt  ,
       to_bitmap(null)  as consume_award_book_cnt,
       to_bitmap(null)  as consume_award_chapter_cnt,
      null as consume_vip_amt ,
      null as consume_vip_cnt  ,
       to_bitmap(null)  as consume_vip_book_cnt,
       to_bitmap(null)  as consume_vip_chapter_cnt,
      null as bat_ulk_cnt,
      null as fix_ulk_cnt,
      null as sup_ulk_cnt,
      null as sup_ulk_amt,
      null as  bat_ulk_money_amt ,
      null as consume_point_amt , -- 消耗数量
      null as consume_point_cnt , -- ----消耗次数
      null as login_times,  -- -----每天的登录次数
         null as ordinary_recharge_amt,
null as ordinary_recharge_cnt,
null as vip_recharge_amt,
null as vip_recharge_cnt,
null as sub_recharge_amt,
null as sub_recharge_cnt ,
null as  read_times  ,
to_bitmap(null) as  read_book_cnt, -- 阅读书本数
to_bitmap(null) as  read_chapter_cnt, -- 阅读章节数
null as  read_cnt ,-- 阅读次数
null as  get_money_amt  ,
null as  get_gift_amt,  -- 获取礼券
null as  get_award_amt,   -- 获取赠送币
null as  get_point_amt,  -- 获取积分
null as  get_point_cnt ,  -- 获取积分次数
sum(amt) as produce_ads_amt,
sum(cnt) as produce_ads_cnt
from dws.dws_advertisement_user_position_amt_ed
where dt>='${bf_1_dt}' and dt<'${dt}'  and product_id not in (7777,8888,6833)
group by 1,2,3

) a
left join
(   select acc.product_id,acc.id, if(acc.corever is  null or acc.corever =0 ,1,acc.corever) as corever,acc.mt  ,acc.current_language,
       (case when acc.product_id = 3311 and (acc.current_language2 is null or acc.current_language2 = 0) then  6
             when acc.product_id = 3322 and (acc.current_language2 is null or acc.current_language2 = 0) then  5
             when acc.product_id = 3333 and (acc.current_language2 is null or acc.current_language2 = 0) then  2
             when acc.product_id = 3366 and (acc.current_language2 is null or acc.current_language2 = 0) then  3
             when acc.product_id = 3371 and (acc.current_language2 is null or acc.current_language2 = 0) then  7
             when acc.product_id = 3388 and (acc.current_language2 is null or acc.current_language2 = 0) then  4
             when acc.product_id = 3501 and (acc.current_language2 is null or acc.current_language2 = 0) then  11
             when acc.product_id = 3511 and (acc.current_language2 is null or acc.current_language2 = 0) then  12
             when acc.product_id = 3399 and (acc.current_language2 is null or acc.current_language2 = 0) then  9
             else acc.current_language2 end ) as  current_language2,
       acc.create_time as reg_time,acc.reg_country,acc.country,acc.appver,acc.ver,acc.money as bal_money_amt,acc.gift_money as bal_gift_amt,acc.jifen as bal_point_amt
from  dim.dim_user_account_info_view acc
) acc
on a.product_id=acc.product_id and a.user_id=acc.id
 left join
 dim.dim_countrylevel c
 on acc.product_id =c.product_id  and acc.reg_country =c.short_name
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,59,60,61;
