----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_ad_book_promotion_arpu
-- workflow_version : 17
-- create_user      : yanxh
-- task_name        : ads_sr_ad_book_promotion_arpu
-- task_version     : 8
-- update_time      : 2024-10-16 11:20:45
-- sql_path         : \starrocks\tbl_ads_sr_ad_book_promotion_arpu\ads_sr_ad_book_promotion_arpu
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_sr_ad_book_promotion_arpu  where dt>='${bf_15_dt}';

-- SQL语句
-- ===================算消耗指标======================
insert into ads.ads_sr_ad_book_promotion_arpu
 select tag.dt,tag.product_id,Ifnull(tag.book_id,-99) as book_id,tag.chl2,tag.campaign,tag.source_chl,tag.current_language2,tag.mt,tag.core,tag.adcamp_id,
 count(distinct tag.user_id) as active_unt ,
sum(if(tag.dt=c.dt and date_add(tag.dt,0)< tag.next_dt ,money_amt,0)) as D0_money_amt,
sum(if(tag.dt=date_sub(c.dt,1) and date_add(tag.dt,1)< tag.next_dt, money_amt,0)) as D1_money_amt,
sum(if(tag.dt=date_sub(c.dt,2) and date_add(tag.dt,2)< tag.next_dt, money_amt,0)) as D2_money_amt,
sum(if(tag.dt=date_sub(c.dt,3) and date_add(tag.dt,3)< tag.next_dt, money_amt,0)) as D3_money_amt,
sum(if(tag.dt=date_sub(c.dt,4) and date_add(tag.dt,4)< tag.next_dt, money_amt,0)) as D4_money_amt,
sum(if(tag.dt=date_sub(c.dt,5) and date_add(tag.dt,5)< tag.next_dt, money_amt,0)) as D5_money_amt,
sum(if(tag.dt=date_sub(c.dt,6) and date_add(tag.dt,6)< tag.next_dt, money_amt,0)) as D6_money_amt,
sum(if(tag.dt=date_sub(c.dt,7) and date_add(tag.dt,7)< tag.next_dt, money_amt,0)) as D7_money_amt,
sum(if(tag.dt=date_sub(c.dt,8) and date_add(tag.dt,8)< tag.next_dt, money_amt,0)) as D8_money_amt,
sum(if(tag.dt=date_sub(c.dt,9) and date_add(tag.dt,9)< tag.next_dt, money_amt,0)) as D9_money_amt,
sum(if(tag.dt=date_sub(c.dt,10) and date_add(tag.dt,10)< tag.next_dt, money_amt,0)) as D10_money_amt,
sum(if(tag.dt=date_sub(c.dt,11) and date_add(tag.dt,11)< tag.next_dt, money_amt,0)) as D11_money_amt,
sum(if(tag.dt=date_sub(c.dt,12) and date_add(tag.dt,12)< tag.next_dt, money_amt,0)) as D12_money_amt,
sum(if(tag.dt=date_sub(c.dt,13) and date_add(tag.dt,13)< tag.next_dt, money_amt,0)) as D13_money_amt,
sum(if(tag.dt=date_sub(c.dt,14) and date_add(tag.dt,14)< tag.next_dt, money_amt,0)) as D14_money_amt,
sum(if(tag.dt=date_sub(c.dt,15) and date_add(tag.dt,15)< tag.next_dt, money_amt,0)) as D15_money_amt,
sum(if(tag.dt=c.dt and date_add(tag.dt,0)< tag.next_dt ,gift_amt,0)) as D0_gift_amt,
sum(if(tag.dt=date_sub(c.dt,1) and date_add(tag.dt,1)< tag.next_dt  , gift_amt,0)) as D1_gift_amt,
sum(if(tag.dt=date_sub(c.dt,2) and date_add(tag.dt,2)< tag.next_dt , gift_amt,0)) as D2_gift_amt,
sum(if(tag.dt=date_sub(c.dt,3) and date_add(tag.dt,3)< tag.next_dt , gift_amt,0)) as D3_gift_amt,
sum(if(tag.dt=date_sub(c.dt,4) and date_add(tag.dt,4)< tag.next_dt, gift_amt,0)) as D4_gift_amt,
sum(if(tag.dt=date_sub(c.dt,5) and date_add(tag.dt,5)< tag.next_dt, gift_amt,0)) as D5_gift_amt,
sum(if(tag.dt=date_sub(c.dt,6) and date_add(tag.dt,6)< tag.next_dt, gift_amt,0)) as D6_gift_amt,
sum(if(tag.dt=date_sub(c.dt,7) and date_add(tag.dt,7)< tag.next_dt, gift_amt,0)) as D7_gift_amt,
sum(if(tag.dt=date_sub(c.dt,8) and date_add(tag.dt,8)< tag.next_dt, gift_amt,0)) as D8_gift_amt,
sum(if(tag.dt=date_sub(c.dt,9) and date_add(tag.dt,9)< tag.next_dt, gift_amt,0)) as D9_gift_amt,
sum(if(tag.dt=date_sub(c.dt,10) and date_add(tag.dt,10)< tag.next_dt, gift_amt,0)) as D10_gift_amt,
sum(if(tag.dt=date_sub(c.dt,11) and date_add(tag.dt,11)< tag.next_dt, gift_amt,0)) as D11_gift_amt,
sum(if(tag.dt=date_sub(c.dt,12) and date_add(tag.dt,12)< tag.next_dt, gift_amt,0)) as D12_gift_amt,
sum(if(tag.dt=date_sub(c.dt,13) and date_add(tag.dt,13)< tag.next_dt, gift_amt,0)) as D13_gift_amt,
sum(if(tag.dt=date_sub(c.dt,14) and date_add(tag.dt,14)< tag.next_dt, gift_amt,0)) as D14_gift_amt,
sum(if(tag.dt=date_sub(c.dt,15) and date_add(tag.dt,15)< tag.next_dt, gift_amt,0)) as D15_gift_amt,
now() as etl_tm
from

(
select tag.dt,tag.product_id,tag.book_id,tag.chl2,tag.campaign,tag.source_chl,tag.current_language2,tag.mt,tag.core,tag.adcamp_id,user_id,
 date(ifnull(lead(dt)over(partition by product_id,book_id,user_id order by dt ),'9999-01-01')) as next_dt,
date(ifnull(lag(dt)over(partition by product_id,book_id,user_id order by dt ),'1999-01-01')) as last_dt
-- date(date_add(tag.dt,15)) as end_day
from dws.dws_sr_ad_book_promotion_user_info_di tag
where tag.dt>=date_sub('${dt}',interval 15 day )
--    and tag.user_id in (156446286)  -- 验证数据
--   and tag.book_id =11195375
  )
tag

left join
( -- 获取用户书籍阅币、礼券消耗------------------
select  dt,product_id,book_id,user_id,sum(if(types=1,amount,0)) as money_amt, sum(if(types=2,amount,0)) as gift_amt
from  dws.dws_consume_user_consume_ed
where dt>=date_sub('${dt}',interval 15 day ) and types in (1,2)
 -- and user_id in (156446286)  -- 验证数据
 -- and book_id =11195375
group by 1,2,3,4
order by 1 ,4
) c
on
tag.product_id=c.product_id and  tag.user_id=c.user_id and  tag.book_id=c.book_id and c.dt>=tag.dt

group by 1,2,3,4,5 ,6,7,8,9,10;
