----------------------------------------------------------------
-- 程序功能： 长篇孵化-书籍评级
-- 程序名： P_ads_book_level_info_df
-- 目标表： ads.ads_book_level_info_df
-- 负责人： xjc
-- 开发日期： 2026-03-13
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_book_level_info_df
with plans as (
    select a1.codeid
          ,a1.beginLength
          ,a1.codestage
          ,a1.planround
          ,a1.publishlength
          ,if(date(a1.EndDate)>='${bf_1_dt}'
             ,datediff('${bf_1_dt}',a1.BeginDate)
             ,datediff(a1.EndDate,a1.BeginDate)
             )                                      as diff_day
          ,a1.SourceChl
          ,if(a1.SourceChl = 'applovin_int',1,0)    as if_al
          ,if(a1.TestStatus = 3,1,0)                as if_stop
          ,a1.BeginDate
          ,a1.EndDate
      from (select b1.codeid
                  ,b1.beginLength
                  ,b1.codestage
                  ,b1.planround
                  ,b1.teststatus
                  ,b1.sourcechl
                  ,b2.publishlength
                  ,b3.BeginDate
                  ,b3.EndDate
                  ,rank() over (partition by b1.codeid order by b1.codestage desc)                                      as rk
                  ,row_number() over(partition by b1.codeid,b1.sourcechl order by b1.codestage desc,b1.EndDate desc)    as rn
              from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    as b1
              join ods.ods_tidb_sharpengine_bi_if_books                    as b2
                on b2.bookid = b1.codeid
              left join (select codeid
                               ,min(BeginDate)    as BeginDate
                               ,max(EndDate)      as EndDate
                           from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
                          group by 1
                        )                                                  as b3
                on b3.codeid = b1.codeid
              join ods.ods_edit_book                                       as b4
                on b4.BookId*1000+lpad(b4.SiteId,3,'0') = b1.codeid
               and b4.IsWashingBook = 1
             where b1.projectcode = 1
               and b1.codeid <> ''
               and b1.sourcechl <> ''
               and b1.isdel = 0
               and b1.codestage <> 4
               and b2.storytype = 0
               and b1.BeginDate<='${bf_1_dt}'
           )    as a1
     where a1.rn=1
       and a1.rk=1
)
, ltv as (
    select a2.bookid
          ,a1.createtime
          ,sum(a1.costamount)    as costamount
      from ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer    as a1
      left join ods.ods_tidb_sharpengine_ads_global_adext                as a2
        on a1.productid = a2.productid
       and a1.adid = a2.adid
      left join ods.ods_tidb_sharpengine_ads_global_FbAccount            as a3
        on a2.fbaccount = a3.account
      join (select codeid
              from plans
             group by 1
           )                                                             as a4
        on a4.codeid = a2.bookid
      join ods.ods_ad_sharpengine_ads_global_ProjectProduct              as a5
        on a1.productid = a5.productid
       and a5.projectcode = 1
     where a1.createtime <= '${bf_1_dt}'
       and a1.createtime >= date_sub('${bf_1_dt}', interval 6 day)
       and (a3.fbaccounttype = 0 or a3.fbaccounttype is null)
     group by 1, 2
)
, avgltv as (
    select
        bookid
       ,avg(costamount)    as AvgCostAmount
    from ltv 
   group by 1
)
, book_level as (
    select a1.bookid
          ,a1.AvgCostAmount
          ,a2.beginLength
          ,a2.CodeStage
          ,a2.Planround
          ,a2.if_al
          ,a2.if_stop
          ,a2.PublishLength
          ,a2.SourceChl
          ,case when a2.CodeStage=3 and a1.AvgCostAmount<50 and a2.PublishLength>300000 then '3-D'
                when a2.CodeStage=3 and a1.AvgCostAmount>5000  then '3-S'
                when a2.CodeStage=3 and a1.AvgCostAmount>1000  then '3-A'
                when a2.CodeStage=3 and a1.AvgCostAmount>500  then '3-B'
                when a2.CodeStage=3 and a1.AvgCostAmount<=500  then '3-C'
                when a2.CodeStage=2 and a2.if_al=1 and a2.if_stop=1  then '2-D'
                when a2.CodeStage=2 and a1.AvgCostAmount>1000  then '2-A'
                when a2.CodeStage=2 and a1.AvgCostAmount>500  then '2-B'
                when a2.CodeStage=2 and a1.AvgCostAmount<=500  then '2-C'
                when a2.CodeStage=1 and a2.if_al=1 and a2.if_stop=1  then '1-D'
                when a2.CodeStage=1 and  a2.if_stop=0 then '1-B'
                else '其他'
                end    as book_level
    from avgltv    as a1
    join plans     as a2
      on a1.bookid = a2.codeid
)
select '${bf_1_dt}'
      ,substr(a1.bookid,1,length(a1.bookid)-3)    as book_id       -- 书籍id
      ,substr(a1.bookid,-3)                       as site_id       -- 语言id
      ,a1.book_level                              as book_level    -- 书籍等级
      ,now()                                      as etl_tm        -- 清洗时间
  from (select bookid
              ,book_level
              ,row_number()over (partition by bookid order by case when book_level='3-D' then 1
                                                                   when book_level='3-S' then 2
                                                                   when book_level='3-A' then 3
                                                                   when book_level='3-B' then 4
                                                                   when book_level='3-C' then 5
                                                                   when book_level='2-D' then 6
                                                                   when book_level='2-A' then 7
                                                                   when book_level='2-B' then 8
                                                                   when book_level='2-C' then 9
                                                                   when book_level='1-D' then 10
                                                                   when book_level='1-B' then 11
                                                                   else 12
                                                               end
                                )    as rn
          from book_level
       )    as a1
 where rn=1
;