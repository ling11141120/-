----------------------------------------------------------------
-- 程序功能： 短剧ROI涨幅和相关影响指标
-- 程序名： P_ads_sr_series_roi_growth_metrics
-- 目标表： ads.ads_sr_series_roi_growth_metrics
-- 负责人： chenmo
-- 开发日期：2026-06-18
----------------------------------------------------------------

insert into ads.ads_sr_series_roi_growth_metrics
with revenue1 as (
    select current_language2
         , mt
         , source
         , book_id
         , code
         , days
         , days_rank
         , dn
         , amount_d0
         , amount
         , amount_lag
         , max(days) over (partition by concat(book_id)) as days_max
         , min(days) over (partition by concat(book_id)) as days_min
         , inc
      from (select current_language2
                 , mt
                 , source
                 , book_id
                 , code
                 , days_rank
                 , days
                 , dn
                 , amount
                 , lag(amount, 1) over (partition by concat(current_language2, mt, book_id, source, days) order by dn)          as amount_lag
                 , amount / lag(amount, 1) over (partition by concat(current_language2, mt, book_id, source, days) order by dn) as inc
                 , min(ifnull(amount, 0)) over (partition by concat(current_language2, mt, book_id, source, days))              as amount_d0
              from (-- 累计分天收入
                    select a.current_language2
                         , a.mt
                         , case when a.source in('fbs2s', 'tt', 'facebook') then 'ad'
                                when a.source in('fbs2s_dpt', 'tt_dpt') then 'dpt'
                                else a.source
                            end                as source
                         , a.book_id
                         , a.code
                         , a.days_rank
                         , a.days
                         , b.dn
                         , sum(case when b.dn >= a.dn then a.amount end) as amount
                      from ads.ads_sr_series_income_dn as a
                      -- 补dn
                      left join (select dn
                                   from ads.ads_sr_series_income_dn
                                  where current_language2 = 3
                                  group by 1
                                ) as b
                        on 1 = 1
                     group by 1, 2, 3, 4, 5, 6, 7, 8
                   ) as x
           ) as x
     where amount_d0 > 0    -- 剔除 D0收入0
)
-- 英语，天级涨幅
, inc_en as (
    select current_language2
         , mt
         , source
         , dn
         , sum(inc * amount_d0 * pow(0.99, days) * (dn <= days)) / sum(amount_d0 * pow(0.99, days) * (dn <= days)) as inc
      from (-- 按大盘汇总天级收入，投放90天以上的书籍
            select current_language2
                 , mt
                 , source
                 , dn
                 , days
                 , sum(amount_d0)                as amount_d0
                 , sum(amount) / sum(amount_lag) as inc
              from revenue1
             where dn >= 0
               and days_max > 90
               and current_language2 = 3
             group by 1, 2, 3, 4, 5
           ) as x
     group by 1, 2, 3, 4
)
-- 各语言大盘，累计涨幅
, inc_exp as (
    select a.current_language2
         , a.mt
         , a.source
         , a.dn
         , a.amount_d0_days60
         , a.amount_d0
         , a.inc
         , exp(sum(ln(case when ifnull(a.inc, 1) <= 1 then b.inc
                           when abs(1 - a.inc / b.inc) > 0.1 / (1 + ln(if(a.dn = 0, 1, a.dn))) then (b.inc * 0.8 + a.inc * 0.2)
                           else a.inc
                       end
                     )
                  ) over (partition by concat(a.current_language2, a.mt, a.source)
                              order by a.dn rows between unbounded preceding and CURRENT ROW
                         )
              ) as inc_dn
      from (-- 各语言用户涨幅
            select current_language2
                 , mt
                 , source
                 , dn
                 , sum(case when days < 60 then amount_d0 end)              as amount_d0_days60
                 , sum(amount_d0)                                           as amount_d0
                 , sum(inc * amount_d0 * pow(0.99, days) * (dn <= days))
                   / sum(amount_d0 * pow(0.99, days) * (dn <= days))        as inc
              from (-- 按大盘汇总天级收入，投放90天以上的书籍
                    select current_language2
                         , mt
                         , source
                         , dn
                         , days
                         , sum(amount_d0)                as amount_d0
                         , sum(amount) / sum(amount_lag) as inc
                      from revenue1
                     where dn >= 0
                     group by 1, 2, 3, 4, 5
                   ) as x
             group by 1, 2, 3, 4
           ) as a
      -- 英语天级涨幅
      left join inc_en as b
        on a.mt = b.mt
       and a.dn = b.dn
       and a.source = b.source
)
-- 书籍，累计涨幅，暂时不区分媒体
, inc_book as (
    select a.current_language2
         , a.mt
         , a.book_id
         , a.code
         , a.days_max
         , a.source
         , a.dn
         , a.amount_d0_rank28
         , a.amount_d0_days60
         , a.amount_d0
         , a.inc
         , b.inc_dn    as inc_dn_en
         , exp(sum(ln(case when ifnull(a.inc, 1) <= 1 then coalesce(b.inc, c.inc)
                           when abs(1 - a.inc / b.inc) > 0.3 / (1 + ln(if(a.dn = 0, 1, a.dn))) then (b.inc * 0.8 + a.inc * 0.2)
                           else a.inc
                       end
                     )
                  ) over (partition by concat(a.current_language2, a.mt, a.book_id, a.source)
                              order by a.dn rows between unbounded preceding and CURRENT ROW
                         )
              )        as inc_dn
      from (-- 分剧每天涨幅，媒体d0收入
            select current_language2
                 , mt
                 , book_id
                 , code
                 , days_max
                 , source
                 , dn
                 , sum(case when days_rank <= 28 then amount_d0 end)          as amount_d0_rank28
                 , sum(case when days <= 60 then amount_d0 end)               as amount_d0_days60
                 , sum(amount_d0)                                             as amount_d0
                 , sum(inc * amount_d0 * pow(0.98, days_rank) * (dn <= days))
                   / sum(amount_d0 * pow(0.98, days_rank) * (dn <= days))     as inc
              from (-- 分剧涨幅,暂时不区分媒体，媒体差异主要由dpt比例和iaa收入占比来调整
                    select current_language2
                         , mt
                         , book_id
                         , code
                         , source
                         , dn
                         , days
                         , days_rank
                         , days_max
                         , sum(amount_d0)                as amount_d0
                         , sum(amount) / sum(amount_lag) as inc
                      from revenue1
                     where dn >= 0
                       and book_id > 0
                     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
                   ) as x
             group by 1, 2, 3, 4, 5, 6, 7
           ) as a
      -- 各语言天级涨幅
      left join inc_exp as b
        on a.mt = b.mt
       and a.dn = b.dn
       and a.current_language2 = b.current_language2
       and a.source = b.source
    -- 英语天级涨幅，兜底
      left join inc_en as c
        on a.mt = c.mt
       and a.dn = c.dn
       and a.source = c.source
)
-- 3、书籍和终端维度，内容相似性指标(累计数据,最近2个月，如果没有投放，则取最后日花费>100的日期往前推2个月)，仅判断tt和fb用户，
-- 最后投放日期，需要历史全表数据
, last_date as (
    select book_id
         , mt
         , cost_amount
         , cost_7d
         , last_date
         , last_date_w2a
         , roi_0to1
         , roi_0to3
         , roi_0to7
         , sum(cost_amount) over (partition by book_id) as cost_sum
      from (select book_id
                 , mt
                 , sum(cost_amount) as cost_amount
                 , sum(case when days_diff(curdate(), create_time) < 8 then cost_amount end) as cost_7d
                 , max(case when cost_amount > 100 then create_time end) as last_date
                 , max(case when cost_amount_w2a > 100 then create_time end) as last_date_w2a
                 , sum(case when days_diff(curdate(), create_time) >= 2 then d1_amt end) / sum(case when days_diff(curdate(), create_time) >= 2 then d0_amt end) as roi_0to1
                 , sum(case when days_diff(curdate(), create_time) >= 4 then d3_amt end) / sum(case when days_diff(curdate(), create_time) >= 4 then d0_amt end) as roi_0to3
                 , sum(case when days_diff(curdate(), create_time) >= 8 then d7_amt end) / sum(case when days_diff(curdate(), create_time) >= 8 then d0_amt end) as roi_0to7
              from (select b.book_id
                         , a.mt
                         , a.create_time
                         , sum(cost_amount) as cost_amount
                         , sum(case when a.source_chl in('fbs2s', 'tt') then cost_amount end) as cost_amount_w2a
                         , sum(d0_amt)      as d0_amt
                         , sum(d1_amt)      as d1_amt
                         , sum(d3_amt)      as d3_amt
                         , sum(d7_amt)      as d7_amt
                      from (select product_id
                                 , ad_id
                                 , create_time
                                 , mt
                                 , source_chl
                                 , sum(cost_amount)                    as cost_amount
                                 , sum(day0_amount + day0_amount_byad) as d0_amt
                                 , sum(day1_amount + day1_amount_byad) as d1_amt
                                 , sum(day3_amount + day3_amount_byad) as d3_amt
                                 , sum(day7_amount + day7_amount_byad) as d7_amt
                              from ads.ads_advertisement_fbadroiinstallreferrer_view
                             where create_time > days_add(curdate(), -360)
                               and product_id not in(6833, 6883)
                               and source_chl in('fbs2s', 'facebook', 'tt', 'tiktok app')
                             group by 1, 2, 3, 4, 5
                           ) as a
                      join ads.ads_advertisement_adext_view as b
                        on a.product_id = b.product_id
                       and a.ad_id = b.ad_id
                     group by 1, 2, 3
                   ) as x
             group by 1, 2
           ) as xx
)
-- 最后日花费>100的日期，近7天花费，累计花费，
-- 次留率
, rt as (
    select a.book_id
         , a.mt
         , count(distinct concat(a.install_date, a.user_id)) as reg_num
         , count(distinct case when r.user_id is not null then concat(a.install_date, a.user_id) end) as rt_num
         , count(distinct case when r.user_id is not null then concat(a.install_date, a.user_id) end) / count(distinct concat(a.install_date, a.user_id)) as rt_rate
      from (select a.dt
                 , a.md5_key
                 , a.unique_cd_reader_id
                 , a.core
                 , a.user_id
                 , a.product_id
                 , a.source_chl
                 , a.source
                 , a.book_id
                 , a.code
                 , a.current_language2
                 , a.mt
                 , a.install_date
                 , a.ad_id
                 , a.attribute
                 , a.next_time
              from (select dt
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
                         , next_time
                      from ads.ads_sr_user_attribution_info
                     where install_date >= days_add(curdate(), -360)
                       and source in('fbs2s', 'facebook', 'tt')
                       and book_id > 0
                   ) as a
              -- 筛选近2个月
              join last_date as b
                on a.book_id = b.book_id
               and a.mt = b.mt
               and days_diff(b.last_date, a.install_date) < 60
           ) as a
      -- 次留 =次日阅读
      left join (select user_id
                      , product_id
                      , book_id
                      , date(hours_add(create_time, -13)) as dt
                      , min(hours_add(create_time, -13))  as create_time
                      , count(1)                          as reads
                   from ads.ads_read_user_chapter_view
                  where create_time >= days_add(curdate(), -360)
                  group by 1, 2, 3, 4
                ) as r
        on a.user_id = r.user_id
       and a.product_id = r.product_id
       and days_diff(r.dt, date(a.install_date)) = 1
     group by 1, 2
)
-- 书籍维度，new收入占比 & d0 ltv
, new_rate as (
    select book_id
         , reg_num
         , day0_amt
         , reg_num_new
         , day0_amt_new
         , reg_num_ios
         , reg_num_new_ios
         , ios_day0_amt
         , ios_day0_amt_new
         , reg_num_and
         , reg_num_new_and
         , and_day0_amt
         , and_day0_amt_new
         , ios_day0_amt_new / ios_day0_amt                                                                          as ios_newamt_rate
         , and_day0_amt_new / and_day0_amt                                                                          as and_newamt_rate
         , ios_day0_amt_new / reg_num_new_ios / (ios_day0_amt - ios_day0_amt_new) * (reg_num_ios - reg_num_new_ios) as ios_nrate
         , and_day0_amt_new / reg_num_new_and / (and_day0_amt - and_day0_amt_new) * (reg_num_and - reg_num_new_and) as and_nrate
         , ios_day0_amt / reg_num_ios                                                                               as ios_ltv0
         , and_day0_amt / reg_num_and                                                                               as and_ltv0
      from (select e.book_id
                 , sum(reg_num)                         as reg_num
                 , sum(day0_amt)                        as day0_amt
                 , sum(reg_num_new)                     as reg_num_new
                 , sum(day0_amt_new)                    as day0_amt_new
                 , sum(reg_num_ios)                     as reg_num_ios
                 , sum(reg_num_new_ios)                 as reg_num_new_ios
                 , sum(ios_day0_amt)                    as ios_day0_amt
                 , sum(ios_day0_amt_new)                as ios_day0_amt_new
                 , sum(reg_num - reg_num_ios)           as reg_num_and
                 , sum(reg_num_new - reg_num_new_ios)   as reg_num_new_and
                 , sum(day0_amt - ios_day0_amt)         as and_day0_amt
                 , sum(day0_amt_new - ios_day0_amt_new) as and_day0_amt_new
              from (select product_id
                         , ad_id
                         , install_date
                         , reg_num
                         , day0_amt
                         , reg_num_new
                         , day0_amt_new
                         , reg_num_ios
                         , reg_num_new_ios
                         , ios_day0_amt
                         , ios_day0_amt_new
                      from ads.ads_bi_ad_new_user_value_ed
                     where product_id not in (6833, 6883)
                   ) as a
              -- 获取bookid
              join (select distinct ad_id
                         , product_id
                         , book_id
                      from ads.ads_advertisement_adext_view
                   ) as e
                on a.ad_id = e.ad_id
               and a.product_id = e.product_id
        -- 筛选 近60天
              join last_date as b
                on e.book_id = b.book_id
               and days_diff(b.last_date, a.install_date) < 60
             group by 1
           ) as x
)
-- 大盘，dpt收入占比 & new收入占比 & 自然收入占比 & 用户的目标调整,用于new和rmt达标目标调整
, new_rate_sum as (
    select current_language2
         , mt
         , amount_sum
         , inc_ad
         , inc_dpt
         -- new收入占比
         , new_amtrate_sum
         , new0_rate_sum
         -- dpt收入占比
         , dpt0_rate_sum
         , dpt90_rate_sum
         -- 自然收入占比
         , organic_rate0
         , organic_rate90
         -- 用户目标调整值
         , (1 - new0_rate_sum) / 2.8                                                                                                                  as newstd_diff
         -- 仅rmt和new进行平衡，不含dpt
         , (1 - new0_rate_sum) / 2.8 * inc_ad * new0_rate_sum / (inc_ad * greatest(0, (1 - dpt0_rate_sum - new0_rate_sum)) + inc_dpt * dpt0_rate_sum) as oldstd_add
      from (select current_language2
                 , mt
                 , amount_sum
                 , amount_d0
                 , amount_dpt
                 , amount_organic
                 , dpt0_rate_sum
                 , new_amtrate_sum
                 , organic_rate0
                 , inc_ad
                 , inc_dpt
                 , inc_organic
                 -- new/new+rmt+dpt
                 , (1 - dpt0_rate_sum) * new_amtrate_sum                                                                                                        as new0_rate_sum
                 -- D90 dpt收入占比
                 , dpt0_rate_sum * inc_dpt / (inc_ad * (1 - dpt0_rate_sum) + inc_dpt * dpt0_rate_sum)                                                           as dpt90_rate_sum
                 -- D90自然收入占比
                 , organic_rate0 * inc_organic / (organic_rate0 * inc_organic + (1 - organic_rate0) * (dpt0_rate_sum * inc_dpt + inc_ad * (1 - dpt0_rate_sum))) as organic_rate90
              from (select a.current_language2
                         , a.mt
                         , a.amount_sum
                         , a.amount_d0
                         , a.amount_dpt
                         , a.amount_organic
                         , a.amount_dpt / a.amount_d0      as dpt0_rate_sum
                         , case when a.mt = 1 then ios_day0_amt_new / (ios_day0_amt)
                                when a.mt = 4 then and_day0_amt_new / (and_day0_amt)
                                else null
                            end                            as new_amtrate_sum
                         , a.amount_organic / a.amount_sum as organic_rate0
                         , e.inc_ad
                         , e.inc_dpt
                         , e.inc_organic
                      from (select current_language2
                                 , mt
                                 , sum(amount)       as amount_sum
                                 , sum(case when source in ('fbs2s', 'fbs2s_dpt', 'tt', 'tt_dpt') then amount end) as amount_d0
                                 , sum(case when source in ('fbs2s_dpt', 'tt_dpt') then amount end) as amount_dpt
                                 , sum(case when source in ('organic') then amount end) as amount_organic
                              from ads.ads_sr_series_income_dn
                             where days < 90
                               and dn = -1
                             group by 1, 2
                           ) as a
                      -- 大盘new收入占比
                      left join (select e.current_language2
                                      , sum(reg_num)                         as reg_num
                                      , sum(day0_amt)                        as day0_amt
                                      , sum(reg_num_new)                     as reg_num_new
                                      , sum(day0_amt_new)                    as day0_amt_new
                                      , sum(reg_num_ios)                     as reg_num_ios
                                      , sum(reg_num_new_ios)                 as reg_num_new_ios
                                      , sum(ios_day0_amt)                    as ios_day0_amt
                                      , sum(ios_day0_amt_new)                as ios_day0_amt_new
                                      , sum(reg_num - reg_num_ios)           as reg_num_and
                                      , sum(reg_num_new - reg_num_new_ios)   as reg_num_new_and
                                      , sum(day0_amt - ios_day0_amt)         as and_day0_amt
                                      , sum(day0_amt_new - ios_day0_amt_new) as and_day0_amt_new
                                   from (select product_id
                                              , ad_id
                                              , install_date
                                              , reg_num
                                              , day0_amt
                                              , reg_num_new
                                              , day0_amt_new
                                              , reg_num_ios
                                              , reg_num_new_ios
                                              , ios_day0_amt
                                              , ios_day0_amt_new
                                           from ads.ads_bi_ad_new_user_value_ed
                                          where product_id not in (6833, 6883)
                                            and install_date > days_add(curdate(), -60)
                                        ) as a
                                   -- 获取current_language2
                                   join (select distinct current_language2
                                              , product_id
                                              , ad_id
                                           from ads.ads_advertisement_adext_view
                                        ) as e
                                     on a.ad_id = e.ad_id
                                    and a.product_id = e.product_id
                                  group by 1
                                ) as b
                        on a.current_language2 = b.current_language2
                      -- 大盘涨幅
                      left join (select current_language2
                                      , mt
                                      , max(case when source = 'ad' then inc_dn end) as inc_ad
                                      , max(case when source = 'dpt' then inc_dn end) as inc_dpt
                                      , max(case when source = 'organic' then inc_dn end) as inc_organic
                                   from (select current_language2
                                              , mt
                                              , source
                                              , max(case when (current_language2 = 3 and dn = 120) or (current_language2 <> 3 and dn = 90) then inc_dn end) as inc_dn
                                           from inc_exp
                                          where dn in(90, 120)
                                          group by 1, 2, 3
                                        ) as x
                                  group by 1, 2
                                ) as e
                        on a.current_language2 = e.current_language2
                       and a.mt = e.mt
                   ) as x
           ) as xx
)
-- 书籍维度，dpt收入占比
, dpt_rate as (
    select current_language2
         , mt
         , book_id
         , sum(amount)       as amount_d0
         -- 日期加权
         , ifnull(sum((case when source in('fbs2s_dpt', 'tt_dpt') then amount end) * pow(0.99, days)), 0) as amount_dpt
         , ifnull(sum((case when source in('fbs2s_dpt', 'tt_dpt') then amount end) * pow(0.99, days)) / sum(amount * pow(0.99, days)), 0) as dpt0_rate
      from ads.ads_sr_series_income_dn
     where dn = -1
       and source in('fbs2s', 'fbs2s_dpt', 'tt', 'tt_dpt')
     group by 1, 2, 3
)
-- 推广剧首日消费占比
, consume_rate as (
    select a.book_id
         , a.current_language2
         , a.mt
         , sum(case when a.book_id = b.book_id then amount end) as consumes_ad
         , sum(amount)         as consume_sum
      from (select a.product_id
                 , a.user_id
                 , a.book_id
                 , a.current_language2
                 , a.mt
                 , a.install_date
                 , a.next_time
              from ads.ads_sr_user_attribution_info as a
              -- 筛选 近60天
              join last_date as b
                on a.book_id = b.book_id
               and a.mt = b.mt
               and days_diff(b.last_date, a.install_date) < 60
        where a.source in('fbs2s', 'tt', 'facebook', 'tiktok app')
           ) as a
      -- 消费
      left join (select date(hours_add(createtime, -13)) as dt
                      , product_id
                      , user_id
                      , book_id
                      , sum(chapter_num)                 as chapter_num
                      , sum(amount)                      as amount
                      , min(hours_add(createtime, -13))  as consume_time
                   from ads.ads_consume_user_consume_view
                  where dt >= '2023-09-01'
                    and chapter_num > 0
                  group by date(hours_add(createtime, -13)), product_id, user_id, book_id
                ) as b
        on a.product_id = b.product_id
       and a.user_id = b.user_id
       and a.install_date <= b.consume_time
       and b.consume_time <= a.next_time
       and days_diff(b.consume_time, a.install_date) < 1
     group by 1, 2, 3
)
-- 指标关联汇总输出
, r as (
    select current_language2
         , book_id
         , code
         , mt
         , mt2
         , days_max
         , amount_d0
         , amount_d0_days60
         , inc0
         , inc1
         , inc3
         , inc7
         , inc30
         , inc60
         , inc90
         , inc120
         , dpt0_rate
         , cost_sum
         , cost_7d
         , last_date
         , roi_0to1
         , roi_0to3
         , roi_0to7
         , rt_rate
         , new_amt_rate
         , new_amt_rate_dpt
         , nrate
         , ltv0
         , new_amtrate_sum
         , new0_rate_sum
         , dpt0_rate_sum
         , dpt90_rate_sum
         , organic_rate0
         , organic_rate90
         , newstd_diff
         , oldstd_add
         , inc_ad
         , inc_dpt
         , code_stage
         , has_std
         , r0_std
         , r7_std
         , h24_std
         , consume_rate
         , language
         , book_target
         , book_target / if(current_language2 = 3, inc120, inc90)                 as r0_std2
         , book_target / if(current_language2 = 3, inc120, inc90) * inc7          as r7_std2
         , book_target / if(current_language2 = 3, inc120, inc90) * inc0          as h24_std2
         , book_target / if(current_language2 = 3, inc120, inc90) - r0_std        as r0_std_diff
         , book_target / if(current_language2 = 3, inc120, inc90) * inc7 - r7_std as r7_std_diff
      from (select current_language2
                 , book_id
                 , code
                 , mt
                 , mt2
                 , days_max
                 , amount_d0
                 , amount_d0_days60
                 , inc0
                 , inc1
                 , inc3
                 , inc7
                 , inc30
                 , inc60
                 , inc90
                 , inc120
                 , dpt0_rate
                 , cost_sum
                 , cost_7d
                 , last_date
                 , roi_0to1
                 , roi_0to3
                 , roi_0to7
                 , rt_rate
                 , new_amt_rate
                 , new_amt_rate_dpt
                 , nrate
                 , ltv0
                 , new_amtrate_sum
                 , new0_rate_sum
                 , dpt0_rate_sum
                 , dpt90_rate_sum
                 , organic_rate0
                 , organic_rate90
                 , newstd_diff
                 , oldstd_add
                 , inc_ad
                 , inc_dpt
                 , code_stage
                 , has_std
                 , r0_std
                 , r7_std
                 , h24_std
                 , consume_rate
                 , language
                 -- 回本目标，含dpt方案 = 100%-D90自然收入占比 - D90DPT收入占比 * 系数  - （new用户收入占比D90* 新用户降幅 - old用户收入占比D90* 老用户增幅）
                 , (1 - organic_rate90 - 0.6 * dpt0_rate * inc_dpt / (dpt0_rate * inc_dpt + (1 - dpt0_rate) * inc_ad))
                   - inc_ad / (dpt0_rate * inc_dpt + (1 - dpt0_rate) * inc_ad)
                   * (newstd_diff * new_amt_rate_dpt - oldstd_add * (1 - new_amt_rate_dpt)) as book_target
              from (select a.current_language2
                         , a.book_id
                         , a.code
                         , a.mt
                         , a.mt2
                         , a.days_max
                         , a.amount_d0
                         , a.amount_d0_days60
                         , a.inc0
                         , a.inc1
                         , a.inc3
                         , a.inc7
                         , a.inc30
                         , a.inc60
                         , a.inc90
                         , a.inc120
                         , d.dpt0_rate
                         , l.cost_sum
                         , l.cost_7d
                         , l.last_date
                         , l.roi_0to1
                         , l.roi_0to3
                         , l.roi_0to7
                         , r.rt_rate
                         , if(a.mt = 1, n.ios_newamt_rate, n.and_newamt_rate)                   as new_amt_rate
                         , (1 - dpt0_rate) * if(a.mt = 1, n.ios_newamt_rate, n.and_newamt_rate) as new_amt_rate_dpt
                         , if(a.mt = 1, n.ios_nrate, n.and_nrate)                               as nrate
                         , if(a.mt = 1, n.ios_ltv0, n.and_ltv0)                                 as ltv0
                         , n2.new_amtrate_sum
                         , n2.new0_rate_sum
                         , n2.dpt0_rate_sum
                         , n2.dpt90_rate_sum
                         , n2.organic_rate0
                         , n2.organic_rate90
                         , cast(n2.newstd_diff as decimal(8, 4))                                as newstd_diff
                         , cast(n2.oldstd_add  as decimal(8, 4))                                as oldstd_add
                         , n2.inc_ad
                         , n2.inc_dpt
                         , s.code_stage
                         , if(std.r0_std is not null, 1, 0)                                     as has_std
                         , coalesce(std.r0_std, std2.r0_std)                                    as r0_std
                         , coalesce(std.r7_std, std2.r7_std)                                    as r7_std
                         , coalesce(std.h24_std, std2.h24_std)                                  as h24_std
                         , con.consumes_ad / con.consume_sum                                    as consume_rate
                         , upper(pt.abbreviation)                                               as language
                      from (select current_language2
                                 , book_id
                                 , code
                                 , mt
                                 , case when mt = 1 then 'iOS'
                                        when mt = 4 then 'Android'
                                        else 'other'
                                    end                                    as mt2
                                 , days_max
                                 , sum(amount_d0 * (dn = 0))               as amount_d0
                                 , sum(amount_d0_days60 * (dn = 0))        as amount_d0_days60
                                 , max(case when dn = 0 then inc_dn end)   as inc0
                                 , max(case when dn = 1 then inc_dn end)   as inc1
                                 , max(case when dn = 3 then inc_dn end)   as inc3
                                 , max(case when dn = 7 then inc_dn end)   as inc7
                                 , max(case when dn = 30 then inc_dn end)  as inc30
                                 , max(case when dn = 60 then inc_dn end)  as inc60
                                 , max(case when dn = 90 then inc_dn end)  as inc90
                                 , max(case when dn = 120 then inc_dn end) as inc120
                              from inc_book
                             where dn in(-1, 0, 1, 3, 7, 30, 60, 90, 120)
                               and source in('ad')
                               and mt in(1, 4)
                             group by 1, 2, 3, 4, 5, 6
                           ) as a
                      -- dpt占比
                      left join dpt_rate as d
                        on a.book_id = d.book_id
                       and a.mt = d.mt
                      -- 花费和涨幅
                      left join last_date as l
                        on a.book_id = l.book_id
                       and a.mt = l.mt
                      -- 次留率
                      left join rt as r
                        on a.book_id = r.book_id
                       and a.mt = r.mt
                      -- new收入占比
                      left join new_rate as n
                        on a.book_id = n.book_id
                      -- 大盘new占比和 dpt占比
                      left join new_rate_sum as n2
                        on a.current_language2 = n2.current_language2
                       and a.mt = n2.mt
                      -- 书籍阶段，不同媒体取最高阶段
                      left join (select code_id
                                      , max(code_stage) as code_stage
                                   from ads.ads_srsv_ads_marketing_plan_view
                                  where is_del = 0
                                    and project_code = 1
                                    and source_chl = ''
                                  group by 1
                                ) as s
                        on a.book_id = s.code_id
                      -- 分书标准
                      left join (select book_id
                                      , mt
                                      , r0_std
                                      , r7_std
                                      , h24_std
                                   from dwd.dwd_advertisement_book_roi_stdcfg_daily_view
                                  where days_diff(curdate(), date_key) = 1
                                ) as std
                        on a.mt = std.mt
                       and a.book_id = std.book_id
                      -- 大盘标准,按女频标准执行
                      left join (select Current_Language2
                                      , mt
                                      , r0_std
                                      , r7_std
                                      , h24_std
                                   from dwd.dwd_advertisement_put_product_stdcfg_daily_view
                                  where days_diff(curdate(), date_key) = 1
                                    and book_channel = 1
                                ) as std2
                        on a.current_language2 = std2.current_language2
                       and a.mt = std2.mt
                      -- 首日消费占比
                      left join consume_rate as con
                        on a.book_id = con.book_id
                       and a.mt = con.mt
                      -- 投放语言处理
                      left join (select langid
                                      , abbreviation
                                   from dim.DIM_ProductType
                                  where langid is not null
                                ) as pt
                        on a.current_language2 = pt.langid
                   ) as x
           ) as xx
)
-- 书籍结果
select current_language2
     , book_id
     , code
     , mt
     , mt2
     , days_max
     , amount_d0
     , amount_d0_days60
     , inc0
     , inc1
     , inc3
     , inc7
     , inc30
     , inc60
     , inc90
     , inc120
     , dpt0_rate
     , cost_sum
     , cost_7d
     , last_date
     , roi_0to1
     , roi_0to3
     , roi_0to7
     , rt_rate
     , new_amt_rate
     , new_amt_rate_dpt
     , nrate
     , ltv0
     , new_amtrate_sum
     , new0_rate_sum
     , dpt0_rate_sum
     , dpt90_rate_sum
     , organic_rate0
     , organic_rate90
     , newstd_diff
     , oldstd_add
     , inc_ad
     , inc_dpt
     , code_stage
     , has_std
     , r0_std
     , r7_std
     , h24_std
     , consume_rate
     , language
     , book_target
     , r0_std2
     , r7_std2
     , h24_std2
     , r0_std_diff
     , r7_std_diff
     , now()             as etl_time
  from r
 where ifnull(cost_sum, 0) > 1000
   and length(round(inc0)) <= 10
   and length(round(inc1)) <= 10
   and length(round(inc3)) <= 10
   and length(round(inc7)) <= 10
   and length(round(inc30)) <= 10
   and length(round(inc60)) <= 10
   and length(round(inc90)) <= 10
   and length(round(inc120)) <= 10
;
