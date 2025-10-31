----------------------------------------------------------------
-- 程序功能： 嫌疑达人分值表
-- 程序名： P_ads_bi_suspect_daren_score.sql
-- 目标表： ads.ads_bi_suspect_daren_score
-- 负责人： wx
-- 开发日期： 2025-10-31
-- 版本号： v0.0.0
----------------------------------------------------------------
insert into ads.ads_bi_suspect_star_score(
     dt                -- 日期
    ,user_id           -- 用户id
    ,prj_type          -- 项目类型
    ,prj_type_name     -- 项目类型名称
    ,avg_view_num      -- 平均观看集/章数
    ,payment_method    -- 支付方式
    ,tp_prd            -- 充值产品
)
with t1 as (
    select '${bf_1_dt}'    as dt
          ,a1.user_id
          ,a1.prj_type
          ,a2.total_episode_count
          ,a3.avg_count    as avg_view_num
          ,a1.pay_type     as payment_method
          ,a4.is_sub       as tp_prd
      from (select user_id
                  ,project_type as prj_type
                  ,group_concat(sub_pay_type) as pay_type
              from (select user_id
                          ,project_type
                          ,sub_pay_type
                      from ads.ads_srsv_trade_koc_payorderinfo_di
                     where project_type = 2 and user_id is not null
                     group by 1, 2 ,3
                   )    as b1
             group by 1, 2
           )    as a1
      left join (select login_id as user_id
                       ,count(distinct episode_id) as total_episode_count
                   from ods_log.ods_sensors_cd_video_startwatching
                  where dt >= '2025-10-01'
                  group by 1
                )    as a2
        on a1.user_id = a2.user_id
      left join (select user_id
                       ,round(avg(episode_count), 1) avg_count
                   from (select login_id as user_id
                               ,date_format(dt, '%y-%m-%d %h:%i:00') as minute_time
                               ,count(distinct episode_id) as episode_count
                           from ods_log.ods_sensors_cd_video_startwatching
                          where dt >= '2025-10-01'
                          group by 1, 2
                        )     as b2
                  group by 1
                )    as a3
        on a1.user_id = a3.user_id
      left join (select login_id as user_id
                       ,case when subscription_days >= 1 then '是'
                             else '否'
                         end as is_sub
                      from ods_log.ods_sensors_cd_video_production_ordersuccess
                     where dt >= '2025-10-01' and project_id = 8
                     group by 1, 2
                    )    as a4
        on a1.user_id = a4.user_id
     union all
    select '${bf_1_dt}'    as dt
          ,a1.user_id
          ,a1.prj_type
          ,a2.total_episode_count
          ,a3.avg_count    as avg_view_num
          ,a1.pay_type     as payment_method
          ,a4.is_sub       as tp_prd
      from (select user_id
                  ,project_type as prj_type
                  ,group_concat(sub_pay_type) as pay_type
              from (select user_id
                          ,project_type
                          ,sub_pay_type
                      from ads.ads_srsv_trade_koc_payorderinfo_di
                     where project_type = 1 and user_id is not null
                     group by 1, 2 ,3
                   )    as b1
             group by 1, 2
           )    as a1
      left join (select login_id as user_id
                       ,count(distinct chapter_id) as total_episode_count
                   from ods_log.ods_sensors_production_startreadingchapter
                  where dt >= '2025-10-01'
                  group by 1
                )    as a2
        on a1.user_id = a2.user_id

      left join (select user_id
                       ,round(avg(chapter_count), 1) avg_count
                   from (select login_id as user_id
                               ,date_format(dt, '%y-%m-%d %h:%i:00') as minute_time
                               ,count(distinct chapter_id) as chapter_count
                           from ods_log.ods_sensors_production_startreadingchapter
                          where dt >= '2025-10-01'
                          group by 1, 2
                        )     as b2
                  group by 1
                )    as a3
        on a1.user_id = a3.user_id
      left join (select login_id as user_id
                       ,case when subscription_days >= 1 then '是'
                             else '否'
                         end as is_sub
                      from ods_log.ods_sensors_cd_video_production_ordersuccess
                     where dt >= '2025-10-01' and project_id = 5
                     group by 1, 2
                    )    as a4
        on a1.user_id = a4.user_id
)

select dt
      ,user_id
      ,prj_type
      ,case when prj_type = 1 then '海阅'
            when prj_type = 2 then '海剧'
            else '0'
        end as prj_type_name
      ,case when total_episode_count >= 10 and avg_view_num < 1 then '1集/章/章以下'
            when total_episode_count >= 10 and avg_view_num >= 1 and avg_view_num < 1.5 then '1-1.5集/章'
            when total_episode_count >= 10 and avg_view_num >= 1.5 and avg_view_num < 2 then '1.5-2集/章'
            when total_episode_count >= 10 and avg_view_num >= 2 and avg_view_num < 2.5 then '2-2.5集/章'
            when total_episode_count >= 10 and avg_view_num >= 2.5 and avg_view_num < 3 then '2.5-3集/章'
            when total_episode_count >= 10 and avg_view_num >= 3 and avg_view_num < 3.5 then '3-3.5集/章'
            when total_episode_count >= 10 and avg_view_num >= 3.5 then '3.5集/章以上'
            else '总观看集/章数少于10集/章'
        end as avg_view_num
      ,payment_method
      ,tp_prd
  from t1
;