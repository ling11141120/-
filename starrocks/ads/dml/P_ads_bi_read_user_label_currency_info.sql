----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_read_user_label_currency_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : ads_bi_read_user_label_currency_info
-- task_version     : 3
-- update_time      : 2025-03-10 21:57:52
-- sql_path         : \starrocks\tbl_ads_bi_read_user_label_currency_info\ads_bi_read_user_label_currency_info
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_bi_read_user_label_currency_info where  dt>='${bf_1_dt}' and dt<'${dt}';

-- SQL语句
insert into  ads.ads_bi_read_user_label_currency_info
with csm as (
    select
        dt
        ,product_id
        ,user_id
        ,core
        ,sum(pay_amt) as pay_amt
        ,sum(grant_money_amt) as grant_money_amt
        ,sum(grant_gift_amt) as grant_gift_amt
        ,sum(exp_gift_amt) as exp_gift_amt
        ,sum(csm_amt) as csm_amt
        ,sum(csm_gift_amt) as csm_gift_amt
    from (
        select dt,productid as product_id,userid as user_id,corever as core,sum(chargeitemcount) as pay_amt ,0 as grant_money_amt,0 as grant_gift_amt ,0 as exp_gift_amt,0 as csm_amt,0 as csm_gift_amt
        from dws.dws_trade_user_shopitem_charge_ed
        where dt>='${bf_1_dt}' and dt<'${dt}'
        group by 1,2,3,4

        union all -- 发放阅币的---
        -- 表没有分core
        select
            t.dt,t.product_id,t.user_id,u.corever,0 as pay_amt, sum(real_get) grant_money_amt ,0,0 ,0,0
        from (
            select dt,product_id,user_id,real_get from dwd.dwd_grant_readernovel_getmoneylog_view
            where dt>='${bf_1_dt}' and dt<'${dt}' and charge_type  not in (5,100)
        ) t
        left join dim.dim_user_all_info u on t.product_id = u.product_id and t.user_id = u.user_id
        group by 1,2,3,4

        union all  -- -------------发放礼券以及过期礼券------------------------
        select dt,product_id,user_id,coalesce(CAST((substring(appid, 4, 3)) AS INT), -99) AS core,0 as pay_amt,0 as grant_money_amt,sum(if(op_type =1,gift_num,0)) as grant_gift_amt ,sum(if(op_type =2,gift_num,0)) as exp_gift_amt,0,0
        from dwd.dwd_grant_user_giftlog where dt>='${bf_1_dt}' and dt<'${dt}'  and gift_type =0 group by 1,2,3,4

        union all  -- --------消耗阅币、礼券-------------------
        select dt,  product_id,user_id,corever,0,0,0,0 ,sum(if(types=1,con_chp_amount,0)) as csm_amt,  sum(if(types=2,con_chp_amount,0)) as csm_gift_amt
        from dwm.dwm_consume_user_consume_mild_ed
        where dt>='${bf_1_dt}' and dt<'${dt}' and  product_id not in (7777,8888)  and types in (1,2)  and pay_type !=1103  group by  1,2,3,4
    )  a
    group by 1,2,3,4
)
select
    usfo.dt,usfo.product_id,usfo.user_tps,usfo.core,usfo.user_attribute
 ,bitmap_agg(usfo.user_id) as unt
 ,sum(p.pay_amt) as pay_amt
 ,sum(p.grant_money_amt) as grant_money_amt
  ,sum(p.grant_gift_amt) as grant_gift_amt ,
  sum(p.exp_gift_amt) as exp_gift_amt,
 sum(p.csm_amt) as  csm_amt,
 sum(p.csm_gift_amt) as csm_gift_amt,now() as etl_tm
 from
   dws.dws_wide_user_read_user_label_info_ed  usfo
  left join -- -----------充值金额-------------------------
csm p
 on usfo.dt=p.dt and usfo.product_id=p.product_id and usfo.user_id = p.user_id and p.core = usfo.core
 where usfo.dt>='${bf_1_dt}'  and usfo.dt<'${dt}'
    group by 1,2,3,4,5;
