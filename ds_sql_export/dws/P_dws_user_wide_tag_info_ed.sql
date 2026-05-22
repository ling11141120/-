----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_srsv_wide_user_type_info_di
-- workflow_version : 54
-- create_user      : yanxh
-- task_name        : dws_user_wide_tag_info_ed
-- task_version     : 7
-- update_time      : 2025-04-11 20:32:10
-- sql_path         : \starrocks\tbl_dws_srsv_wide_user_type_info_di\dws_user_wide_tag_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_user_wide_tag_info_ed where dt = '${bf_1_dt}';

-- SQL语句
insert into dws.dws_user_wide_tag_info_ed
with recharge_mode as (
    select '${bf_1_dt}' as dt, ProductId as product_id, UserId as user_id, ItemCount as mode, num, createtime,
           case
                when itemcount>0 and itemcount<=5 then '单次0-5元用户'
                when itemcount>5 and itemcount<=10 then '单次5-10元用户'
                when itemcount>10 and itemcount<=20  then '单次10-20元用户'
                when itemcount>20 and itemcount<=30  then '单次20-30元用户'
                when itemcount>30 and itemcount<=50  then '单次30-50元用户'
                when itemcount>50 then '单次50元以上用户'
           end as user_value
    from (
             select ProductId, UserId, ItemCount, num, createtime,
                    row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rk
             from (
                      select ProductId, UserId, ItemCount, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt <= '${bf_1_dt}' and TestFlag = 0 group by 1, 2, 3
                  ) a
         ) b
    where rk = 1
),active as (
select a.dt, 1 as user_type,a.product_id, a.user_id,
       case when a.reg_days=0 then 'D0用户'
            when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7用户'
            when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30用户'
            when a.reg_days>=31 and b.user_id is not null then 'D31+存量用户'
            when a.reg_days>=31 and b.user_id is null then 'D31+回流用户'
       else 'D31+回流用户' end as user_period,
       c.source,
       if(b.user_id is not null,1,0) as is_l7_active
from (
         select dt, product_id, user_id,current_language2, reg_days
         from dws.dws_user_wide_active_ed
         where dt = '${bf_1_dt}'
     )a
    left join (
         select product_id,user_id from dws.dws_user_wide_active_ed
         where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${bf_1_dt}'
         group by product_id, user_id
    )b on a.product_id=b.product_id and a.user_id=b.user_id
    left join(
        select  dt,Product_Id,User_Id,max(source) as source
        from dws.dws_srsv_wide_user_type_info_di
        where   dt='${bf_1_dt}'
            and user_period=2
            and product_id not in(6883,6833)
        group by 1,2,3
    ) c on a.dt=c.dt and a.product_id=c.product_id and a.user_id=c.user_id
),rmt as (
    select Product_Id,User_Id,max(dt) as install_dt
    from dws.dws_srsv_wide_user_type_info_di
    where dt>=date_sub('${bf_1_dt}',interval 6 month ) and dt <='${bf_1_dt}'
          and user_period=3  and  product_id not in(6883,6833)
    group by 1,2
),rmt_up as(
    select active.dt, 2 as user_type,active.product_id, active.user_id,
           case when datediff(active.dt,rmt.install_dt)=0 then 'D0用户'
                when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7用户'
                when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30用户'
                when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+存量用户'
                else 'D31+回流用户'
           end as user_period,
           source,
           if(rmt.user_id is not null,1,0) as is_rmt
    from active  left join rmt on active.product_id=rmt.Product_Id and active.user_id=rmt.User_Id
)
select t1.dt,t1.user_type,t1.product_id,t1.user_id,t1.user_period,ifnull(recharge_mode.user_value,'无价值用户') as user_value,
       t1.source,now() as etl_time
from (
    select dt,user_type,product_id,user_id,user_period,source
    from active
    union all
    select dt,user_type,product_id,user_id,user_period,source
    from rmt_up
         )t1
left join recharge_mode on t1.dt=recharge_mode.dt and t1.product_id=recharge_mode.product_id and t1.user_id=recharge_mode.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_wide_tag_info_ed_history
-- workflow_version : 4
-- create_user      : linq
-- task_name        : dws_user_wide_tag_info_ed
-- task_version     : 3
-- update_time      : 2023-12-25 18:12:24
-- sql_path         : \starrocks\tbl_dws_user_wide_tag_info_ed_history\dws_user_wide_tag_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_user_wide_tag_info_ed where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_user_wide_tag_info_ed
with recharge_mode as (
    select '${bf_1_dt}' as dt, ProductId as product_id, UserId as user_id, ItemCount as mode, num, createtime,
           case
                when itemcount>0 and itemcount<=5 then '单次0-5元用户'
                when itemcount>5 and itemcount<=10 then '单次5-10元用户'
                when itemcount>10 and itemcount<=20  then '单次10-20元用户'
                when itemcount>20 and itemcount<=30  then '单次20-30元用户'
                when itemcount>30 and itemcount<=50  then '单次30-50元用户'
                when itemcount>50 then '单次50元以上用户'
           end as user_value
    from (
             select ProductId, UserId, ItemCount, num, createtime,
                    row_number() over (partition by ProductId,UserId order by num desc,createtime desc ) as rk
             from (
                      select ProductId, UserId, ItemCount, count(1) as num, max(CreateTime) as createtime
                      from dwd.dwd_trade_user_payorder
                      where dt <= '${bf_1_dt}' and TestFlag = 0 group by 1, 2, 3
                  ) a
         ) b
    where rk = 1
),active as (
select a.dt, 1 as user_type,a.product_id, a.user_id,
       case when a.reg_days=0 then 'D0用户'
            when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7用户'
            when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30用户'
            when a.reg_days>=31 and b.user_id is not null then 'D31+存量用户'
            when a.reg_days>=31 and b.user_id is null then 'D31+回流用户'
       else 'D31+回流用户' end as user_period,
       c.source,
       if(b.user_id is not null,1,0) as is_l7_active
from (
         select dt, product_id, user_id,current_language2, reg_days
         from dws.dws_user_wide_active_ed
         where dt = '${bf_1_dt}'
     )a
    left join (
         select product_id,user_id from dws.dws_user_wide_active_ed
         where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${bf_1_dt}'
         group by product_id, user_id
    )b on a.product_id=b.product_id and a.user_id=b.user_id
    left join(
        select stat_period as dt,Product_Id,User_Id,max(source) as source
        from dws.dws_wide_user_type_info_ed
        where user_period=2 and period_types=1 and stat_period='${bf_1_dt}'
            and product_id not in(6883,6833)
        group by 1,2,3
    ) c on a.dt=c.dt and a.product_id=c.product_id and a.user_id=c.user_id
),rmt as (
    select Product_Id,User_Id,max(stat_period) as install_dt
    from dws.dws_wide_user_type_info_ed
    where user_period=3 and period_types=1 and stat_period>=date_sub('${bf_1_dt}',interval 6 month ) and stat_period <='${bf_1_dt}'
          and product_id not in(6883,6833)
    group by 1,2
),rmt_up as(
    select active.dt, 2 as user_type,active.product_id, active.user_id,
           case when datediff(active.dt,rmt.install_dt)=0 then 'D0用户'
                when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7用户'
                when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30用户'
                when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+存量用户'
                else 'D31+回流用户'
           end as user_period,
           source,
           if(rmt.user_id is not null,1,0) as is_rmt
    from active  left join rmt on active.product_id=rmt.Product_Id and active.user_id=rmt.User_Id
)
select t1.dt,t1.user_type,t1.product_id,t1.user_id,t1.user_period,ifnull(recharge_mode.user_value,'无价值用户') as user_value,
       t1.source,now() as etl_time
from (
    select dt,user_type,product_id,user_id,user_period,source
    from active
    union all
    select dt,user_type,product_id,user_id,user_period,source
    from rmt_up
         )t1
left join recharge_mode on t1.dt=recharge_mode.dt and t1.product_id=recharge_mode.product_id and t1.user_id=recharge_mode.user_id;
