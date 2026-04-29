insert into ads.ads_bi_user_active_recharge_retentiom_stat_a
with tmp as (   select t.stat_period as dt,t.product_id as product_id,t.user_id as user_id,
                       if(p.user_id is not null,1,2) as user_type
                from
                    (   select dt as stat_period,product_id,user_id
                        from dws.dws_srsv_wide_user_type_info_di
                        where   dt >= date_sub('${dt}',interval 7 day) and dt  < '${dt}'
                        and product_id not in (6883,6833)
                        group by 1,2,3
                    ) t
                        left join
                    (   select  dt as stat_period,product_id,user_id
                        from dws.dws_srsv_wide_user_type_info_di where dt >= date_sub('${dt}',interval 7 day) and dt  < '${dt}' and user_period in (1,3)
                        and product_id not in (6883,6833)
                        group by 1,2,3
                    ) p
                    on t.stat_period = p.stat_period and t.product_id = p.product_id and t.user_id = p.user_id
                group by 1,2,3,4
)
SELECT	c.dt as dt,c.user_type as user_type,
          active_user_num,
          recharge_user_num,
          recharge_amt,
          retention_num_2,
          retention_num_7,
          now() as etl_time
from
    (	select 	tmp.dt as dt,tmp.user_type as user_type,
                   count(distinct tmp.product_id,tmp.user_id) as active_user_num,
                   count(distinct if(b.user_id is not null,concat(tmp.product_id,'-',tmp.user_id),null)) as recharge_user_num,
                   sum(pay_amt) as recharge_amt
         from tmp
                  left join
              (	  select dt,product_id,user_id,sum(ordinary_recharge_amt+vip_recharge_amt +sub_recharge_amt) as pay_amt
                   from ads.ads_wide_user_info_ed
                   where dt >= date_sub('${dt}',interval 7 day) and dt  < '${dt}'
                   and  (ordinary_recharge_amt is not null or vip_recharge_amt  is not null or sub_recharge_amt  is not null)
                   group by 1,2,3
              ) b
              on tmp.dt = b.dt and tmp.product_id = b.product_id and tmp.user_id = b.user_id
         group by 1,2
    ) c
        left join
    (	select 	a.dt as dt,a.user_type as user_type,count(distinct a.product_id,a.user_id) as retention_num_2
         from
             (	select dt,product_id,user_id,user_type,date_add(dt,interval 1 day) as dt_2t
                  from tmp
             ) a
                 left join tmp
                           on a.dt_2t = tmp.dt and a.product_id = tmp.product_id and a.user_id = tmp.user_id
         where  tmp.user_id is not null
         group by 1,2
    ) a
    on a.dt = c.dt and a.user_type = c.user_type
        left join
    (	select 	a.dt as dt,a.user_type as user_type,count(distinct a.product_id,a.user_id) as retention_num_7
         from
             (	select dt,product_id,user_id,user_type,date_add(dt,interval 6 day) as dt_7t
                  from tmp
             ) a
                 left join tmp
                           on a.dt_7t = tmp.dt and a.product_id = tmp.product_id and a.user_id = tmp.user_id
         where  tmp.user_id is not null
         group by 1,2
    ) b
    on c.dt = b.dt and c.user_type = b.user_type;
