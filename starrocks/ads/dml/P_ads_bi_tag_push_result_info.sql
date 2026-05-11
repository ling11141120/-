insert into ads.ads_bi_tag_push_result_info
with tmp_a AS (
    select
        a.dt,
        a.product_id ,
        a.err_msg_id    as message_id ,
        a.user_id ,
        a.task_type ,
        a.batch_id ,
        split_part(a.token,':',1) as token  ,
        a.is_success
    from dwd.dwd_market_sr_push_msg_log_di a
    where a.dt >= '${bf_10_dt}'
      and a.dt < '${dt}'
      and a.task_type =4
      and a.is_success = 1
),

tmp_c AS (
-- --------push送达的日志--------------
select date(event_time) as dt,  message_id ,event_type,instance_id,product_id
from  dwd.dwd_market_log_bigquerylog_view
where
    event_time>='${bf_10_dt}' and event_time<DATE_add('${dt}',interval 1 day)
  and  message_id is not null
--  and  event_type='MESSAGE_DELIVERED' -- 送达成功的条件
group by 1,2,3,4 ,5
),
sd as (
-- -------------------逻辑更新一下  ---- 需要确定这个表的时区是东八区 --
select a.dt,
       a.product_id,
        a.batch_id as push_id,
-- count(distinct a.user_id) 下发,
       count(distinct a.user_id) as actual_push_unt, -- 实际推送
-- count(distinct if(c.message_id is not null and c.event_type='MESSAGE_ACCEPTED',a.user_id,null))  有效下发,
       count(distinct (CASE WHEN c.message_id is not null and c.event_type='MESSAGE_DELIVERED' THEN a.user_id ELSE null END)) as   send_unt -- 送达人数
from tmp_a a
left  join tmp_c c
    on a.message_id=c.message_id
    and a.token=c.instance_id
    and a.product_id=c.product_id
/*
left join  -- --------获取活动id 策略id
( select  a.push_id,a.activity_id,a.strategy_id,a.book_id,a.lang_id,b.productid as product_id from   dim.dim_tag_push_activity_info_view a
left join dim.DIM_ProductType b on a.lang_id=b.langid ) d
on a.product_id=d.product_id and a.batch_id=d.push_id  */
group by 1,2 ,3
),

tmp_d AS (
-- --------获取活动id 策略id
select
    a.push_id,
    a.activity_id,
    a.strategy_id,
    a.book_id,
    a.lang_id,
    b.productid as product_id
from   dim.dim_tag_push_activity_info_view a
left join dim.DIM_ProductType b
    on a.lang_id=b.langid
),
-- 点击人数的数据 点击之后一个小时内的----------------------

-- ----------埋点的数据都是东八区的 并且推送类型只有 4 TAG推送的数据----------------------------
rd as ( -- ----------------获取push信息的 用户点击的明细数据------------------------
select
    a.dt,
    a.app_product_id as product_id,
    a.push_id ,
    a.push_type ,
    d.strategy_id,
    d.book_id,
    count(distinct a.identity_login_id ) as click_unt,
    count(distinct rd.user_id) as read_unt
from dwd.dwd_sensors_production_pushclick_view a
left join  tmp_d d
    on a.app_product_id=d.product_id
    and a.push_id=d.push_id
left join
    -- -----------阅读人数-- -----------
    (select product_id,user_id,create_time from  dwd.dwd_read_user_chapter_view where dt>= '${bf_10_dt}' and  dt<'${dt}' group by 1,2,3  ) rd
    on a.app_product_id=rd.product_id
        and a.identity_login_id=rd.user_id
        and rd.create_time>=a.event_tm
        and rd.create_time<DATE_add(a.event_tm,interval  1 hour)
where a.dt>='${bf_10_dt}'
    and a.dt<'${dt}'
    and a.push_id is not null
    and a.push_type <> 1
-- and   a.app_product_id =3371 and a.push_id =9030014 -- and a.push_type =10700
group by 1,2,3,4,5,6
    ) ,


    py as (
-- ----------------获取push信息的 用户点击的明细数据------------------------
select a.dt,a.app_product_id as product_id,a.push_id ,a.push_type ,d.strategy_id,d.book_id,count(distinct a.identity_login_id ) as click_unt,count(distinct py.user_id) as pay_unt,sum(py.pay_amt) pay_amt
from dwd.dwd_sensors_production_pushclick_view a
    left join tmp_d d
on a.app_product_id=d.product_id and a.push_id=d.push_id
    left join
-- ----------充值人数，充值金额----------------
    (select  productid as product_id,userid as user_id,createtime as create_time,sum(itemcount) as pay_amt  from dwd.dwd_trade_user_payorder where dt>= '${bf_10_dt}' and  dt<'${dt}'  group by 1,2,3) py
    on a.app_product_id=py.product_id and a.identity_login_id=py.user_id and py.create_time>=a.event_tm   and py.create_time<DATE_add(a.event_tm,interval  1 hour)

where a.dt>='${bf_10_dt}' and a.dt<'${dt}'  and a.push_id is not null and a.push_type <> 1
-- and a.app_product_id =3371 and a.push_id =9030014 -- and a.push_type =10700
group by 1,2,3,4,5,6

    ),

    csm as (
-- ----------------获取push信息的 用户点击的明细数据------------------------
select a.dt,a.app_product_id as product_id,a.push_id ,a.push_type ,d.strategy_id,d.book_id,count(distinct a.identity_login_id ) as click_unt
        ,count(distinct (CASE WHEN csm.types=1 THEN csm.user_id ELSE null END)) as money_unt -- 阅币消费人数
        ,sum( CASE WHEN csm.types=1 THEN csm.amt ELSE null END) as money_amt -- 阅币消费数量
        ,count(distinct (CASE WHEN csm.types in (1,2,3,4) THEN csm.user_id ELSE null END)) as total_unt -- 总消费人数
        ,sum( CASE WHEN csm.types in (1,2,3,4) THEN csm.amt ELSE null END) as total_amt -- 总消费数量
        ,count(distinct (CASE WHEN csm.types=2 THEN csm.user_id ELSE null END)) as gift_money_unt -- 礼券消费人数
        ,sum( CASE WHEN csm.types=2 THEN csm.amt ELSE null END) as gift_money_amt -- 礼券消费数量
from dwd.dwd_sensors_production_pushclick_view a
    left join tmp_d d
on a.app_product_id=d.product_id and a.push_id=d.push_id
    left join
-- ----------消费人数，消费数量----------------
    (select product_id,user_id, createtime as create_time ,
    types,sum(amount) as amt
    from dwd.dwd_consume_user_consume_explode  where dt>='${bf_10_dt}'and  dt<'${dt}'and pay_type not in (1103,101) and (types in(1,2,3) or (types=4 and isFirst=1))  group by 1,2,3,4) csm
    on a.app_product_id=csm.product_id and a.identity_login_id=csm.user_id and csm.create_time>=a.event_tm   and csm.create_time<DATE_add(a.event_tm,interval  1 hour)

where a.dt>='${bf_10_dt}' and a.dt<'${dt}'  and a.push_id is not null and a.push_type <> 1
--  and a.app_product_id =3371 and a.push_id =9030014  -- and a.push_type =10700
group by 1,2,3,4,5,6

    )

select sd.dt,sd.product_id,sd.push_id,b.push_type,b.strategy_id,b.book_id,sd.actual_push_unt, sd.send_unt,b.click_unt,b.read_unt,b.pay_unt,b.pay_amt,b.money_unt,b.money_amt,b.total_unt,b.total_amt,b.gift_money_unt,b.gift_money_amt,now() as etl_tm
from sd
         left join
     (
         select rd.dt,rd.product_id,rd.push_id ,rd.push_type ,rd.strategy_id,rd.book_id,rd.click_unt,rd.read_unt,py.pay_unt,py.pay_amt,csm.money_unt,csm.money_amt,csm.total_unt,csm.total_amt,csm.gift_money_unt,csm.gift_money_amt
         from  rd
                   left join py
                             on rd.dt=py.dt and   rd.product_id  = py.product_id and rd.push_id=py.push_id and rd.push_type=py.push_type --    and rd.click_unt= py.click_unt   --   and rd.strategy_id=py.strategy_id and rd.book_id=py.book_id
                   left join csm
                             on rd.dt=csm.dt and  rd.product_id=csm.product_id and rd.push_id=csm.push_id  and rd.push_type=csm.push_type --   and rd.click_unt= csm.click_unt --  and rd.strategy_id=csm.strategy_id and rd.book_id=csm.book_id
     ) b
     on sd.dt=b.dt and sd.product_id=b.product_id and sd.push_id=b.push_id