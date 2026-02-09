create or replace view ads.ads_bi_charge_ltv_view (
    dt                   comment "日期,来自stat_period"
   ,user_period          comment "用户类型 1：新用户 3：rmt(拉活用户)"
   ,product_id           comment "产品id"
   ,which_weeks          comment "第几周"
   ,which_months         comment "第几月"
   ,corever              comment "core"
   ,mt                   comment "终端"
   ,reg_country          comment "国家"
   ,country_level        comment "国家等级"
   ,current_language2    comment "注册语言"
   ,source               comment "3是付费 2是官网  1 是自然和其他 条件：source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3 when source in ('officialsite','(not set)') then 2 else 1"
   ,chl2                 comment "注册时渠道"
   ,chl                  comment "最新渠道"
   ,source_chl           comment "最新引流渠道"
   ,user_ad_source       comment "广告投流用户：0：正常用户，1：vip投流用户"
   ,ecpm_level           comment "ecpm"
   ,book_id              comment "海阅用户归因book_id"
   ,unt                  comment "用户数"
   ,ecpm_unt             comment "ecpm用户数"
   ,pay_user_cnt0        comment "累计前0天付费用户数"
   ,ltv0                 comment "累计前0天付费金额"
   ,pay_user_cnt1        comment "累计前1天付费用户数"
   ,ltv1                 comment "累计前1天付费金额"
   ,pay_user_cnt2        comment "累计前2天付费用户数"
   ,ltv2                 comment "累计前2天付费金额"
   ,pay_user_cnt3        comment "累计前3天付费用户数"
   ,ltv3                 comment "累计前3天付费金额"
   ,pay_user_cnt4        comment "累计前4天付费用户数"
   ,ltv4                 comment "累计前4天付费金额"
   ,pay_user_cnt5        comment "累计前5天付费用户数"
   ,ltv5                 comment "累计前5天付费金额"
   ,pay_user_cnt6        comment "累计前6天付费用户数"
   ,ltv6                 comment "累计前6天付费金额"
   ,pay_user_cnt7        comment "累计前7天付费用户数"
   ,ltv7                 comment "累计前7天付费金额"
   ,pay_user_cnt8        comment "累计前8天付费用户数"
   ,ltv8                 comment "累计前8天付费金额"
   ,pay_user_cnt9        comment "累计前9天付费用户数"
   ,ltv9                 comment "累计前9天付费金额"
   ,pay_user_cnt10       comment "累计前10天付费用户数"
   ,ltv10                comment "累计前10天付费金额"
   ,pay_user_cnt11       comment "累计前11天付费用户数"
   ,ltv11                comment "累计前11天付费金额"
   ,pay_user_cnt12       comment "累计前12天付费用户数"
   ,ltv12                comment "累计前12天付费金额"
   ,pay_user_cnt13       comment "累计前13天付费用户数"
   ,ltv13                comment "累计前13天付费金额"
   ,pay_user_cnt14       comment "累计前14天付费用户数"
   ,ltv14                comment "累计前14天付费金额"
   ,pay_user_cnt15       comment "累计前15天付费用户数"
   ,ltv15                comment "累计前15天付费金额"
   ,pay_user_cnt16       comment "累计前16天付费用户数"
   ,ltv16                comment "累计前16天付费金额"
   ,pay_user_cnt17       comment "累计前17天付费用户数"
   ,ltv17                comment "累计前17天付费金额"
   ,pay_user_cnt18       comment "累计前18天付费用户数"
   ,ltv18                comment "累计前18天付费金额"
   ,pay_user_cnt19       comment "累计前19天付费用户数"
   ,ltv19                comment "累计前19天付费金额"
   ,pay_user_cnt20       comment "累计前20天付费用户数"
   ,ltv20                comment "累计前20天付费金额"
   ,pay_user_cnt21       comment "累计前21天付费用户数"
   ,ltv21                comment "累计前21天付费金额"
   ,pay_user_cnt22       comment "累计前22天付费用户数"
   ,ltv22                comment "累计前22天付费金额"
   ,pay_user_cnt23       comment "累计前23天付费用户数"
   ,ltv23                comment "累计前23天付费金额"
   ,pay_user_cnt24       comment "累计前24天付费用户数"
   ,ltv24                comment "累计前24天付费金额"
   ,pay_user_cnt25       comment "累计前25天付费用户数"
   ,ltv25                comment "累计前25天付费金额"
   ,pay_user_cnt26       comment "累计前26天付费用户数"
   ,ltv26                comment "累计前26天付费金额"
   ,pay_user_cnt27       comment "累计前27天付费用户数"
   ,ltv27                comment "累计前27天付费金额"
   ,pay_user_cnt28       comment "累计前28天付费用户数"
   ,ltv28                comment "累计前28天付费金额"
   ,pay_user_cnt29       comment "累计前29天付费用户数"
   ,ltv29                comment "累计前29天付费金额"
   ,pay_user_cnt30       comment "累计前30天付费用户数"
   ,ltv30                comment "累计前30天付费金额"
   ,pay_user_cnt45       comment "累计前45天付费用户数"
   ,ltv45                comment "累计前45天付费金额"
   ,pay_user_cnt60       comment "累计前60天付费用户数"
   ,ltv60                comment "累计前60天付费金额"
   ,pay_user_cnt90       comment "累计前90天付费用户数"
   ,ltv90                comment "累计前90天付费金额"
   ,pay_user_cnt120      comment "累计前120天付费用户数"
   ,ltv120               comment "累计前120天付费金额"
)
comment "累计付费统计"
as
select a1.dt                                                                                                                 as dt
      ,a1.user_period                                                                                                        as user_period
      ,a1.product_id                                                                                                         as product_id
      ,a1.which_weeks                                                                                                        as which_weeks
      ,a1.which_months                                                                                                       as which_months
      ,a1.corever                                                                                                            as corever
      ,a1.mt                                                                                                                 as mt
      ,a1.reg_country                                                                                                        as reg_country
      ,a1.country_level                                                                                                      as country_level
      ,case when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3311 then 6
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3322 then 5
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3333 then 2
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3366 then 3
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3371 then 7
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3388 then 4
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3501 then 11
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3511 then 12
            when (a1.current_language2 is null or a1.current_language2 = 0) and a1.product_id = 3399 then 9
            else a1.current_language2
        end                                                                                                                  as current_language2
      ,a1.source                                                                                                             as source
      ,a2.chl2                                                                                                               as chl2
      ,a2.chl                                                                                                                as chl
      ,a3.source_chl                                                                                                         as source_chl
      ,a4.user_ad_source                                                                                                     as user_ad_source
      ,case when a5.ecpm >= 0 and a5.ecpm < 1 then '0-1'
            when a5.ecpm >= 1 and a5.ecpm < 5 then '1-5'
            when a5.ecpm >= 5 and a5.ecpm < 10 then '5-10'
            when a5.ecpm >= 10 and a5.ecpm < 20 then '10-20'
            when a5.ecpm >= 20 and a5.ecpm < 30 then '20-30'
            when a5.ecpm >= 30 and a5.ecpm < 40 then '30-40'
            when a5.ecpm >= 40 and a5.ecpm < 50 then '40-50'
            when a5.ecpm >= 50 and a5.ecpm < 100 then '50-100'
            when a5.ecpm >= 100 and a5.ecpm < 200 then '100-200'
            when a5.ecpm >= 200 then '200+'
            else '未知'
        end                                                                                                                  as ecpm_level
      ,a6.tf_book_id                                                                                                         as book_id
      ,count(distinct a1.user_id)                                                                                            as unt
      ,count(distinct a5.user_id)                                                                                            as ecpm_unt
      ,if(datediff(now(), a1.dt) >= 0, count(distinct if(a1.pay_days <= 0 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt0
      ,sum(if(a1.pay_days = 0, a1.ltv, 0))                                                                                   as ltv0
      ,if(datediff(now(), a1.dt) >= 1, count(distinct if(a1.pay_days <= 1 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt1
      ,sum(if(a1.pay_days = 1, a1.ltv, 0))                                                                                   as ltv1
      ,if(datediff(now(), a1.dt) >= 2, count(distinct if(a1.pay_days <= 2 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt2
      ,sum(if(a1.pay_days = 2, a1.ltv, 0))                                                                                   as ltv2
      ,if(datediff(now(), a1.dt) >= 3, count(distinct if(a1.pay_days <= 3 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt3
      ,sum(if(a1.pay_days = 3, a1.ltv, 0))                                                                                   as ltv3
      ,if(datediff(now(), a1.dt) >= 4, count(distinct if(a1.pay_days <= 4 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt4
      ,sum(if(a1.pay_days = 4, a1.ltv, 0))                                                                                   as ltv4
      ,if(datediff(now(), a1.dt) >= 5, count(distinct if(a1.pay_days <= 5 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt5
      ,sum(if(a1.pay_days = 5, a1.ltv, 0))                                                                                   as ltv5
      ,if(datediff(now(), a1.dt) >= 6, count(distinct if(a1.pay_days <= 6 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt6
      ,sum(if(a1.pay_days = 6, a1.ltv, 0))                                                                                   as ltv6
      ,if(datediff(now(), a1.dt) >= 7, count(distinct if(a1.pay_days <= 7 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt7
      ,sum(if(a1.pay_days = 7, a1.ltv, 0))                                                                                   as ltv7
      ,if(datediff(now(), a1.dt) >= 8, count(distinct if(a1.pay_days <= 8 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt8
      ,sum(if(a1.pay_days = 8, a1.ltv, 0))                                                                                   as ltv8
      ,if(datediff(now(), a1.dt) >= 9, count(distinct if(a1.pay_days <= 9 and a1.amount != 0, a1.user_id, null)), null)      as pay_user_cnt9
      ,sum(if(a1.pay_days = 9, a1.ltv, 0))                                                                                   as ltv9
      ,if(datediff(now(), a1.dt) >= 10, count(distinct if(a1.pay_days <= 10 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt10
      ,sum(if(a1.pay_days = 10, a1.ltv, 0))                                                                                  as ltv10
      ,if(datediff(now(), a1.dt) >= 11, count(distinct if(a1.pay_days <= 11 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt11
      ,sum(if(a1.pay_days = 11, a1.ltv, 0))                                                                                  as ltv11
      ,if(datediff(now(), a1.dt) >= 12, count(distinct if(a1.pay_days <= 12 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt12
      ,sum(if(a1.pay_days = 12, a1.ltv, 0))                                                                                  as ltv12
      ,if(datediff(now(), a1.dt) >= 13, count(distinct if(a1.pay_days <= 13 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt13
      ,sum(if(a1.pay_days = 13, a1.ltv, 0))                                                                                  as ltv13
      ,if(datediff(now(), a1.dt) >= 14, count(distinct if(a1.pay_days <= 14 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt14
      ,sum(if(a1.pay_days = 14, a1.ltv, 0))                                                                                  as ltv14
      ,if(datediff(now(), a1.dt) >= 15, count(distinct if(a1.pay_days <= 15 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt15
      ,sum(if(a1.pay_days = 15, a1.ltv, 0))                                                                                  as ltv15
      ,if(datediff(now(), a1.dt) >= 16, count(distinct if(a1.pay_days <= 16 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt16
      ,sum(if(a1.pay_days = 16, a1.ltv, 0))                                                                                  as ltv16
      ,if(datediff(now(), a1.dt) >= 17, count(distinct if(a1.pay_days <= 17 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt17
      ,sum(if(a1.pay_days = 17, a1.ltv, 0))                                                                                  as ltv17
      ,if(datediff(now(), a1.dt) >= 18, count(distinct if(a1.pay_days <= 18 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt18
      ,sum(if(a1.pay_days = 18, a1.ltv, 0))                                                                                  as ltv18
      ,if(datediff(now(), a1.dt) >= 19, count(distinct if(a1.pay_days <= 19 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt19
      ,sum(if(a1.pay_days = 19, a1.ltv, 0))                                                                                  as ltv19
      ,if(datediff(now(), a1.dt) >= 20, count(distinct if(a1.pay_days <= 20 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt20
      ,sum(if(a1.pay_days = 20, a1.ltv, 0))                                                                                  as ltv20
      ,if(datediff(now(), a1.dt) >= 21, count(distinct if(a1.pay_days <= 21 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt21
      ,sum(if(a1.pay_days = 21, a1.ltv, 0))                                                                                  as ltv21
      ,if(datediff(now(), a1.dt) >= 22, count(distinct if(a1.pay_days <= 22 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt22
      ,sum(if(a1.pay_days = 22, a1.ltv, 0))                                                                                  as ltv22
      ,if(datediff(now(), a1.dt) >= 23, count(distinct if(a1.pay_days <= 23 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt23
      ,sum(if(a1.pay_days = 23, a1.ltv, 0))                                                                                  as ltv23
      ,if(datediff(now(), a1.dt) >= 24, count(distinct if(a1.pay_days <= 24 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt24
      ,sum(if(a1.pay_days = 24, a1.ltv, 0))                                                                                  as ltv24
      ,if(datediff(now(), a1.dt) >= 25, count(distinct if(a1.pay_days <= 25 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt25
      ,sum(if(a1.pay_days = 25, a1.ltv, 0))                                                                                  as ltv25
      ,if(datediff(now(), a1.dt) >= 26, count(distinct if(a1.pay_days <= 26 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt26
      ,sum(if(a1.pay_days = 26, a1.ltv, 0))                                                                                  as ltv26
      ,if(datediff(now(), a1.dt) >= 27, count(distinct if(a1.pay_days <= 27 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt27
      ,sum(if(a1.pay_days = 27, a1.ltv, 0))                                                                                  as ltv27
      ,if(datediff(now(), a1.dt) >= 28, count(distinct if(a1.pay_days <= 28 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt28
      ,sum(if(a1.pay_days = 28, a1.ltv, 0))                                                                                  as ltv28
      ,if(datediff(now(), a1.dt) >= 29, count(distinct if(a1.pay_days <= 29 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt29
      ,sum(if(a1.pay_days = 29, a1.ltv, 0))                                                                                  as ltv29
      ,if(datediff(now(), a1.dt) >= 30, count(distinct if(a1.pay_days <= 30 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt30
      ,sum(if(a1.pay_days = 30, a1.ltv, 0))                                                                                  as ltv30
      ,if(datediff(now(), a1.dt) >= 45, count(distinct if(a1.pay_days <= 45 and a1.amount != 0, a1.user_id, null)), null)    as pay_user_cnt45
      ,sum(if(a1.pay_days = 45, a1.ltv, 0))                                                                                  as ltv45
      ,if(datediff(now(), a1.dt) >= 60, count(distinct if(a1.pay_days <= 60 and a1.ltv > 0, a1.user_id, null)), null)        as pay_user_cnt60
      ,sum(if(a1.pay_days = 60, a1.ltv, 0))                                                                                  as ltv60
      ,if(datediff(now(), a1.dt) >= 90, count(distinct if(a1.pay_days <= 90 and a1.ltv > 0, a1.user_id, null)), null)        as pay_user_cnt90
      ,sum(if(a1.pay_days = 90, a1.ltv, 0))                                                                                  as ltv90
      ,if(datediff(now(), a1.dt) >= 120, count(distinct if(a1.pay_days <= 120 and a1.ltv > 0, a1.user_id, null)), null)      as pay_user_cnt120
      ,sum(if(a1.pay_days = 120, a1.ltv, 0))                                                                                 as ltv120
  from ads.ads_trade_user_type_ltv_mid              as a1
  left join dim.dim_short_video_user_accountinfo    as a2
    on a1.product_id = a2.product_id
   and a1.user_id = a2.user_id
  left join (select b1.product_id
                   ,b1.user_id
                   ,b1.last_source    as source_chl
               from (select t.product_id
                           ,t.user_id
                           ,t.last_source
                           ,row_number() over (partition by t.product_id, t.user_id order by t.install_date desc, t.mt asc, t.corever asc, t.lang2 asc)    as rn
                       from dws.dws_user_market_channel_info_detail_td    as t
                      where t.dt = date_sub(current_date(), interval 1 day)
                        and t.product_id in (6833)
                    )    as b1
              where b1.rn = 1
            )                                       as a3
    on a1.product_id = a3.product_id
   and a1.user_id = a3.user_id
  left join dim.dim_user_other_info_view            as a4
    on a1.product_id = a4.product_id
   and a1.user_id = a4.id
  left join (select product_id
                   ,user_id
                   ,dt
                   ,user_period
                   ,corever
                   ,mt
                   ,row_number() over (partition by product_id, user_id, dt, user_period, corever, mt order by ad_type asc)    as rn
                   ,ecpm
               from ads.ads_srsv_user_value_analysis
            )                                       as a5
    on a1.product_id = a5.product_id
   and a1.user_id = a5.user_id
   and a1.dt = a5.dt
   and a1.user_period = a5.user_period
   and a1.corever = a5.corever
   and a1.mt = a5.mt
   and a5.rn = 1
  left join (select id as user_id
                   ,max(book_id) as tf_book_id
               from dim.dim_user_account_info_view
              where book_id is not null
                and book_id !=''
              GROUP BY 1
            )                                       as a6
    on a1.user_id = a6.user_id
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
;
