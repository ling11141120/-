----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_recharge_fulibao
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : ads_sr_user_recharge_fulibao
-- task_version     : 3
-- update_time      : 2024-09-11 20:22:01
-- sql_path         : \starrocks\tbl_ads_sr_user_recharge_fulibao\ads_sr_user_recharge_fulibao
----------------------------------------------------------------
-- SQL语句
insert into   ads.ads_sr_user_recharge_fulibao
with tr  as (
    select ProductId  , UserId , itemcount, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt <= '${dt}'
                      and shopitem in (830,840) -- 830:旧福利包 -- 840：新福利包
                     group by 1, 2, 3
)

select a.ProductId,a.userid,
a.recharge_cnt, -- 次数
b.itemcount as recharge_amt, -- 最近一次充值金额
c.charge_mode as recharge_mode, -- 充值金额众数
now()  as etl_tm
from (
-- 福利包充值次数--
select   ProductId , UserId,sum(num) as recharge_cnt
from tr
group by 1,2
) a

left join
(
-- 最近一次福利包充值金额--
select   ProductId , UserId,itemcount
from tr
qualify row_number() over (partition by ProductId,UserId order by createtime desc ) =1
) b
  on a.ProductId=b.ProductId and a.userid=b.userid
left join
(
-- 获取用户的阅币福利包的众数 -- -------------------------
    select ProductId , UserId,
            ItemCount as charge_mode -- 订阅金额众数
    from (
             select ProductId, UserId, ItemCount, num, createtime,
                    -- 将充值次数降序、充值时间降序
                    row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rn
             from tr
         ) b
    where rn = 1
    order by 1,2
 )  c

 on a.ProductId=c.ProductId and a.userid=c.userid;
