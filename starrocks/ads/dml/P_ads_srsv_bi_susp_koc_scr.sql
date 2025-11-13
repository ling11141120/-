----------------------------------------------------------------
-- 程序功能： 嫌疑达人分值表
-- 程序名： P_ads_srsv_bi_susp_koc_scr
-- 目标表： ads.ads_srsv_bi_susp_koc_scr
-- 负责人： wx
-- 开发日期： 2025-10-31
-- 版本号： v0.0.0
----------------------------------------------------------------
insert into tmp.ads_srsv_bi_susp_koc_scr
with t1 as (
    select '${bf_1_dt}'    as dt
          ,a1.user_id
          ,a1.prj_type_cd
          ,a2.ttl_view_num
          ,a3.min_avg_view_num
          ,a1.pay_type     as pay_mth
          ,a4.is_sub       as tp_prd
      from (select user_id
                  ,project_type                                               as prj_type_cd
                  ,group_concat(sub_pay_type)                                 as pay_type
              from (select user_id
                          ,project_type
                          ,sub_pay_type
                      from ads.ads_srsv_trade_koc_payorderinfo_di
                     where dt = '${bf_1_dt}'
                       and project_type = 2
                       and user_id is not null
                     group by 1, 2 ,3
                   )                                                          as b1
             group by 1, 2
           )                                                                  as a1
      left join (select login_id                                              as user_id
                       ,count(distinct episode_id)                            as ttl_view_num
                   from ods_log.ods_sensors_cd_video_startwatching
                  where dt = '${bf_1_dt}'
                  group by 1
                )                                                             as a2
        on a1.user_id = a2.user_id
      left join (select user_id
                       ,round(avg(episode_count), 1)                          as min_avg_view_num
                   from (select login_id                                      as user_id
                               ,date_format(event_tm, '%y-%m-%d %h:%i:00')    as minute_time
                               ,count(distinct episode_id)                    as episode_count
                           from ods_log.ods_sensors_cd_video_startwatching
                          where dt = '${bf_1_dt}'
                          group by 1, 2
                        )                                                     as b2
                  group by 1
                )                                                             as a3
        on a1.user_id = a3.user_id
      left join (select login_id                                              as user_id
                       ,case when subscription_days >= 1 then '是'
                             else '否'
                         end                                                  as is_sub
                      from ods_log.ods_sensors_cd_video_production_ordersuccess
                     where project_id = 8
                       and dt = '${bf_1_dt}'
                     group by 1, 2
                    )                                                         as a4
        on a1.user_id = a4.user_id
     union all
    select '${bf_1_dt}'                                                       as dt
          ,a1.user_id
          ,a1.prj_type_cd
          ,a2.ttl_view_num
          ,a3.min_avg_view_num
          ,a1.pay_type                                                        as pay_mth
          ,a4.is_sub                                                          as tp_prd
      from (select user_id
                  ,project_type                                               as prj_type_cd
                  ,group_concat(sub_pay_type)                                 as pay_type
              from (select user_id
                          ,project_type
                          ,sub_pay_type
                      from ads.ads_srsv_trade_koc_payorderinfo_di
                     where dt = '${bf_1_dt}'
                       and project_type = 1
                       and user_id is not null
                     group by 1, 2 ,3
                   )                                                          as b1
             group by 1, 2
           )                                                                  as a1
      left join (select login_id                                              as user_id
                       ,count(distinct chapter_id)                            as ttl_view_num
                   from ods_log.ods_sensors_production_startreadingchapter
                  where dt = '${bf_1_dt}'
                  group by 1
                )                                                             as a2
        on a1.user_id = a2.user_id
      left join (select user_id
                       ,round(avg(chapter_count), 1)                          as min_avg_view_num
                   from (select login_id                                      as user_id
                               ,date_format(event_tm, '%y-%m-%d %h:%i:00')    as minute_time
                               ,count(distinct chapter_id)                    as chapter_count
                           from ods_log.ods_sensors_production_startreadingchapter
                          where dt = '${bf_1_dt}'
                          group by 1, 2
                        )                                                     as b2
                  group by 1
                )                                                             as a3
        on a1.user_id = a3.user_id
      left join (select identity_login_id                                     as user_id
                       ,case when subscription_days >= 1 then '是'
                             else '否'
                         end                                                  as is_sub
                   from ods_log.ods_sensors_cd_video_production_ordersuccess
                  where dt = '${bf_1_dt}'
                    and project_id = 5
                  group by 1, 2
                )                                                             as a4
        on a1.user_id = a4.user_id
)
select a1.dt                                                     -- 日期
      ,a1.user_id                                                -- 用户id
      ,a1.prj_type_cd                                            -- 项目类型
      ,coalesce(a2.cd_col_desc, '-99')       as prj_type_name    -- 项目类型名称
      ,a1.ttl_view_num                                           -- 总观看集/章数
      ,a1.min_avg_view_num                                       -- 每分钟平均观看集/章数
      ,a1.pay_mth                                                -- 支付方式
      ,a1.tp_prd                                                 -- 充值产品
  from t1                                    as a1
  left join dim.dim_pub_code_mapping_dict    as a2
    on a1.prj_type_cd = a2.cd_val
   and a2.cd_col = 'biz_type_cd'
   and a2.app_plat = 'pub'
 where a1.ttl_view_num is not null
;