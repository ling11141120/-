-------------------------------------------------
-- 应用报表：海剧-短剧维度报表/每日广告基建上限（海剧）
-------------------------------------------------

with z1 as (
    select product
         , source2
         , code_id
         , begin_date
         , code_stage
         , test_status
         , min(cycle_n)                 as cycle_min
         , max_by(spend, 1 / cycle_n)   as spend
         , max_by(d0_amt, 1 / cycle_n)  as d0_amt
         , max_by(std_amt, 1 / cycle_n) as std_amt
      from (select product
                 , source2
                 , code_id
                 , code_stage
                 , test_status
                 , if(source2 in ('adwords'), first_time, begin_date)                             as begin_date
                 , ceiling(days_diff(dt, if(source2 in ('adwords'), first_time, begin_date)) / 7) as cycle_n
                 , sum(spend)                                                                     as spend
                 , sum(d0_amt)                                                                    as d0_amt
                 , sum(std_amt)                                                                   as std_amt
              from (select *
                         , min(dt) over (partition by concat(product, source2, code_id)) as first_time
                      from (select dt
                                 , product
                                 , source2
                                 , code_id
                                 , code_stage
                                 , test_status
                                 , begin_date
                                 , sum(spend)   as spend
                                 , sum(d0_amt)  as d0_amt
                                 , sum(std_amt) as std_amt
                              from ads.ads_srsv_bi_ad_optimizer_spend_data
                             where source2 in ('adwords') or code_stage > 1
                             group by 1, 2, 3, 4, 5, 6, 7
                           ) x
                   ) xx
             group by 1, 2, 3, 4, 5, 6, 7
            ) xxx
     where source2 in ('adwords')
        or (cycle_n > 1 and d0_amt / std_amt < 0.85)
     group by 1, 2, 3, 4, 5, 6
)
select date_add(dt, 1)                         as `DT+1`
     , z0.*
     , concat(round(总new占比*100, 2), '%')     as 总new占比2
     , case when 是否补位 = 0 then '有基建'
            when 是否补位 = 1 and ifnull(兜底书籍,1) = 1 then '兜底基建'
            else '新增席位'
        end                                    as `是否补位_`
     , concat(current_language,'-', book_code) as item_info
     ,if(z0.dt > date_add(z1.begin_date,7*cycle_min),'花费上限','基建上限' ) as 控本类型
  from ads.ads_srsv_bi_ad_optimizer_target_data_result z0
  left join z1
    on z0.product = z1.product
   and z0.source2 = z1.source2
   and z0.code_id = z1.code_id
   and (z0.source2 in ('adwords') or z0.code_stage = z1.code_stage)
 where date_add(dt, 1) = '${日期}'

-- where nick_name2 is not null