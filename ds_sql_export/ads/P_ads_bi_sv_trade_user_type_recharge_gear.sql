----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sv_trade_user_type_recharge_gear
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_bi_sv_trade_user_type_recharge_gear
-- task_version     : 3
-- update_time      : 2024-10-22 18:09:46
-- sql_path         : \starrocks\tbl_ads_bi_sv_trade_user_type_recharge_gear\ads_bi_sv_trade_user_type_recharge_gear
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_sv_trade_user_type_recharge_gear where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_sv_trade_user_type_recharge_gear
with base as ( -- 1.获取订单明细信息--
    select dt,product_id,user_id,shop_item,item_count,base_amount,pay_config_id
    from dwd.dwd_trade_short_video_payorder
    where dt<='${bf_1_dt}' and test_flag=0 and status=0
),
payorder as (
    select a.dt,a.product_id,a.user_id,b.current_language2 as reg_language,ifnull(d.level,2) as country_level,
           b.mt,b.corever,a.shop_item,a.item_count as recharge_gear,
           if(a.dt=c.fst_recharege_dt,1,0) as is_first_recharge,
           e.vip_type,-- 新增的vip类型，'1 月卡 2 季卡 3 年卡 4 周卡'
           count(a.user_id) as charge_cnt,
           sum(item_count) as before_charge,
           sum(a.base_amount/100) as after_charge
    from base a -- 2.关联账户表，获取用户基础信息-------------------
             left join dim.dim_short_video_user_accountinfo b on a.product_id=b.product_id and a.user_id=b.user_id
             left join( -- 3.获取首次充值时间
        select product_id,user_id,min(dt) as fst_recharege_dt
        from base
        group by 1,2
    ) c on a.product_id=c.product_id and a.user_id=c.user_id
             left join(-- ---4.获取国家等级字段-----------------------
        select product_id,short_name,level from dim.dim_countrylevel where product_id=6833
    )d on b.product_id=d.product_id and b.reg_country=d.short_name
             left join
         (    -- 5.获取vip充值的类型 '1 月卡 2 季卡 3 年卡 4 周卡'
             select pay_config_id,is_on_off ,vip_type from dim.dim_sv_recharge_item_info_view
             where pay_config_id is not null
                 qualify row_number() over(partition by pay_config_id order by is_on_off desc )= 1
             order by 1
         ) e
         on a.pay_config_id=e.pay_config_id
    where a.dt='${bf_1_dt}'
    group by 1,2,3,4,5,6,7,8,9,10,11
)
select
    a.dt,
    b.period_type,
    a.product_id,a.user_id,a.reg_language,a.country_level,a.mt,a.corever,
    b.user_type,
    a.shop_item,a.recharge_gear,
    a.is_first_recharge,
    a.vip_type,
    a.charge_cnt,
    a.before_charge,
    a.after_charge,
    now() as etl_tm
from payorder a
left join (
    select
        product_id,
        user_id,
        period_type,
        user_type
    from dws.dws_user_short_video_wide_active_period_ed
    where dt='${bf_1_dt}'
) b on a.product_id = b.product_id and a.user_id = b.user_id;
