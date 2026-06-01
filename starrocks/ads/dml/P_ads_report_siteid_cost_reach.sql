----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_siteid_cost_reach
-- workflow_version : 3
-- create_user      : zhengtt
-- task_name        : ads_report_siteid_cost_reach
-- task_version     : 3
-- update_time      : 2026-05-21 16:40:40
-- sql_path         : \starrocks\tbl_ads_report_siteid_cost_reach\ads_report_siteid_cost_reach
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_siteid_cost_reach
select '${dt}'                                           as dt
     , a.siteid
     , a.GradeType
     , a.CostRateTarget / 100                            as CostRateTarget
     , b.cost_reach_rate
     , a.CostRateTarget / 100 - b.cost_reach_rate        as gap
     , b.cost_no_reach
     , b.cost_reach
     , b.total_book_num
     , now()                                             as etl_time
  from ods.ods_tidb_shuangwen_en_viscgradeconfig         as a
  left join (
      select t1.site_id
           , sum(t1.cost_reach)                          as cost_reach
           , sum(t1.cost_no_reach)                       as cost_no_reach
           , count(1)                                    as total_book_num
           , sum(t1.cost_reach) / count(1)               as cost_reach_rate
        from (
            select dt
                 , product_id
                 , book_id
                 , cost_amt_curmon
                 , amount_curmon
                 , if(amount_curmon > cost_amt_curmon, 1, 0)  as cost_reach
                 , if(amount_curmon <= cost_amt_curmon, 1, 0) as cost_no_reach
                 , m.site_id
              from ads.ads_report_cost_income               as t0
              left join dim.dim_rule_productid_lang_mapping as m
                on t0.product_id = m.recharge_product_id
             where dt = '${dt}'
               and cost_amt_curmon > 0
               and is_cost_rate = 1
           )                                                as t1
        left join (
            select concat(bookid, siteid)                   as book_id
                 , siteid
              from ods.ods_tidb_shuangwen_tidb_en_viscfocusbookconfig
             where monthtime = date_format('${dt}', '%Y-%m-01')
               and delstatus = 0
               and createtime <= '${dt}'
           )                                                as t2
          on t1.book_id = t2.book_id
        left join dim.dim_shuangwen_book_read_consume_info  as t3
          on t1.book_id = t3.book_id
        where t2.book_id is null
         and t3.font_length >= 100000
       group by t1.site_id
     )                                                      as b
    on a.siteid = b.site_id
 where date_format('${bf_1_dt}', '%Y-%m') = date_format(a.MonthTime, '%Y-%m')
;
