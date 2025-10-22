----------------------------------------------------------------
-- 程序功能： BI-短篇孵化自动化小语种翻译收入成本
-- 程序名： P_ads_bi_ss_inc_auto_lcl_trl_rev_cost
-- 目标表： ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost
-- 负责人： xjc
-- 开发日期： 2025-10-21
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost
-- 生效的书籍id
with plans as (
    select codeid
          ,begindate
          ,enddate
          ,sourcechl
      from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
     where isdel = 0
       and projectcode = 1
       and sourcechl != ''
       and enddate > '${dt}'
       and begindate < '${dt}'
)
-- 计算用户成本与收入相关指标
,user_cost_revenue as (
    select sum(a1.devnum)        as devnum
          ,sum(a1.day0amount)    as day0amount
          ,sum(a1.costamount)    as costamount
          ,a1.createtime
          ,a2.bookid
          ,case when a1.sourcechl in ('fbs2s', 'facebook') then 'fb'
                else a1.sourcechl
            end                  as sourcechl
      from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer    as a1
      left join ods.ods_tidb_sharpengine_ads_global_adext                as a2
        on a1.productid = a2.productid
       and a1.adid = a2.adid
      left join ods.ods_tidb_sharpengine_ads_global_FbAccount            as a3
        on a2.fbaccount = a3.account
      join plans                                                         as a4
        on a4.codeid = a2.bookid
       and a4.sourcechl = case when a1.sourcechl in ('fbs2s', 'facebook') then 'fb'
                               else a1.sourcechl
                           end
     where a1.createtime >= a4.begindate
       and a1.createtime <= a4.enddate
       and (a3.fbaccounttype = 0 or a3.fbaccounttype is null)
       and a1.productid in (select product_id
                              from dim.dim_project_product
                             where project_code = 1
                            )
       and a1.sourcechl in ('fbs2s', 'facebook', 'tt')
     group by 4,5,6
)
select a1.createtime                                             as dt                -- 数据创建时间
      ,a1.bookid                                                 as book_id           -- 书籍id
      ,a1.sourcechl                                              as chl_src           -- 渠道来源
      ,(a1.day0amount/ a1.devnum)/ (a1.costamount/ a1.devnum)    as roi               -- 投资回报率
      ,a1.costamount / a1.devnum                                 as cpi               -- 平均注册用户花费数
      ,a1.day0amount / a1.devnum                                 as arpu              -- 日均用户收入
      ,a1.costamount                                             as ttl_amt           -- 总成本
      ,now()                                                     as etl_time          -- etl处理时间
  from user_cost_revenue                                         as a1
;