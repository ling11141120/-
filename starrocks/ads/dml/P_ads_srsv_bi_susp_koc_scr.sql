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
      ,a1.usr_id                          as usr_id              -- 用户id
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
  from (select b1.user_id                                                                      as usr_id
              ,b1.project_type                                                                 as prj_type_cd
              ,group_concat(distinct b1.sub_pay_type)                                          as pay_type
          from ads.ads_srsv_trade_koc_payorderinfo_di                                          as b1    -- 海剧海阅koc订单
         where b1.dt >= date_sub('${bf_1_dt}', interval 1 year)
           and b1.dt <= '${bf_1_dt}'
           and b1.project_type in (1, 2)
           and b1.user_id is not null
         group by 1, 2
       )                                                                                       as a1
  left join (
             -- 海剧观看
             select b2.usr_id
                   ,2                                                                          as prj_type_cd
                   ,b2.ttl_view_num
                   ,b3.min_avg_view_num
               from (select c1.login_id                                                        as usr_id
                           ,count(distinct c1.episode_id)                                      as ttl_view_num
                       from ods_log.ods_sensors_cd_video_startwatching                         as c1
                      where c1.dt = '${bf_1_dt}'
                      group by 1
                    )                                                                          as b2
               left join (select c2.usr_id
                                ,round(avg(c2.episode_count), 1)                               as min_avg_view_num
                            from (select d1.login_id                                           as usr_id
                                        ,date_trunc('minute', d1.event_tm)                     as min_tm
                                        ,count(distinct d1.episode_id)                         as episode_count
                                    from ods_log.ods_sensors_cd_video_startwatching            as d1
                                   where d1.dt = '${bf_1_dt}'
                                   group by 1, 2
                                 )                                                             as c2
                           group by 1
                         )                                                                     as b3
                 on b2.usr_id = b3.usr_id
            )                                                                                  as a2
    on a1.usr_id = a2.usr_id
   and a1.prj_type_cd = a2.prj_type_cd
  left join (
             -- 海阅观看
             select b4.usr_id
                   ,1                                                                          as prj_type_cd
                   ,b4.ttl_view_num
                   ,b5.min_avg_view_num
               from (select c3.login_id                                                        as usr_id
                           ,count(distinct c3.chapter_id)                                      as ttl_view_num
                       from ods_log.ods_sensors_production_startreadingchapter                 as c3
                      where c3.dt = '${bf_1_dt}'
                      group by 1
                    )                                                                          as b4
               left join (select c4.usr_id
                                ,round(avg(c4.chapter_count), 1)                               as min_avg_view_num
                            from (select d2.login_id                                           as usr_id
                                        ,date_trunc('minute', d2.event_tm)                     as min_tm
                                        ,count(distinct d2.chapter_id)                         as chapter_count
                                    from ods_log.ods_sensors_production_startreadingchapter    as d2
                                   where d2.dt = '${bf_1_dt}'
                                   group by 1, 2
                                 )                                                             as c4
                           group by 1
                         )                                                                     as b5
                  on b4.usr_id = b5.usr_id
            )                                                                                  as a3
    on a1.usr_id = a3.usr_id
   and a1.prj_type_cd = a3.prj_type_cd
  left join (select b6.login_id                                                                as usr_id
                   ,case when b6.project_id = 8 then 2
                         else 1
                     end                                                                       as prj_type_cd
                   ,case when b6.subscription_days >= 1 then '是'
                         else '否'
                     end        as is_sub
              from ods_log.ods_sensors_cd_video_production_ordersuccess                        as b6    -- 海剧海阅充值成功
             where b6.project_id in (8, 5)
               and b6.dt = '${bf_1_dt}'
             group by 1, 2, 3
            )                                                                                  as a4
    on a1.usr_id = a4.usr_id
   and a1.prj_type_cd = a4.prj_type_cd
  left join dim.dim_pub_code_mapping_dict                                                      as a5
    on a1.prj_type_cd = a5.cd_val
   and a5.cd_col = 'biz_type_cd'
   and a5.app_plat = 'pub'
 where a2.ttl_view_num is not null
    or a3.ttl_view_num is not null
;