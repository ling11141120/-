----------------------------------------------------------------
-- 程序功能： 短篇孵化自动化小语种发起翻译流程调整（即英文书籍累计花费500，d0roi 超过15% 安排进行小语种的翻译并入池
-- 程序名： P_ads_bi_ss_inc_auto_lcl_trl_rev_cost
-- 目标表： ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost
-- 负责人： xjc/chenmo
-- 开发日期： 2025-10-21
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_ss_inc_auto_lcl_trl_rev_cost
with plans as (
    select codeid
          ,begindate
          ,enddate
          ,sourcechl
      from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
     where isdel = 0
       and projectcode = 1
       and sourcechl != ''
       and enddate > now()
       and begindate < now()
)
,ltv as (
    select sum(faliir.devnum)                                              as devnum
          ,sum(faliir.day0amount)                                          as day0amount
          ,sum(faliir.costamount)                                          as costamount
          ,faliir.createtime
          ,ae.bookid
          ,case when faliir.sourcechl in ('fbs2s', 'facebook') then 'fb'
           else faliir.sourcechl
           end                                                             as sourcechl
      from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer      as faliir
      left join ods.ods_tidb_sharpengine_ads_global_adext                  as ae
        on faliir.productid = ae.productid
       and faliir.adid = ae.adid
      left join ods.ods_tidb_sharpengine_ads_global_FbAccount              as fa
        on ae.fbaccount = fa.account
      join plans
        on plans.codeid = ae.bookid
       and plans.sourcechl = case when faliir.sourcechl in ('fbs2s', 'facebook') then 'fb'
                              else faliir.sourcechl
                               end
     where faliir.createtime >= plans.begindate
       and faliir.createtime <= plans.enddate
       and (fa.fbaccounttype = 0 or fa.fbaccounttype is null)
       and faliir.productid in (select product_id
                                   from dim.dim_project_product
                                  where project_code = 1
                                )
       and faliir.sourcechl in ('fbs2s', 'facebook', 'tt')
     group by 4,5,6
)
select createtime                                          as dt
      ,bookid                                              as book_id
      ,sourcechl
      ,(day0amount / devnum) / (costamount / devnum)       as roi
      ,costamount / devnum                                 as cpi
      ,day0amount / devnum                                 as arpu
      ,costamount
      ,now()
from ltv
;