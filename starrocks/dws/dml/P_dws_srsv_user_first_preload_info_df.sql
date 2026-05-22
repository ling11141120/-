----------------------------------------------------------------
-- 程序功能： 海剧海阅首次预加载信息
-- 程序名： P_dws_srsv_user_first_preload_info_df
-- 目标表： dws.dws_srsv_user_first_preload_info_df
-- 负责人： lwb
-- 开发日期：2026-05-21
----------------------------------------------------------------

insert into dws.dws_srsv_user_first_preload_info_df
select product_id
     , user_id
     , ad_type
     , ecpm             as lst_preload_ecpm
     , fst_preload_time
     , now()            as etl_time
  from (select product_id
             , user_id
             , ad_type
             , ecpm
             , create_time                                                                                                                                    as fst_preload_time
             , row_number() over( partition by product_id, user_id, ad_type order by create_time, case when upper(ad_format) = 'REWARDED' then 0 else 1 end ) as rn
          from (select a.product_id
                     , a.id                                          as user_id
                     , 3                                             as ad_type
                     , get_json_string(b.s0, '$.valueMicros') * 1000 as ecpm
                     , get_json_string(b.s0, '$.adFormat')           as ad_format
                     , b.create_time
                  from (select product_id
                             , user_id
                             , s0
                             , create_time
                          from ods_log.ods_readerlog_xx_log_commonactionlog
                         where Action = 'FirstPreloadEvent'
                           and dt >= '${bf_1_dt}'
                       ) b
                  inner join (select product_id
                                   , id
                                from dim.dim_user_account_info_view
                             ) a
                    on a.product_id = b.product_id
                   and a.id = b.user_id
               ) t
       ) t
 where rn = 1

union all

select product_id       as product_id
     , user_id          as user_id
     , ad_type          as ad_type
     , max(ecpm)        as lst_preload_ecpm
     , fst_preload_time as fst_preload_time
     , now()            as etl_time
  from (select product_id
             , user_id
             , ad_type
             , ecpm
             , create_time as fst_preload_time
          from (select a.product_id
                     , a.user_id
                     , b.ad_type
                     , b.value_micros * 1000                                                    as ecpm
                     , b.create_time
                     , min(b.create_time) over(partition by a.product_id, a.user_id, b.ad_type) as min_create_time
                  from (select account_id
                             , ad_type
                             , value_micros
                             , create_time
                          from ods.ods_tidb_sv_short_video_log_ad_preload_revenue_di
                         where create_time >= '${bf_1_dt}'
                       ) b
                  inner join (select product_id
                                   , user_id
                                from dim.dim_short_video_user_accountinfo
                             ) a
                    on a.user_id = b.account_id
               ) t
         where create_time = min_create_time
       ) t
 group by product_id, user_id, ad_type, fst_preload_time
;
