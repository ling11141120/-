insert into ads.ads_bi_wide_user_retention_info
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where last_day_of_month >= date_sub('${bf_1_dt}', interval 31 day)
           and last_day_of_month <= '${bf_1_dt}'
           and period_types = 3
           and user_period in (1)
     and product_id in (3311,3322,3333,3366,3371,3388,3501,3511)
     )a
inner join (
    select dt, product_id, user_id
    from dws.dws_user_wide_active_ed
    where dt >= date_sub('${bf_1_dt}', interval 31 day)
      and dt <= '${bf_1_dt}'
     and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
          and b.dt >= a.last_day_of_month
          and b.dt <= DATE_ADD(a.last_day_of_month, interval 31 day)
          and a.product_id = b.product_id and a.user_id = b.user_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
union all
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where (last_day_of_month = date_sub('${bf_1_dt}', interval 60 day) and period_types = 3 and user_period in (1) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 90 day) and period_types = 3 and user_period in (1) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 120 day) and period_types = 3 and user_period in (1) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 150 day) and period_types = 3 and user_period in (1) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 180 day) and period_types = 3 and user_period in (1) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511))
     )a
inner join (
    select dt, product_id, user_id
    from dws.dws_user_wide_active_ed
    where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
)b on  (a.last_day_of_month = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
-- ????
union all
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where last_day_of_month >= date_sub('${bf_1_dt}', interval 31 day)
           and last_day_of_month <= '${bf_1_dt}'
           and period_types = 3
           and user_period in (2)
     and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
     )a
inner join (
    select dt, product_id, user_id
    from dws.dws_user_wide_active_ed
    where dt >= date_sub('${bf_1_dt}', interval 31 day)
      and dt <= '${bf_1_dt}'
     and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
          and b.dt >= a.last_day_of_month
          and b.dt <= DATE_ADD(a.last_day_of_month, interval 31 day)
          and a.product_id = b.product_id and a.user_id = b.user_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
union all
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where (last_day_of_month = date_sub('${bf_1_dt}', interval 60 day) and period_types = 3 and user_period in (2) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 90 day) and period_types = 3 and user_period in (2) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 120 day) and period_types = 3 and user_period in (2) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 150 day) and period_types = 3 and user_period in (2) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 180 day) and period_types = 3 and user_period in (2) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511))
     )a
inner join (
    select dt, product_id, user_id
    from dws.dws_user_wide_active_ed
    where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,1111)
)b on  (a.last_day_of_month = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id) or
       (a.last_day_of_month = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
-- rmt ??
union all
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where last_day_of_month >= date_sub('${bf_1_dt}', interval 31 day)
           and last_day_of_month <= '${bf_1_dt}'
           and period_types = 3
           and user_period in (3)
     and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
     )a
inner join (
    select dt, product_id, user_id,mt,corever
    from dws.dws_user_wide_active_ed
    where dt >= date_sub('${bf_1_dt}', interval 31 day)
      and dt <= '${bf_1_dt}'
     and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
)b on b.dt >= date_sub('${bf_1_dt}', interval 31 day)
          and b.dt >= a.last_day_of_month
          and b.dt <= DATE_ADD(a.last_day_of_month, interval 31 day)
          and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
union all
select md5(concat_ws('_',a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,DATEDIFF(b.dt, a.last_day_of_month))),
       a.stat_period,a.period_types,a.years,a.product_id,a.corever,a.mt,a.reg_country,a.country_level,a.current_language2,a.source,a.user_period,
       DATEDIFF(b.dt, a.last_day_of_month) as reg_days,
       count(distinct b.user_id)     as retention_num,-- ????
       now()                         as etl_time
from (
         select stat_period,period_types,years,product_id,user_id,corever,mt,reg_country,country_level,current_language2,source,user_period,last_day_of_month
         from dws.dws_wide_user_type_info_ed a
         where (last_day_of_month = date_sub('${bf_1_dt}', interval 60 day) and period_types = 3 and user_period in (3) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 90 day) and period_types = 3 and user_period in (3) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 120 day) and period_types = 3 and user_period in (3) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 150 day) and period_types = 3 and user_period in (3) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)) or
               (last_day_of_month = date_sub('${bf_1_dt}', interval 180 day) and period_types = 3 and user_period in (3) and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511))
     )a
inner join (
    select dt, product_id, user_id,mt,corever
    from dws.dws_user_wide_active_ed
    where dt = '${bf_1_dt}' and product_id   in (3311,3322,3333,3366,3371,3388,3501,3511)
)b on  (a.last_day_of_month = date_sub(b.dt, interval 60 day) and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever) or
       (a.last_day_of_month = date_sub(b.dt, interval 90 day) and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever) or
       (a.last_day_of_month = date_sub(b.dt, interval 120 day) and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever) or
       (a.last_day_of_month = date_sub(b.dt, interval 150 day) and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever) or
       (a.last_day_of_month = date_sub(b.dt, interval 180 day) and a.product_id = b.product_id and a.user_id = b.user_id and a.mt=b.mt and a.corever=b.corever)
group by 1, 2, 3,4,5,6,7,15,16,123123;