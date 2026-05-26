----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_bi_video_watch_retention_stat
-- workflow_version : 21
-- create_user      : zhengtt
-- task_name        : ads_video_video_watch_retention_stat
-- task_version     : 10
-- update_time      : 2024-12-04 18:11:22
-- sql_path         : \starrocks\sch_ads_bi_video_watch_retention_stat\ads_video_video_watch_retention_stat
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_bi_video_watch_retention_stat
select  a.dt as dt,cast(a.dt as string) as dt_string,a.ad_id as ad_id,a.tv_id as tv_id,a.tv_name as tv_name,
        count(distinct a.user_id) as day_0_num,
        count(distinct if(series = 1,a.user_id,null)) as series_1_retention,
        count(distinct if(series = 2,a.user_id,null)) as series_2_retention,
        count(distinct if(series = 3,a.user_id,null)) as series_3_retention,
        count(distinct if(series = 4,a.user_id,null)) as series_4_retention,
        count(distinct if(series = 5,a.user_id,null)) as series_5_retention,
        count(distinct if(series = 6,a.user_id,null)) as series_6_retention,
        count(distinct if(series = 7,a.user_id,null)) as series_7_retention,
        count(distinct if(series = 8,a.user_id,null)) as series_8_retention,
        count(distinct if(series = 9,a.user_id,null)) as series_9_retention,
        count(distinct if(series = 10,a.user_id,null)) as series_10_retention,
        count(distinct if(series = 11,a.user_id,null)) as series_11_retention,
        count(distinct if(series = 12,a.user_id,null)) as series_12_retention,
        count(distinct if(series = 13,a.user_id,null)) as series_13_retention,
        count(distinct if(series = 14,a.user_id,null)) as series_14_retention,
        count(distinct if(series = 15,a.user_id,null)) as series_15_retention,
        count(distinct if(series = 16,a.user_id,null)) as series_16_retention,
        count(distinct if(series = 17,a.user_id,null)) as series_17_retention,
        count(distinct if(series = 18,a.user_id,null)) as series_18_retention,
        count(distinct if(series = 19,a.user_id,null)) as series_19_retention,
        count(distinct if(series = 20,a.user_id,null)) as series_20_retention,
        count(distinct if(series = 21,a.user_id,null)) as series_21_retention,
        count(distinct if(series = 22,a.user_id,null)) as series_22_retention,
        count(distinct if(series = 23,a.user_id,null)) as series_23_retention,
        count(distinct if(series = 24,a.user_id,null)) as series_24_retention,
        count(distinct if(series = 25,a.user_id,null)) as series_25_retention,
        count(distinct if(series = 26,a.user_id,null)) as series_26_retention,
        count(distinct if(series = 27,a.user_id,null)) as series_27_retention,
        count(distinct if(series = 28,a.user_id,null)) as series_28_retention,
        count(distinct if(series = 29,a.user_id,null)) as series_29_retention,
        count(distinct if(series = 30,a.user_id,null)) as series_30_retention,
        count(distinct if(series = 35,a.user_id,null)) as series_35_retention,
        count(distinct if(series = 40,a.user_id,null)) as series_40_retention,
        count(distinct if(series = 45,a.user_id,null)) as series_45_retention,
        count(distinct if(series = 50,a.user_id,null)) as series_50_retention,
        count(distinct if(series = 55,a.user_id,null)) as series_55_retention,
        count(distinct if(series = 60,a.user_id,null)) as series_60_retention,
        count(distinct if(series = 65,a.user_id,null)) as series_65_retention,
        count(distinct if(series = 70,a.user_id,null)) as series_70_retention,
        count(distinct if(series = 75,a.user_id,null)) as series_75_retention,
        count(distinct if(series = 80,a.user_id,null)) as series_80_retention,
        count(distinct if(series = 85,a.user_id,null)) as series_85_retention,
        count(distinct if(series = 90,a.user_id,null)) as series_90_retention,
        count(distinct if(series = 95,a.user_id,null)) as series_95_retention,
        count(distinct if(series = 100,a.user_id,null)) as series_100_retention,
        now() as etl_time
from
    (   select  a.dt as dt,a.Unique_CdReaderId as user_id,a.Ad_Id as ad_id,a.Remarketing_Time as remarketing_time,
                a.Next_Attribute_Time as next_attribute_time,a.Install_Date as install_date,
                b.tv_id as tv_id,b.tv_name as tv_name
        from
            (   select dt,Unique_CdReaderId,Ad_Id,Remarketing_Time,Next_Attribute_Time,Install_Date
                from dwd.dwd_user_install_info_ed_view
                where Product_Id = 6883 and Is_Remarketing = 0 and User_Id > 0 and dt >=  '${bf_1_dt}'
            ) a
                left join
            (   select ad_id,tv_id,tv_name
                from dwd.dwd_advertisement_adext_view
                where product_id = 6883 and tv_id is not null
            ) b
            on a.Ad_Id = b.ad_id
        where b.ad_id is not null
    ) a
        left join
    (   select  date(create_time) as dt,user_id,tv_id,series,create_time
        from
            (   select  user_id,tv_id,series,create_time,
                        row_number() over (partition by user_id,tv_id,series order by create_time) as rn
                from dwd.dwd_video_vedio_watch_cn_view
                where user_id is not null and user_id != '' and tv_id is not null and tv_id != ''
                  and date(create_time) >= '${bf_1_dt}'
            ) a
        where rn = 1
    ) b
    on a.user_id = b.user_id and a.tv_id = b.tv_id and a.dt = b.dt
where
-- b.create_time >= a.install_date
b.create_time >= minutes_sub(a.install_date,1)  -- 20241029  jcshen  修改
and b.create_time <= a.remarketing_time and b.create_time <= a.next_attribute_time
group by 1,2,3,4,5;
