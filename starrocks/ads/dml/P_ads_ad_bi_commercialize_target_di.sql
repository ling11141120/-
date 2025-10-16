-- 程序功能： 海阅、海剧广告商业化指标
-- 程序名： P_ads_ad_bi_commercialize_target_di
-- 目标表： ads.ads_ad_bi_commercialize_target_di
-- 负责人： xjc
-- 开版日期：
-- 版本号： v0.0.1

-- ========================= tbl_ads_ad_bi_commercialize_target_di_sr =======================================
-- -----------------------调度脚本，t+1----------------------------------------
-- ------------------------改用ads.ads_ad_bi_commercialize_target_di表------------------------------
-- ------------------------改用t+4清洗------------------------------
-- ========================241227加 ad_unlock_user_cnt 广告解锁人数字段,ad_all_user_cnt 全广告渗透用户=====================
insert into  ads.ads_ad_bi_commercialize_target_di
with z1 as (
    select t1.dt
          ,t1.core
          ,dau
          ,deu
          ,motivate_deu
      from (select dt
                  ,core
                  ,sum(dau)                        as dau
              from ads.ads_bi_read_adv_income_report_userdata_view
             where dt >= '${bf_4_dt}'
               and dt < '${dt}'
             group by 1,2
           )                                      as t1
      left join (select dt
                       ,core
                       ,count(distinct user_id)   as deu
                       ,count(distinct case  when b.ad_show_type_name = '激励视频' then user_id
                                        end)      as motivate_deu
                   from
                      (select dt
                             ,positions
                             ,user_id
                             ,core
                         from dws.dws_advertisement_user_position_amt_ed
                        where product_id not in (6833, 6883)
                          and dt >= '${bf_4_dt}'
                          and dt < '${dt}'
                      )                           as a
                   left join (select ad_position
                                    ,ad_show_type_name
                                from dim.dim_sr_ads_position_view
                             )                    as b
                     on a.positions = b.ad_position
                  group by 1,2
                )                                 as t2
        on t1.dt = t2.dt and t1.core = t2.core
)
,z2 as (
    select dt
          ,a.corever as core
          ,sum(ad_amt)                                                                 	    	as ad_amt_zs
          ,sum(case when ad_show_type_name = '激励视频' then impression_cnt end)       		 	as show_cnt_zs
          ,sum(case when ad_show_type_name = '激励视频' then click_cnt end)            		 	as click_cnt_zs
      from (select dt
                  ,corever
                  ,position_id
                  ,ad_amt
                  ,impression_cnt
                  ,click_cnt
              from ads.ads_bi_read_adv_income_report_advdata
             where product_id <> 6833
               and dt >= '${bf_4_dt}'
               and dt < '${dt}'
           )                                      as a
      left join (select ad_position
                       ,ad_show_type_name
                   from dim.dim_sr_ads_position_view
              ) b
        on a.position_id = b.ad_position
     group by 1,2
),z3 as (
    select dt
          ,b.core
          ,sum(cnt) show_cnt_yg
          ,count(distinct user_id) show_unt_yg
          ,sum(amt) ad_amt_yg
      from (select ad_position
              from dim.dim_sr_ads_position_view
             where ad_show_type_name = '激励视频'
           )            as a
      join (select dt
                 ,positions
                 ,user_id
                 ,cnt
                 ,amt
                 ,core
             from dws.dws_advertisement_user_position_amt_ed
            where product_id not in (6833, 6883)
              and dt >= '${bf_4_dt}'
              and dt < '${dt}'
           )            as b
        on a.ad_position = b.positions
    group by 1,2
)
-- 无用户id，无core维度，需要增加
,z4 as (
         select
             dt, sum(click_cnt) as click_cnt_sc, sum(watch_cnt) as watch_cnt_sc
         from
             (
                 select ad_position
                 from dim.dim_sr_ads_position_view
                 where ad_show_type_name = '激励视频'
             ) a
                 inner join (
                 select
                     dt, ad_position_id, click_cnt, watch_cnt
                 from dws.dws_advertisement_ad_position_play_data_ed
                 where dt >= '${bf_4_dt}' and dt < '${dt}'
             ) b on a.ad_position = b.ad_position_id
         group by 1
),z5 as (
-- 有用户id，无core维度，需要增加
         select date(a.unlock_time) as dt
              ,1 as project_type
              ,b.corever as core
              ,count(distinct a.pid) as ad_unlock_user_cnt
         from ads.ads_ad_unlock_chapter_detail_view as a
         left join dim.dim_user_account_info_view as b
           on a.pid = b.id
          and a.product_id=b.product_id
         where a.product_id not in (6833, 6883)
           and date(a.unlock_time) >= '${bf_4_dt}'  and date(a.unlock_time) < '${dt}'
         group by 1,2,3
),z6 as (
         select dt
                ,core
              ,case when product_id = 6833 then 2 else 1 end as project_type
              ,count(distinct user_id) as ad_all_user_cnt
         from (
                  select  dt
                       ,product_id
                       ,user_id
                        ,core
                  from dws.dws_advertisement_user_position_amt_ed

                  union all
-- 有用户，无core
                  select date(a.unlock_time) as dt
                       ,a.product_id
                       ,a.pid as user_id
                        ,b.corever as core
                  from ads.ads_ad_unlock_chapter_detail_view as a
                  left join dim.dim_user_account_info_view as b  -- id有重复现象，有潜在风险，待解决
                    on a.pid = b.id
                   and a.product_id=b.product_id
                  where a.lock_type=0
              ) a
         where dt >= '${bf_4_dt}' and dt < '${dt}'
           and product_id <> 6833
         group by 1,2,3
)
select
    z1.dt as dt,
    1 as project_type,
    concat(year(z1.dt), '-',week(date_sub(z1.dt, interval ((dayofweek(z1.dt) + 1) % 7) day) ) + 1,'(',date(date_sub(z1.dt, interval ((dayofweek(z1.dt) + 1) % 7) day)),'至',date(date_sub( z1.dt, interval ((dayofweek(z1.dt) + 1) % 7 - 6) day )),')') as week,
    concat(year(z1.dt), 'q',quarter(z1.dt)) as quarter,
    ifnull(dau,0) as dau,
    ifnull(deu,0) as deu,
    ifnull(motivate_deu,0) as motive_deu,
    ifnull(round(ad_amt_zs,2),0) as ad_amt_zs,
    ifnull(click_cnt_zs,0) as click_cnt_zs,
    ifnull(show_cnt_zs,0) as show_cnt_zs,
    ifnull(round(ad_amt_yg,2),0) as ad_amt_yg,
    ifnull(show_cnt_yg,0) as show_cnt_yg,
    ifnull(show_unt_yg,0) as show_unt_yg,
    ifnull(watch_cnt_sc,0) as watch_cnt_sc,
    ifnull(click_cnt_sc,0) as click_cnt_sc,
    ifnull(z5.ad_unlock_user_cnt,0) as ad_unlock_user_cnt,
    ifnull(z6.ad_all_user_cnt,0) as ad_all_user_cnt,
    null as ad_amt_zs_c1,
    null as unlock_unt,
    null as unlock_cnt,
    null as unlock_unt_d0,
    null as unlock_cnt_d0,
    null as unlock_unt_d1,
    null as unlock_cnt_d1,
    null as ad_unlock_unt,
    null as ad_unlock_cnt,
    null as ad_unlock_unt_d0,
    null as ad_unlock_cnt_d0,
    null as ad_unlock_unt_d1,
    null as ad_unlock_cnt_d1,
    null as watch_unt,
    null as watch_cnt,
    null as watch_unt_d0,
    null as watch_cnt_d0,
    null as watch_unt_d1,
    null as watch_cnt_d1,
    null as series_cnt,
    null as series_cnt_d0,
    null as series_cnt_d1,
    now() as etl_tm
from z1
         left join z2 on z1.dt = z2.dt
         left join z3 on z1.dt = z3.dt
         left join z4 on z1.dt = z4.dt
         left join z5 on z1.dt = z5.dt
         left join z6 on z1.dt = z6.dt
;



-- ========================= tbl_ads_ad_bi_commercialize_target_di_sv =======================================
-- -----------------------调度脚本，t+1----------------------------------------
-- ========================241227加 ad_unlock_user_cnt 广告解锁人数字段,ad_all_user_cnt 全广告渗透用户=====================
-- ========================250109加 z5 ad_unlock_user_cnt 广告解锁人数字段,ad_all_user_cnt 全广告渗透用户=====================
-- ========================250115加 z2 ad_amt_zs_c1 字段，z7、z8 =====================
insert into  ads.ads_ad_bi_commercialize_target_di
with user_info as(
    -- 海外短剧用户信息
    select
        sacc.product_id,
        sacc.user_id,
        sacc.corever as corever,
        sacc.mt2 as mt,
        sacc.current_language,
        sacc.current_language2,
        sacc.reg_country,
        sacc.create_time,
        sacc.sex,
        sacc.third_party_id,
        sacc.pass_word,
        sacc.email,sacc.bind_email
    from dim.dim_short_video_user_accountinfo sacc
    union all
    -- 国内短剧用户信息
    select
        6883 as product_id,
        account as user_id,
        corever2 as corever,
        mt2 as mt,
        null as current_language,
        current_language2,
        reg_country,
        create_time,
        sex,
        null as third_party_id,
        null as pass_word,
        null as email,
        null as bind_email
    from dim.dim_video_cn_accountinfo_view
)
,z1 as (
    select
        dt,
        core,
        sum(dau) as dau,
        sum(deu) as deu,
        sum(motiv_deu) as motivate_deu
    from ads.ads_bi_short_video_adv_income_report_userdata_view
    where
        dt >= '${bf_1_dt}' and dt < '${dt}'
    group by 1,2
),
     z2 as (
         select
             dt,
             a.core,
             sum(ad_amount) as ad_amt_zs,
             sum(if(a.core = 1, ad_amount, 0)) as ad_amt_zs_c1,
             sum(case when b.ad_show_type_name = '激励视频' then impressions end) as show_cnt_zs,
             sum(case when b.ad_show_type_name = '激励视频' then clicks end) as click_cnt_zs
         from ads.ads_bi_ad_video_income a
                  left join dim.dim_sv_ads_position_view b on a.positions = b.ad_position
         where
             dt >= '${bf_1_dt}' and dt < '${dt}'
         group by 1,2
     ),
     z3 as (
         -- 修改后采用dim_sv_ads_position_view映射表替换and positions not in (8,9,12)逻辑
         select
             a.dt,
             a.core,
             sum(a.cnt) as show_cnt_yg,
             count(distinct a.user_id) as show_unt_yg,
             sum(a.amt) as ad_amt_yg
         from (
                  select
                      dt,
                      user_id,
                      cnt,
                      amt,
                      positions,
                      core
                  from dws.dws_advertisement_user_position_amt_ed
                  where product_id = 6833 and dt >= '${bf_1_dt}' and dt < '${dt}'
              ) a
                  join (
             select
                 ad_position
             from dim.dim_sv_ads_position_view
             where ad_show_type_name = '激励视频'
         ) b on a.positions = b.ad_position
         group by a.dt,a.core
     ),
     z4 as (
         -- 修改后采用dim_sv_ads_position_view映射表替换and positions not in (8,9,12)逻辑
         select
             a.dt,
             sum(a.click_cnt) as click_cnt_sc,
             sum(a.watch_cnt) as watch_cnt_sc
         from (
-- 无core维度，无用户id，需要增加
                  select
                      dt,
                      click_cnt,
                      watch_cnt,
                      ad_position_id
                  from dws.dws_sv_ads_position_play_data_di
                  where dt >= '${bf_1_dt}' and dt < '${dt}'
              ) a
                  join (
             select
                 ad_position
             from dim.dim_sv_ads_position_view
             where ad_show_type_name = '激励视频'
         ) b on a.ad_position_id = b.ad_position
         group by a.dt
     ),
     z5 as (
         -- 无core维度，有用户id，需要增加
         select date(a.create_time) as dt
              ,2 as project_type
              ,b.corever as core
              ,count(distinct a.account_id) as ad_unlock_user_cnt
         from dwd.dwd_short_video_series_unlock_view as a
         left join user_info as b
           on a.account_id = b.user_id
         where  date(a.create_time) >= '${bf_1_dt}'  and date(a.create_time) < '${dt}'
         group by 1,2,3
     ),
     z6 as (
         select dt
              ,case when product_id = 6833 then 2 else 1 end as project_type
              ,a.core
              ,count(distinct user_id) as ad_all_user_cnt
         from (
                  select  dt
                       ,product_id
                       ,user_id
                        ,core
                  from dws.dws_advertisement_user_position_amt_ed
                  union all
-- 无core维度，有用户id，同上
                  select date(a.unlock_time) as dt
                       ,a.product_id
                       ,a.pid as user_id
                        ,b.corever as core
                  from ads.ads_ad_unlock_chapter_detail_view as a
                  left join user_info as b
                    on a.pid = b.user_id
                    and a.product_id=b.product_id
                  where a.lock_type=0
              ) a
         where dt >= '${bf_1_dt}' and dt < '${dt}'
           and product_id = 6833
         group by 1,2,3
     ),
     z7 as (
         select
             a.dt,
             a.core,
             count(distinct a.login_id) as unlock_unt,
             sum(unlock_cnt) as unlock_cnt,
             count(distinct if(a.dt = b.dt, a.login_id, null)) as unlock_unt_d0,
             sum(if(a.dt = b.dt, unlock_cnt, 0)) as unlock_cnt_d0,
             count(distinct if(datediff(a.dt,b.dt) >= 1, a.login_id, null)) as unlock_unt_d1,
             sum(if(datediff(a.dt,b.dt) >= 1, unlock_cnt, 0)) as unlock_cnt_d1,
             count(distinct if(unlock_type = 8, a.login_id, null)) as ad_unlock_unt,
             sum(if(unlock_type = 8, unlock_cnt, 0)) as ad_unlock_cnt,
             count(distinct if(unlock_type = 8 and a.dt = b.dt, a.login_id, null)) as ad_unlock_unt_d0,
             sum(if(unlock_type = 8 and a.dt = b.dt, unlock_cnt, 0)) as ad_unlock_cnt_d0,
             count(distinct if(unlock_type = 8 and datediff(a.dt,b.dt) >= 1, a.login_id, null)) as ad_unlock_unt_d1,
             sum(if(unlock_type = 8 and datediff(a.dt,b.dt) >= 1, unlock_cnt, 0)) as ad_unlock_cnt_d1
         from (

                  select
                      dt,
                      login_id,
                      unlock_type,
                      core,
                      count(1) as unlock_cnt
                  from dwd.dwd_sensors_cd_video_unlockepisode_view
                  where dt = '${bf_1_dt}'
                  group by dt, login_id, unlock_type,core
              ) a
                  left join dim.dim_short_video_user_accountinfo b on a.login_id = b.user_id
         group by a.dt,a.core
     ),
     z8 as (
         select
             a.dt,
             b.corever as core,
             count(1) as watch_unt,
             sum(watch_cnt) as watch_cnt,
             sum(if(a.dt = b.dt, 1, null)) as watch_unt_d0,
             sum(if(a.dt = b.dt, watch_cnt, 0)) as watch_cnt_d0,
             sum(if(datediff(a.dt,b.dt) >= 1, 1, 0)) as watch_unt_d1,
             sum(if(datediff(a.dt,b.dt) >= 1, watch_cnt, 0)) as watch_cnt_d1,
             sum(user_series_cnt)/count(1) as series_cnt,
             sum(if(a.dt = b.dt, user_series_cnt, 0))/sum(if(a.dt = b.dt, 1, null)) as series_cnt_d0,
             sum(if(datediff(a.dt,b.dt) >= 1, user_series_cnt, 0))/sum(if(datediff(a.dt,b.dt) >= 1, 1, 0)) as series_cnt_d1
         from (
                  -- 有用户id，无core
                  select
                      dt,
                      account_id,
                      count(1) as watch_cnt,
                      count(distinct series_id) as user_series_cnt
                  from dwd.dwd_video_short_video_epis_history
                  where dt = '${bf_1_dt}'
                  group by dt, account_id
              ) a
                  left join dim.dim_short_video_user_accountinfo b on a.account_id = b.user_id
         group by a.dt,b.corever
     )
select
    z1.dt as dt,
    2 as project_type,
    concat(year(z1.dt), '-',week(date_sub(z1.dt, interval ((dayofweek(z1.dt) + 1) % 7) day) ) + 1,'(',date(date_sub(z1.dt, interval ((dayofweek(z1.dt) + 1) % 7) day)),'至',date(date_sub( z1.dt, interval ((dayofweek(z1.dt) + 1) % 7 - 6) day )),')') as week,
    concat(year(z1.dt), 'q',quarter(z1.dt)) as quarter,
    ifnull(dau,0) as dau,
    ifnull(deu,0) as deu,
    ifnull(motivate_deu,0) as motive_deu,
    ifnull(round(ad_amt_zs,2),0) as ad_amt_zs,
    ifnull(click_cnt_zs,0) as click_cnt_zs,
    ifnull(show_cnt_zs,0) as show_cnt_zs,
    ifnull(round(ad_amt_yg,2),0) as ad_amt_yg,
    ifnull(show_cnt_yg,0) as show_cnt_yg,
    ifnull(show_unt_yg,0) as show_unt_yg,
    ifnull(watch_cnt_sc,0) as watch_cnt_sc,
    ifnull(click_cnt_sc,0) as click_cnt_sc,
    ifnull(z5.ad_unlock_user_cnt,0) as ad_unlock_user_cnt,
    ifnull(z6.ad_all_user_cnt,0) as ad_all_user_cnt,
    ifnull(z2.ad_amt_zs_c1, 0) as ad_amt_zs_c1,
    ifnull(z7.unlock_unt, 0) as unlock_unt,
    ifnull(z7.unlock_cnt, 0) as unlock_cnt,
    ifnull(z7.unlock_unt_d0, 0) as unlock_unt_d0,
    ifnull(z7.unlock_cnt_d0, 0) as unlock_cnt_d0,
    ifnull(z7.unlock_unt_d1, 0) as unlock_unt_d1,
    ifnull(z7.unlock_cnt_d1, 0) as unlock_cnt_d1,
    ifnull(z7.ad_unlock_unt, 0) as ad_unlock_unt,
    ifnull(z7.ad_unlock_cnt, 0) as ad_unlock_cnt,
    ifnull(z7.ad_unlock_unt_d0, 0) as ad_unlock_unt_d0,
    ifnull(z7.ad_unlock_cnt_d0, 0) as ad_unlock_cnt_d0,
    ifnull(z7.ad_unlock_unt_d1, 0) as ad_unlock_unt_d1,
    ifnull(z7.ad_unlock_cnt_d1, 0) as ad_unlock_cnt_d1,
    ifnull(z8.watch_unt, 0) as watch_unt,
    ifnull(z8.watch_cnt, 0) as watch_cnt,
    ifnull(z8.watch_unt_d0, 0) as watch_unt_d0,
    ifnull(z8.watch_cnt_d0, 0) as watch_cnt_d0,
    ifnull(z8.watch_unt_d1, 0) as watch_unt_d1,
    ifnull(z8.watch_cnt_d1, 0) as watch_cnt_d1,
    ifnull(z8.series_cnt, 0) as series_cnt,
    ifnull(z8.series_cnt_d0, 0) as series_cnt_d0,
    ifnull(z8.series_cnt_d1, 0) as series_cnt_d1,
    now() as etl_tm
from z1
         left join z2 on z1.dt = z2.dt
         left join z3 on z1.dt = z3.dt
         left join z4 on z1.dt = z4.dt
         left join z5 on z1.dt = z5.dt
         left join z6 on z1.dt = z6.dt
         left join z7 on z1.dt = z7.dt
         left join z8 on z1.dt = z8.dt
;