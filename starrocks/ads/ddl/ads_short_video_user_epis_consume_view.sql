create or replace view ads_short_video_user_epis_consume_view (
     dt
    ,product_id
    ,user_id
    ,series_id
    ,epis_num
    ,is_toufang
    ,user_subscribe_type
    ,mt
    ,core
    ,source
    ,epis_coin_consume_amount
    ,epis_cert_consume_amount
) as
select a.dt
     , a.product_id
     , a.user_id
     , a.series_id
     , a.epis_num
     , if(b.user_id is not null, 1, 2)                as is_toufang
     , coalesce(sst.subscribe_type_cd, '其他')        as user_subscribe_type
     , a.mt
     , a.core
     , a.source
     , a.epis_coin_consume_amount
     , a.epis_cert_consume_amount
  from (
      select dwm_video_short_video_watch_consume_ed.dt
           , dwm_video_short_video_watch_consume_ed.product_id
           , dwm_video_short_video_watch_consume_ed.user_id
           , dwm_video_short_video_watch_consume_ed.series_id
           , dwm_video_short_video_watch_consume_ed.epis_num
           , dwm_video_short_video_watch_consume_ed.source
           , dwm_video_short_video_watch_consume_ed.mt
           , dwm_video_short_video_watch_consume_ed.core
           , dwm_video_short_video_watch_consume_ed.epis_coin_consume_amount
           , dwm_video_short_video_watch_consume_ed.epis_cert_consume_amount
        from dwm.dwm_video_short_video_watch_consume_ed
       where coalesce(dwm_video_short_video_watch_consume_ed.epis_coin_consume_amount
                    , dwm_video_short_video_watch_consume_ed.epis_cert_consume_amount) is not null
  ) a
  left join (
      select distinct User_Id
        from dwd.dwd_user_install_info_ed_view
       where Product_Id = 6833
         and IsDelete != 1
  ) b
    on a.user_id = b.user_id
  left join ads.ads_user_sv_subscribe_status_di sst
    on a.user_id = sst.user_id
   and a.dt = sst.dt
union all
select dwm_video_short_video_watch_consume_ed.dt
     , dwm_video_short_video_watch_consume_ed.product_id
     , dwm_video_short_video_watch_consume_ed.user_id
     , dwm_video_short_video_watch_consume_ed.series_id
     , dwm_video_short_video_watch_consume_ed.epis_num
     , 0                                             as is_toufang
     , coalesce(sst.subscribe_type_cd, '其他')        as user_subscribe_type
     , dwm_video_short_video_watch_consume_ed.mt
     , dwm_video_short_video_watch_consume_ed.core
     , dwm_video_short_video_watch_consume_ed.source
     , dwm_video_short_video_watch_consume_ed.epis_coin_consume_amount
     , dwm_video_short_video_watch_consume_ed.epis_cert_consume_amount
  from dwm.dwm_video_short_video_watch_consume_ed
  left join ads.ads_user_sv_subscribe_status_di sst
    on dwm_video_short_video_watch_consume_ed.user_id = sst.user_id
   and dwm_video_short_video_watch_consume_ed.dt = sst.dt
 where coalesce(dwm_video_short_video_watch_consume_ed.epis_coin_consume_amount
              , dwm_video_short_video_watch_consume_ed.epis_cert_consume_amount) is not null
;
