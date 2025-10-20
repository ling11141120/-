----------------------------------------------------------------
-- 程序功能： 周期型内容域目标书籍进度事实表
-- 程序名： P_ads_report_target_book_progress_monitoring
-- 目标表： ads.ads_report_target_book_progress_monitoring
-- 负责人： qhr
-- 开发日期： 2025-10-17
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_report_target_book_progress_monitoring
-- 每月首次P级
with month_first_plevel as (
    -- 每个月中p级字段不为空的，然后排序，取时间最早的那条P级数据
    select a1.book_id
          ,a1.plevel
      from (select b1.book_id
                  ,b1.plevel
                  ,row_number() over(partition by b1.book_id
                                         order by b1.dt
                                    )                           as rank_num
              from ads.ads_content_book_plevel_capacity_p_da    as b1
             where date_format(b1.dt,'%Y-%m') = date_format('${bf_1_dt}','%Y-%m')
               and plevel is not null
           )                                                    as a1
     where a1.rank_num = 1
)
-- 最近60天进过三阶的书
, stage3_before_60d as (
    -- 一本书可能近60天多次进3队，取最近的一条数据
    select a1.book_id
          ,a1.language_id
      from (select b1.codeid                                               as book_id
                  ,b1.currentlanguage                                      as language_id
                  ,row_number() over (partition by b1.codeid
                                          order by b1.begindate desc
                                     )                                     as rank_num
              from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    as b1
             where b1.codestage = 3                                   -- 进过3阶
               and datediff(current_date(), b1.begindate) <= 60       -- 近60天
           )                                                               as a1
     where a1.rank_num = 1
)
-- 最近60天进过三阶繁体书
, stage3_ft_source_tmp as (
    select a1.book_id                                  as book_id
          ,a2.book_code                                as book_code
      from stage3_before_60d                           as a1
      join dim.dim_shuangwen_book_read_consume_info    as a2
        on a1.book_id = a2.book_id
     where a1.language_id = 2
)
-- 最近60天进过三阶的英语书
, stage3_en_source_tmp as (
    select a1.book_id                                  as book_id
          ,a2.book_code                                as book_code
      from stage3_before_60d                           as a1
      join dim.dim_shuangwen_book_read_consume_info    as a2
        on a1.book_id = a2.book_id
     where a1.language_id = 3
)
, p0_book_id_tmp as (
    -- 对于繁体源头书，通过书籍代号找到它的英语衍生书
    select a1.book_id
          ,a1.site_id
      from ads.ads_report_book_capacity_rate_stat    as a1
      join stage3_ft_source_tmp                      as a2
        on a1.book_code = a2.book_code
     where a1.dt = '${bf_1_dt}'
       and a1.site_id = 322    -- 繁体书的衍生书为英语的
     union
     -- 对于英语源头书，通过书籍代号找到它的小语衍生书
    select a3.book_id
          ,a3.site_id
      from ads.ads_report_book_capacity_rate_stat    as a3
      join stage3_en_source_tmp                      as a4
        on a3.book_code = a4.book_code
     where a3.dt = '${bf_1_dt}'
       and a3.site_id != 322    -- 英语源头书的衍生书为除英语外的其它小语言
)
-- 关联当天最新的P级， 优先及顺序 P0>P1>其它
, result_plevel as (
    select ifnull(a1.book_id,a2.book_id)    as book_id
          ,case when a2.book_id is not null then 'P0'    -- 每月首次是P1，昨天最新P级是P0,那就取P0
                else a1.plevel
            end                             as plevel
      from month_first_plevel               as a1
      full join p0_book_id_tmp              as a2
        on a1.book_id = a2.book_id
)
select a1.dt                  as dt                  -- 日期
      ,a1.to_book_id          as to_book_id          -- 书籍id
      ,a1.site_id             as site_id             -- 语言id
      ,a1.resource_type       as resource_type       -- 生产位
      ,a1.book_name           as book_name           -- 书籍名称
      ,a1.book_code           as book_code           -- 书籍代码
      ,a2.plevel              as book_plevel         -- 书籍打P级标签
      ,a1.book_status         as book_status         -- 书籍状态
      ,a1.account_name        as account_name        -- 项管名称
      ,a1.proofread_length    as proofread_length    -- 精修（二校）字数
      ,a1.publish_length      as publish_length      -- 发布字数
      ,a1.length_target       as length_target       -- 目标字数
      ,a1.yield_rate          as yield_rate          -- 达成率
      ,case when a1.yield_rate >= 1 then 1
            when a1.yield_rate < 1 and a1.yield_rate >= 0.8 then 2
            when a1.yield_rate < 0.8 then 3
        end                   as progress_judge      -- 进度判断
      ,a1.daily_publish       as daily_publish       -- 日更字数
      ,a1.fin_day_anly        as fin_day_anly        -- 预计完成天数
      ,a1.pri_cd              as pri_cd              -- 优先级编号
      ,a1.pri_name            as pri_name            -- 优先级名称
      ,now()                  as etl_time            -- etl清洗时间
  from (select '${dt}'                                                   as dt
              ,b1.to_book_id
              ,b1.site_id
              ,b1.book_name
              ,b1.book_code
              ,b1.book_status
              ,b1.account_name
              ,b1.resource_type
              ,b1.proofread_length
              ,b1.publish_length
              ,b1.length_target
              ,b1.publish_length / b1.length_target                      as yield_rate
              ,b1.daily_publish
              ,(b1.length_target-b1.publish_length)/ b1.daily_publish    as fin_day_anly
              ,b1.pri_cd
              ,b1.pri_name
          from dwd.dwd_content_book_capacity_monitoring_snap             as b1
         where b1.dt = '${bf_1_dt}'
       )                                                                 as a1
  left join result_plevel                                                as a2
    on a1.to_book_id*1000+a1.site_id = a2.book_id
;
