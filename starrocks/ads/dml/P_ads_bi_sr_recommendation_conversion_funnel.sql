----------------------------------------------------------------
-- 程序功能： 
-- 程序名： P_ads_bi_sr_recommendation_conversion_funnel
-- 目标表： ads.ads_bi_sr_recommendation_conversion_funnel
-- 负责人： 
-- 开发日期：2026-06-01
----------------------------------------------------------------

insert into ads.ads_bi_sr_recommendation_conversion_funnel
with itemexposure as (
    select dt
         , replace(position_type, 'a_', '')                      as position_type
         , if(starts_with(position_type, 'a_'), 0, programme_id) as programme_id
         , case when list_id = 2280001 then 1620001
                when list_id = 1950006 then 1320003
                when list_id = 1170017 then 840004
                when list_id = 2100034 then 1590001
                else if(starts_with(position_type, 'a_'), 0, module_channel_id)
            end                                                  as module_channel_id
         , if(starts_with(position_type, 'a_'), 0, list_id)      as list_id
         , if(starts_with(position_type, 'a_'), activity_id, 0)  as activity_id
         , login_id
         , app_product_id
         , app_core_ver
         , os
         , cnt
      from (select dt
                 , case when element_id = '100363' then 'a_开屏'
                        when element_id = '100390' then 'a_弹窗'
                        when element_id = '100391' then 'a_悬浮窗'
                        when element_id = '100359' then 'a_书城banner'
                        when element_id = '100351' then 'a_底部弹框'
                        when element_id = '100352' then 'a_章末推送'
                        when element_id = '100366' then 'a_书架顶部'
                        when page_id = '10005' and element_id = '100321' and activity_id > 1 then 'a_书架推荐'
                        when element_id = '100358' then 'a_返回推弹窗'
                        when page_id = '10001' and element_id = '100597' then '书城-榜单集合'
                        when page_id = '100364' and element_id = '100597' then '末页推-榜单集合'
                        when page_id = '10006' and element_id = '100141' then '详情页-榜单集合'
                        when element_id in ('100392', '100393') then '推书弹窗'
                        when page_id = '10004' and element_id = '100597' then '搜索页-榜单集合'
                        when page_id = '100648' and element_id = '100597' then 'VIP专题落地页-榜单集合'
                        when page_id = '100774' and element_id = '100597' then '福利中心-榜单集合'
                        else ''
                    end                                                                  as position_type
                 , programme_id
                 , module_channel_id
                 , list_id
                 , activity_id
                 , login_id
                 , app_core_ver
                 , if(app_core_ver = '15' and app_product_id is null, 0, app_product_id) as app_product_id
                 , os
                 , count(1)                                                              as cnt
              from ads.ads_sensors_production_itemexposure_view as b1
             where dt between '${bf_1_dt}'
               and '${dt}'
               and app_core_ver is not null
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
           ) as a1
     where position_type <> ''
)
, itemclick as (
    select dt
         , replace(position_type, 'a_', '')                      as position_type
         , if(starts_with(position_type, 'a_'), 0, programme_id) as programme_id
         , case when list_id = 2280001 then 1620001
                when list_id = 1950006 then 1320003
                when list_id = 1170017 then 840004
                when list_id = 2100034 then 1590001
                else if(starts_with(position_type, 'a_'), 0, module_channel_id)
            end                                                  as module_channel_id
         , if(starts_with(position_type, 'a_'), 0, list_id)      as list_id
         , if(starts_with(position_type, 'a_'), activity_id, 0)  as activity_id
         , login_id
         , cnt
      from (select dt
                 , case when element_id = '100363' then 'a_开屏'
                        when element_id = '100390' then 'a_弹窗'
                        when element_id = '100391' then 'a_悬浮窗'
                        when element_id = '100359' then 'a_书城banner'
                        when element_id = '100351' then 'a_底部弹框'
                        when element_id = '100352' then 'a_章末推送'
                        when element_id = '100366' then 'a_书架顶部'
                        when page_id = '10005' and element_id = '100321' and activity_id > 1 then 'a_书架推荐'
                        when element_id = '100358' then 'a_返回推弹窗'
                        when page_id = '10001' and element_id = '100597' then '书城-榜单集合'
                        when page_id = '100364' and element_id = '100597' then '末页推-榜单集合'
                        when page_id = '10006' and element_id = '100141' then '详情页-榜单集合'
                        when element_id in ('100392', '100393') then '推书弹窗'
                        when page_id = '10004' and element_id = '100597' then '搜索页-榜单集合'
                        when page_id = '100648' and element_id = '100597' then 'VIP专题落地页-榜单集合'
                        when page_id = '100774' and element_id = '100597' then '福利中心-榜单集合'
                        else ''
                    end              as position_type
                 , programme_id
                 , module_channel_id
                 , list_id
                 , activity_id
                 , login_id
                 , count(1)          as cnt
              from ads.ads_sensors_production_itemclick_view as b1
             where dt between '${bf_1_dt}'
               and '${dt}'
               and app_core_ver is not null
             group by 1, 2, 3, 4, 5, 6, 7
           ) as a1
     where position_type <> ''
)
, endreadingchapter as (
    select dt
         , replace(position_type, 'a_', '')                                      as position_type
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[2]) as programme_id
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[3]) as module_channel_id
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[4]) as list_id
         , if(starts_with(position_type, 'a_'), split(activity_link, '_')[4], 0) as activity_id
         , login_id
         , sum(cnt)                                                              as cnt
      from (select dt
                 , case when book_id like '1110000%' then '书城-榜单集合'
                        when split(activity_link, '_')[1] = 'flashscreen' then 'a_开屏'
                        when split(activity_link, '_')[1] = 'popup' then 'a_弹窗'
                        when split(activity_link, '_')[1] = 'netmonitor' then 'a_悬浮窗'
                        when split(activity_link, '_')[1] = 'banner' then 'a_书城banner'
                        when split(activity_link, '_')[1] = 'reading' then 'a_底部弹框'
                        when split(activity_link, '_')[1] = 'chapterpush' then 'a_章末推送'
                        when split(activity_link, '_')[1] = 'topbookshelf' then 'a_书架顶部'
                        when split(activity_link, '_')[1] in ('bookshelf-add', 'bookshelf-add0') then 'a_书架推荐'
                        when split(activity_link, '_')[1] = 'quit-recommend' then 'a_返回推弹窗'
                        when split(activity_link, '_')[1] = 'bookstore' then '书城-榜单集合'
                        when split(activity_link, '_')[1] = 'endchapter' then '末页推-榜单集合'
                        when split(activity_link, '_')[1] = 'bookdetail' then '详情页-榜单集合'
                        when split(activity_link, '_')[1] = 'pushbookpop' then '推书弹窗'
                        when split(activity_link, '_')[1] = 'searchpage' then '搜索页-榜单集合'
                        when split(activity_link, '_')[1] = 'vippage' then 'VIP专题落地页-榜单集合'
                        when split(activity_link, '_')[1] = 'walfarecenter' then '福利中心-榜单集合'
                        else ''
                    end     as position_type
                 , case when book_id like '1110000%' then concat('bookstore_1770001_1890002_2580001_0_', book_id) else activity_link end as activity_link
                 , login_id
                 , count(1) as cnt
              from ads.ads_sensors_production_endreadingchapter_view as b1
             where dt between '${bf_1_dt}'
               and '${dt}'
               and app_core_ver is not null
             group by 1, 2, 3, 4
           ) as a1
     where position_type <> ''
     group by 1, 2, 3, 4, 5, 6, 7
)
, unlockchapter as (
    select dt
         , replace(position_type, 'a_', '')                                      as position_type
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[2]) as programme_id
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[3]) as module_channel_id
         , if(starts_with(position_type, 'a_'), 0, split(activity_link, '_')[4]) as list_id
         , if(starts_with(position_type, 'a_'), split(activity_link, '_')[4], 0) as activity_id
         , login_id
         , sum(unlock_chapter_num)                                               as unlock_chapter_num
         , sum(consume)                                                          as consume
      from (select dt
                 , case when split(activity_link, '_')[1] = 'flashscreen' then 'a_开屏'
                        when split(activity_link, '_')[1] = 'popup' then 'a_弹窗'
                        when split(activity_link, '_')[1] = 'netmonitor' then 'a_悬浮窗'
                        when split(activity_link, '_')[1] = 'banner' then 'a_书城banner'
                        when split(activity_link, '_')[1] = 'reading' then 'a_底部弹框'
                        when split(activity_link, '_')[1] = 'chapterpush' then 'a_章末推送'
                        when split(activity_link, '_')[1] = 'topbookshelf' then 'a_书架顶部'
                        when split(activity_link, '_')[1] in ('bookshelf-add', 'bookshelf-add0') then 'a_书架推荐'
                        when split(activity_link, '_')[1] = 'quit-recommend' then 'a_返回推弹窗'
                        when split(activity_link, '_')[1] = 'bookstore' then '书城-榜单集合'
                        when split(activity_link, '_')[1] = 'endchapter' then '末页推-榜单集合'
                        when split(activity_link, '_')[1] = 'bookdetail' then '详情页-榜单集合'
                        when split(activity_link, '_')[1] = 'pushbookpop' then '推书弹窗'
                        when split(activity_link, '_')[1] = 'searchpage' then '搜索页-榜单集合'
                        when split(activity_link, '_')[1] = 'vippage' then 'VIP专题落地页-榜单集合'
                        when split(activity_link, '_')[1] = 'walfarecenter' then '福利中心-榜单集合'
                        else ''
                    end                                                                          as position_type
                 , activity_link
                 , if(b1.unlock_type = '106', "广告解锁", "非广告解锁")                              as un
                 , identity_login_id                                                             as login_id
                 , length(chapter_ids) - length(replace(chapter_ids, ',', '')) + 1               as unlock_chapter_num
                 , if(coin_consume > 0, coin_consume, 0) + if(gift_consume > 0, gift_consume, 0) as consume
              from ads.ads_sensors_production_unlockchapter_view as b1
             where dt between '${bf_1_dt}'
               and '${dt}'
               and app_core_ver is not null
           ) as a1
     where position_type <> ''
     group by 1, 2, 3, 4, 5, 6, 7
)
select a1.dt                                    as dt
     , a1.app_product_id                        as app_product_id
     , ifnull(a1.app_core_ver, '-99')           as app_core_ver
     , ifnull(a1.os, '-99')                     as os
     , ifnull(a1.position_type, '-99')          as position_type
     , ifnull(a1.programme_id, -99)             as programme_id
     , ifnull(a1.module_channel_id, -99)        as module_channel_id
     , ifnull(a1.list_id, -99)                  as list_id
     , ifnull(a1.activity_id, -99)              as activity_id
     , ifnull(cast(a1.login_id as bigint), -99) as exposure_login_id
     , a9.cd_val_desc                           as product_name
     , scheme_name                              as scheme_name
     , a6.name                                  as module_channel_name
     , a7.name                                  as list_name
     , tactics_name                             as tactics_name
     , coalesce(tactics_name, scheme_name)      as tatics_scheme_name
     , a1.cnt                                   as exposure_cnt
     , a2.login_id                              as click_login_id
     , a2.cnt                                   as click_cnt
     , a3.login_id                              as reading_login_id
     , a3.cnt                                   as reading_chapter_cnt
     , a4.login_id                              as unlockchapter_login_id
     , a4.unlock_chapter_num                    as unlock_chapter_num
     , a4.consume                               as unlockchapter_consume
     , now()                                    as etl_tm
  from itemexposure as a1
  left join itemclick as a2
    on a1.dt = a2.dt
   and a1.position_type = a2.position_type
   and a1.programme_id = a2.programme_id
   and a1.module_channel_id = a2.module_channel_id
   and a1.list_id = a2.list_id
   and a1.activity_id = a2.activity_id
   and a1.login_id = a2.login_id
  left join endreadingchapter as a3
    on a1.dt = a3.dt
   and a1.position_type = a3.position_type
   and a1.programme_id = a3.programme_id
   and a1.module_channel_id = a3.module_channel_id
   and a1.list_id = a3.list_id
   and a1.activity_id = a3.activity_id
   and a1.login_id = a3.login_id
  left join unlockchapter as a4
    on a1.dt = a4.dt
   and a1.position_type = a4.position_type
   and a1.programme_id = a4.programme_id
   and a1.module_channel_id = a4.module_channel_id
   and a1.list_id = a4.list_id
   and a1.activity_id = a4.activity_id
   and a1.login_id = a4.login_id
  left join dim.dim_sr_tag_scheme_management_view as a5
    on a1.programme_id = a5.scheme_id
  left join (select id
                  , name
               from ads.ads_center_book_channel_view
              group by 1, 2
            ) as a6
    on a1.module_channel_id = a6.id
  left join (select id
                  , name
               from ads.ads_center_book_list_view
              group by 1, 2
            ) as a7
    on a1.list_id = a7.id
  left join dim.dim_tag_center_activity_view as a8
    on a1.activity_id = a8.tactics_id
  left join dim.dim_pub_code_mapping_dict as a9
    on a1.app_product_id = a9.cd_val
   and a9.app_plat = 'pub'
   and a9.cd_col = 'product_id'
;
