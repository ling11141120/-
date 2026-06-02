----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_susp_koc_scr
-- workflow_version : 4
-- create_user      : qhr
-- task_name        : 新P_ads_srsv_bi_susp_koc_scr
-- task_version     : 1
-- update_time      : 2026-05-12 11:37:03
-- sql_path         : \starrocks\tbl_ads_srsv_bi_susp_koc_scr\新P_ads_srsv_bi_susp_koc_scr
----------------------------------------------------------------
-- SQL语句
----------------------------------------------------------------
-- 程序功能： 嫌疑达人分值表
-- 程序名： P_ads_srsv_bi_susp_koc_scr
-- 目标表： ads.ads_srsv_bi_susp_koc_scr
-- 负责人： wx/qhr
-- 开发日期： 2025-10-31
-- 版本号： v1.1.0
----------------------------------------------------------------
delete from ads.ads_srsv_bi_susp_koc_scr
 where dt >= date_sub('${bf_1_dt}', interval 1 month)
   and dt <= '${bf_1_dt}';

insert into ads.ads_srsv_bi_susp_koc_scr
select a1.dt                              as dt                  -- 日期
      ,a1.usr_id                          as usr_id              -- 用户id
      ,a1.prj_type_cd                     as prj_type_cd         -- 项目类型
      ,coalesce(a5.cd_val_desc, '-99')    as prj_type_name       -- 项目类型名称
      ,case when a1.prj_type_cd = 2 then a2.ttl_view_num
            else a3.ttl_view_num
        end                               as ttl_view_num        -- 总观看数量
      ,case when a1.prj_type_cd = 2 then a2.ttl_view_min
            else a3.ttl_view_min
        end                               as ttl_view_min        -- 总观看分钟数
      ,a1.pay_type                        as pay_mth             -- 支付方式
      ,a4.is_sub                          as tp_prd              -- 充值产品
      ,coalesce(a6.ad_show_cnt, 0)        as ad_show_cnt         -- 广告展示次数
      ,case when coalesce(a6.ad_show_cnt, 0) > 0
            then a6.ad_rev_amt / a6.ad_show_cnt
            else 0
        end                               as avg_rev_per_ad      -- 单广告平均收入
      ,case when coalesce(a6.ad_show_cnt, 0) > 0
            then (case when a1.prj_type_cd = 2 then a2.ttl_view_min
                       else a3.ttl_view_min
                  end) * 60 / a6.ad_show_cnt
            else 0
        end                               as watch_sec_per_ad    -- 单广告看剧时长
  from (select b2.dt
              ,c1.user_id                          as usr_id
              ,c1.prj_type_cd                      as prj_type_cd
              ,group_concat(distinct c3.sub_pay_type) as pay_type
          from (select c2.datestr                  as dt
                  from dim.dim_date                as c2
                 where c2.datestr >= date_sub('${bf_1_dt}', interval 1 month)
                   and c2.datestr <= '${bf_1_dt}'
               )                                   as b2
         cross join (select user_id
                          ,if(product_id = 6833, 2, 1) as prj_type_cd
                          ,begin_time
                      from dwd.dwd_srsv_advertisement_koc_attribution_record_view
                     where begin_time >= date_sub(date_sub('${bf_1_dt}', interval 1 year), interval 1 month)
                    )                               as c1    -- KOC归因表（全量KOC用户，含无订单）
          left join (select user_id
                          ,project_type
                          ,sub_pay_type
                      from ads.ads_srsv_trade_koc_payorderinfo_di
                     where dt >= date_sub('${bf_1_dt}', interval 1 year)
                       and dt <= '${bf_1_dt}'
                       and project_type in (1, 2)
                       and user_id is not null
                     group by 1, 2, 3
                    )                               as c3    -- 订单表补充支付方式
            on c1.user_id = c3.user_id
           and c1.prj_type_cd = c3.project_type
         where c1.begin_time >= date_sub(b2.dt, interval 1 year)
           and c1.begin_time <= b2.dt                        -- KOC窗口：每个日期取自己往前1年
         group by 1, 2, 3
       )                                            as a1
  left join (
             -- 海剧观看
             select b3.dt
                   ,b3.usr_id
                   ,2                                                                          as prj_type_cd
                   ,b3.ttl_view_num
                   ,b4.ttl_view_min
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
  left join (select b7.dt
                   ,b7.login_id                                                                as usr_id
                   ,case when b7.project_id = 8 then 2
                         else 1
                     end                                                                       as prj_type_cd
                   ,max(case when b7.subscription_days >= 1 then '是'
                            else '否'
                       end)                                                                    as is_sub
              from ods_log.ods_sensors_cd_video_production_ordersuccess                        as b7    -- 海剧海阅充值成功
             where b7.project_id in (8, 5)
               and b7.dt >= date_sub('${bf_1_dt}', interval 1 month)
               and b7.dt <= '${bf_1_dt}'
             group by 1, 2, 3
            )                                                                                  as a4
    on a1.dt = a4.dt
   and a1.usr_id = a4.usr_id
   and a1.prj_type_cd = a4.prj_type_cd
  left join dim.dim_pub_code_mapping_dict                                                      as a5
    on a1.prj_type_cd = a5.cd_val
   and a5.cd_col = 'biz_type_cd'
   and a5.app_plat = 'pub'
  left join (select b8.dt
                   ,b8.user_id                          as usr_id
                   ,case when b8.product_id = 6833 then 2
                         else 1
                     end                                as prj_type_cd
                   ,sum(b8.cnt)                         as ad_show_cnt
                   ,sum(b8.amt)                         as ad_rev_amt
               from dws.dws_advertisement_user_position_amt_ed    as b8
              where b8.dt >= date_sub('${bf_1_dt}', interval 1 month)
                and b8.dt <= '${bf_1_dt}'
                and b8.user_id is not null
                and b8.ad_show_type = 3
              group by 1, 2, 3
            )                                                                       as a6
    on a1.dt = a6.dt
   and a1.usr_id = a6.usr_id
   and a1.prj_type_cd = a6.prj_type_cd
;
