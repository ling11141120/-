insert into ads.ads_trade_user_type_pay_ltv_est_mid
with tmp as (
    -- 0-30天
    select generate_series as rn from table(generate_series(0, 30, 1))
),
rmt as (
    select
        dt, user_period, product_id, user_id, corever, mt, reg_country, country_level, current_language2, source,
        which_weeks, which_months,
        lead(dt, 1, '9999-12-31') over (partition by product_id, user_id order by dt, mt, corever) as end_day,
        count(1) over (partition by product_id, user_id) as num
    from (
        select
            dt, user_period, product_id, user_id, corever, mt, reg_country, country_level, current_language2, source,
            weekofyear(dt) as which_weeks, month(dt) as which_months,
            row_number() over (partition by dt, product_id, user_id order by mt, corever) as rn
        from dws.dws_srsv_wide_user_type_info_est_di
        where product_id != 6883 and dt >= date_sub('${dt}',interval 120 day) and dt <= '${dt}' and user_period = 3
        union all
        select
            stat_period, user_period, product_id, user_id, corever, mt, reg_country, country_level, current_language2, source,
            weekofyear(stat_period) as which_weeks, month(stat_period) as which_months,
            row_number() over (partition by stat_period, product_id, user_id order by mt, corever) as rn
        from dws.dws_wide_video_cn_user_type_info_est_ed
        where product_id = 6883 and period_types = 1 and stat_period >= date_sub('${dt}',interval 120 day) and stat_period <= '${dt}' and user_period = 3
    ) a where rn = 1
),
new as (
    select
        dt, user_period, product_id, user_id, corever, mt, reg_country, country_level, current_language2, source,
        weekofyear(dt) as which_weeks, month(dt) as which_months,
        lead(dt, 1, '9999-12-31') over (partition by product_id, user_id order by dt, mt, corever) as end_day,
        count(1) over (partition by product_id, user_id) as num
    from dws.dws_srsv_wide_user_type_info_est_di
    where product_id != 6883 and dt >= date_sub('${dt}',interval 120 day) and dt <= '${dt}' and user_period = 1
    union all
    select
        date(date_sub(a.create_time, interval 13 hour)) as dt, 1 as user_period, 6883 as product_id, account, if(a.corever2 != 0, a.corever2, 1) as corever,
        mt2, if(a.reg_country = '', 'unknown', a.reg_country) as reg_country, null as country_level, current_language2, 1 as source,
        weekofyear(date_sub(a.create_time, interval 13 hour)) as which_weeks, month(date_sub(a.create_time, interval 13 hour)) as which_months,
        lead(date_sub(a.create_time, interval 13 hour), 1, '9999-12-31') over (partition by account order by date_sub(a.create_time, interval 13 hour) ,mt2, if(a.corever2 != 0, a.corever2, 1)) as end_day,
        count(1) over (partition by account) num
    from dim.dim_video_cn_accountinfo_view a
    where date(date_sub(a.create_time, interval 13 hour)) >= date_sub('${dt}', interval 120 day) and date(date_sub(a.create_time, interval 13 hour)) <= '${dt}'
),
payorder as (
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.pay_type,
        sum(a.charge_money) as charge_money
    from (
        -- 海剧
        select
            a.dt, a.product_id, a.user_id, if(a.shop_item = 0, shop_item, ifnull(concat(a.shop_item, '_', ifnull(b.vip_type, 1)), 0)) as pay_type, a.charge_money
        from (
            select
                a.dt, a.product_id, a.user_id,
                SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(b.ExtInfo,'|',-1),'com.changdu.mobovideo.',-1),'com.changdu.moboshort.',-1),'com.changjian.moboshortcj.',-1),'third.',-1) as item_id,
                b.shop_item, a.base_amount as charge_money
            from (
                select
                    *
                from dwd.dwd_trade_sharpenginepaycenter_payorder_est_view
                where product_id = 6833 and test_flag = 0 and order_status = 1 and dt >= date_sub('${dt}', interval 120 day) and dt <= '${dt}'
            ) a
            left join (
                select
                    *
                from dwd.dwd_trade_short_video_payorder_view
                where product_id = 6833 and test_flag = 0 and status = 0 and dt >= date_sub('${dt}', interval 125 day) and dt <= date_add('${dt}', interval 5 day)
            ) b on a.product_id = b.product_id and a.user_id = b.user_id and a.order_serial_id = b.order_id
        ) a
        left join (
            select
                item_id, shop_item_id, vip_type
            from dim.dim_short_video_goods_view
            where shop_item_id in(840,810)
            and is_remove=0
            group by 1, 2, 3
        ) b
        on a.item_id = b.item_id and a.shop_item = b.shop_item_id
        union all
        -- 海阅
        select
            a.dt, a.Productid, a.UserId, if(a.ShopItem = 0, ShopItem, ifnull(concat(a.ShopItem, '_', ifnull(b.vip_type, 1)), 0)) as pay_type, a.charge_money
        from (
            select
                date(date_sub(CreateTime, interval 13 hour)) as dt, Productid, UserId,
                SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
                SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(
                SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'readerfr.',-1),'minireaderfr.',-1),
                'cdycnovelfr.',-1),'tcreader.',-1),'minireaderft.',-1),'minireaderen.',-1),'ereader.',-1),'readerpt.',-1),'novelpt.',-1) ,'spainreader.',-1),'noveltw.',-1),
                'novelen.',-1),'readerru.',-1),'minireaderes.',-1),'minireaderth.',-1),'readerid.',-1),'thai.',-1),
                'noveles.',-1),'novelru.',-1),'reader4.',-1),'novelth.',-1),'novelid.',-1),'readerja.',-1),'novelja.',-1) as item_id,
                ShopItem, abs(BaseAmount)/100 as charge_money
            from dwd.dwd_trade_user_payorder
            where date(date_sub(dt, interval 13 hour)) >= date_sub('${dt}', interval 120 day) and date(date_sub(dt, interval 13 hour)) <= '${dt}'
        ) a
        left join (
            select
                item_id,
                case when validity = 1 then 1 -- 月卡
                    when validity = 3 then 2 -- 季卡
                    when validity = 12 then 3 -- 年卡
                    when validity = 107 then 4 -- 周卡
                end as vip_type
            from dim.dim_trade_pay_item_info_view
            where merchandise_type in(800,810,830,840,850)
            and status = 1 and is_delete = 0
            group by 1, 2
        ) b on a.item_id = b.item_id
        union all
        -- 国剧
        select dt, Product_id, user_id, 0 as pay_type, charge_money_rmb
        from dws.dws_trade_viedo_cn_payorder_est_ed a
        where dt >= date_sub('${dt}',interval 120 day) and dt <= '${dt}' and self_type = 0
    ) a
    group by 1, 2, 3, 4
)
-- rmt ltv0 -> ltv30
select
    dt, user_period, product_id, user_id, pay_type, ifnull(rn, -99) as pay_days, which_weeks, which_months, corever, mt, reg_country, country_level, current_language2, source,
    if(pay_days = rn, chargemoney, 0) as amount,
    sum(if(pay_days = rn, chargemoney, 0)) over (partition by dt, user_period, product_id, user_id, pay_type, which_weeks, which_months, corever, mt, reg_country, country_level, current_language2, source order by rn) as ltv,
    now() as etl_time
from (
    select
        dt, user_period, product_id, user_id, pay_type, corever, mt, reg_country, country_level, current_language2, source, which_weeks, which_months, end_day, pay_days, chargemoney,
        lead(pay_days) over (partition by dt, user_period, product_id, user_id, pay_type, corever, mt, reg_country, country_level, current_language2, source, which_weeks, which_months order by pay_days) as lead_pay_days
    from (
        select
            a.dt, a.user_period, a.product_id, a.user_id, ifnull(b.pay_type, -1) as pay_type,
            a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
            a.which_weeks, a.which_months, a.end_day,
            datediff(b.dt, a.dt) as pay_days,
            sum(b.charge_money) as chargemoney
        from rmt a
        left join (
            select
                *
            from payorder
            where dt >= date_sub('${dt}', interval 30 day) and dt <= '${dt}'
        ) b
        on a.product_id = b.product_id and a.user_id = b.user_id and a.dt <= b.dt and a.dt >= date_sub(b.dt, interval 30 day) and b.dt < a.end_day
        where a.dt >= date_sub('${dt}', interval 30 day) and a.dt <= '${dt}'
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    ) a
) a
left join tmp b
on a.pay_days <= b.rn and datediff(a.end_day, a.dt) > rn and if(a.lead_pay_days is null, if(datediff('${dt}', a.dt) < 31, datediff('${dt}', a.dt) + 1, 31), a.lead_pay_days) > rn
union all
-- rmt ltv45 -> ltv120
select
    a.dt, a.user_period, a.product_id, a.user_id, a.pay_type, ifnull(a.pay_days, -99) as pay_days,
    a.which_weeks, a.which_months, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
    a.amount, a.ltv,
    now() as etl_time
from (
    select
        a.dt, a.user_period, a.product_id, a.user_id, a.pay_type, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
        a.which_weeks, a.which_months, split(b.unnest,'_')[1] pay_days, ifnull(c.charge_money, 0) as amount,split(b.unnest,'_')[2] as ltv
    from (
        select
            a.dt, a.user_period, a.product_id, a.user_id, ifnull(b.pay_type, -1) as pay_type, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
            a.which_weeks, a.which_months,
            split(concat_ws('$',
                concat_ws('_', 45, sum(if(datediff(b.dt, a.dt) <= 45, b.charge_money, 0))),
                concat_ws('_', 60, sum(if(datediff(b.dt, a.dt) <= 60, b.charge_money, 0))),
                concat_ws('_', 90, sum(if(datediff(b.dt, a.dt) <= 90, b.charge_money, 0))),
                concat_ws('_', 120, sum(if(datediff(b.dt, a.dt) <= 120, b.charge_money, 0)))),
            '$') as arr
        from rmt a
        left join payorder b
        on a.product_id = b.product_id and a.user_id = b.user_id and a.dt <= b.dt and a.dt >= date_sub(b.dt, interval 120 day) and b.dt < end_day
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
    ) a
    cross join unnest(arr) b
    left join payorder c
    on a.dt = c.dt and a.product_id = c.product_id and a.user_id = c.user_id and a.pay_type = c.pay_type
) a
-- 处理不超过end_day的逻辑
join rmt b on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id and a.pay_days < datediff(b.end_day, b.dt)
where a.pay_days <= datediff('${dt}', b.dt) -- 过滤时间还没到的pay_days
union all
-- 新用户 ltv0 -> ltv30
select
    dt, user_period, product_id, user_id, pay_type, ifnull(rn, -99) as pay_days, which_weeks, which_months, corever, mt, reg_country, country_level, current_language2, source,
    if(pay_days = rn, chargemoney, 0) as amount,
    sum(if(pay_days = rn, chargemoney, 0)) over (partition by dt, user_period, product_id, user_id, pay_type, which_weeks, which_months, corever, mt, reg_country, country_level, current_language2, source order by rn) as ltv,
    now() as etl_time
from (
    select
        dt, user_period, product_id, user_id, pay_type, corever, mt, reg_country, country_level, current_language2, source, which_weeks, which_months, end_day, pay_days, chargemoney,
        lead(pay_days) over (partition by dt, user_period, product_id, user_id, pay_type, corever, mt, reg_country, country_level, current_language2, source, which_weeks, which_months order by pay_days) as lead_pay_days
    from (
        select
            a.dt, a.user_period, a.product_id, a.user_id, ifnull(b.pay_type, -1) as pay_type,
            a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
            a.which_weeks, a.which_months, a.end_day,
            datediff(b.dt, a.dt) as pay_days,
            sum(b.charge_money) as chargemoney
        from new a
        left join (
            select
                *
            from payorder
            where dt >= date_sub('${dt}', interval 30 day) and dt <= '${dt}'
        ) b
        on a.product_id = b.product_id and a.user_id = b.user_id and a.dt <= b.dt and a.dt >= date_sub(b.dt, interval 30 day) and b.dt < end_day
        where a.dt >= date_sub('${dt}', interval 30 day) and a.dt <= '${dt}'
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    ) a
) a
left join tmp b
on a.pay_days <= b.rn and datediff(a.end_day, a.dt) > rn and if(a.lead_pay_days is null, if(datediff('${dt}', a.dt) < 31, datediff('${dt}', a.dt) + 1, 31), a.lead_pay_days) > rn
union all
-- 新用户 ltv45 -> ltv120
select
    a.dt, a.user_period, a.product_id, a.user_id, a.pay_type, ifnull(a.pay_days, -99) as pay_days,
    a.which_weeks, a.which_months, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
    a.amount, a.ltv,
    now() as etl_time
from (
    select
        a.dt, a.user_period, a.product_id, a.user_id, a.pay_type, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
        a.which_weeks, a.which_months, split(b.unnest,'_')[1] pay_days, ifnull(c.charge_money, 0) as amount,split(b.unnest,'_')[2] as ltv
    from (
        select
            a.dt, a.user_period, a.product_id, a.user_id, ifnull(b.pay_type, -1) as pay_type, a.corever, a.mt, a.reg_country, a.country_level, a.current_language2, a.source,
            a.which_weeks, a.which_months,
            split(concat_ws('$',
                concat_ws('_', 45, sum(if(datediff(b.dt, a.dt) <= 45, b.charge_money, 0))),
                concat_ws('_', 60, sum(if(datediff(b.dt, a.dt) <= 60, b.charge_money, 0))),
                concat_ws('_', 90, sum(if(datediff(b.dt, a.dt) <= 90, b.charge_money, 0))),
                concat_ws('_', 120, sum(if(datediff(b.dt, a.dt) <= 120, b.charge_money, 0)))),
            '$') as arr
        from new a
        left join payorder b
        on a.product_id = b.product_id and a.user_id = b.user_id and a.dt <= b.dt and a.dt >= date_sub(b.dt, interval 120 day) and b.dt < end_day
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
    ) a
    cross join unnest(arr) b
    left join payorder c
    on a.dt = c.dt and a.product_id = c.product_id and a.user_id = c.user_id and a.pay_type = c.pay_type
) a
-- 处理不超过end_day的逻辑
join new b on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id and a.pay_days < datediff(b.end_day, b.dt)
where a.pay_days <= datediff('${dt}', b.dt); -- 过滤时间还没到的pay_days