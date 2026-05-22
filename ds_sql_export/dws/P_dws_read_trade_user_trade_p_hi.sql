----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_trade_user_trade_p_hi
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : dws_read_trade_user_trade_p_hi
-- task_version     : 4
-- update_time      : 2024-06-03 11:12:58
-- sql_path         : \starrocks\tbl_dws_read_trade_user_trade_p_hi\dws_read_trade_user_trade_p_hi
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_trade_user_trade_p_hi

with dws_trade_user_recharge_temp as (
    select '${dt}' as dt,product_id,user_id, Firstchargeday,Firstchargemoney,Autoid
    from
        (
            select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid , row_number()  over(partition by product_id,user_id order by Autoid) as rn
            from (
                     select product_id,user_id,Firstchargeday,Firstchargemoney,Autoid  from dws.dws_trade_user_recharge_temp where dt=date(date_add('${dt}',interval -1 day ))
            union all
            select productid,userid,date(createtime) as  Firstchargeday,itemcount as Firstchargemoney,Autoid  from dwd.dwd_trade_user_payorder where dt='${dt}'
    ) a
    )  b where rn=1
)

select DATE_FORMAT (a.CreateTime, '%Y-%m-%d %H') AS dt_hour,
       a.productid,
       a.userid,
       b.corever,
       b.current_language,
       b.current_language2,
       b.appver,
       b.mt,
       b.ver,
       b.reg_country,
       b.create_time as regtime,
       a.ShopItem,
       a.packageid,
       a.SubpayType,
       c.Firstchargeday,
       c.Firstchargemoney,
       sum(CasE WHEN a.dt < '2021-02-01' AND a.systemtype IN ( 336617, 336651 ) AND a.itemcount > 0 THEN a.itemcount * 0.014
                WHEN a.dt < '2021-02-01' THEN a.itemcount
                ELSE a.baseamount/100 END ) as chargemoney,
       count(a.userid) as chargecount   ,
       sum(a.itemcount) chargeitemcount,
       now() as etl_time
from
    dwd.dwd_trade_user_payorder a
        left join
    dim.dim_user_account_info_view b
    on a.productid=b.product_id and a.userid=b.id
        left join
    dws_trade_user_recharge_temp c
    on a.productid=c.product_id and a.userid=c.user_id and c.dt ='${dt}'
where a.dt >='${dt}' and a.dt< date(date_add('${dt}',interval 1 day ))
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13,14,15,16
;
