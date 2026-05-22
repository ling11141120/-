----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_bi_read_consume_p_di
-- workflow_version : 20
-- create_user      : yanxh
-- task_name        : ads_sr_bi_read_consume_p_di
-- task_version     : 15
-- update_time      : 2025-06-07 01:34:26
-- sql_path         : \starrocks\tbl_ads_sr_bi_read_consume_p_di\ads_sr_bi_read_consume_p_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_sr_bi_read_consume_p_di`
  select  dt,ifnull(lang_id,-99) as lang_id,book_id,source_user_tp,days_num,ifnull(mt,0) as mt,ifnull(source,'other') as source ,ifnull(nick_name,'other') as nick_name ,book_name, book_code,
 sum(fst_read_unt) as fst_read_unt,-- 首次阅读人数( 首次阅读日期=阅读日期 )
 sum(read_unt) as read_unt,-- 阅读人数
 sum(csum_unt) as csum_unt,-- 消耗人数
 sum(csum_amt) as csum_amt,  -- 阅币消耗金额
 sum(read_unt_a) as read_unt_a,-- 累计天数阅读人数
 sum(csum_unt_a)  as csum_unt_a  -- 累计天数消耗人数)
from (
-- ===================================== 阅读，消耗人数、 阅币消耗数 ====================================
   select fst.dt,
     fst.lang_id,
     fst.book_id,
     fst.book_name,
     fst.book_code,
     fst.source,
     fst.source_user_tp,
     fst.mt,
     fst.nick_name,
     datediff(b.dt,fst.dt) as days_num,-- 时间周期
     count(distinct  if(b.tps=1 and fst.dt=b.dt,fst.user_id,null)) as fst_read_unt,-- 首次阅读人数( 首次阅读日期=阅读日期 )
     count(distinct if(b.tps=1,b.user_id,null)) as read_unt,-- 阅读人数
     count(distinct if(b.tps=2,b.user_id,null)) as csum_unt,-- 消耗人数
     sum(if(b.tps=2,b.amt,0)) as csum_amt,                -- 阅币消耗数
     0  as read_unt_a ,-- 累计天数阅读人数
     0  as csum_unt_a  -- 累计天数消耗人数
   from  ads.ads_sr_bi_read_consume_p_di_temp  fst  -- 首次阅读的表
   left join
                 -- ----------------阅读的明细----------------------------------
   ( select  date(hours_add(create_time,-13)) as dt  ,product_id,user_id,book_id,1 as tps ,0 as amt from dwd.dwd_read_user_chapter_view
   where dt>=date_sub(hours_add('${bf_1_dt}',13),interval 8 day)  and create_time>=date_sub(hours_add('${bf_1_dt}',13),interval 8 day) and dt<date_add('${dt}',interval 7 day)
  union all -- ---------消耗明细 此表已经是西五区的表了-----------------------
   select   dt  ,product_id,user_id,book_id,2 as tps,con_chp_amount as amt from dwm.dwm_consume_user_consume_w5_p_di
   where dt>=date_sub('${bf_1_dt}',interval 8 day)  and dt<date_add('${dt}',interval 7 day) and types=1 and book_id >0 -- 阅币的
   ) b
   on fst.product_id=b.product_id and fst.book_id=b.book_id and fst.user_id =b.user_id and datediff(b.dt,fst.dt)<=7 and  b.dt>=fst.dt

  where fst.dt>=date_sub('${bf_1_dt}',interval 7 day) and fst.dt<'${dt}'
   --    and  fst.book_id=	11878375   and fst.source_user_tp=2 and fst.mt=1
   group by 1,2,3,4,5,6,7,8,9 ,10

union all

-- =================计算累计天数阅读人数==============================================
 select  dt,lang_id,book_id,book_name, book_code,source,source_user_tp,mt,
 nick_name,
 days_num-1 as days_num,
 0 as fst_read_unt,-- 首次阅读人数( 首次阅读日期=阅读日期 )
 0 as read_unt,-- 阅读人数
 0 as csum_unt,-- 消耗人数
 0 as csum_amt,                -- 阅币消耗金额
 count(distinct user_id) as read_unt_a,-- 累计天数阅读人数
 0  as csum_unt_a  -- 累计天数消耗人数
from (
   select fst.dt,
     fst.lang_id,
     fst.book_id,
     fst.book_name,
     fst.book_code,
     fst.source,
     fst.source_user_tp,
     fst.mt,
     fst.nick_name,
     fst.user_id,
     count(distinct b.dt)  as days_num
   from ads.ads_sr_bi_read_consume_p_di_temp  fst  -- 首次阅读的表
   left join
                 -- ----------------阅读的明细----------------------------------
   ( select  date(hours_add(create_time,-13)) as dt  ,product_id,user_id,book_id from dwd.dwd_read_user_chapter_view
   where dt>=date_sub(hours_add('${bf_1_dt}',13),interval 8 day)  and create_time>=date_sub(hours_add('${bf_1_dt}',13),interval 8 day) and dt<date_add('${dt}',interval 7 day)
   ) b
   on fst.product_id=b.product_id and fst.book_id=b.book_id and fst.user_id =b.user_id and datediff(b.dt,fst.dt)<=7 and  b.dt>=fst.dt
  where fst.dt>=date_sub('${bf_1_dt}',interval 7 day) and fst.dt<'${dt}'
    -- and  fst.book_id=	11878375   and fst.source_user_tp=2 and fst.mt=1
   group by 1,2,3,4,5,6,7,8,9,10
       -- 过滤掉没有阅读的
 )  a
 where days_num>0
 group by 1,2,3,4,5,6,7 ,8,9,10

union all

-- =================计算累计天数消耗人数==============================================
 select  dt,lang_id,book_id,book_name, book_code,source,source_user_tp,mt,
 nick_name,
 days_num-1 as days_num,
 0 as fst_read_unt,-- 首次阅读人数( 首次阅读日期=阅读日期 )
 0 as read_unt,-- 阅读人数
 0 as csum_unt,-- 消耗人数
 0 as csum_amt,                -- 阅币消耗金额
 0 as read_unt_a,-- 累计天数阅读人数
 count(distinct user_id)  as csum_unt_a  -- 累计天数消耗人数
from (
   select fst.dt,
     fst.lang_id,
     fst.book_id,
     fst.book_name,
     fst.book_code,
     fst.source,
     fst.source_user_tp,
     fst.mt,
     fst.nick_name,
     fst.user_id,
     count(distinct b.dt)  as days_num
   from ads.ads_sr_bi_read_consume_p_di_temp  fst  -- 首次阅读的表
   left join

   ( -- ---------消耗明细 此表已经是西五区的表了-----------------------
   select   dt  ,product_id,user_id,book_id,2 as tps,con_chp_amount as amt from dwm.dwm_consume_user_consume_w5_p_di
   where dt>=date_sub('${bf_1_dt}',interval 8 day)  and dt<date_add('${dt}',interval 7 day) and types=1 and book_id >0 -- 阅币的
   ) b
   on fst.product_id=b.product_id and fst.book_id=b.book_id and fst.user_id =b.user_id and datediff(b.dt,fst.dt)<=7 and  b.dt>=fst.dt
  where fst.dt>=date_sub('${bf_1_dt}',interval 7 day) and fst.dt<'${dt}'
  --     and  fst.book_id=	11878375   and fst.source_user_tp=2 and fst.mt=1
   group by 1,2,3,4,5,6,7,8,9,10
 --  having count(distinct b.dt)>0  -- 过滤掉没有消耗的
 )  a
 where days_num>0
 group by 1,2,3,4,5,6,7 ,8,9,10

) x
 -- where dt='2024-07-10' and source='fbs2s'
group by 1,2,3,4,5,6,7 ,8,9,10;
