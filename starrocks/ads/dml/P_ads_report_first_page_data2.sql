INSERT INTO ads.ads_report_first_page_data2
select a.dt as create_date ,
       a.DAU,
       a.`新增用户数`,
       b.`充值人数`,
       b.`充值金额`,
       b.`首充用户数`,
       NOW()
from
    (
        select dt,
               sum(DAU) DAU,
               sum(`新增用户数`) as `新增用户数`
        from(
                 select dt,
                        product_id,
                        count(distinct user_id) DAU ,
                        bitmap_union_count(if(user_types=0, user_id,null)) `新增用户数`
                 from ads.ads_report_user_dau_ed
                 where  dt>=date_sub(curdate(),interval 30 day)
                   and  product_id in (3366,3311,3322,3333,3371,3388,3399,3501,3511)
                 group by 1,2
             ) v
        group by 1
    ) a
left join (
            select dt,
                   sum(charge_num) `充值人数`,
                   sum(charge_money) `充值金额`,
                   sum(fisrt_charge_num) `首充用户数`
             from ads.ads_user_charge_1d
             where dt>=date_sub(curdate(),interval 30 day)
               and product_id in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
             group by 1
            ) b
on a.dt=b.dt