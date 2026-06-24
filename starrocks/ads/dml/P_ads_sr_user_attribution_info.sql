----------------------------------------------------------------
-- 程序功能： 海剧全归因用户归因明细
-- 程序名： P_ads_sr_user_attribution_info
-- 目标表： ads.ads_sr_user_attribution_info
-- 负责人： chenmo
-- 开发日期：2026-06-18
----------------------------------------------------------------

insert into ads.ads_sr_user_attribution_info
-- 底表1、补充再归因逻辑，归因明细
with unique_id as (
    select unique_cdreader_id
         , product_id
         , corever2
         , min(create_time) as create_time
         , max(id)          as user_id
      from dim.dim_user_account_info_view
     group by 1, 2, 3
)
-- dpt明细
, q_install as (
    select qq1.unique_cd_reader_id
         , if(ifnull(qq1.user_id, 0) < 10, qq2.user_id, qq1.user_id) as user_id
         , qq1.product_id
         , qq1.source
         , qq1.book_id
         , qq1.current_language2
         , qq1.mt
         , qq1.ad_id
         , qq1.core
         , qq2.create_time                                          as reg_time
         , min(install_date)                                        as install_date
      from (-- dpt
            select q1.unique_cd_reader_id
                 , q1.mt
                 , q1.source
                 , q1.book_id
                 , q1.product_id
                 , q1.user_id
                 , q1.current_language2
                 , q1.trace_id
                 , q1.ad_id
                 , q1.install_date
                 , q1.core
              from (select unique_cd_reader_id
                         , mt
                         , source
                         , book_id
                         , product_id
                         , user_id
                         , current_language2
                         , trace_id
                         , ad_id
                         , install_date
                         , core
                      from ads.ads_advertisement_if_user_attribution_queue_view
                     where date(install_date) >= '${bf_3_dt}'
                       and Product_Id not in (6833, 6883)
                       and source in ('fbs2s', 'tt')
                       and ifnull(desc_info, '') = ''
                   ) as q1
              -- 剔除已归因
              left join (select distinct unique_cdreaderid
                               , core
                               , install_date
                           from ads.ads_user_install_info_view
                          where dt >= '${bf_7_dt}'
                            and Product_Id not in (6833, 6883)
                            and source in ('fbs2s', 'facebook', 'adwords', 'appleadservice', 'tiktok app', 'tt')
                            and isdelete = 0
                         ) as q2
                on q1.unique_cd_reader_id = q2.unique_cdreaderid
               and q1.core = q2.core
               and days_diff(q1.install_date, q2.install_date) < 1
               and days_diff(q1.install_date, q2.install_date) > -1
             where q2.unique_cdreaderid is null
          ) as qq1
      -- user_id 补缺
      left join unique_id as qq2
        on qq1.unique_cd_reader_id = qq2.unique_cdreader_id
       and qq1.core = qq2.corever2
       and qq1.product_id = qq2.product_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- 阅读_流失
, q_read as (
    select q.unique_cd_reader_id
         , q.product_id
         , q.user_id
         , q.source
         , q.book_id
         , q.current_language2
         , q.mt
         , q.install_date
         , q.reg_time
         , q.ad_id
         , q.core
         , ifnull(max(r.create_time), '1990-01-01')                                          as loss_time    -- 流失时间
         , ifnull(max(case when q.book_id = r.book_id then r.create_time end), '1990-01-01') as ad_loss_time -- 广告书流失时间
      from q_install as q
      left join (select user_id
                      , product_id
                      , book_id
                      , date(hours_add(create_time, -13)) as dt
                      , min(create_time)                  as create_time
                   from ads.ads_read_user_chapter_view
                  where create_time >= date_sub('${bf_3_dt}', interval 60 day)
                  group by 1, 2, 3, 4
                ) as r
        on q.user_id = r.user_id
       and q.product_id = r.product_id
       and q.install_date > r.create_time
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
-- 历史解锁 & 24H解锁
, q_unlock as (
    select q.unique_cd_reader_id
         , q.user_id
         , q.product_id
         , q.source
         , q.book_id
         , q.current_language2
         , q.mt
         , q.install_date
         , q.reg_time
         , q.loss_time
         , q.ad_loss_time
         , q.ad_id
         , q.core
         , max(case when q.install_date > u.create_time then u.create_time end) as unlock_time   -- bf是否历史解锁
         , max(case when q.install_date <= u.create_time then 1 end)            as is_24h_unlock -- af24h内解锁
      from q_read as q
      left join (select product_id
                      , user_id
                      , book_id
                      , date(hours_add(createtime, -13)) as dt
                      , min(createtime)                  as create_time
                   from ads.ads_consume_user_consume_view
                  where dt >= date_sub('${bf_3_dt}', interval 60 day)
                    and chapter_num > 0
                  group by 1, 2, 3, 4
                ) as u
        on q.user_id = u.user_id
       and q.book_id = u.book_id
       and days_diff(u.create_time, q.install_date) < 1
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
-- 所有归因记录，new+rmt+dpt+自然新增
, user_attribute as (
    -- DPT,符合归因判断
    select x.unique_cd_reader_id
         , x.user_id
         , x.product_id
         , x.source
         , x.book_id
         , x.current_language2
         , x.mt
         , x.install_date
         , x.reg_time
         , x.ad_id
         , x.core
         , x.attribute
      from (select unique_cd_reader_id
                 , user_id
                 , product_id
                 , source
                 , book_id
                 , current_language2
                 , mt
                 , install_date
                 , reg_time
                 , ad_id
                 , core
                 , case when unlock_time is null and days_diff(install_date, ifnull(loss_time, '2050-01-01')) >= 7 and is_24h_unlock = 1 then 3
                        when days_diff(install_date, ifnull(loss_time, '2050-01-01')) > 30 then 5
                        else -1
                    end as attribute
              from q_unlock
           ) as x
     where attribute > 0
     union all
    -- 有渠道记录前自然用户
    select info.unique_cdreader_id as unique_cdreader_id
         , id                      as user_id
         , info.product_id         as product_id
         , 'none'                  as source
         , 0                       as book_id
         , current_language2       as current_language2
         , mt2                     as mt
         , create_time             as install_date
         , create_time             as reg_time
         , '0'                     as ad_id
         , corever2                as core
         , 1                       as attribute
      from (select unique_cdreader_id
                 , id
                 , product_id
                 , current_language2
                 , mt2
                 , create_time
                 , corever2
              from dim.dim_user_account_info_view
             where create_time > '${bf_3_dt}'
           ) as info
      -- 渠道最早记录
      left join (select unique_cd_reader_id
                      , core
                      , product_id
                      , min(install_date) as install_date
                   from ads.ads_advertisement_if_user_attribution_queue_view
                  where install_date >= date_sub('${bf_3_dt}', interval 60 day)
                    and Product_Id not in (6833, 6883)
                  group by 1, 2, 3
                ) as s
        on info.unique_cdreader_id = s.unique_cd_reader_id
       and info.corever2 = s.core
       and info.product_id = s.product_id
     where hours_diff(ifnull(s.install_date, '2050-01-01'), info.create_time) > 1
     union all
    -- new+rmt
    select qq1.unique_cdreaderid                                     as unique_cd_reader_id
         , if(ifnull(qq1.user_id, 0) < 10, qq2.user_id, qq1.user_id) as user_id
         , qq1.product_id                                            as product_id
         , qq1.source                                                as source
         , qq1.book_id                                               as book_id
         , qq1.current_language2                                     as current_language2
         , qq1.mt                                                    as mt
         , qq1.install_date                                          as install_date
         , qq2.create_time                                           as reg_time
         , qq1.ad_id                                                 as ad_id
         , qq1.core                                                  as core
         , 1                                                         as attribute
      from (select unique_cdreaderid
                 , user_id
                 , product_id
                 , source
                 , book_id
                 , current_language2
                 , mt
                 , install_date
                 , ad_id
                 , core
              from ads.ads_user_install_info_view
             where dt >= '${bf_3_dt}'
               and Product_Id not in (6833, 6883)
               and isdelete = 0
               and unique_cdreaderid is not null
           ) as qq1
      -- userid空补缺
      left join unique_id as qq2
        on qq1.unique_cdreaderid = qq2.unique_cdreader_id
       and qq1.core = qq2.corever2
       and qq1.product_id = qq2.product_id
)
-- 下一次归因，注册语言处理,时区改西五区，媒体值处理1，core1
select date(install_date) as dt
     , md5(concat(unique_cd_reader_id,core,
                  if(user_id is null, -99, user_id), product_id, source_chl, source, book_id,
                  if(code is null, -99, code), current_language2,
                  if(mt is null, -99, mt), install_date,
                  if(ad_id is null, -99, ad_id), attribute
                 )
          )               as md5_key
     , unique_cd_reader_id
     , core
     , user_id
     , product_id
     , source_chl
     , source
     , book_id
     , code
     , current_language2
     , mt
     , install_date
     , ad_id
     , attribute
     , next_time
     , now()              as etl_time
  from (select a1.unique_cd_reader_id
             , a1.core
             , a1.user_id
             , a1.product_id
             , a1.source                                           as source_chl
             , case when attribute = 1 and a1.source in ('fbs2s', 'facebook', 'tt', 'adwords') then a1.source
                    when attribute > 1 and a1.source in ('fbs2s', 'tt') then concat(a1.source, '_dpt')
                    when attribute > 1 then 'dpt'
                    when attribute = 1 and a1.source in ('none', 'organic', '(not set)', 'officialsite') then 'organic'
                    else 'other_ad'
                end                                                as source
             , a1.book_id
             , s.book_code                                         as code
             , coalesce(s.languageid, a1.current_language2)        as current_language2
             , a1.mt
             , hours_add(a1.install_date, -13)                     as install_date
             , hours_add(least(a1.reg_time, a1.install_date), -13) as reg_time
             , a1.ad_id
             , a1.attribute
             , lead(hours_add(a1.install_date, -13), 1, '2050-01-01')
               over (partition by product_id, user_id
                         order by hours_add(a1.install_date, -13)
                    )                                              as next_time
        from user_attribute as a1
        left join (select book_id
                        , languageid
                        , book_code
                     from dim.dim_shuangwen_book_read_consume_info
                    group by 1, 2, 3
                  ) as s
          on a1.book_id = s.book_id
       ) as x
 where minutes_diff(next_time, install_date) > 1
;

-- SQL语句
insert into ads.ads_sr_user_attribution_info
select dt
     , md5_key
     , unique_cd_reader_id
     , core
     , user_id
     , product_id
     , source_chl
     , source
     , book_id
     , code
     , current_language2
     , mt
     , install_date
     , ad_id
     , attribute
     , lead(install_date, 1, '2050-01-01') over (partition by product_id, user_id order by install_date, md5_key) as next_time
     , etl_tm
  from ads.ads_sr_user_attribution_info
;
