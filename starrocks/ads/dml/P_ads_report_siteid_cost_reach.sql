insert into ads.ads_report_siteid_cost_reach
select '${dt}'                                     as dt
     , a.siteid
     , a.GradeType
     , a.CostRateTarget / 100                      as CostRateTarget
     , b.cost_reach_rate
     , a.CostRateTarget / 100 - b.cost_reach_rate  as gap
     , b.cost_no_reach
     , b.cost_reach
     , b.total_book_num
     , now()                                       as etl_time
  from ods.ods_tidb_shuangwen_en_viscgradeconfig a
  left join (select t1.site_id
                  , sum(t1.cost_reach)             as cost_reach
                  , sum(t1.cost_no_reach)          as cost_no_reach
                  , count(1)                       as total_book_num
                  , sum(t1.cost_reach) / count(1)  as cost_reach_rate
               from (select t0.dt
                          , t0.product_id
                          , t0.book_id
                          , t0.cost_amt_curmon
                          , t0.amount_curmon
                          , if(t0.amount_curmon > t0.cost_amt_curmon, 1, 0)   as cost_reach
                          , if(t0.amount_curmon <= t0.cost_amt_curmon, 1, 0)  as cost_no_reach
                          , m.site_id
                       from ads.ads_report_cost_income t0
                       left join dim.dim_rule_productid_lang_mapping m
                         on t0.product_id = m.recharge_product_id
                      where t0.dt = '${dt}'
                        and t0.cost_amt_curmon > 0
                        and t0.is_cost_rate = 1
                    )                                as t1
               left join (select concat(bookid, siteid) as book_id
                               , siteid
                            from ods.ods_tidb_shuangwen_tidb_en_viscfocusbookconfig
                           where monthtime = date_format('${dt}', '%Y-%m-01')
                             and delstatus = 0
                             and createtime <= '${dt}'
                         )                                as t2
                 on t1.book_id = t2.book_id
              where t2.book_id is null
              group by t1.site_id
            )                                            as b
    on a.siteid = b.site_id
 where date_format('${bf_1_dt}', '%Y-%m') = date_format(a.MonthTime, '%Y-%m')
;
