----------------------------------------------------------------
-- 程序功能： 模板维度基建上限前置表-底表一-临时
-- 程序名： P_ads_srsv_bi_ad_optimizer_template_target_data_pre_1
-- 目标表： ads.ads_srsv_bi_ad_optimizer_template_target_data_pre_1
-- 负责人： qhr
-- 开发日期： 2025-08-15
-- 版本号： v0.1.1
----------------------------------------------------------------

-- 维度:日期、新老组，书籍，mt，优化师&组
insert into ads.ads_srsv_bi_ad_optimizer_template_target_data_pre_1
with z1 as (
    select a.source_chl                                 as source_chl
          ,a.product_id                                 as product_id
          ,a.product                                    as product
          ,if(a.product=1,0,a.core)                     as core
          ,a.ad_set_id                                  as ad_set_id
          ,a.ad_camp_id                                 as ad_camp_id
          ,e.is_spc                                     as is_spc
          ,a.mt                                         as mt
          ,a.dt                                         as dt
          ,days_diff(curdate(),a.dt)                    as days
          ,if(dayofweek(a.dt)=1,7,dayofweek(a.dt)-1)    as weekdays
          ,case when a.dx = 1 then 1
                else 0
            end                                         as is_newad
          ,e.book_id                                    as book_id
          ,e.ad_target                                  as ad_target
          ,e.book_channel                               as book_channel
          ,e.story_type                                 as story_type
          ,sum(a.cost_amount)                           as cost_amount
          ,sum(a.reg_num)                               as reg_num
          ,sum(a.amount)                                as amount
          ,sum(a.payers_num)                            as payers_num
      from (select ad_set_id
                  ,ad_camp_id
                  ,source_chl
                  ,product_id
                  ,product
                  ,core
                  ,mt
                  ,dt
                  ,cost_amount
                  ,reg_num
                  ,amount
                  ,d7_amt
                  ,payers_num
                  ,DENSE_RANK() over(partition by concat(source_chl,ad_set_id) order by dt asc)    as dx
                  ,lag(dt,1) over(partition by concat(source_chl,ad_set_id) order by dt asc)       as date_key_bf1d
              from (select ad_set_id                             as ad_set_id
                          ,ad_camp_id                            as ad_camp_id
                          ,source_chl                            as source_chl
                          ,product_id                            as product_id
                          ,case when product_id = 6833 then 2
                                else 1
                            end                                  as product
                          ,core                                  as core
                          ,mt                                    as mt
                          ,date(create_time)                     as dt
                          ,sum(cost_amount)                      as cost_amount
                          ,sum(reg_num)                          as reg_num
                          ,sum(day0_amount+day0_amount_by_ad)    as amount
                          ,sum(day7_amount+day7_amount_by_ad)    as d7_amt
                          ,sum(day0_first_pay_num)               as payers_num
                      from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view
                     where source_chl in ('facebook','fbs2s','tt','tiktok app')
                       and create_time >= days_add(curdate(),-365)
                     group by 1,2,3,4,5,6,7,8
                  )                                              as x
             where cost_amount > 0
           )                                                     as a
      -- 书籍id
      join (select product_id
                  ,ad_set_id
                  ,ad_target
                  ,book_channel
                  ,story_type
                  ,is_spc
                  ,max_by(book_id,cnt)                                   as book_id
              from (select ad_set_id
                          ,product_id
                          ,book_id
                          ,ad_target
                          ,book_channel
                          ,story_type
                          ,if(upper(ads_type) like '%SPC%','SPC', '')    as is_spc
                          ,count(1) cnt
                      from ads.ads_advertisement_adext_view
                     group by 1,2,3,4,5,6,7
                   )                                                     as x
            group by 1,2,3,4,5,6
           )                                                             as e
        on a.product_id=e.product_id
       and a.ad_set_id=e.ad_set_id
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
)

-- 语言，代号，创编模板
, z2 as (
    select a.source_chl                                        as source_chl
          ,a.product_id                                        as product_id
          ,a.product                                           as product
          ,a.core                                              as core
          ,a.ad_set_id                                         as ad_set_id
          ,a.ad_camp_id                                        as ad_camp_id
          ,a.is_spc                                            as is_spc
          ,a.mt                                                as mt
          ,a.dt                                                as dt
          ,a.days                                              as days
          ,a.weekdays                                          as weekdays
          ,a.is_newad                                          as is_newad
          ,a.book_id                                           as book_id
          ,a.ad_target                                         as ad_target
          ,a.book_channel                                      as book_channel
          ,a.story_type                                        as story_type
          ,a.cost_amount                                       as cost_amount
          ,a.reg_num                                           as reg_num
          ,a.amount                                            as amount
          ,a.payers_num                                        as payers_num
          ,if(a.product=2,s.source_series_code,b.book_code)    as book_code
          ,if(a.product=2,s.language,b.languageid)             as languageid
          ,UPPER(pt.abbreviation)                              as current_language2
          ,t.template_name                                     as template_name
          ,t.template_id                                       as template_id
      from z1                                                  as a
      left join (select book_id       -- 书籍id
                       ,site_id2
                       ,book_code     -- 代号
                       ,languageid    -- 投放语言
                  from dim.dim_shuangwen_book_read_consume_info    -- 海阅
                  group by 1,2,3,4
                )                                              as b
        on a.book_id=b.book_id
       and a.product=1
      left join (select series_id
                       ,language                -- 投放语言
                       ,source_series_code      -- 代号
                   from dim.dim_sv_series_hi    -- 海剧
                  group by 1,2,3
                )                                              as s
        on a.book_id=s.series_id
       and a.product=2
      left join (select langid          -- 语言id
                       ,abbreviation    -- 语言代号
                   from dim.DIM_ProductType
                )                                              as pt
        on if(a.product=2,s.language,b.languageid) = pt.langid
      join (select distinct a.task_id                                              -- 创编任务
                  ,a.ad_set_id
                  ,b.template_id                                                   -- 创编模板
                  ,c.name                                      as template_name    -- 模板名称
                  ,c.source_chl
              from (select distinct task_id    -- 创编任务
                          ,ad_set_id           -- 广告组
                      from ads.ads_creation_ad_set_task_log_view
                     where status =1
                   )                                           as a
              left join ads.ads_creation_ad_set_task_view      as b
                on a.task_id=b.id
              left join ads.ads_creation_template_view         as c
                on b.template_id=c.id
           )                                                   as t
        on case when a.is_spc in('SPC') then a.ad_camp_id else a.ad_set_id end=t.ad_set_id
)

-- 优化师及创编相关维度信息
, opt_and_ce_info as (
    select a1.source_chl
          ,a1.product_id
          ,a1.product
          ,a1.core
          ,a1.ad_set_id
          ,a1.ad_camp_id
          ,a1.is_spc
          ,a1.mt
          ,a1.dt
          ,a1.days
          ,a1.weekdays
          ,a1.is_newad
          ,a1.book_id
          ,a1.ad_target
          ,a1.book_channel
          ,a1.story_type
          ,a1.cost_amount
          ,a1.reg_num
          ,a1.amount
          ,a1.payers_num
          ,a1.book_code
          ,a1.languageid
          ,a1.current_language2
          ,a1.template_name
          ,a1.template_id
          ,a2.opt_eid                                   -- 优化师工号
          ,a2.opt_name                                  -- 优化师姓名
          ,a3.IsAutoCreation    as auto_ce_type_cd      -- 自动创编类型编码
          ,case when a3.IsAutoCreation = 0 then '关'
                when a3.IsAutoCreation = 1 then '自动创编'
                when a3.IsAutoCreation = 2 then '小预算创编'
                when a3.IsAutoCreation = 3 then '小预算VIP创编'
                else null
            end                 as auto_ce_type_name    -- 自动创编类型名称
          ,case when a4.fst_ce_dt is null then 0
                else 1
            end                 as is_fst_infra         -- 是否首日基建
          ,a5.InitAdSetCount    as init_infra_num       -- 初始基建条数
          ,case when a6.AdSetCount > 0 then 1
                else 0
            end                 as is_new_group_ce      -- 是否有创编新组
      from z2    as a1
      left join (select b1.prj_cd
                       ,b1.src_med
                       ,b1.prd_cd
                       ,b1.lang_abbr
                       ,b1.opt_eid
                       ,b1.opt_name
                       ,day7_amt
                   from tmp.dim_srsv_auto_spl_wo_plan_view                                  as b1
                   left join (select c1.ads_optimizer
                                    ,sum(c1.cost_amount)                                    as day7_amt
                                from ads.ads_bi_ad_cost_recharge_view                       as c1
                               where dt between date_sub(curdate(), interval 6 day) and curdate()
                                 and coalesce(ads_optimizer, 'unknown') not in ('unknown', 'inste_bf760b83b9c349c7bbf2b221ac673d25', 'inste_5e3bc147ee9e45bd8479e3f149735bd3')
                               group by c1.ads_optimizer
                             )                                                              as b2
                     on b1.opt_eid = b2.ads_optimizer
                qualify dense_rank() over(partition by b1.prj_cd, b1.src_med, b1.prd_cd, b1.lang_abbr order by b2.day7_amt desc) = 1    -- 同一组媒体+代号存在多个优化师取近7天花费最高的
                )                                                                           as a2
        on a1.product = a2.prj_cd
       and if(a1.source_chl in ('facebook','fbs2s'),'fb', a1.source_chl) = a2.src_med
       and concat(regexp_replace(a1.book_code,'[-–—‐‒].*$',''), '-', upper(a1.current_language2)) = concat(a2.prd_cd, '-', upper(a2.lang_abbr))
      left join (select ProjectCode
                       ,CodeId
                       ,SourceChl
                       ,IsAutoCreation
                   from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
                  where isDel = 0
                qualify row_number() over(partition by ProjectCode, CodeId, SourceChl order by BeginDate desc) = 1
                )                                                                           as a3
        on a1.product = a3.ProjectCode
       and a1.book_id = a3.CodeId
       and if(a1.source_chl in ('facebook','fbs2s'),'fb', a1.source_chl) = a3.SourceChl
      left join (select b3.ProjectCode
                       ,b3.SourceChl
                       ,b3.CodeId
                       ,b4.TemplateId
                       ,min(b3.DateKey)    as fst_ce_dt
                   from ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationAutoTask         as b3
                   join ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationPlanTask         as b4
                     on b3.Id = b4.AdsCreationAutoTaskId
                  group by 1,2,3,4
                )                                                                           as a4
        on a1.product = a4.ProjectCode
       and if(a1.source_chl in ('facebook','fbs2s'),'fb', a1.source_chl) = a4.SourceChl
       and a1.book_id = a4.CodeId
       and a1.template_id = a4.TemplateId
       and a1.dt = a4.fst_ce_dt
      left join (select b5.ProjectCode
                      ,b5.SourceChl
                      ,b5.CodeId
                      ,b6.TemplateId
                      ,b6.InitAdSetCount
                   from ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationPlan             as b5
                   join ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationPlanItem         as b6
                     on b5.PlanId = b6.PlanId
                  where b5.PlanStatus = 1
                    and b5.DelFlag = 0
                    and b6.DelFlag = 0
                    and COALESCE(b5.CodeId,'') <> ''
                )                                                                           as a5
        on a1.product = a5.ProjectCode
       and if(a1.source_chl in ('facebook','fbs2s'),'fb', a1.source_chl) = a5.SourceChl
       and a1.book_id = a5.CodeId
       and a1.template_id = a5.TemplateId
      left join (select b7.ProjectCode
                      ,b8.SourceChl
                      ,b8.CodeId
                      ,b7.TemplateId
                      ,count(distinct b10.AdSetId)                                          as AdSetCount
                   from ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationPlanTask         as b7
                   join ods.ods_ads_tidb_sharpengine_ads_global_AdsCreationAutoTask         as b8
                     on b7.AdsCreationAutoTaskId = b8.Id
                   left join ods.ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask       as b9
                     on b7.PlanTaskId = b9.PlanTaskId
                    and b9.Status = 1
                   left join ods.ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog    as b10
                     on b9.Id = b10.TaskId
                    and b10.Status = 1
                  where b7.AdsCreationAutoTaskId > 0
                    and b8.DateKey = date(date_sub(curdate(),interval 1 day))
                    and ifnull(b9.CopyFromTaskId,0)=0
                  group by 1, 2, 3, 4
                )                                                                           as a6
        on a1.product = a6.ProjectCode
       and if(a1.source_chl in ('facebook','fbs2s'),'fb', a1.source_chl) = a6.SourceChl
       and a1.book_id = a6.CodeId
       and a1.template_id = a6.TemplateId
)

-- 维度：日期、bookid，
-- 指标：标准，new占比，通过D0收入比例确定投放标准，昨日+今日
, z3 as (
    select a.*
          ,ifnull(b.ios_day0_amt,0)                                                                                  as ios_day0_amt
          ,ifnull(b.day0_amt,0)                                                                                      as day0_amt
          ,ifnull(b.day0_amt_new,0)                                                                                  as day0_amt_new
          ,ifnull(b.reg_num_ios,0)                                                                                   as reg_num_ios
          ,ifnull(b.reg_num,0)                                                                                       as reg_num_all
          ,ifnull(b.reg_num_new,0)                                                                                   as reg_num_new
          ,case when a.product_id= 6833 then coalesce(r2.ios_r0_std,put2.ios_r0_std)
                else coalesce(r.ios_r0_std,put.ios_r0_std)
            end                                                                                                      as ios_r0_std
          ,case when a.product_id= 6833 then coalesce(r2.and_r0_std,put2.and_r0_std)
                else coalesce(r.and_r0_std,put.and_r0_std)
            end                                                                                                      as and_r0_std
          ,ifnull(lag(b.reg_num_ios,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)    as reg_num_ios_yester
          ,ifnull(lag(b.reg_num,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)        as reg_num_yester
          ,ifnull(lag(b.reg_num_new,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)    as reg_num_new_yester
      from opt_and_ce_info                                  as a
      left join (select a.product_id
                      ,if(a.product_id<>6833,0,e.core)      as core
                      ,e.source_chl
                      ,e.ad_set_id
                      ,date(a.install_date)                 as dt
                      ,sum(a.ios_day0_amt)                  as ios_day0_amt
                      ,sum(a.day0_amt)                      as day0_amt
                      ,sum(a.day0_amt_new)                  as day0_amt_new
                      ,sum(a.reg_num_ios)                   as reg_num_ios
                      ,sum(a.reg_num)                       as reg_num
                      ,sum(a.reg_num_new)                   as reg_num_new
                   from ads.ads_bi_ad_new_user_value_ed     as a
                   join ads.ads_advertisement_adext_view    as e
                     on a.product_id=e.product_id
                    and a.ad_id=e.ad_id
                  where e.source_chl in ('facebook','fbs2s','tt','tiktok app')
                    and a.install_date>'2024-01-01'
                    and e.book_id is not null
                  group by 1,2,3,4,5
                )                                           as b
        on a.product_id=b.product_id
       and a.core=b.core
       and a.ad_set_id=b.ad_set_id
       and a.dt=b.dt
    -- 最新书籍标准
      left join (select BookId
                      ,DateKey
                      ,SourceChl
                      ,AdTarget
                      ,max(if(mt=1,R0Std,null))     as ios_r0_std
                      ,max(if(mt=4,R0Std,null))     as and_r0_std
                   from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily
                  where DateKey>days_add(curdate(),-360)
                  group by 1,2,3,4
                )                                   as r
         on r.BookId=a.book_id
       and r.DateKey=a.dt
       and r.SourceChl = a.source_chl
       and IFNULL(r.AdTarget,'') = IFNULL(a.ad_target,'')
      -- 最新阅读大盘标准
      left join (select CurrentLanguage2
                       ,DateKey
                       ,BookChannel
                       ,SourceChl
                       ,AdTarget
                       ,BookType
                       ,max(if(mt=1,R0Std,null))     as ios_r0_std
                       ,max(if(mt=4,R0Std,null))     as and_r0_std
                    from ods.ods_ads_tidb_sharpengine_ads_global_PutProductRoiStdCfgV2Daily
                   where BookChannel =1
                     and DateKey>days_add(curdate(),-360)
                   group by 1,2,3,4,5,6
                )                                    as put
        on put.CurrentLanguage2=a.languageid
       and put.BookChannel = (if(a.book_channel not in (0, 1), 1, a.book_channel))
       and put.DateKey=a.dt
       and put.SourceChl = a.source_chl
       and IFNULL(put.AdTarget,'') = IFNULL(a.ad_target,'')
       and put.BookType = a.story_type
    -- 海剧分剧标准
    left join (select DateKey
                    ,VideoId
                    ,SourceChl
                    ,AdTarget
                    ,max(if(mt=1,R0Std,null))    as ios_r0_std
                    ,max(if(mt=4,R0Std,null))    as and_r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_VideoRoiStdCfgV2Daily
                where DateKey>days_add(curdate(),-360)
                group by 1,2,3,4
              )                                  as r2
      on r2.VideoId=a.book_id
     and r2.SourceChl = a.source_chl
     and r2.DateKey=a.dt
     and IFNULL(r2.AdTarget,'') = IFNULL(a.ad_target,'')
    -- 海剧标准
    left join (select DateKey
                    ,CurrentLanguage2
                    ,SourceChl
                    ,AdTarget
                    ,max(if(mt=1,R0Std,null))  ios_r0_std
                    ,max(if(mt=4,R0Std,null))  and_r0_std
                from ods.ods_ads_tidb_sharpengine_ads_global_PutProductVideoRoiStdCfgV2Daily
                where DateKey>days_add(curdate(),-360)
                group by 1,2,3,4
              )                                   as put2
      on put2.CurrentLanguage2=a.languageid
     and put2.SourceChl = a.source_chl
     and put2.DateKey=a.dt
     and IFNULL(put2.AdTarget,'') = IFNULL(a.ad_target,'')
)

-- 标准和指标处理,core过滤,book_id非null
-- 优化师、创编模板、新老组汇总
, z4 as (
    select source2
          ,product
          ,core
          ,dt
          ,days
          ,weekdays
          ,is_newad
          ,book_id
          ,book_code
          ,languageid
          ,current_language2
          ,template_id
          ,template_name
          ,opt_eid              -- 优化师工号
          ,opt_name             -- 优化师姓名
          ,auto_ce_type_cd      -- 自动创编类型编码
          ,auto_ce_type_name    -- 自动创编类型名称
          ,is_fst_infra         -- 是否首日基建
          ,init_infra_num       -- 初始基建条数
          ,is_new_group_ce      -- 是否有创编新组
          ,sum(day0_amt)                                                                   as reg_num_all
          ,sum(day0_amt_new)                                                               as reg_num_new
          ,count(distinct ad_set_id)                                                       as adset_num
          ,sum(cost_amount)                                                                as spend
          ,sum(reg_num)                                                                    as reg_num
          ,sum(amount)                                                                     as d0_amt
          ,sum(payers_num)                                                                 as payers_num
          ,sum(coalesce(r0_std,(ios_r0_std+and_r0_std)/2)*cost_amount)                     as std_amt
          ,ifnull(case when sum(day0_amt_new)=0 then sum(reg_num_new+reg_num_new_yester)/sum(reg_num_yester+reg_num_all)
                      else coalesce(sum(day0_amt_new)/sum(day0_amt),sum(reg_num_new+reg_num_new_yester)/sum(reg_num_yester+reg_num_all))
                  end
                  ,0
                )                                                                         as new_amt_rate
      from (select *
                  ,case when source_chl in ('facebook','fbs2s') then 'meta'
                        when source_chl in ('tt','tiktok app') then 'tiktok'
                        else 'other'
                    end                                                                     as source2
                  ,case when mt=1 then ios_r0_std
                        when mt=4 then and_r0_std
                        else cast(ios_rate*ifnull(ios_r0_std,0)+(1-ios_rate)*and_r0_std as decimal(20,6))
                    end                                                                     as r0_std
              from (select *
                          ,(reg_num_ios+reg_num_ios_yester)/(reg_num_all+reg_num_yester)    as ios_rate    -- ios占比
                      from z3
                    where core<=1
                      and book_id is not null
                  )                                                                        as x
          )                                                                                as  xx
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
)

-- 新广告组，基建评估指标 ,首个优化师，历史花费最大优化师
-- 增加阶段， 代号，书籍语言，近2天B级书过滤
-- core过滤
-- 淘汰参数：
, z5 as (
    select a.source2
          ,a.product as project_code
          ,if(a.product=1,'海阅','海剧') product
          ,a.core
          ,a.dt
          ,a.days
          ,a.weekdays
          ,a.book_id
          ,a.book_code
          ,a.languageid
          ,a.current_language2
          ,a.template_id
          ,a.template_name
          ,a.adset_num
          ,a.spend
          ,a.d0_amt
          ,a.std_amt
          ,a.reg_num
          ,a.reg_num_all
          ,a.reg_num_new
          ,a.new_amt_rate
          ,a.old_spend
          ,a.old_d0_amt
          ,a.old_std_amt
          ,a.days_book
          -- 近7天new占比
          ,a.regnum_new_7d
          ,a.regnum_all_7d
          -- 判断是否淘汰
          ,a.spend_10d        -- 近7天平均花费
          ,a.adset_num_10d    -- 近7日基建，阈值10条
          ,a.days_10d
          ,a.d0_amt_10d
          ,a.std_amt_10d
          -- 历史总达标率，评估替补优先级，后续考虑加入花费
          ,a.d0_amt_all
          ,a.std_amt_all
          -- 判断基建
          ,a.d0_amt_pow
          ,a.std_amt_pow
          -- 老组达标率
          ,a.d0_amt_pow_old
          ,a.std_amt_pow_old
          -- 后3天达标
          ,a.d0_amt_af
          ,a.std_amt_af
          -- 新组 & 老组指标
          ,spend1
          ,d0_amt1
          ,std_amt1
          ,d0_amt_pow1
          ,std_amt_pow1
          ,p.code_stage
          ,p.code_lv        -- B级只对最近2天生效
          ,p.test_status    -- 禁投只对最近2天生效
          ,date(p.begin_date)  begin_date
          ,date(p.end_date)    end_date
          -- 淘汰判断
          ,case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9 then null
                when d0_amt/std_amt>if(a.source2='meta',if(a.product=2,0.75,0.8),0.9) and spend>30 then null
                -- 海阅1阶关闭
                when a.product=1 and code_stage=1 and a.days_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.7 then a.dt
                when a.product=1 and code_stage=1 and a.days_10d>=4 and ifnull(d0_amt_10d/std_amt_10d,0)<0.8 then a.dt
                -- 基建2天，3条，0回收
                when a.days_10d>=2 and a.adset_num_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.1 then a.dt
                -- 基建3天，3条，60%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,3,3) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.65,0.60),0.70) then a.dt
                -- 基建3天，6条，70%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,6,6) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.75,0.70),0.80) then a.dt
                else null
            end as off_begindate
          ,date(days_add(case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9 then null
                              when  d0_amt/std_amt>if(a.source2='meta',if(a.product=2,0.75,0.8),0.9) and spend>30 then null
                              -- 基建2天，3条，0回收
                              when a.days_10d>=2 and a.adset_num_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.1 then a.dt
                              -- 基建3天，3条，60%达标率
                              when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,3,3) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.65,0.60),0.70) then a.dt
                              -- 基建3天，6条，70%达标率
                              when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,6,6) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.75,0.70),0.80) then a.dt
                              else null
                          end
                        ,7
                        )
              ) as off_enddate
      from (select a.source2
                  ,a.product
                  ,a.core
                  ,a.dt
                  ,a.days
                  ,a.weekdays
                  ,a.book_id
                  ,a.book_code
                  ,a.languageid
                  ,a.current_language2
                  ,a.template_id
                  ,a.template_name
                  ,a.adset_num
                  ,a.spend
                  ,a.d0_amt
                  ,a.std_amt
                  ,a.reg_num
                  ,a.reg_num_all
                  ,a.reg_num_new
                  ,a.new_amt_rate
                  ,a.old_spend
                  ,a.old_d0_amt
                  ,a.old_std_amt
                  ,days_diff(curdate(),a.first_time)                                                                                                                                as days_book
                  -- 新组 & 老组指标
                  ,a.spend1
                  ,a.d0_amt1
                  ,a.std_amt1
                  -- 近7天new占比
                  ,sum(case when days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_new end)                                                                                      as regnum_new_7d
                  ,sum(case when days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_all end)                                                                                      as regnum_all_7d
                  -- 判断是否淘汰
                  ,sum(case when b.is_newad=1  and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.spend end)                                                                          as spend_10d        -- 近7天平均花费
                  ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.adset_num end)                                                                       as adset_num_10d    -- 近7日基建，阈值10条
                  ,count(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.dt end)                                                                            as days_10d
                  ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end)                as d0_amt_10d
                  ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end)               as std_amt_10d
                  -- 历史总达标率，评估替补优先级，后续考虑加入花费
                  ,sum(case when a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end)                                                            as d0_amt_all
                  ,sum(case when a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end)                                                           as std_amt_all
                  -- 判断基建
                  ,ifnull(sum(case when b.is_newad=1 and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)     as d0_amt_pow
                  ,ifnull(sum(case when b.is_newad=1 and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)    as std_amt_pow
                  -- 老组达标率
                  ,ifnull(sum(case when b.is_newad=0 and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)     as d0_amt_pow_old
                  ,ifnull(sum(case when b.is_newad=0 and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)    as std_amt_pow_old
                  -- 后3天达标
                  ,sum(case when b.is_newad=1 and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.d0_amt) end)                                                  as d0_amt_af
                  ,sum(case when b.is_newad=1 and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.std_amt) end)                                                 as std_amt_af
                  ,ifnull(sum(case when a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)                      as d0_amt_pow1
                  ,ifnull(sum(case when a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0)                     as std_amt_pow1
              -- 有投放书籍&模板，指标
              from (select *
                          ,min(dt) over(partition by product,book_id)    as first_time  -- 书籍首次投放日期
                      -- 有投放数据的
                      from (select source2
                                  ,product
                                  ,core
                                  ,dt
                                  ,days
                                  ,weekdays
                                  ,book_id
                                  ,book_code
                                  ,languageid
                                  ,current_language2
                                  ,template_id
                                  ,template_name
                                  -- 新组当日指标
                                  ,sum(case when is_newad = 1 then adset_num    end) as adset_num
                                  ,sum(case when is_newad = 1 then spend        end) as spend
                                  ,sum(case when is_newad = 1 then d0_amt       end) as d0_amt
                                  ,sum(case when is_newad = 1 then std_amt      end) as std_amt
                                  ,sum(case when is_newad = 1 then reg_num      end) as reg_num
                                  ,sum(case when is_newad = 1 then reg_num_all  end) as reg_num_all
                                  ,sum(case when is_newad = 1 then reg_num_new  end) as reg_num_new
                                  ,sum(case when is_newad = 1 then new_amt_rate end) as new_amt_rate
                                  -- 老组当日指标
                                  ,sum(case when is_newad = 0 then spend        end) as old_spend
                                  ,sum(case when is_newad = 0 then d0_amt       end) as old_d0_amt
                                  ,sum(case when is_newad = 0 then std_amt      end) as old_std_amt
                                  -- 新组 & 老组当日指标
                                  ,sum(spend)                                        as spend1
                                  ,sum(d0_amt)                                       as d0_amt1
                                  ,sum(std_amt)                                      as std_amt1
                              from z4
                            where spend > 0
                              and adset_num > 0
                              and days < 360 -- 过去180天数据
                            group by 1,2,3,4,5,6,7,8,9,10,11,12
                          ) as x
                  )         as a
              -- 历史数据
              left join z4   as b
                on a.product=b.product
              and a.book_id=b.book_id
              and a.source2=b.source2
              and a.core=b.core
              and a.template_id=b.template_id
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27
          )                 as a
      -- 测试排期
      left join (select code_id
                      ,project_code
                      ,case when source_chl in ('fb') then 'meta'
                            when source_chl in('tt') then 'tiktok'
                            else source_chl
                        end as source2
                      ,update_time
                      ,begin_date
                      ,end_date
                      ,code_stage
                      ,code_lv
                      ,test_status
                  from ads.ads_srsv_ads_marketing_plan_view
                  where is_del=0
                    and source_chl <>''
                ) p
        on a.dt>=p.begin_date
      and a.dt<=p.end_date
      and a.book_id=p.code_id
      and a.product=p.project_code
      and a.source2=p.source2  -- 进阶日前一天数据
    where a.core<=1
      and if(days_diff(a.dt,p.update_time)>=0,ifnull(code_lv,''),'') not in('B')
      and if(days_diff(a.dt,p.update_time)>=0,ifnull(test_status,0),0) < 2
)
select a1.source2
      ,a1.project_code
      ,a1.core
      ,a1.dt
      ,a1.book_id
      ,a1.template_id
      ,a1.product
      ,a1.days
      ,a1.weekdays
      ,a1.book_code
      ,a1.languageid
      ,a1.current_language2
      ,a1.template_name
      ,a1.adset_num
      ,a1.spend
      ,a1.d0_amt
      ,a1.std_amt
      ,a1.reg_num
      ,a1.reg_num_all
      ,a1.reg_num_new
      ,a1.new_amt_rate
      ,a1.old_spend
      ,a1.old_d0_amt
      ,a1.old_std_amt
      ,a1.days_book
      ,a1.regnum_new_7d
      ,a1.regnum_all_7d
      ,a1.spend_10d
      ,a1.adset_num_10d
      ,a1.days_10d
      ,a1.d0_amt_10d
      ,a1.std_amt_10d
      ,a1.d0_amt_all
      ,a1.std_amt_all
      ,a1.d0_amt_pow
      ,a1.std_amt_pow
      ,a1.d0_amt_pow_old
      ,a1.std_amt_pow_old
      ,a1.d0_amt_af
      ,a1.std_amt_af
      ,a1.code_stage
      ,a1.code_lv
      ,a1.test_status
      ,a1.begin_date
      ,a1.end_date
      ,a1.off_begindate
      ,a1.off_enddate
      ,a2.opt_eid              -- 优化师工号
      ,a2.opt_name             -- 优化师姓名
      ,a2.auto_ce_type_cd      -- 自动创编类型编码
      ,a2.auto_ce_type_name    -- 自动创编类型名称
      ,a2.is_fst_infra         -- 是否首日基建
      ,a2.init_infra_num       -- 初始基建条数
      ,a2.is_new_group_ce      -- 是否有创编新组
      ,a1.spend1
      ,a1.d0_amt1
      ,a1.std_amt1
      ,a1.d0_amt_pow1
      ,a1.std_amt_pow1
      ,now() as etl_time
  from z5         as a1
  left join z4    as a2
    on a1.dt = a2.dt
   and a1.project_code=a2.product
   and a1.book_id=a2.book_id
   and a1.source2=a2.source2
   and a1.template_id=a2.template_id
   and a1.core = a2.core
 where a1.template_id is not null
;