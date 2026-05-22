----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_looklike_user_label
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_sr_looklike_user_label
-- task_version     : 5
-- update_time      : 2024-10-16 11:31:30
-- sql_path         : \starrocks\tbl_ads_sr_looklike_user_label\ads_sr_looklike_user_label
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_looklike_user_label
   with user_all as (
 select
    us.product_id,
    us.user_id,
    lg.login_days,                 -- 登录天数
    lg.login_re,                   -- 最近登录日期
    py.first_recharge,                 -- 首次充值金额
    py.recharge_cnt,                   -- 累计充值次数
    py.total_recharge,                 -- 累计充值金额
    py.recharge_avg ,                  --  平均充值金额
    py.total_subscribe_money,          -- 累计订阅金额
    py.charge_mode,                    -- 充值众数
    py.coupon_mode,                    -- 充值优惠众数(充值获得礼券数/阅币数)
    py.last_recharge_time,             -- 最近充值时间
    cm.chapter_total,                  -- 累计付费解锁章节数
    cm.chapter_days_avg,               -- 日均付费解锁章节数
    cu.consume_total,                  -- 用户累计消耗（阅币+礼券）数
    cu.consume_days_avg,               -- 日均消费货币数（阅币+礼券）
    rd.total_read_time ,               -- 累计阅读时长
    rd.read_time_da_avg                -- 日均阅读时长

 from
             -- 用户注册表
 (  select product_id ,id as user_id
    from dim.dim_user_account_info_view  ) us
left join
(
-- 登录的指标
select  product_id,user_id,
        login_days,                 -- 登录天数
        new_login_time  as login_re -- 最近登录日期
from dws.dws_user_login_a
where dt='${bf_1_dt}'
 ) lg
 on   us.product_id= lg.product_id and  us.user_id=lg.user_id

 left join
 (
-- 充值的指标
select product_id,user_id,
    first_recharge, -- 首次充值金额
    recharge_cnt,   -- 累计充值次数
    total_recharge,  -- 累计充值金额
    recharge_avg ,     --  平均充值金额
    total_subscribe_money, -- 累计订阅金额
    charge_mode,  -- 充值众数
    coupon_mode,  -- 充值优惠众数(充值获得礼券数/阅币数)
    last_recharge_time -- 最近充值时间
from dws.dws_trade_user_recharge_roll_a
where dt='${bf_1_dt}'
 )  py
 on   us.product_id= py.product_id and  us.user_id=py.user_id

left join
(
-- 消耗指标
select product_id,user_id,
       con_chapter_nums as chapter_total, -- 累计付费解锁章节数
       con_chapter_nums/csum_days_cnt as chapter_days_avg -- 日均付费解锁章节数
from dws.dws_consume_user_consume_a
where dt='${bf_1_dt}'
) cm
 on   us.product_id= cm.product_id and  us.user_id=cm.user_id

 left join
 (

select product_id,user_id,
       sum(con_amount) as consume_total,  -- 用户累计消耗（阅币+礼券）数
       sum(con_amount)/count(distinct csum_days_cnt) as consume_days_avg -- 日均消费货币数（阅币+礼券）
from dws.dws_consume_user_consume_td_mid
where dt='${bf_1_dt}' and types in (1,2)
group by 1,2
) cu

 on   us.product_id= cu.product_id and  us.user_id=cu.user_id
 left join
 (
 -- 阅读指标
select product_id,user_id,
read_time_td as total_read_time , -- 累计阅读时长
read_time_td/read_day_td  as read_time_da_avg -- 日均阅读时长
from
dws.dws_read_user_readtime_a_mid
) rd
 on   us.product_id= rd.product_id and  us.user_id=rd.user_id
 )

 select user_all.product_id, user_all.user_id, login_days, login_re, first_recharge, recharge_cnt, total_recharge, recharge_avg,
 total_subscribe_money, charge_mode, coupon_mode, last_recharge_time, chapter_total, chapter_days_avg,
 consume_total, consume_days_avg, total_read_time, read_time_da_avg,now() as etl_tm
 from user_all
 inner join
 -- ------------------关联有活跃的表-----------------
 ( select product_id , user_id  from (
 select product_id , user_id
 from  dws.dws_user_wide_active_ed
 where dt= '${bf_1_dt}'
 group by 1,2
 union all
select  product_id , user_id
from dws.dws_read_user_book_readtime_ed
 where dt= '${bf_1_dt}'
  group by 1,2
 )  ac group by 1,2
 ) active

 on user_all.product_id= active.product_id  and   user_all.user_id= active.user_id;
