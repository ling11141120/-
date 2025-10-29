----------------------------------------------------------------
-- 程序功能： 海阅用户权益状态表
-- 程序名： P_ads_bi_sr_usr_ben_statu.sql
-- 目标表： ads.ads_bi_sr_usr_ben_statu
-- 负责人： wx
-- 开发日期： 2025-10-27
-- 版本号： v0.0.0
----------------------------------------------------------------
insert into ads.ads_bi_sr_usr_ben_statu(
     dt                 -- 日期
    ,user_id            -- 用户id
    ,ben_type           -- 权益类型
    ,ben_type_name      -- 权益类型名称
    ,rel_ord            -- 关联订单
    ,ben_ocr_tm         -- 权益生效时间
    ,ben_end_tm         -- 权益失效时间
    ,h_alc_amt          -- 每小时分摊金额
    ,ulk_chap_num       -- 解锁章节字数
)
with base_data as (
    select user_id
          ,order_id
          ,shop_item
          ,group_concat(distinct order_id)    as rel_ord
          ,min(create_time)                   as ben_ocr_tm
          ,max(if(vipexpire_time = -99,vipexpire_time2,vipexpire_time)) as ben_end_tm
          ,max(item_count)                    as item_count
      from (select user_id
                  ,order_id
                  ,shop_item
                  ,create_time
                  ,vipexpire_time
                  ,item_count
                  ,case when get_json_object(sensorsdata,'$.subscription_period') = 1 then date_add(create_time,7)
                        when get_json_object(sensorsdata,'$.subscription_period') = 2 then add_months(create_time,1)
                        when get_json_object(sensorsdata,'$.subscription_period') = 3 then add_months(create_time,3)
                        when get_json_object(sensorsdata,'$.subscription_period') = 4 then add_months(create_time,12)
                        when get_json_object(sensorsdata,'$.subscription_period') = 5 then date_add(create_time,get_json_object(sensorsdata,'$.subscription_num') )
                        else vipexpire_time
                    end   as vipexpire_time2
              from ads.ads_trade_user_payorder_view
             where shop_item in (810, 840, 850)
           )    as a1
     group by 1, 2 ,3
)
, chapter_words as (
    select dt
          ,identity_login_id         as user_id
          ,sum(a2.chapter_length)    as ulk_chap_num
      from ads.ads_sensors_production_unlockchapter_view    as a1
      left join ods.ods_edit_shuangwen_chapter              as a2
        on a1.book_id = (a2.book_id*1000+site_id)
       and get_json_object(a1.chapter_ids, '$[0]') = a2.chapter_id
     where unlock_type in (103,104)
       and dt = '${bf_1_dt}'
     group by 1, 2
)

select a1.datestr      as dt
      ,a2.user_id
      ,a2.shop_item    as ben_type
      ,case when a2.shop_item = 810 then 'svip'
            when a2.shop_item = 840 then '新福利包'
            when a2.shop_item = 850 then 'vip'
            else '0'
        end    as ben_type_name
      ,a2.rel_ord
      ,a2.ben_ocr_tm
      ,a2.ben_end_tm
      ,case when a1.datestr = date_format(a2.ben_ocr_tm, '%Y-%m-%d') then
                 (a2.item_count / ceil(date_diff('minute', a2.ben_end_tm, a2.ben_ocr_tm) / 60)) * ceil(date_diff('minute', date_add(a1.datestr, 1), a2.ben_ocr_tm) / 60)
            when a1.datestr = date_format(a2.ben_end_tm, '%Y-%m-%d') then
                 (a2.item_count / ceil(date_diff('minute', a2.ben_end_tm, a2.ben_ocr_tm) / 60)) * ceil(date_diff('minute', a2.ben_end_tm, date_trunc('day', a2.ben_end_tm)) / 60)
            else (a2.item_count / ceil(date_diff('minute', a2.ben_end_tm, a2.ben_ocr_tm) / 60)) * 24
        end as h_alc_amt
      ,a3.ulk_chap_num
  from dim.dim_date          as a1
 inner join base_data        as a2
    on a1.datestr = '${bf_1_dt}'
   and a1.datestr between date_format(a2.ben_ocr_tm, '%Y-%m-%d')
   and date_format(a2.ben_end_tm, '%Y-%m-%d')
  left join chapter_words    as a3
    on a2.user_id = a3.user_id
   and a1.datestr = a3.dt
 where a1.datestr = '${bf_1_dt}'
