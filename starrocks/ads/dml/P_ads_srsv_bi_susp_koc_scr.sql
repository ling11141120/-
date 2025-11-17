----------------------------------------------------------------
-- 程序功能： 嫌疑达人分值表
-- 程序名： P_ads_srsv_bi_susp_koc_scr
-- 目标表： ads.ads_srsv_bi_susp_koc_scr
-- 负责人： wx
-- 开发日期： 2025-10-31
-- 版本号： v1.0.0
----------------------------------------------------------------
insert into tmp.ads_srsv_bi_susp_koc_scr
select '${bf_1_dt}'                       as dt                  -- 日期
      ,a1.user_id                         as usr_id              -- 用户id
      ,a1.prj_type_cd                     as prj_type_cd         -- 项目类型
      ,coalesce(a5.cd_col_desc, '-99')    as prj_type_name       -- 项目类型名称
      ,case when a1.prj_type_cd = 2 then a2.ttl_view_num
            else a3.ttl_view_num
        end                               as ttl_view_num        -- 总观看数量
      ,case when a1.prj_type_cd = 2 then a2.min_avg_view_num
            else a3.min_avg_view_num
        end                               as min_avg_view_num    -- 每分钟平均观看数量
      ,a1.pay_type                        as pay_mth             -- 支付方式
      ,a4.is_sub                          as tp_prd              -- 充值产品
  from (select b1.user_id
              ,b1.project_type                                                    as prj_type_cd
              ,group_concat(b1.sub_pay_type)                                      as pay_type
          from ads.ads_srsv_trade_koc_payorderinfo_di                             as b1    -- 海剧海阅koc订单
         where b1.dt >= date_sub('${bf_1_dt}', interval 1 year)
           and b1.dt <= '${bf_1_dt}'
           and b1.project_type in (1, 2)
           and b1.user_id is not null
         group by 1, 2
       )                                                                          as a1
  left join (select b2.login_id                                                   as user_id
                   ,2                                                             as prj_type_cd
                   ,count(distinct b2.episode_id)                                 as ttl_view_num
                   ,round(avg(b2.episode_count), 1)                               as min_avg_view_num
               from (select c1.login_id
                           ,c1.episode_id
                           ,date_trunc('minute', c1.event_tm)                     as min_tm
                           ,count(distinct c1.episode_id)
                             over(partition by c1.login_id
                                              ,date_trunc('minute', c1.event_tm)
                                 )    as episode_count
                       from ods_log.ods_sensors_cd_video_startwatching            as c1    -- 海剧观看
                      where c1.dt = '${bf_1_dt}'
                    )                                                             as b2
              group by 1, 2
            )                                                                     as a2
    on a1.user_id = a2.user_id
   and a1.prj_type_cd = a2.prj_type_cd
  left join (select b3.login_id                                                   as user_id
                   ,1                                                             as prj_type_cd
                   ,count(distinct b3.episode_id)                                 as ttl_view_num
                   ,round(avg(b3.episode_count), 1)                               as min_avg_view_num
               from (select c2.login_id
                           ,c2.episode_id
                           ,date_trunc('minute', c2.event_tm)                     as min_tm
                           ,count(distinct c2.episode_id)
                             over(partition by c2.login_id
                                              ,date_trunc('minute', c2.event_tm)
                                 )    as episode_count
                       from ods_log.ods_sensors_production_startreadingchapter    as c2    -- 海阅观看
                      where c2.dt = '${bf_1_dt}'
                    )                                                             as b3
              group by 1, 2
            )                                                                     as a3
    on a1.user_id = a3.user_id
   and a1.prj_type_cd = a3.prj_type_cd
  left join (select b4.login_id                                                   as user_id
                   ,case when b4.project_id = 8 then 2
                         else 1
                     end                                                          as prj_type_cd
                   ,case when b4.subscription_days >= 1 then '是'
                         else '否'
                     end        as is_sub
              from ods_log.ods_sensors_cd_video_production_ordersuccess           as b4    -- 海剧海阅充值成功
             where b4.project_id in (8, 5)
               and b4.dt = '${bf_1_dt}'
             group by 1, 2, 3
            )                                                                     as a4
    on a1.user_id = a4.user_id
   and a1.prj_type_cd = a4.prj_type_cd
  left join dim.dim_pub_code_mapping_dict                                         as a5
    on a1.prj_type_cd = a5.cd_val
   and a5.cd_col = 'biz_type_cd'
   and a5.app_plat = 'pub'
 where a2.ttl_view_num is not null
    or a3.ttl_view_num is not null
;