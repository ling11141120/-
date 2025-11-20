----------------------------------------------------------------
-- 程序功能： 嫌疑达人分值表
-- 程序名： P_ads_srsv_bi_susp_koc_scr
-- 目标表： ads.ads_srsv_bi_susp_koc_scr
-- 负责人： wx/qhr
-- 开发日期： 2025-10-31
-- 版本号： v1.0.0
----------------------------------------------------------------
insert into ads.ads_srsv_bi_susp_koc_scr
select a1.dt                              as dt                  -- 日期
      ,a1.usr_id                          as usr_id              -- 用户id
      ,a1.prj_type_cd                     as prj_type_cd         -- 项目类型
      ,coalesce(a5.cd_col_desc, '-99')    as prj_type_name       -- 项目类型名称
      ,case when a1.prj_type_cd = 2 then a2.ttl_view_num
            else a3.ttl_view_num
        end                               as ttl_view_num        -- 总观看数量
      ,case when a1.prj_type_cd = 2 then a2.ttl_view_min
            else a3.ttl_view_min
        end                               as ttl_view_min        -- 总观看分钟数
      ,a1.pay_type                        as pay_mth             -- 支付方式
      ,a4.is_sub                          as tp_prd              -- 充值产品
  from (select b2.dt
              ,b1.user_id                                                                      as usr_id
              ,b1.prj_type_cd                                                                  as prj_type_cd
              ,b1.pay_type                                                                     as pay_type
          from (select c1.user_id
                      ,c1.project_type                                                         as prj_type_cd
                      ,group_concat(distinct c1.sub_pay_type)                                  as pay_type
                  from ads.ads_srsv_trade_koc_payorderinfo_di                                  as c1    -- 海剧海阅koc订单
                 where c1.dt >= date_sub('${bf_1_dt}', interval 1 year)
                   and c1.dt <= '${bf_1_dt}'
                   and c1.project_type in (1, 2)
                   and c1.user_id is not null
                 group by 1, 2
               )                                                                               as b1
         cross join (select c2.datestr                                                         as dt
                       from dim.dim_date                                                       as c2
                      where c2.datestr >= date_sub('${bf_1_dt}', interval 1 month)
                        and c2.datestr <= '${bf_1_dt}'
                    )                                                                          as b2
       )                                                                                       as a1
  left join (
             -- 海剧观看
             select b3.dt
                   ,b3.usr_id
                   ,2                                                                          as prj_type_cd
                   ,b3.ttl_view_num
                   ,b4.ttl_view_min
                   ,round(b3.ttl_view_num / b4.ttl_view_min, 1)                                as min_avg_view_num
               from (select c3.dt
                           ,c3.login_id                                                        as usr_id
                           ,count(distinct c3.episode_id)                                      as ttl_view_num
                       from ods_log.ods_sensors_cd_video_startwatching                         as c3
                      where c3.dt >= date_sub('${bf_1_dt}', interval 1 month)
                        and c3.dt <= '${bf_1_dt}'
                      group by 1, 2
                    )                                                                          as b3
               left join (select c4.dt
                                ,c4.usr_id
                                ,count(1)                                                      as ttl_view_min
                            from (select d1.dt
                                        ,d1.login_id                                           as usr_id
                                        ,date_trunc('minute', d1.event_tm)                     as min_tm
                                    from ods_log.ods_sensors_cd_video_startwatching            as d1
                                   where d1.dt >= date_sub('${bf_1_dt}', interval 1 month)
                                     and d1.dt <= '${bf_1_dt}'
                                   group by 1, 2, 3
                                 )                                                             as c4
                           group by 1, 2
                         )                                                                     as b4
                 on b3.dt = b4.dt
                and b3.usr_id = b4.usr_id
            )                                                                                  as a2
    on a1.dt = a2.dt
   and a1.usr_id = a2.usr_id
   and a1.prj_type_cd = a2.prj_type_cd
  left join (
             -- 海阅观看
             select b5.dt
                   ,b5.usr_id
                   ,1                                                                          as prj_type_cd
                   ,b5.ttl_view_num
                   ,b6.ttl_view_min
               from (select c5.dt
                           ,c5.login_id                                                        as usr_id
                           ,count(distinct c5.chapter_id)                                      as ttl_view_num
                       from ods_log.ods_sensors_production_startreadingchapter                 as c5
                      where c5.dt >= date_sub('${bf_1_dt}', interval 1 month)
                        and c5.dt <= '${bf_1_dt}'
                      group by 1, 2
                    )                                                                          as b5
               left join (select c6.dt
                                ,c6.usr_id
                                ,count(1)                                                      as ttl_view_min
                            from (select d2.dt
                                        ,d2.login_id                                           as usr_id
                                        ,date_trunc('minute', d2.event_tm)                     as min_tm
                                    from ods_log.ods_sensors_production_startreadingchapter    as d2
                                   where d2.dt >= date_sub('${bf_1_dt}', interval 1 month)
                                     and d2.dt <= '${bf_1_dt}'
                                   group by 1, 2, 3
                                 )                                                             as c6
                           group by 1, 2
                         )                                                                     as b6
                  on b5.dt = b6.dt
                 and b5.usr_id = b6.usr_id
            )                                                                                  as a3
    on a1.dt = a3.dt
   and a1.usr_id = a3.usr_id
   and a1.prj_type_cd = a3.prj_type_cd
  left join (select b7.dt
                   ,b7.login_id                                                                as usr_id
                   ,case when b7.project_id = 8 then 2
                         else 1
                     end                                                                       as prj_type_cd
                   ,case when b7.subscription_days >= 1 then '是'
                         else '否'
                     end        as is_sub
              from ods_log.ods_sensors_cd_video_production_ordersuccess                        as b7    -- 海剧海阅充值成功
             where b7.project_id in (8, 5)
               and b7.dt >= date_sub('${bf_1_dt}', interval 1 month)
               and b7.dt <= '${bf_1_dt}'
             group by 1, 2, 3, 4
            )                                                                                  as a4
    on a1.dt = a4.dt
   and a1.usr_id = a4.usr_id
   and a1.prj_type_cd = a4.prj_type_cd
  left join dim.dim_pub_code_mapping_dict                                                      as a5
    on a1.prj_type_cd = a5.cd_val
   and a5.cd_col = 'biz_type_cd'
   and a5.app_plat = 'pub'
 where a2.ttl_view_num is not null
    or a3.ttl_view_num is not null
;