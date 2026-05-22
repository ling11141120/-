----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_wide_optimize
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : ads_bi_ad_new_user_value_ed_2
-- task_version     : 1
-- update_time      : 2025-06-16 18:49:28
-- sql_path         : \starrocks\sch_wide_optimize\ads_bi_ad_new_user_value_ed_2
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_ad_new_user_value_ed
with tmp as
    (   select  a.dt as dt,a.install_time as install_time,a.product_id as product_id,
                a.user_id as user_id,a.mt, a.ad_id as ad_id,ifnull(b.create_time,a.install_time) as create_time
        from
            (   select  date(hours_add(install_date,-13)) as dt,
            hours_add(install_date,-13) as install_time,
            product_id,
            user_id,
            mt,
            CASE WHEN (Ad_Id IS NULL OR Ad_Id ='')
    THEN concat('AdId=none|SourceChl=',  CASE WHEN Source is null OR Source = '' THEN 'none' ELSE Source END ,
    '|Mt=',concat(Mt,''),'|Core=',concat(Core,''),'|Chl2=',CASE WHEN Chl2 is null OR Chl2 = '' THEN 'none' ELSE Chl2 END,'|CurrentLanguage2=',
    concat(Current_Language2,''))
    ELSE Ad_Id END as ad_id,
                             row_number() over(partition by product_id,user_id,date(hours_add(install_date,-13)) order by
                                 case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords')
                                          then 3 when source in ('officialsite','(not set)') then 2 else 1 end desc,install_date) as rn
                     from dwd.dwd_user_install_info_ed_view
                     where   IsDelete = 0 and Is_Remarketing = 0 and User_Id > 0 and date(hours_add(install_date,-13)) >= date(date_sub(hours_add('${dt}',-13),interval 7 day))
                       and Product_Id in (3311,7757,3501,3366,3322,3399,6833,3511,3333,3371,8858,3388)
                 ) a
                     left join
                 (   select product_id,Id,hours_add(create_time,-13) as create_time from dim.dim_user_account_info_view
                     where product_id in (3311,7757,3501,3366,3322,3399,3511,3333,3371,8858,3388)
                     union
                     select  product_id,user_id,hours_add(create_tm,-13) as create_time
                     from dim.dim_short_video_account_device_info
                 ) b
                 on a.Product_Id = b.product_id and a.User_Id = b.Id
             where rn = 1
         )

select  c.dt as dt,c.product_id as product_id,md5(c.ad_id) as md5_ad_id,c.ad_id as ad_id,
        cast(c.dt as string) as install_date,
        reg_num,reg_num_new,
        CASE WHEN day0_amt_new is not null THEN day0_amt_new ELSE 0 END as day0_amt_new,
        CASE WHEN day1_amt_new is not null THEN day1_amt_new ELSE 0 END as day1_amt_new,
        CASE WHEN day2_amt_new is not null THEN day2_amt_new ELSE 0 END as day2_amt_new,
        CASE WHEN day3_amt_new is not null THEN day3_amt_new ELSE 0 END as day3_amt_new,
        CASE WHEN day4_amt_new is not null THEN day4_amt_new ELSE 0 END as day4_amt_new,
        CASE WHEN day5_amt_new is not null THEN day5_amt_new ELSE 0 END as day5_amt_new,
        CASE WHEN day6_amt_new is not null THEN day6_amt_new ELSE 0 END as day6_amt_new,
        CASE WHEN day7_amt_new is not null THEN day7_amt_new ELSE 0 END as day7_amt_new,

        CASE WHEN day0_amt is not null THEN day0_amt ELSE 0 END as day0_amt,
        CASE WHEN day1_amt is not null THEN day1_amt ELSE 0 END as day1_amt,
        CASE WHEN day2_amt is not null THEN day2_amt ELSE 0 END as day2_amt,
        CASE WHEN day3_amt is not null THEN day3_amt ELSE 0 END as day3_amt,
        CASE WHEN day4_amt is not null THEN day4_amt ELSE 0 END as day4_amt,
        CASE WHEN day5_amt is not null THEN day5_amt ELSE 0 END as day5_amt,
        CASE WHEN day6_amt is not null THEN day6_amt ELSE 0 END as day6_amt,
        CASE WHEN day7_amt is not null THEN day7_amt ELSE 0 END as day7_amt,
        CASE WHEN ios_day0_amt is not null THEN ios_day0_amt ELSE 0 END as ios_day0_amt,
        CASE WHEN ios_day0_amt_new is not null THEN ios_day0_amt_new ELSE 0 END as ios_day0_amt_new,
        CASE WHEN reg_num_ios is not null THEN reg_num_ios ELSE 0 END as reg_num_ios,
        CASE WHEN reg_num_new_ios is not null THEN reg_num_new_ios ELSE 0 END as reg_num_new_ios,
        now() as etl_time
from

    (   select  dt,ad_id,a.product_id as product_id,
                count(distinct a.Product_Id,a.User_Id) as reg_num,
                count(distinct if(hours_add(a.install_time,-1) <= a.create_time and hours_add(a.install_time,1) >= a.create_time ,concat(a.Product_Id,a.User_Id),null))
                    as reg_num_new,
                sum(if(dt = order_dt and hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time ,base_amount,0)) as day0_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 1 and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day1_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 2  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day2_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 3  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day3_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 4  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day4_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 5  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day5_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 6 and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day6_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 7  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day7_amt_new,

                sum(if(dt = order_dt,base_amount,0)) as day0_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 1,base_amount,0)) as day1_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 2,base_amount,0)) as day2_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 3,base_amount,0)) as day3_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 4,base_amount,0)) as day4_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 5,base_amount,0)) as day5_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 6,base_amount,0)) as day6_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 7,base_amount,0)) as day7_amt,
                sum(if(dt = order_dt and mt = 1,base_amount,0)) as ios_day0_amt,
                sum(if(dt = order_dt and mt = 1 and hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as ios_day0_amt_new,
                count(distinct if(mt = 1, concat(a.Product_Id,a.User_Id),null)) as reg_num_ios,
                count(distinct if(mt = 1 and hours_add(a.install_time,-1) <= a.create_time and hours_add(a.install_time,1) >= a.create_time ,concat(a.Product_Id,a.User_Id),null)) as reg_num_new_ios
        from
            (   select  dt,install_time,product_id,user_id,mt,ad_id,create_time
                from tmp
                --  where hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time
            ) a
                left join
            (   select date(hours_add(create_time,-13)) as order_dt,hours_add(create_time,-13) as order_create_time,product_id,user_id,base_amount  from dwd.dwd_trade_sharpenginepaycenter_payorder_view
        where product_id in (3311,7757,3501,3366,3322,3399,6833,3511,3333,3371,8858,3388) and coo_order_status = 1 AND test_flag = 0
          and date(hours_add(create_time,-13)) >= date(date_sub(hours_add('${dt}',-13),interval 7 day))
    ) b
    on a.product_id = b.product_id and a.user_id = b.user_id and a.install_time <= b.order_create_time

group by 1,2,3
    ) c;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_ad_new_user_value_ed
-- workflow_version : 29
-- create_user      : zhengtt
-- task_name        : ads_bi_ad_new_user_value_ed
-- task_version     : 16
-- update_time      : 2025-04-30 15:37:33
-- sql_path         : \starrocks\tbl_ads_bi_ad_new_user_value_ed\ads_bi_ad_new_user_value_ed
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_ad_new_user_value_ed
with tmp as
    (   select  a.dt as dt,a.install_time as install_time,a.product_id as product_id,
                a.user_id as user_id,a.mt, a.ad_id as ad_id,ifnull(b.create_time,a.install_time) as create_time
        from
            (   select  date(hours_add(install_date,-13)) as dt,
            hours_add(install_date,-13) as install_time,
            product_id,
            user_id,
            mt,
            CASE WHEN (Ad_Id IS NULL OR Ad_Id ='')
    THEN concat('AdId=none|SourceChl=',  CASE WHEN Source is null OR Source = '' THEN 'none' ELSE Source END ,
    '|Mt=',concat(Mt,''),'|Core=',concat(Core,''),'|Chl2=',CASE WHEN Chl2 is null OR Chl2 = '' THEN 'none' ELSE Chl2 END,'|CurrentLanguage2=',
    concat(Current_Language2,''))
    ELSE Ad_Id END as ad_id,
                             row_number() over(partition by product_id,user_id,date(hours_add(install_date,-13)) order by
                                 case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords')
                                          then 3 when source in ('officialsite','(not set)') then 2 else 1 end desc,install_date) as rn
                     from dwd.dwd_user_install_info_ed_view
                     where   IsDelete = 0 and Is_Remarketing = 0 and User_Id > 0 and date(hours_add(install_date,-13)) >= date(date_sub(hours_add('${dt}',-13),interval 7 day))
                       and Product_Id in (3311,7757,3501,3366,3322,3399,6833,3511,3333,3371,8858,3388)
                 ) a
                     left join
                 (   select product_id,Id,hours_add(create_time,-13) as create_time from dim.dim_user_account_info_view
                     where product_id in (3311,7757,3501,3366,3322,3399,3511,3333,3371,8858,3388)
                     union
                     select  product_id,user_id,hours_add(create_tm,-13) as create_time
                     from dim.dim_short_video_account_device_info
                 ) b
                 on a.Product_Id = b.product_id and a.User_Id = b.Id
             where rn = 1
         )

select  c.dt as dt,c.product_id as product_id,md5(c.ad_id) as md5_ad_id,c.ad_id as ad_id,
        cast(c.dt as string) as install_date,
        reg_num,reg_num_new,
        CASE WHEN day0_amt_new is not null THEN day0_amt_new ELSE 0 END as day0_amt_new,
        CASE WHEN day1_amt_new is not null THEN day1_amt_new ELSE 0 END as day1_amt_new,
        CASE WHEN day2_amt_new is not null THEN day2_amt_new ELSE 0 END as day2_amt_new,
        CASE WHEN day3_amt_new is not null THEN day3_amt_new ELSE 0 END as day3_amt_new,
        CASE WHEN day4_amt_new is not null THEN day4_amt_new ELSE 0 END as day4_amt_new,
        CASE WHEN day5_amt_new is not null THEN day5_amt_new ELSE 0 END as day5_amt_new,
        CASE WHEN day6_amt_new is not null THEN day6_amt_new ELSE 0 END as day6_amt_new,
        CASE WHEN day7_amt_new is not null THEN day7_amt_new ELSE 0 END as day7_amt_new,

        CASE WHEN day0_amt is not null THEN day0_amt ELSE 0 END as day0_amt,
        CASE WHEN day1_amt is not null THEN day1_amt ELSE 0 END as day1_amt,
        CASE WHEN day2_amt is not null THEN day2_amt ELSE 0 END as day2_amt,
        CASE WHEN day3_amt is not null THEN day3_amt ELSE 0 END as day3_amt,
        CASE WHEN day4_amt is not null THEN day4_amt ELSE 0 END as day4_amt,
        CASE WHEN day5_amt is not null THEN day5_amt ELSE 0 END as day5_amt,
        CASE WHEN day6_amt is not null THEN day6_amt ELSE 0 END as day6_amt,
        CASE WHEN day7_amt is not null THEN day7_amt ELSE 0 END as day7_amt,
        CASE WHEN ios_day0_amt is not null THEN ios_day0_amt ELSE 0 END as ios_day0_amt,
        CASE WHEN ios_day0_amt_new is not null THEN ios_day0_amt_new ELSE 0 END as ios_day0_amt_new,
        CASE WHEN reg_num_ios is not null THEN reg_num_ios ELSE 0 END as reg_num_ios,
        CASE WHEN reg_num_new_ios is not null THEN reg_num_new_ios ELSE 0 END as reg_num_new_ios,
        now() as etl_time
from

    (   select  dt,ad_id,a.product_id as product_id,
                count(distinct a.Product_Id,a.User_Id) as reg_num,
                count(distinct if(hours_add(a.install_time,-1) <= a.create_time and hours_add(a.install_time,1) >= a.create_time ,concat(a.Product_Id,a.User_Id),null))
                    as reg_num_new,
                sum(if(dt = order_dt and hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time ,base_amount,0)) as day0_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 1 and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day1_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 2  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day2_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 3  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day3_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 4  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day4_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 5  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day5_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 6 and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day6_amt_new,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 7  and  hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as day7_amt_new,

                sum(if(dt = order_dt,base_amount,0)) as day0_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 1,base_amount,0)) as day1_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 2,base_amount,0)) as day2_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 3,base_amount,0)) as day3_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 4,base_amount,0)) as day4_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 5,base_amount,0)) as day5_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 6,base_amount,0)) as day6_amt,
                sum(if(datediff(order_dt,dt) >= 0 and datediff(order_dt,dt) <= 7,base_amount,0)) as day7_amt,
                sum(if(dt = order_dt and mt = 1,base_amount,0)) as ios_day0_amt,
                sum(if(dt = order_dt and mt = 1 and hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time,base_amount,0)) as ios_day0_amt_new,
                count(distinct if(mt = 1, concat(a.Product_Id,a.User_Id),null)) as reg_num_ios,
                count(distinct if(mt = 1 and hours_add(a.install_time,-1) <= a.create_time and hours_add(a.install_time,1) >= a.create_time ,concat(a.Product_Id,a.User_Id),null)) as reg_num_new_ios
        from
            (   select  dt,install_time,product_id,user_id,mt,ad_id,create_time
                from tmp
                --  where hours_add(install_time,-1) <= create_time and hours_add(install_time,1) >= create_time
            ) a
                left join
            (   select date(hours_add(create_time,-13)) as order_dt,hours_add(create_time,-13) as order_create_time,product_id,user_id,base_amount  from dwd.dwd_trade_sharpenginepaycenter_payorder_view
        where product_id in (3311,7757,3501,3366,3322,3399,6833,3511,3333,3371,8858,3388) and coo_order_status = 1 AND test_flag = 0
          and date(hours_add(create_time,-13)) >= date(date_sub(hours_add('${dt}',-13),interval 7 day))
    ) b
    on a.product_id = b.product_id and a.user_id = b.user_id and a.install_time <= b.order_create_time

group by 1,2,3
    ) c;
