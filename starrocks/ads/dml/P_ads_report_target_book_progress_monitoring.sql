insert into ads.ads_report_target_book_progress_monitoring
-- 每月首次P级
with month_first_plevel as (
    select book_id
         ,plevel
      from (
            select book_id
                 ,plevel
                 ,row_number() over(partition by book_id order by dt) rank_num
              from ads.ads_content_book_plevel_capacity_p_da
             where date_format(dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m')
               and plevel is not null                                                      --每个月中p级字段不为空的，然后排序，取时间最早的那条P级数据
           ) c
     where c.rank_num = 1
),

-- 最近60天进过三阶的书
stage3_before_60d as (
    select book_id
         ,language_id
      from (
            select codeid as book_id
                 ,currentlanguage as language_id
                 ,row_number() over (partition by codeid order by begindate desc) as rank_num                   -- 一本书可能近60天多次进3队，取最近的一条数据
              from ods.ods_tidb_ad_sharpengine_ads_global_marketingplan
             where codestage = 3                                                                                -- 进过3阶
               and datediff(current_date(), begindate) <= 60                                                    -- 近60天进过3阶
           ) a
     where a.rank_num = 1
),

-- 最近60天进过三阶繁体书
stage3_ft_source_tmp as (
    select a.book_id as book_id
         ,b.book_code as book_code
      from stage3_before_60d a
inner join dim.dim_shuangwen_book_read_consume_info b
        on a.book_id = b.book_id
     where a.language_id = 2                                                                                     -- 最近60天进过3阶的繁体书
),

-- 最近60天进过三阶的英语书
stage3_en_source_tmp as (
    select a.book_id as book_id
         ,b.book_code as book_code
      from stage3_before_60d a
inner join dim.dim_shuangwen_book_read_consume_info b
        on a.book_id = b.book_id
     where a.language_id = 3                                                                                     -- 最近60天进过3阶的英语书
),

p0_book_id_tmp as (
 -- 对于繁体源头书，通过书籍代号找到它的英语衍生书
    select a.book_id
         ,a.site_id
      from ads.ads_report_book_capacity_rate_stat a
inner join stage3_ft_source_tmp b
        on a.book_code = b.book_code
     where a.dt = '${bf_1_dt}'
       and a.site_id = 322                                                                                    -- 繁体书的衍生书为英语的
    union
     -- 对于英语源头书，通过书籍代号找到它的小语衍生书
    select a.book_id
         ,a.site_id
      from ads.ads_report_book_capacity_rate_stat a
inner join stage3_en_source_tmp b
        on a.book_code = b.book_code
     where a.dt = '${bf_1_dt}'
       and a.site_id != 322                                                                                   -- 英语源头书的衍生书为除英语外的其它小语言
),

-- 关联当天最新的P级， 优先及顺序 P0>P1>其它
result_plevel as (
    select ifnull(a.book_id,b.book_id) as book_id
         ,case
             when b.book_id is not null then 'P0'          -- 每月首次是P1，昨天最新P级是P0,那就取P0
             else a.plevel
           end as plevel
      from month_first_plevel a
     full join p0_book_id_tmp b
        on a.book_id = b.book_id
)

select a.dt
     ,a.to_book_id
     ,a.site_id
     ,a.resource_type
     ,a.book_name
     ,a.book_code
     ,b.plevel
     ,a.book_status
     ,a.account_name
     ,a.proofread_length
     ,a.publish_length
     ,a.length_target
     ,a.yield_rate
     ,case
         when a.yield_rate >= 1 then 1
         when a.yield_rate < 1 and a.yield_rate >= 0.8 then 2
         when a.yield_rate < 0.8 then 3
       end progress_judge
     ,a.daily_publish
     ,a.fin_day_anly
     ,now() as etl_time
  from (
        select '${dt}' as dt
             ,to_book_id
             ,site_id
             ,book_name
             ,book_code
             ,book_status
             ,account_name
             ,resource_type
             ,proofread_length
             ,publish_length
             ,length_target
             ,publish_length / length_target as yield_rate
             ,daily_publish
             ,(length_target-publish_length)/ daily_publish as fin_day_anly
          from dwd.dwd_content_book_capacity_monitoring_snap
         where dt = '${bf_1_dt}'
       ) a
 left join result_plevel b
    on a.to_book_id*1000+a.site_id = b.book_id
;


