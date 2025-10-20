-- ----------------------昨天的脚本---------------------------------
insert into dws.dws_user_wide_active_period_ed
with active as (
    select a.dt, a.product_id, a.user_id, mt,
           case when a.reg_days=0 then 'D0'
                when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7'
                when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30'
                when a.reg_days>=31 and b.user_id is not null then 'D31+_stock_user'
                when a.reg_days>=31 and b.user_id is null then 'D31+_backflow_user'
                else 'D31+_backflow_user' end as user_type,
           if(b.user_id is not null,1,0) as is_l7_active
    from (
             select a.dt, a.product_id, a.user_id, a.mt,a.reg_country, reg_days
             from dws.dws_user_wide_active_ed a
             where dt = '${bf_1_dt}'
         )a left join (
        select product_id,user_id from dws.dws_user_wide_active_ed
        where dt>=date_sub('${bf_1_dt}',interval 7 day) and dt<'${bf_1_dt}'
        group by product_id, user_id
    )b on a.product_id=b.product_id and a.user_id=b.user_id
),rmt as (
    select Product_Id,User_Id,max(dt) as install_dt
    from dws.dws_srsv_wide_user_type_info_di
    where dt>=date_sub('${bf_1_dt}',interval 6 month ) and dt <='${bf_1_dt}'
      and user_period=3  and  product_id not in(6883,6833)
    group by 1,2
),
rmt_user_type as(
 select active.dt, active.product_id, active.user_id,active.mt,
        case when datediff(active.dt,rmt.install_dt)=0 then 'D0'
             when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7'
             when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30'
             when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+_stock_user'
             else 'D31+_backflow_user'
            end as user_type,
        if(rmt.user_id is not null,1,0) as is_rmt
 from active  left join rmt on active.product_id=rmt.Product_Id and active.user_id=rmt.User_Id
),

source_chl_tmp as (
    select
        product_id, user_id, source_chl
    from (
        select product_id,user_id,Source as source_chl,
            row_number() over (partition by product_id,user_id order by Create_Time desc) as rn
        from dwd.dwd_user_install_info_ed_view
        where product_id not in(6833)
    ) a where rn = 1
),

result_tmp AS (
select
    maintab.dt, maintab.product_id, maintab.user_id, 'ctt' as period_type, active.user_type, corever, maintab.mt, ver, current_language,
    current_language2, reg_country, country_level,
    appver, reg_time, reg_days, sex,
    is_pay,
    is_pay_current,

    now() as etl_time
from (select * from dws.dws_user_wide_active_ed where dt='${bf_1_dt}') maintab
         left join active on maintab.dt=active.dt and maintab.Product_id = active.product_id and maintab.user_id = active.user_id

union all

select
    maintab.dt, maintab.product_id, maintab.user_id, 'rmt' as period_type, rmt_user_type.user_type, corever, maintab.mt, ver, current_language,
    current_language2, reg_country, country_level,
    appver, reg_time, reg_days, sex,
    is_pay,
    is_pay_current,
    now() as etl_time
from (select * from dws.dws_user_wide_active_ed where dt='${bf_1_dt}') maintab
         left join rmt_user_type on maintab.dt=rmt_user_type.dt and maintab.product_id = rmt_user_type.Product_id and maintab.user_id = rmt_user_type.user_id
)

SELECT a.dt,
       a.product_id,
       a.user_id,
       a.period_type,
       a.user_type,
       a.corever,
       a.mt,
       a.ver,
       a.current_language,
       a.current_language2,
       b.source_chl AS source_chl,
       a.reg_country,
       a.country_level,
       a.appver,
       a.reg_time,
       a.reg_days,
       a.sex,
       a.is_pay,
       a.is_pay_current,
       c.user_ad_source,
	   c.UserAdSetSource as user_ad_set_source,
	   c.UserAdSetTime as user_ad_set_time,
       a.etl_time
FROM result_tmp a
LEFT JOIN source_chl_tmp b
ON a.product_id = b.product_id
AND a.user_id = b.user_id
left join dim.dim_user_other_info_view c
on a.product_id = c.product_id and a.user_id = c.id
;




-- ----------------------当天的脚本---------------------------------
insert into dws.dws_user_wide_active_period_ed
with active as (
    select a.dt, a.product_id, a.user_id, mt,
           case when a.reg_days=0 then 'D0'
                when a.reg_days>=1 and a.reg_days<=7 then 'D1-D7'
                when a.reg_days>=8 and a.reg_days<=30 then 'D8-D30'
                when a.reg_days>=31 and b.user_id is not null then 'D31+_stock_user'
                when a.reg_days>=31 and b.user_id is null then 'D31+_backflow_user'
                else 'D31+_backflow_user' end as user_type,
           if(b.user_id is not null,1,0) as is_l7_active
    from (
             select a.dt, a.product_id, a.user_id, a.mt,a.reg_country, reg_days
             from dws.dws_user_wide_active_ed a
             where dt = '${dt}'
         )a left join (
        select product_id,user_id from dws.dws_user_wide_active_ed
        where dt>=date_sub('${dt}',interval 7 day) and dt<'${dt}'
        group by product_id, user_id
    )b on a.product_id=b.product_id and a.user_id=b.user_id
),rmt as (
    select Product_Id,User_Id,max(dt) as install_dt
    from dws.dws_srsv_wide_user_type_info_di
    where dt>=date_sub('${dt}',interval 6 month ) and dt <='${dt}'
      and user_period=3  and  product_id not in(6883,6833)
    group by 1,2
),
rmt_user_type as(
 select active.dt, active.product_id, active.user_id,active.mt,
        case when datediff(active.dt,rmt.install_dt)=0 then 'D0'
             when datediff(active.dt,rmt.install_dt)>=1 and datediff(active.dt,rmt.install_dt)<=7 then 'D1-D7'
             when datediff(active.dt,rmt.install_dt)>=8 and datediff(active.dt,rmt.install_dt)<=30 then 'D8-D30'
             when datediff(active.dt,rmt.install_dt)>=31 and is_l7_active=1 then 'D31+_stock_user'
             else 'D31+_backflow_user'
            end as user_type,
        if(rmt.user_id is not null,1,0) as is_rmt
 from active  left join rmt on active.product_id=rmt.Product_Id and active.user_id=rmt.User_Id
),

source_chl_tmp as (
    select
        product_id, user_id, source_chl
    from (
        select product_id,user_id,Source as source_chl,
            row_number() over (partition by product_id,user_id order by Create_Time desc) as rn
        from dwd.dwd_user_install_info_ed_view
        where product_id not in(6833)
    ) a where rn = 1
),

result_tmp_today AS (
select
    maintab.dt, maintab.product_id, maintab.user_id, 'ctt' as period_type, active.user_type, corever, maintab.mt, ver, current_language,
    current_language2, reg_country, country_level,
    appver, reg_time, reg_days, sex,
    is_pay,
    is_pay_current,

    now() as etl_time
from (select * from dws.dws_user_wide_active_ed where dt='${dt}') maintab
         left join active on maintab.dt=active.dt and maintab.Product_id = active.product_id and maintab.user_id = active.user_id

union all

select
    maintab.dt, maintab.product_id, maintab.user_id, 'rmt' as period_type, rmt_user_type.user_type, corever, maintab.mt, ver, current_language,
    current_language2, reg_country, country_level,
    appver, reg_time, reg_days, sex,
    is_pay,
    is_pay_current,

    now() as etl_time
from (select * from dws.dws_user_wide_active_ed where dt='${dt}') maintab
         left join rmt_user_type on maintab.dt=rmt_user_type.dt and maintab.product_id = rmt_user_type.Product_id and maintab.user_id = rmt_user_type.user_id
)

SELECT a.dt,
        a.product_id,
        a.user_id,
        a.period_type,
        a.user_type,
        a.corever,
        a.mt,
        a.ver,
        a.current_language,
        a.current_language2,
        b.source_chl AS source_chl,
        a.reg_country,
        a.country_level,
        a.appver,
        a.reg_time,
        a.reg_days,
        a.sex,
        a.is_pay,
        a.is_pay_current,
        c.user_ad_source,
		c.UserAdSetSource as user_ad_set_source,
	    c.UserAdSetTime as user_ad_set_time,
        a.etl_time
FROM result_tmp_today a
LEFT JOIN source_chl_tmp b
       ON a.product_id = b.product_id
           AND a.user_id = b.user_id
left join dim.dim_user_other_info_view c
on a.product_id = c.product_id and a.user_id = c.id
;
