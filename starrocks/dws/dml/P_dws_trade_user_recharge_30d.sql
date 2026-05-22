----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_user_recharge_30d
-- workflow_version : 7
-- create_user      : linq
-- task_name        : dws_trade_user_recharge_30d
-- task_version     : 7
-- update_time      : 2026-03-24 19:24:13
-- sql_path         : \starrocks\tbl_dws_trade_user_recharge_30d\dws_trade_user_recharge_30d
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_trade_user_recharge_30d where month >= date_format(date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month),'%Y%m');

-- SQL语句
insert into dws.dws_trade_user_recharge_30d
select date_format(dt, '%Y%m')                                                         as month,
       Productid                                                                       as product_id,
       if(corever is null, -99, corever)                                               as corever,
       if(CurrentLanguage is null, -99, CurrentLanguage)                               as current_language,
       if(CurrentLanguage2 is null, -99, CurrentLanguage2)                             as current_language2,
       if(appver is null, -99, appver)                                                 as appver,
       if(mt is null, -99, mt)                                                         as mt,
       if(ver is null, -99, ver)                                                       as ver,
       if(regcountry is null, -99, regcountry)                                         as reg_country,
       if(ShopItem is null, -99, ShopItem)                                             as shop_item,
       if(SubpayType is null, -99, SubpayType)                                         as subpay_type,
       IF(concat(year(dt), month(dt)) = CONCAT(year(NOW()), month(NOW())), DAY(curdate()),
          dayofmonth(DATE_SUB(DATE_ADD(DATE_TRUNC('MONTH', dt), INTERVAL 1 MONTH), INTERVAL 1
                              DAY)))                                                   as daysnum,
       sum(chargemoney)                                                                as charge_money,
       round(sum(chargeitemcount))                                                            as charge_itemcount,
       sum(chargecount)                                                                as charge_count,
       sum(if(date_format(regtime, '%Y%m') = date_format(dt, '%Y%m'), chargecount, 0)) as new_chargecount,
       sum(if(date_format(regtime, '%Y%m') = date_format(dt, '%Y%m'), chargemoney, 0)) as new_charge_money,
       sum(if(date_format(regtime, '%Y%m') = date_format(dt, '%Y%m'), chargeitemcount,
              0))                                                                      as new_charge_itemcount,
       now() as etl_time
from
    (
        select dt,Productid,corever,CurrentLanguage,CurrentLanguage2,appver,mt,ver,regcountry,
               ShopItem,SubpayType,chargemoney,chargeitemcount,chargecount,regtime
        from dws.dws_trade_user_shopitem_charge_ed
        where dt >= date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month)  and productid not in (7777, 8888)
        union all
        select dt,Product_id,corever,Current_Language,Current_Language2,null  as appver,mt,null as ver,reg_country,
               null  as ShopItem,Sub_pay_Type,charge_money,charge_itemcount,charge_count,reg_time
        from dws.dws_trade_short_viedo_payorder_ed
        where dt >= date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month)
        union all
        select  dt,Product_id,core,null as Current_Language,current_language2,null  as appver,mt,null as ver,
                reg_country,null  as ShopItem,null as Sub_pay_Type,charge_money,charge_itemcount,charge_count,cast(reg_date as datetime)
        from  dws.dws_trade_viedo_cn_payorder_ed
        where dt >= date_sub(DATE_TRUNC('MONTH', '${dt}'), interval 1 month) and  self_type = 0
    ) a
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;

-- SQL语句
commit;
