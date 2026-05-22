----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ad_time_partitioned_data
-- workflow_version : 17
-- create_user      : chenmo
-- task_name        : ads_ad_time_partitioned_data
-- task_version     : 13
-- update_time      : 2025-04-02 15:04:15
-- sql_path         : \starrocks\tbl_ads_ad_time_partitioned_data\ads_ad_time_partitioned_data
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_ad_time_partitioned_data
-- data1，广告组分时数据，历史指标，未来指标
    -- 维度：广告组、小时、媒体，花费、注册、点击、展示
    -- 需要针对，展示，花费，收入异常做剔除
        with z1 as (
        select
            a.ad_set_id
            ,a.product_id
            ,a.core
            ,a.source_chl
            ,date(a.create_time) dt
            ,hour(a.create_time) as hour
            ,a.create_time
            ,a.reg_num
            ,a.cost_amount
            ,a.h_d0_amt
            ,a.h_d0_payers
            ,coalesce(fb.impressions,tt.impressions) as impressions
            ,coalesce(if(a.source_chl='facebook',fb.clicks,fb.link_click),tt.clicks) as LinkClicks
        from (
            -- 广告组，小时，指标
            select ad_set_id
                ,product_id
                ,core
                ,source_chl
                ,create_time
                ,date(create_time) as dt
                ,sum(cost_amount) cost_amount
                ,sum(reg_num) reg_num
                ,sum(case when 23-create_hour=0 then hour0_amount
                    when 23-create_hour=1 then hour0_amount+hour1_amount
                    when 23-create_hour=2 then hour0_amount+hour1_amount+hour2_amount
                    when 23-create_hour=3 then hour0_amount+hour1_amount+hour2_amount+hour3_amount
                    when 23-create_hour=4 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount
                    when 23-create_hour=5 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount
                    when 23-create_hour=6 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount
                    when 23-create_hour=7 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount
                    when 23-create_hour=8 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount
                    when 23-create_hour=9 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount
                    when 23-create_hour=10 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount
                    when 23-create_hour=11 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount
                    when 23-create_hour=12 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount
                    when 23-create_hour=13 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount
                    when 23-create_hour=14 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount
                    when 23-create_hour=15 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount
                    when 23-create_hour=16 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount
                    when 23-create_hour=17 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount
                    when 23-create_hour=18 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount
                    when 23-create_hour=19 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount+hour19_amount
                    when 23-create_hour=20 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount+hour19_amount+hour20_amount
                    when 23-create_hour=21 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount+hour19_amount+hour20_amount+hour21_amount
                    when 23-create_hour=22 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount+hour19_amount+hour20_amount+hour21_amount+hour22_amount
                    when 23-create_hour=23 then hour0_amount+hour1_amount+hour2_amount+hour3_amount+hour4_amount+hour5_amount+hour6_amount+hour7_amount+hour8_amount+hour9_amount+hour10_amount+hour11_amount+hour12_amount+hour13_amount+hour14_amount+hour15_amount+hour16_amount+hour17_amount+hour18_amount+hour19_amount+hour20_amount+hour21_amount+hour22_amount+hour23_amount
                    else 0 end) as h_d0_amt
                ,sum(case when 23-create_hour=0 then hour0_first_pay_num
                    when 23-create_hour=1 then hour0_first_pay_num+hour1_first_pay_num
                    when 23-create_hour=2 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num
                    when 23-create_hour=3 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num
                    when 23-create_hour=4 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num
                    when 23-create_hour=5 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num
                    when 23-create_hour=6 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num
                    when 23-create_hour=7 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num
                    when 23-create_hour=8 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num
                    when 23-create_hour=9 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num
                    when 23-create_hour=10 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num
                    when 23-create_hour=11 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num
                    when 23-create_hour=12 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num
                    when 23-create_hour=13 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num
                    when 23-create_hour=14 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num
                    when 23-create_hour=15 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                    when 23-create_hour=16 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num+hour16_first_pay_num
                    when 23-create_hour=17 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num+hour16_first_pay_num+hour17_first_pay_num
                    when 23-create_hour=18 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num+hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num
                    when 23-create_hour=19 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                        +hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num+hour19_first_pay_num
                    when 23-create_hour=20 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                        +hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num+hour19_first_pay_num+hour20_first_pay_num
                    when 23-create_hour=21 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                        +hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num+hour19_first_pay_num+hour20_first_pay_num+hour21_first_pay_num
                    when 23-create_hour=22 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                        +hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num+hour19_first_pay_num+hour20_first_pay_num+hour21_first_pay_num+hour22_first_pay_num
                    when 23-create_hour=23 then hour0_first_pay_num+hour1_first_pay_num+hour2_first_pay_num+hour3_first_pay_num+hour4_first_pay_num+hour5_first_pay_num+hour6_first_pay_num+hour7_first_pay_num+hour8_first_pay_num+hour9_first_pay_num+hour10_first_pay_num+hour11_first_pay_num+hour12_first_pay_num+hour13_first_pay_num+hour14_first_pay_num+hour15_first_pay_num
                        +hour16_first_pay_num+hour17_first_pay_num+hour18_first_pay_num+hour19_first_pay_num+hour20_first_pay_num+hour21_first_pay_num+hour22_first_pay_num+hour23_first_pay_num
                    else 0 end) as h_d0_payers
            from ads.ads_fb_ad_roi_install_referrer_by_hour_time_zone
            where create_time >= days_add(curdate(),-440) and create_time < days_add(curdate(),-8)  and source_chl in ('fbs2s','facebook','tt')  and ifnull(ad_set_id ,'')<>''
            group by 1,2,3,4,5,6
        ) a
        -- fb展示，点击
        left join (
            select product_id
                ,adset_id
                ,date_start
                ,sum(impressions) impressions
                ,sum(link_click) link_click
                ,sum(clicks) as clicks
            from ads.ads_advertisement_fbaddailyinsightbyhour_view
            where date_start >= days_add(curdate(),-440) and date_start < days_add(curdate(),-8)
            group by 1,2,3
        ) fb on a.ad_set_id =fb.adset_id   and a.create_time=fb.date_start and a.product_id=fb.product_id
        -- tt展示，点击
        left join (
            select product_id
                ,ad_set_id
                ,date_start
                ,sum(impressions) impressions
                ,sum(clicks) clicks
            from ads.ads_advertisement_ltv_daily_insight_by_hour_view
            where date_start >= days_add(curdate(),-440) and date_start < days_add(curdate(),-8)
            group by 1,2,3
        ) tt on a.ad_set_id =tt.ad_set_id   and a.create_time=tt.date_start and a.product_id=tt.product_id
    )

     -- hn收入，hn付费人数
    , z1_1 as (
        select a.ad_set_id
            ,a.product_id
            ,a.core
            ,a.source_chl
            ,a.dt
            ,a.hour
            ,a.create_time
            ,a.reg_num
            ,a.cost_amount
            ,a.h_d0_amt
            ,a.h_d0_payers
            ,a.impressions
            ,a.LinkClicks
            ,sum(case when a.hour-create_hour=0  then h0amt
                    when a.hour-create_hour=1  then h0amt+h1amt
                    when a.hour-create_hour=2  then h0amt+h1amt+h2amt
                    when a.hour-create_hour=3  then h0amt+h1amt+h2amt+h3amt
                    when a.hour-create_hour=4  then h0amt+h1amt+h2amt+h3amt+h4amt
                    when a.hour-create_hour=5  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt
                    when a.hour-create_hour=6  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt
                    when a.hour-create_hour=7  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt
                    when a.hour-create_hour=8  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt
                    when a.hour-create_hour=9  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt
                    when a.hour-create_hour=10  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt
                    when a.hour-create_hour=11  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt
                    when a.hour-create_hour=12  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt
                    when a.hour-create_hour=13  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt
                    when a.hour-create_hour=14  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt
                    when a.hour-create_hour=15  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt
                    when a.hour-create_hour=16  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt
                    when a.hour-create_hour=17  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt
                    when a.hour-create_hour=18  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt
                    when a.hour-create_hour=19  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt+h19amt
                    when a.hour-create_hour=20  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt+h19amt+h20amt
                    when a.hour-create_hour=21  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt+h19amt+h20amt+h21amt
                    when a.hour-create_hour=22  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt+h19amt+h20amt+h21amt+h22amt
                    when a.hour-create_hour=23  then h0amt+h1amt+h2amt+h3amt+h4amt+h5amt+h6amt+h7amt+h8amt+h9amt+h10amt+h11amt+h12amt+h13amt+h14amt+h15amt+h16amt+h17amt+h18amt+h19amt+h20amt+h21amt+h22amt+h23amt
                    else 0 end
            ) hn_amt
            ,sum(case when a.hour-create_hour=0  then h0payers
                when a.hour-create_hour=1  then h0payers+h1payers
                when a.hour-create_hour=2  then h0payers+h1payers+h2payers
                when a.hour-create_hour=3  then h0payers+h1payers+h2payers+h3payers
                when a.hour-create_hour=4  then h0payers+h1payers+h2payers+h3payers+h4payers
                when a.hour-create_hour=5  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers
                when a.hour-create_hour=6  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers
                when a.hour-create_hour=7  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers
                when a.hour-create_hour=8  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers
                when a.hour-create_hour=9  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers
                when a.hour-create_hour=10  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers
                when a.hour-create_hour=11  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers
                when a.hour-create_hour=12  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers
                when a.hour-create_hour=13  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers
                when a.hour-create_hour=14  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers
                when a.hour-create_hour=15  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers
                when a.hour-create_hour=16  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers
                when a.hour-create_hour=17  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers
                when a.hour-create_hour=18  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers
                when a.hour-create_hour=19  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers+h19payers
                when a.hour-create_hour=20  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers+h19payers+h20payers
                when a.hour-create_hour=21  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers+h19payers+h20payers+h21payers
                when a.hour-create_hour=22  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers+h19payers+h20payers+h21payers+h22payers
                when a.hour-create_hour=23  then h0payers+h1payers+h2payers+h3payers+h4payers+h5payers+h6payers+h7payers+h8payers+h9payers+h10payers+h11payers+h12payers+h13payers+h14payers+h15payers+h16payers+h17payers+h18payers+h19payers+h20payers+h21payers+h22payers+h23payers
                else 0 end
            ) hn_payers
        from z1 a
        left join (
            select ad_set_id
                ,product_id
                ,core
                ,source_chl
                ,create_hour
                ,date(create_time) as dt
                ,sum(cost_amount) as cost_amount
                ,sum(reg_num) as  reg_num
                -- 收入
                    ,sum(hour0_amount) as h0amt
                    ,sum(hour1_amount) as h1amt
                    ,sum(hour2_amount) as h2amt
                    ,sum(hour3_amount) as h3amt
                    ,sum(hour4_amount) as h4amt
                    ,sum(hour5_amount) as h5amt
                    ,sum(hour6_amount) as h6amt
                    ,sum(hour7_amount) as h7amt
                    ,sum(hour8_amount) as h8amt
                    ,sum(hour9_amount) as h9amt
                    ,sum(hour10_amount) as h10amt
                    ,sum(hour11_amount) as h11amt
                    ,sum(hour12_amount) as h12amt
                    ,sum(hour13_amount) as h13amt
                    ,sum(hour14_amount) as h14amt
                    ,sum(hour15_amount) as h15amt
                    ,sum(hour16_amount) as h16amt
                    ,sum(hour17_amount) as h17amt
                    ,sum(hour18_amount) as h18amt
                    ,sum(hour19_amount) as h19amt
                    ,sum(hour20_amount) as h20amt
                    ,sum(hour21_amount) as h21amt
                    ,sum(hour22_amount) as h22amt
                    ,sum(hour23_amount) as h23amt
                -- 付费人数
                    ,sum(hour0_first_pay_num) as h0payers
                    ,sum(hour1_first_pay_num) as h1payers
                    ,sum(hour2_first_pay_num) as h2payers
                    ,sum(hour3_first_pay_num) as h3payers
                    ,sum(hour4_first_pay_num) as h4payers
                    ,sum(hour5_first_pay_num) as h5payers
                    ,sum(hour6_first_pay_num) as h6payers
                    ,sum(hour7_first_pay_num) as h7payers
                    ,sum(hour8_first_pay_num) as h8payers
                    ,sum(hour9_first_pay_num) as h9payers
                    ,sum(hour10_first_pay_num) as h10payers
                    ,sum(hour11_first_pay_num) as h11payers
                    ,sum(hour12_first_pay_num) as h12payers
                    ,sum(hour13_first_pay_num) as h13payers
                    ,sum(hour14_first_pay_num) as h14payers
                    ,sum(hour15_first_pay_num) as h15payers
                    ,sum(hour16_first_pay_num) as h16payers
                    ,sum(hour17_first_pay_num) as h17payers
                    ,sum(hour18_first_pay_num) as h18payers
                    ,sum(hour19_first_pay_num) as h19payers
                    ,sum(hour20_first_pay_num) as h20payers
                    ,sum(hour21_first_pay_num) as h21payers
                    ,sum(hour22_first_pay_num) as h22payers
                    ,sum(hour23_first_pay_num) as h23payers
            from ads.ads_fb_ad_roi_install_referrer_by_hour_time_zone
            where create_time >= days_add(curdate(),-440) and create_time < days_add(curdate(),-8)  and source_chl in ('fbs2s','facebook','tt')  and ifnull(ad_set_id ,'')<>''
            group by 1,2,3,4,5,6
        )  b on a.ad_set_id =b.ad_set_id and a.product_id=b.product_id and a.core=b.core and a.source_chl=b.source_chl and a.hour>=b.create_hour and a.dt=b.dt
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13
    )

    -- 维度：广告组，日，
            -- 广告组属性：书信息,投放天数dn,过滤日花费<5美金
    , z2 as (
        select a.*
            ,b.mt
            ,b.language
            ,b.book_id
            ,b.code
            ,row_number() over(partition by concat(a.ad_set_id,a.product_id,a.core,a.source_chl,b.mt) order by a.dt asc) as dn
        from (
            -- 广告组日维度
            select ad_set_id
                ,source_chl
                ,product_id
                ,case when product_id in (6833) then 2 else 1 end  as product
                ,core
                ,date(create_time) as dt
                ,sum(cost_amount) as cost
                ,sum(impressions) as impressions
                ,sum(link_clicks ) as link_clicks
                ,sum(reg_num)  as reg_num
                ,sum(day0_amount) as d0_amt
                ,sum(day0_first_pay_num) as payers_num
            from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view
            where  create_time >= days_add(curdate(),-440) and create_time < days_add(curdate(),-8)  and source_chl in ('fbs2s','facebook','tt')  and ifnull(ad_set_id ,'')<>''
            group by 1,2,3,4,5,6
        ) a
        -- bookid,时区，语言，代号
        join (
            select a.*
                ,coalesce(b.language,b2.languageid) as language
                ,coalesce(b.code,b2.book_code) as code
            from (
                select product_id
                    ,core
                    ,source_chl
                    ,ad_setid as ad_set_id
                    ,book_id
                    ,min(mt) as mt
                from ads.ads_advertisement_adbase_view
                where ifnull(book_id,0)>0 and create_time>=days_add(curdate(),-440) and source_chl in ('fbs2s','facebook','tt')
                group by 1,2,3,4,5
            ) a
            -- 剧信息
            left join (
                select series_id
                    ,language
                    ,source_series_code as code
                from dim.dim_sv_series_hi
                group by 1,2,3
            ) b on a.book_id=b.series_id and a.product_id=6833
            -- 书信息
            -- 海阅：代号和投放语言
            left join (
                select book_id
                    ,site_id2
                    ,book_code
                    ,languageid
                from dim.dim_shuangwen_book_read_consume_info
                group by 1,2,3,4
            ) b2 on a.book_id=b2.book_id and a.product_id<>6833
        ) b on a.ad_set_id =b.ad_set_id and a.product_id=b.product_id and a.core=b.core and a.source_chl=b.source_chl
        where a.cost>5
    )

    -- 维度：广告组，日，
            -- 初始预算，最新标准
    , z3 as (
        select a.*
            ,b.first_budget    -- 初始预算
            ,case when a.product_id=6833 then coalesce(r.r0_std,put.r0_std) else coalesce(r2.r0_std,put2.r0_std) end as d0_std
            ,if(dayofweek(a.dt)=1,7,dayofweek(a.dt)-1) as week_day
        from z2 a
        -- 初始预算
        left join (
            select *
            from ads.ads_ad_set_daily_budget_view
            where create_time >= days_add(curdate(),-440)
        ) b on a.ad_set_id =b.ad_setid  and a.source_chl=b.source_chl and a.dt=b.date_key
        -- 分剧标准
        left join  (
            select date_key
                ,video_id
                ,mt
                ,source_chl
                ,r0_std
            from dim.dim_sv_videoroistdcfgdaily_view
            where date_key=days_add(curdate(),-1)
        ) r on a.source_chl=r.source_chl  and a.book_id=r.video_id and a.product_id=6833 and a.mt=r.mt
        -- 海剧大盘标
        left join (
            select date_key
                ,current_language2
                ,source_chl
                ,mt
                ,r0_std
            from dwd.dwd_sv_ad_put_product_video_roi_stdCfg_daily_view
            where date_key=days_add(curdate(),-1)
        ) put on a.language=put.current_language2  and a.source_chl=put.source_chl   and a.product_id=6833 and a.mt=put.mt
        -- 书籍标准
        left join (
            select book_id
                ,date_key
                ,mt
                ,r0_std
            from dwd.dwd_advertisement_book_roi_stdcfg_daily_view
            where date_key=days_add(curdate(),-1)
        ) r2 on a.book_id=r2.book_id  and a.product_id<>6833 and a.mt=r2.mt
        -- 阅读大盘标准
        left join (
            select current_language2
                ,date_key
                ,mt
                ,r0_std
            from dwd.dwd_advertisement_put_product_stdcfg_daily_view
            where  book_channel =1 and date_key=days_add(curdate(),-1)
        ) put2 on a.language=put2.current_language2  and a.product_id<>6833 and a.mt=put2.mt
    )

    -- 大盘老组达标率
    , z3_1 as (
        select *
            ,ifnull(least(1,greatest(d0_amt_sum/amt_std_sum,0.9)),1) as r0_sum
        from (
            select *
                ,sum(d0_amt) over(partition by concat(product,language,source_chl2,week_day) order by dt rows between 7 preceding and 7 following)  as d0_amt_sum
                ,sum(amt_std) over(partition by concat(product,language,source_chl2,week_day) order by dt rows between 7 preceding and 7 following) as amt_std_sum
            from (
                select product
                    ,language
                    ,if(source_chl='tt',2,1) as source_chl2
                    ,week_day
                    ,dt
                    ,sum(d0_amt) as d0_amt
                    ,sum(d0_std*cost) as amt_std
                from z3
                where dn>1
                group by 1,2,3,4,5
            ) x
        ) x
    )

    -- 维度：广告组，日
        -- 历史指标，当日指标，未来指标
    , z4 as (
        select a.ad_set_id
            ,a.source_chl
            ,a.product_id
            ,a.core
            ,a.product
            ,a.language
            ,a.book_id
            ,a.code
            ,a.dn
            ,a.first_budget
            ,a.mt
            ,a.dt
            ,a.week_day
            -- 当日指标
            ,a.cost as d0_cost
            ,a.impressions as d0_impressions
            ,a.link_clicks as d0_link_clicks
            ,a.reg_num as d0_regnum
            ,a.payers_num as d0_payers_num
            ,a.d0_amt as d0_amt
            ,a.d0_std as d0_std
            -- 历史指标bf-1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.cost end) as cost_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.impressions end) as impressions_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.link_clicks end) as link_clicks_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.reg_num end) as reg_num_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.payers_num end) as payers_num_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.d0_amt end) as d0_amt_bf1
            ,sum(case when days_diff(a.dt,b.dt)=1 then b.d0_std*b.cost end) as amt_std_bf1
            -- 历史指标bf-2~n
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.cost end) as cost_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.impressions end) as impressions_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.link_clicks end) as link_clicks_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.reg_num end) as reg_num_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.payers_num end) as payers_num_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.d0_amt end) as d0_amt_bf2_pow
            ,sum(case when days_diff(a.dt,b.dt)>1 then pow(0.6,days_diff(a.dt,b.dt)-1)*b.d0_std*b.cost end) as amt_std_bf2_pow
            -- 验证效果
            -- T+1
            ,sum(case when days_diff(a.dt,b.dt)=-1 then b.cost end) as cost_af1
            ,sum(case when days_diff(a.dt,b.dt)=-1 then b.reg_num end) as reg_num_af1
            ,sum(case when days_diff(a.dt,b.dt)=-1 then b.d0_amt end) as d0_amt_af1
            ,sum(case when days_diff(a.dt,b.dt)=-1 then b.d0_amt/c.r0_sum end) as d0_amt_af1_sum
            ,sum(case when days_diff(a.dt,b.dt)=-1 then b.d0_std*b.cost end) as amt_std_af1
            -- T+2
            ,sum(case when days_diff(a.dt,b.dt)=-2 then b.cost end) as cost_af2
            ,sum(case when days_diff(a.dt,b.dt)=-2 then b.reg_num end) as reg_num_af2
            ,sum(case when days_diff(a.dt,b.dt)=-2 then b.d0_amt end) as d0_amt_af2
            ,sum(case when days_diff(a.dt,b.dt)=-2 then b.d0_amt/c.r0_sum end) as d0_amt_af2_sum
            ,sum(case when days_diff(a.dt,b.dt)=-2 then b.d0_std*b.cost end) as amt_std_af2
            -- T+3
            ,sum(case when days_diff(a.dt,b.dt)=-3 then b.cost end) as cost_af3
            ,sum(case when days_diff(a.dt,b.dt)=-3 then b.reg_num end) as reg_num_af3
            ,sum(case when days_diff(a.dt,b.dt)=-3 then b.d0_amt end) as d0_amt_af3
            ,sum(case when days_diff(a.dt,b.dt)=-3 then b.d0_amt/c.r0_sum end) as d0_amt_af3_sum
            ,sum(case when days_diff(a.dt,b.dt)=-3 then b.d0_std*b.cost end) as amt_std_af3
            -- 未来7天
            ,sum(case when days_diff(a.dt,b.dt)>=-7 and a.dt<b.dt then b.cost end) as cost_af7d
            ,sum(case when days_diff(a.dt,b.dt)>=-7 and a.dt<b.dt then b.reg_num end) as reg_num_af7d
            ,sum(case when days_diff(a.dt,b.dt)>=-7 and a.dt<b.dt then b.d0_amt end) as d0_amt_af7d
            ,sum(case when days_diff(a.dt,b.dt)>=-7 and a.dt<b.dt then b.d0_amt/c.r0_sum end) as d0_amt_af7d_sum
            ,sum(case when days_diff(a.dt,b.dt)>=-7 and a.dt<b.dt then b.d0_std*b.cost end) as amt_std_af7d
        from z3 a
        -- 天级数据
        left join (
            select *
            from z3
        ) b on a.ad_set_id=b.ad_set_id and a.product_id=b.product_id and a.core=b.core and a.source_chl=b.source_chl and a.mt=b.mt
        -- 老组同期大盘达标率
        left join z3_1 c on a.product=c.product and a.language=c.language and if(a.source_chl='tt',2,1)=c.source_chl2 and a.dt=c.dt
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    )

    -- 维度: 广告组，小时，分时 ，日属性和指标
    , z5 as (
        select a.*
            ,b.func
            ,greatest(hn_ir*100/(case when b.func='线性' then b.a*if(hn_cpm>=ifnull(cpm_limit,999999),cpm_limit,if(hn_cpm<=ifnull(x_start,0),1,hn_cpm-ifnull(x_start,0))) + b
                    when b.func='指数' then b.a*exp(b*if(hn_cpm>=ifnull(cpm_limit,999999),cpm_limit,if(hn_cpm<=ifnull(x_start,0),1,hn_cpm-ifnull(x_start,0))))
                    when b.func='幂' then b.a*pow(if(hn_cpm>=ifnull(cpm_limit,999999),cpm_limit,if(hn_cpm<=ifnull(x_start,0),1,hn_cpm-ifnull(x_start,0))),b)
                    else null end)
                    ,0) as ir_rate -- 不同cpm下的IR达标率
        from (
            select a.ad_set_id
                ,a.source_chl
                ,a.product_id
                ,a.core
                ,a.product
                ,a.language
                ,a.book_id
                ,a.code
                ,a.dn
                ,a.first_budget
                ,a.mt
                ,a.dt
            -- 天级明细数据
                ,a.d0_cost
                ,a.d0_impressions
                ,a.d0_link_clicks
                ,a.d0_regnum
                ,a.d0_payers_num
                ,a.d0_amt
                ,a.d0_std
                ,a.cost_bf1
                ,a.impressions_bf1
                ,a.link_clicks_bf1
                ,a.reg_num_bf1
                ,a.payers_num_bf1
                ,a.d0_amt_bf1
                ,a.amt_std_bf1
                ,a.cost_bf2_pow
                ,a.impressions_bf2_pow
                ,a.link_clicks_bf2_pow
                ,a.reg_num_bf2_pow
                ,a.payers_num_bf2_pow
                ,a.d0_amt_bf2_pow
                ,a.amt_std_bf2_pow
                ,a.cost_af1
                ,a.reg_num_af1
                ,a.d0_amt_af1
                ,a.d0_amt_af1_sum
                ,a.amt_std_af1
                ,a.cost_af2
                ,a.reg_num_af2
                ,a.d0_amt_af2
                ,a.d0_amt_af2_sum
                ,a.amt_std_af2
                ,a.cost_af3
                ,a.reg_num_af3
                ,a.d0_amt_af3
                ,a.d0_amt_af3_sum
                ,a.amt_std_af3
                ,a.cost_af7d
                ,a.reg_num_af7d
                ,a.d0_amt_af7d
                ,a.d0_amt_af7d_sum
                ,a.amt_std_af7d
            -- 小时级明细
                ,a.create_time
                ,a.hour
                ,a.hours_spend
                ,a.cost_amount
                ,a.reg_num
                ,a.h_d0_amt
                ,a.h_d0_payers
                ,a.impressions
                ,a.LinkClicks
                ,a.hn_cost
                ,a.hn_regnum
                ,a.hn_amount
                ,a.hn_payers
                ,a.hn_impressions
                ,a.hn_LinkClicks
                ,a.hn_d0_amt
                ,a.hn_d0_payers
            -- 预处理指标 for 规则判断
                ,a.week_day
                ,hn_cost/first_budget as spend_prop             -- 实时花费/初始预算
                ,hn_amount/hn_cost/d0_std as hn_R0                    -- 实时达标率
                ,ifnull(hn_cost/hn_payers,9999) as  hn_CAC  -- 实时CAC
                ,hn_regnum/hn_impressions as hn_ir              -- 实时ir
                ,hn_cost/hn_impressions*1000 as hn_cpm          -- 实时cpm
                ,d0_amt_bf1/amt_std_bf1 as R0_bf1  -- 昨日达标率
                ,d0_amt_bf2_pow/amt_std_bf2_pow  as R0_bf2_n -- 前日之前总达标率
            from (
                select a.*
                    ,b.hour
                    ,b.create_time
                    ,b.cost_amount
                    ,b.reg_num
                    ,b.h_d0_amt
                    ,b.h_d0_payers
                    ,b.impressions
                    ,b.LinkClicks
                    ,b.hour - min(case when b.cost_amount>0 then b.hour end) over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt))  as hours_spend
                    ,sum(b.cost_amount) over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_cost
                    ,sum(b.reg_num)     over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_regnum
                    ,hn_amt as hn_amount
                    ,hn_payers
                    ,sum(b.impressions) over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_impressions
                    ,sum(b.LinkClicks)  over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_LinkClicks
                    ,sum(b.h_d0_amt)    over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_d0_amt
                    ,sum(b.h_d0_payers)  over(partition by concat(b.ad_set_id,b.product_id,b.core,b.source_chl,b.dt) order by b.hour rows between unbounded preceding  and CURRENT ROW) as hn_d0_payers
                from z4 a
                join z1_1 b on a.ad_set_id=b.ad_set_id and a.product_id=b.product_id and a.core=b.core and a.source_chl=b.source_chl  and a.dt=b.dt
            ) a
            where ifnull(a.hours_spend,-99)>=0 and a.d0_std is not null
        ) a
        -- ir和cpm关系表
        left join ads.ads_srsv_cpm_ir_conversion_formula_parameter b  on a.product=b.project_code  and a.language=b.language_id  and a.source_chl=b.source and if(a.mt=0,4,a.mt)=b.mt
    )

    select dt,
           ad_set_id,
           source_chl,
           product_id,
           core,
           create_time,
           product,
           language,
           book_id,
           code,
           dn,
           first_budget,
           mt,
           d0_cost,
           d0_impressions,
           d0_link_clicks,
           d0_regnum,
           d0_payers_num,
           d0_amt,
           d0_std,
           cost_bf1,
           impressions_bf1,
           link_clicks_bf1,
           reg_num_bf1,
           payers_num_bf1,
           d0_amt_bf1,
           amt_std_bf1,
           cost_bf2_pow,
           impressions_bf2_pow,
           link_clicks_bf2_pow,
           reg_num_bf2_pow,
           payers_num_bf2_pow,
           d0_amt_bf2_pow,
           amt_std_bf2_pow,
           cost_af1,
           reg_num_af1,
           d0_amt_af1,
           d0_amt_af1_sum,
           amt_std_af1,
           cost_af2,
           reg_num_af2,
           d0_amt_af2,
           d0_amt_af2_sum,
           amt_std_af2,
           cost_af3,
           reg_num_af3,
           d0_amt_af3,
           d0_amt_af3_sum,
           amt_std_af3,
           cost_af7d,
           reg_num_af7d,
           d0_amt_af7d,
           d0_amt_af7d_sum,
           amt_std_af7d,
           hour,
           hours_spend,
           cost_amount,
           reg_num,
           impressions,
           LinkClicks,
           hn_cost,
           hn_regnum,
           hn_amount,
           hn_payers,
           hn_impressions,
           hn_LinkClicks,
           week_day,
           spend_prop,
           hn_R0,
           hn_CAC,
           hn_ir,
           hn_cpm,
           R0_bf1,
           R0_bf2_n,
           func,
           ir_rate,
           h_d0_amt, -- 新
           h_d0_payers, -- 新
           hn_d0_amt, -- 新
           hn_d0_payers, -- 新
           now() as etl_time
from z5
    where dt >= days_add('${bf_1_dt}',-60);
