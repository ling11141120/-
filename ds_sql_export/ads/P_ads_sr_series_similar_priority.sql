----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_series_similar_priority
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sr_series_similar_priority
-- task_version     : 3
-- update_time      : 2024-12-17 15:56:01
-- sql_path         : \starrocks\tbl_ads_sr_series_similar_priority\ads_sr_series_similar_priority
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_series_similar_priority
select
    book_id,
    mt,
    book_code2,
    days_max2,
    cost_sum2,
    roi_0to1_2,
    roi_0to3_2,
    roi_0to7_2,
    std_r0to7,
    std_r7to90,
    dpt0_rate2,
    new_amt_rate_dpt2,
    rt_rate2,
    ltv0_2,
    consume_rate_2,
    r0_std2,
    r7_std2,
    roi_0to1_diff,
    roi_0to3_diff,
    roi_0to7_diff,
    std_r0to7_diff,
    std_r7to90_diff,
    new_amt_rate_dpt_diff,
    dpt0_rate_diff,
    rt_rate_diff,
    ltv0_diff,
    consume_rate_diff,
    score,
    rn,
    now() as etl_time
from (
    select
        book_id,mt,book_code2,days_max2,cost_sum2,roi_0to1_2,roi_0to3_2,roi_0to7_2,std_r0to7,std_r7to90,dpt0_rate2,new_amt_rate_dpt2,rt_rate2,ltv0_2,consume_rate_2,r0_std2,r7_std2
        ,roi_0to1_diff,roi_0to3_diff,roi_0to7_diff,std_r0to7_diff,std_r7to90_diff,new_amt_rate_dpt_diff,dpt0_rate_diff,rt_rate_diff,ltv0_diff,consume_rate_diff,score
        ,row_number() over(partition by concat(book_id,mt) order by score) as rn
    from (
        select
            a.book_id
            ,a.mt
            ,concat('【',b.language,'-',b.code,'】',b.book_id) as book_code2
            ,b.days_max as days_max2
            ,b.cost_sum as cost_sum2
            ,b.roi_0to1 as roi_0to1_2
            ,b.roi_0to3 as roi_0to3_2
            ,b.roi_0to7 as roi_0to7_2
            ,b.r7_std/b.r0_std as std_r0to7
            ,b.book_target/b.r7_std  as std_r7to90
            ,b.dpt0_rate as dpt0_rate2
            ,b.new_amt_rate_dpt as new_amt_rate_dpt2
            ,b.rt_rate as rt_rate2
            ,b.ltv0 as ltv0_2
            ,b.consume_rate as consume_rate_2
            ,b.r0_std as r0_std2
            ,b.r7_std as r7_std2
            -- 对比数据
            ,a.roi_0to1 - b.roi_0to1 as roi_0to1_diff
            ,a.roi_0to3 - b.roi_0to3 as roi_0to3_diff
            ,a.roi_0to7 - b.roi_0to7 as roi_0to7_diff
            ,a.r7_std2/a.r0_std2 - b.r7_std/b.r0_std as std_r0to7_diff
            ,a.book_target/a.r7_std2 - b.book_target/b.r7_std as std_r7to90_diff
            ,a.new_amt_rate_dpt - b.new_amt_rate_dpt as new_amt_rate_dpt_diff
            ,a.dpt0_rate-b.dpt0_rate as dpt0_rate_diff
            ,a.rt_rate - b.rt_rate as rt_rate_diff
            ,a.ltv0 - b.ltv0 as ltv0_diff
            ,a.consume_rate - b.consume_rate as consume_rate_diff
            -- 相似度系数
            ,abs((15*(abs(a.inc1-b.inc1)+abs(a.roi_0to1-b.roi_0to1)) + 10*(abs(a.inc3-b.inc3)+abs(a.roi_0to3-b.roi_0to3)) + 7*(abs(a.inc7-b.inc7)+abs(a.roi_0to7-b.roi_0to7)))/3
                    + 20*abs(a.rt_rate-b.rt_rate)
                    + 0.2*abs(a.ltv0-b.ltv0)
                    + 2*abs(a.consume_rate-b.consume_rate)) as score
        from (
            select
                current_language2,book_id,mt,roi_0to1,roi_0to3,roi_0to7,r7_std2,r0_std2,book_target,new_amt_rate_dpt,dpt0_rate,rt_rate,ltv0,consume_rate,inc1,inc3,inc7
            from ads.ads_sr_series_roi_growth_metrics
        ) a
        -- 有标准的剧
        left join (
            select
                current_language2,book_id,mt,language,code,days_max,cost_sum,roi_0to1,roi_0to3,roi_0to7,r7_std,book_target,dpt0_rate,new_amt_rate_dpt,rt_rate,ltv0,consume_rate,r0_std,inc1,inc3,inc7
            from ads.ads_sr_series_roi_growth_metrics
            where has_std = 1
        ) b on a.current_language2 = b.current_language2 and a.mt=b.mt and a.book_id<>b.book_id
        where b.book_id is not null
    ) x
) xx
where rn<=5;
