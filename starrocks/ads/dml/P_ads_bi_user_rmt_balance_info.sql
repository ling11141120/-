----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_rmt_balance_info
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_bi_user_rmt_balance_info
-- task_version     : 6
-- update_time      : 2024-03-22 13:50:02
-- sql_path         : \starrocks\tbl_ads_bi_user_rmt_balance_info\ads_bi_user_rmt_balance_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_user_rmt_balance_info
 with us as (
 select dt,product_id,user_id,install_date,csm_tm,types,remain_amount ,rk ,time_diff,user_attribute
 from (
    -- -------根据rmt表关联获取最早拉起时间-----------------------
select    a.dt,a.product_id , a.user_id,a.user_attribute,b.install_date,c.csm_tm ,c.types,c.remain_amount,
TIMEDIFF(b.install_date,c.csm_tm) as time_diff,ROW_NUMBER()over(partition by  a.product_id ,  a.user_id, c.types order by TIMEDIFF( b.install_date, c.csm_tm),c.id desc)  as rk
from dws.dws_wide_user_read_user_label_info_ed  a  -- 标签表只取user_tps=2 rmt用户
  left join
    (  -- 按天算出每个用户的最早拉起时间记录，一个用户一条
    select dt,Product_Id,User_Id,min(Install_Date) Install_Date
    from  dwd.dwd_user_install_info_ed_view  where dt>='${bf_1_dt}' and dt<'${dt}'
    and    product_id  not in (7777,8888,0,6833,6883)  and isdelete !=1
    group by 1,2,3
 ) b
  on a.dt=b.dt and  a.product_id=b.product_id and a.user_id =b.user_id
 left join
(select dt, product_id, create_tm as csm_tm, user_id, types, remain_amount,id from ads.ads_user_rmt_consume_mid    where dt<= '${bf_1_dt}'    ) c
on a.product_id =c.product_id and a.user_id =c.user_id and c.csm_tm< b.install_date
   where  a.dt>='${bf_1_dt}' and a.dt<'${dt}'  and a.user_tps=2      --  and a.user_id in (139004539  )--  and a.product_id =3311
 )  x   where rk=1
 )
 -- select * from us  select  product_id,user_id,count(1) from us group by 1 ,2 having count(1)<2
 ,
 gift  as (
 -- ---------------获取礼券明细----------------------------
 select dt,product_id,user_id ,expire_time ,if(op_type =1 ,gift_num, -gift_num) as gift_num,create_time from  dwd.dwd_grant_user_giftlog
 where  dt>=date_sub('${bf_1_dt}',interval 60 day) and dt<'${dt}' and gift_type =0  and op_type in (1,2)   --  and user_id in (134639562 )
  ) ,
  m30 as (
 -- 1.拉起时间-最后一笔消费时间>30天的  礼券余额为0，还要判断这期间发放且没有过期的礼券数额-------------
 select us.dt,us.product_id,us.user_id,us.install_date,us.csm_tm,us.user_attribute,us.types,
  -- gift.user_id 礼券表里匹配到的用户,
  if(us.types=1,us.remain_amount,0)  as bal_money_amt,
  -- 0 as bal_gift_amt,
  sum(case when  gift.create_time>us.csm_tm and gift.create_time<us.install_date and gift.expire_time> us.install_date then gift.gift_num end) as  bal_gift_amt
 from us
  left join   gift
 on  us.product_id =gift.product_id and us.user_id =gift.user_id
 where ( us.types=2 and  us.install_date > DATE_ADD(us.csm_tm  ,interval 30 day))  or (datediff(us.install_date,us.csm_tm) is null ) or us.types=1
 group by 1,2,3,4,5,6,7 ,8
)
  ,
   --   select user_attribute,count(1),count(distinct user_id)  from m30  group by 1 order by 1
   n30 as (

  select  dt,product_id,user_id,install_date,csm_tm,user_attribute,types,bal_money_amt,x+y as bal_gift_amt  from (

 select dt,product_id,user_id,install_date,csm_tm,user_attribute,types, 0 as bal_money_amt,create_time,expire_time,if(rk=1 and expire_time<install_date,0,remain_amount ) as x ,rk,
    sum(case when create_time>csm_tm and create_time<install_date and expire_time>install_date then gift_num end ) over(partition by dt,product_id,user_id   ) as y
 from(
  select us.dt,us.product_id,us.user_id,us.install_date,us.csm_tm,us.types,us.remain_amount ,us.user_attribute,
 gift.user_id  as gift_user ,
  gift.create_time  ,
  gift.expire_time  ,
  gift.gift_num   ,
 UNIX_TIMESTAMP(us.csm_tm)- UNIX_TIMESTAMP(gift.create_time)  as 时间差 ,
  ROW_NUMBER()over(partition by  us.product_id ,  us.user_id, us.types order by if(UNIX_TIMESTAMP(us.csm_tm)- UNIX_TIMESTAMP(gift.create_time) <0 ,9999999+(UNIX_TIMESTAMP(us.csm_tm)- UNIX_TIMESTAMP(gift.create_time)), UNIX_TIMESTAMP(us.csm_tm)-UNIX_TIMESTAMP(gift.create_time)))  as rk

 from us
  left join  gift
 on  us.product_id =gift.product_id and us.user_id =gift.user_id
 where   us.types=2 and  us.install_date <= DATE_ADD(us.csm_tm  ,interval 30 day)
 ) t  )   l  where rk=1 )

 --  select * from n30   --  select user_attribute,count(1),count(distinct user_id) from (    ) n  group by 1  order by 1

select dt,product_id,user_id,user_attribute,sum(bal_money_amt) as  bal_money_amt, sum(bal_gift_amt ) as  bal_gift_amt,now() as etl_tm
from (
select dt,product_id,user_id,install_date,csm_tm,user_attribute,types,bal_money_amt, bal_gift_amt  from m30
union  all
select dt,product_id,user_id,install_date,csm_tm,user_attribute,types,bal_money_amt, bal_gift_amt  from n30
 ) p
 group by 1,2,3,4;
