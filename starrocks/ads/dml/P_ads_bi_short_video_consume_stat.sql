----------------------------------------------------------------
-- 程序功能： 海外短剧剧集消费统计表
-- 程序名： P_ads_bi_short_video_consume_stat
-- 目标表： ads.ads_bi_short_video_consume_stat
-- 负责人： lwb
-- 开发日期： 2026-06-15
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_consume_stat where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_short_video_consume_stat
with bd as (
    select a.dt
         , product_id
         , a.user_id
         , a.series_id
         , a.series_name
         , series_language
         , source
         , mt
         , a.core
         , last_epis
         , d.series_code
         , e.series_tp
         , c.publish_edat                                                  as publish_tm
         , if(b.user_id is not null and a.series_id = b.series_id, 1, 2)  as is_toufang
         , coalesce(sst.subscribe_type_cd, '其他')                         as user_subscribe_type
         , sum(if(epis_watch_num_real is null, 0, epis_watch_num_real))   as epis_watch_num_real
         , sum(if(epis_coin_consume_amount is null, 0, epis_coin_consume_amount)) as epis_coin_consume_amount
         , sum(if(epis_cert_consume_amount is null, 0, epis_cert_consume_amount)) as epis_cert_consume_amount
      from dwm.dwm_video_short_video_watch_consume_ed a
      left join (
          select User_Id, Book_Id as series_id
            from (
                select Product_Id
                     , User_Id
                     , Book_Id
                     , install_date
                     , row_number() over (partition by Product_Id, User_Id order by Install_Date desc, Id desc) rn
                  from dwd.dwd_user_install_info_ed_view
                 where dt >= date_sub('${bf_1_dt}', interval 30 day)
                   and dt <= '${bf_1_dt}'
                   and Product_Id = 6833
                   and IsDelete != 1
                   and User_Id > 0
                   and Book_Id > 0
            ) t1
           where rn = 1
      ) b
        on a.user_id = b.user_id
      left join dim.dim_short_video_series_view c
        on a.series_id = c.series_id
      left join (
          select a.series_id as series_id
               , b.series_code as series_code
            from dim.dim_short_video_series_view a
            left join dim.dim_short_video_source_series_view b
              on a.source_series_id = b.series_id
           where b.series_id is not null
      ) d
        on a.series_id = d.series_id
      left join (
          select a.series_id
               , array_join(array_sort(array_distinct(array_agg(b.name))), '_') as series_tp
            from dim.dim_short_video_series_ref_type_view a
            left join dim.dim_short_video_series_type_view b
              on a.series_type_id = b.id
           group by 1
      ) e
        on a.series_id = e.series_id
      left join ads.ads_user_sv_subscribe_status_di sst
        on a.user_id = sst.user_id
       and sst.dt = '${bf_1_dt}'
     where a.dt = '${bf_1_dt}'
       and coalesce(epis_watch_num_real, epis_coin_consume_amount, epis_cert_consume_amount) is not null
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
)
select dt
     , md5(concat(series_id, is_toufang, user_subscribe_type
                , if(source is null, '-99', source)
                , if(mt is null, -99, mt)
                , if(core is null, -99, core)
          ))                                                               as md5_key
     , series_id
     , is_toufang
     , user_subscribe_type
     , source
     , mt
     , core
     , product_id
     , series_name
     , series_language
     , last_epis
     , series_code
     , series_tp
     , publish_tm
     , bitmap_union(to_bitmap(if(epis_watch_num_real != 0, user_id, null)))                    as video_watch_user_bitmap
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0, user_id, null))) as video_consume_user_bitmap
     , (sum(epis_coin_consume_amount) + sum(epis_cert_consume_amount)) / 100                   as video_consume_amt
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0, user_id, null)))                as video_coin_consume_user_bitmap
     , sum(epis_coin_consume_amount) / 100                                                      as video_coin_consume_amt
     , now()                                                                                    as etl_time
  from bd
 where is_toufang = 1
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
union all
select dt
     , md5(concat(series_id, is_toufang, user_subscribe_type
                , if(source is null, '-99', source)
                , if(mt is null, -99, mt)
                , if(core is null, -99, core)
          ))                                                               as md5_key
     , series_id
     , is_toufang
     , user_subscribe_type
     , source
     , mt
     , core
     , product_id
     , series_name
     , series_language
     , last_epis
     , series_code
     , series_tp
     , publish_tm
     , bitmap_union(to_bitmap(if(epis_watch_num_real != 0, user_id, null)))                    as video_watch_user_bitmap
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0, user_id, null))) as video_consume_user_bitmap
     , (sum(epis_coin_consume_amount) + sum(epis_cert_consume_amount)) / 100                   as video_consume_amt
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0, user_id, null)))                as video_coin_consume_user_bitmap
     , sum(epis_coin_consume_amount) / 100                                                      as video_coin_consume_amt
     , now()                                                                                    as etl_time
  from bd
 where is_toufang = 2
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
union all
select dt
     , md5(concat(series_id, 0, user_subscribe_type
                , if(source is null, '-99', source)
                , if(mt is null, -99, mt)
                , if(core is null, -99, core)
          ))                                                               as md5_key
     , series_id
     , 0                                                                    as is_toufang
     , user_subscribe_type
     , source
     , mt
     , core
     , product_id
     , series_name
     , series_language
     , last_epis
     , series_code
     , series_tp
     , publish_tm
     , bitmap_union(to_bitmap(if(epis_watch_num_real != 0, user_id, null)))                    as video_watch_user_bitmap
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0 or epis_cert_consume_amount != 0, user_id, null))) as video_consume_user_bitmap
     , (sum(epis_coin_consume_amount) + sum(epis_cert_consume_amount)) / 100                   as video_consume_amt
     , bitmap_union(to_bitmap(if(epis_coin_consume_amount != 0, user_id, null)))                as video_coin_consume_user_bitmap
     , sum(epis_coin_consume_amount) / 100                                                      as video_coin_consume_amt
     , now()                                                                                    as etl_time
  from bd
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
;
