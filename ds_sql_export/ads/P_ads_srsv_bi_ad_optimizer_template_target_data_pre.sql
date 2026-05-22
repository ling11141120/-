----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_template_target_data
-- workflow_version : 76
-- create_user      : chenmo
-- task_name        : ads_srsv_bi_ad_optimizer_template_target_data_pre
-- task_version     : 28
-- update_time      : 2025-11-04 13:54:25
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_template_target_data\ads_srsv_bi_ad_optimizer_template_target_data_pre
----------------------------------------------------------------
-- SQL语句
--  底表1：预处理
insert into  ads.ads_srsv_bi_ad_optimizer_template_target_data_pre

-- 底表1
    -- 维度:日期、新老组，书籍，mt，优化师&组
    with z1 as (
        select a.source_chl
            ,a.product_id
            ,a.product
            ,if(a.product=1,0,a.core) as core
            ,a.ad_set_id
            ,a.ad_camp_id
            ,e.is_spc
            ,a.mt
            ,a.dt
            ,days_diff(curdate(),a.dt) days
            ,if(dayofweek(a.dt)=1,7,dayofweek(a.dt)-1)  as weekdays
            ,case when a.dx=1  then 1 else 0 end is_newad
            ,e.book_id
            ,e.ad_target
            ,e.book_channel
            ,e.story_type
            ,sum(a.cost_amount) cost_amount
            ,sum(a.reg_num) reg_num
            ,sum(a.amount) amount
            ,sum(a.payers_num) payers_num
        from (
            select *
                ,DENSE_RANK() over(partition by concat(source_chl,ad_set_id) order by dt asc) dx
                ,lag(dt,1) over(partition by concat(source_chl,ad_set_id) order by dt asc) date_key_bf1d
            from (
                select ad_set_id
                    ,ad_camp_id
                    ,source_chl
                    ,product_id
                    ,case when product_id in (6833) then 2 else 1 end  as product
                    ,core
                    ,mt
                    ,date(create_time) as dt
                    ,sum(cost_amount) cost_amount
                    ,sum(reg_num) reg_num
                    ,sum(day0_amount+day0_amount_by_ad) amount
                    ,sum(day7_amount+day7_amount_by_ad) d7_amt
                    ,sum(day0_first_pay_num) payers_num
                from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view
                where source_chl in ('facebook','fbs2s','tt','tiktok app') and create_time >= days_add(curdate(),-365)
                group by 1,2,3,4,5,6,7,8
            ) x
            where cost_amount>0
        ) a
        -- 书籍id
        join (
            select product_id
                    ,ad_set_id
                    ,ad_target
                    ,book_channel
                    ,story_type
                    ,is_spc
                    ,max_by(book_id,cnt) book_id
            from (
                select ad_set_id
                    ,product_id
                    ,book_id
                    ,ad_target
                    ,book_channel
                    ,story_type
                    ,if(upper(ads_type) like '%SPC%','SPC', '') as is_spc
                    ,count(1) cnt
                from ads.ads_advertisement_adext_view
                group by 1,2,3,4,5,6,7
            ) x
            group by 1,2,3,4,5,6
        ) e on a.product_id=e.product_id and a.ad_set_id=e.ad_set_id
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
    )

    -- 语言，代号，创编模板
    , z2 as (
        select a.source_chl, a.product_id, a.product, a.core, a.ad_set_id, a.ad_camp_id, a.is_spc, a.mt, a.dt, a.days, a.weekdays, a.is_newad, a.book_id, a.ad_target, a.book_channel, a.story_type, a.cost_amount, a.reg_num, a.amount, a.payers_num
            ,if(a.product=2,s.source_series_code,b.book_code)  book_code
            ,if(a.product=2,s.language,b.languageid)  languageid
            ,UPPER(pt.abbreviation)  as current_language2
            ,t.template_name
            ,t.template_id
        from z1 a
        -- 海阅：代号和投放语言
        left join (
            select book_id
                ,site_id2
                ,book_code
                ,languageid
            from dim.dim_shuangwen_book_read_consume_info
            group by 1,2,3,4
        ) b on a.book_id=b.book_id and a.product=1
        -- 海剧：代号和投放语言
        left join (
            select series_id
                ,language
                ,source_series_code
            from dim.dim_sv_series_hi
            group by 1,2,3
        ) s on a.book_id=s.series_id and a.product=2
        -- 语言
        left join  (
            select langid
                ,abbreviation
            from  dim.DIM_ProductType
        ) pt on if(a.product=2,s.language,b.languageid) = pt.langid
        -- 创编模板
        join (
            -- 创编任务
            select distinct
                a.task_id
                ,a.ad_set_id
                ,b.template_id
                ,c.name  as  template_name
                ,c.source_chl
            from (
                -- 广告组& 创编任务
                select distinct
                    task_id
                    ,ad_set_id
                from ads.ads_creation_ad_set_task_log_view
                where status =1
            ) a
            -- 创编任务 & 创编模板
            left join ads.ads_creation_ad_set_task_view  b on a.task_id=b.id
            -- 模板名称
            left join ads.ads_creation_template_view c on b.template_id=c.id
        ) t on case when a.is_spc in('SPC') then a.ad_camp_id else a.ad_set_id end=t.ad_set_id
    )

    -- 维度：日期、bookid，
    -- 指标：标准，new占比，通过D0收入比例确定投放标准，昨日+今日
    , z3 as (
        select a.*
            ,ifnull(b.ios_day0_amt,0) as ios_day0_amt
            ,ifnull(b.day0_amt,0) as day0_amt
            ,ifnull(b.day0_amt_new,0) as day0_amt_new
            ,ifnull(b.reg_num_ios,0) as reg_num_ios
            ,ifnull(b.reg_num,0) as  reg_num_all
            ,ifnull(b.reg_num_new,0) as reg_num_new
            ,case when a.product_id=6833  then coalesce(r2.ios_r0_std,put2.ios_r0_std) else coalesce(r.ios_r0_std,put.ios_r0_std) end as ios_r0_std
            ,case when a.product_id=6833  then coalesce(r2.and_r0_std,put2.and_r0_std) else coalesce(r.and_r0_std,put.and_r0_std) end as and_r0_std
            ,ifnull(lag(b.reg_num_ios,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)  as reg_num_ios_yester
            ,ifnull(lag(b.reg_num,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)  as reg_num_yester
            ,ifnull(lag(b.reg_num_new,1,0) over(partition by concat(a.product_id,a.ad_set_id) order by a.dt asc),0)  as reg_num_new_yester
        from z2 a
        left join (
            select a.product_id
                ,if(a.product_id<>6833,0,e.core) as core
                ,e.source_chl
                ,e.ad_set_id
                ,date(a.install_date) dt
                ,sum(a.ios_day0_amt) as ios_day0_amt
                ,sum(a.day0_amt) as day0_amt
                ,sum(a.day0_amt_new) as day0_amt_new
                ,sum(a.reg_num_ios) as reg_num_ios
                ,sum(a.reg_num) as reg_num
                ,sum(a.reg_num_new) as reg_num_new
            from ads.ads_bi_ad_new_user_value_ed a
            join ads.ads_advertisement_adext_view e on a.product_id=e.product_id and a.ad_id=e.ad_id
            where e.source_chl in ('facebook','fbs2s','tt','tiktok app')   and a.install_date>'2024-01-01' and e.book_id is not null
            group by 1,2,3,4,5
        ) b on a.product_id=b.product_id and a.core=b.core  and a.ad_set_id=b.ad_set_id and a.dt=b.dt
        -- 最新书籍标准
        left join (
            select BookId
                ,DateKey
                ,SourceChl
                ,AdTarget
                ,max(if(mt=1,R0Std,null))  ios_r0_std
                ,max(if(mt=4,R0Std,null))  and_r0_std
            from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily
            where DateKey>days_add(curdate(),-360)
            group by 1,2,3,4
        ) r on r.BookId=a.book_id and r.DateKey=a.dt and r.SourceChl = a.source_chl and IFNULL(r.AdTarget,'') = IFNULL(a.ad_target,'')
        -- 最新阅读大盘标准
        left join ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgFlowTag put_1 on put_1.dt = a.dt and put_1.AdSetId = a.ad_set_id
        left join (
            select
                CurrentLanguage
                ,DateKey
                ,BookChannel
                ,SourceChl
                ,Core
                ,StdCode
                ,AdTarget
                ,BookType
                ,max(if(mt=1,R0Std,null))  ios_r0_std
                ,max(if(mt=4,R0Std,null))  and_r0_std
            from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily
            where ProjectCode = 1 and DateKey>days_add(curdate(),-360)
            group by 1, 2, 3, 4, 5, 6, 7, 8
        ) put on put.CurrentLanguage=a.languageid and put.BookChannel = (if(a.book_channel not in (0, 1), 1, a.book_channel)) and put.core = a.core
            and put.DateKey=a.dt and put.SourceChl = a.source_chl and IFNULL(put.AdTarget,'') = IFNULL(a.ad_target,'') and IFNULL(put.StdCode,'')=IFNULL(put_1.StdCode,'') and put.BookType = a.story_type
        -- 海剧分剧标准
        left join  (
            select DateKey
                ,VideoId
                ,SourceChl
                ,AdTarget
                ,max(if(mt=1,R0Std,null))  ios_r0_std
                ,max(if(mt=4,R0Std,null))  and_r0_std
            from ods.ods_ads_tidb_sharpengine_ads_global_VideoRoiStdCfgV2Daily
            where DateKey>days_add(curdate(),-360)
            group by 1,2,3,4
        ) r2 on r2.VideoId=a.book_id and r2.SourceChl = a.source_chl and r2.DateKey=a.dt and IFNULL(r2.AdTarget,'') = IFNULL(a.ad_target,'')
        -- 海剧标准
        left join ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgFlowTag put_2 on put_2.dt = a.dt and put_2.AdSetId = a.ad_set_id
        left join (
            select DateKey
                ,CurrentLanguage
                ,SourceChl
                ,Core
                ,StdCode
                ,AdTarget
                ,max(if(mt=1,R0Std,null))  ios_r0_std
                ,max(if(mt=4,R0Std,null))  and_r0_std
            from ods.ods_ads_tidb_sharpengine_ads_global_RoiStdCfgDaily
            where ProjectCode = 2 and DateKey>days_add(curdate(),-360)
            group by 1, 2, 3, 4, 5, 6
        ) put2 on put2.CurrentLanguage=a.languageid and put2.SourceChl = a.source_chl and put2.DateKey=a.dt and put2.core = a.core and IFNULL(put2.AdTarget,'') = IFNULL(a.ad_target,'') and IFNULL(put2.StdCode,'')=IFNULL(put_2.StdCode,'')
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
            -- ,sum(reg_num_ios) reg_num_ios
            ,sum(day0_amt) reg_num_all
            ,sum(day0_amt_new) reg_num_new
            ,count(distinct ad_set_id) adset_num
            ,sum(cost_amount) as spend
            ,sum(reg_num) as reg_num
            ,sum(amount) as d0_amt
            ,sum(payers_num) payers_num
            ,sum(coalesce(r0_std,(ios_r0_std+and_r0_std)/2)*cost_amount) as std_amt
            ,ifnull(case when sum(day0_amt_new)=0 then sum(reg_num_new+reg_num_new_yester)/sum(reg_num_yester+reg_num_all)
                    else coalesce(sum(day0_amt_new)/sum(day0_amt),sum(reg_num_new+reg_num_new_yester)/sum(reg_num_yester+reg_num_all)) end
                    ,0) as new_amt_rate
        from (
            -- 标准处理
            select *
                ,case when source_chl in ('facebook','fbs2s') then 'meta'
                    when source_chl in ('tt','tiktok app') then 'tiktok'
                    else 'other' end source2
                ,case when mt=1 then ios_r0_std
                    when mt=4 then and_r0_std
                    else cast(ios_rate*ifnull(ios_r0_std,0)+(1-ios_rate)*and_r0_std as decimal(20,6)) end as r0_std
            from (
                -- ios占比
                select *
                    ,(reg_num_ios+reg_num_ios_yester)/(reg_num_all+reg_num_yester) as ios_rate
                from z3
                where core<=1 and book_id is not null
            ) x
        ) xx
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13
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
            ,a.spend_10d   -- 近7天平均花费
            ,a.adset_num_10d -- 近7日基建，阈值10条
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
            ,p.code_stage
            ,p.code_lv  -- B级只对最近2天生效
            ,p.test_status -- 禁投只对最近2天生效
            ,date(p.begin_date) begin_date
            ,date(p.end_date) end_date
             -- 淘汰判断
            ,case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9   then null
                when  d0_amt/std_amt>if(a.source2='meta',if(a.product=2,0.75,0.8),0.9) and spend>30 then null
                -- 海阅1阶关闭
                when a.product=1 and code_stage=1 and a.days_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.7 then a.dt
                when a.product=1 and code_stage=1 and a.days_10d>=4 and ifnull(d0_amt_10d/std_amt_10d,0)<0.8 then a.dt
                -- 基建2天，3条，0回收
                when a.days_10d>=2 and a.adset_num_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.1 then a.dt
                -- 基建3天，3条，60%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,3,3) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.65,0.60),0.70) then a.dt
                -- 基建3天，6条，70%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,6,6) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.75,0.70),0.80) then a.dt
                else null end as off_begindate
            ,date(days_add(case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9   then null
                when  d0_amt/std_amt>if(a.source2='meta',if(a.product=2,0.75,0.8),0.9) and spend>30 then null
                -- 基建2天，3条，0回收
                when a.days_10d>=2 and a.adset_num_10d>=3 and ifnull(d0_amt_10d/std_amt_10d,0)<0.1 then a.dt
                -- 基建3天，3条，60%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,3,3) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.65,0.60),0.70) then a.dt
                -- 基建3天，6条，70%达标率
                when a.days_10d>=if(a.product=2,3,3) and a.adset_num_10d>=if(a.product=2,6,6) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.75,0.70),0.80) then a.dt
                else null end
                ,7)
                ) as off_enddate
        from (
            select
                a.source2
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
                ,days_diff(curdate(),a.first_time) as days_book
                -- 近7天new占比
                ,sum(case when days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_new end) as regnum_new_7d
                ,sum(case when days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_all end) as regnum_all_7d
                -- 判断是否淘汰
                ,sum(case when b.is_newad=1  and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.spend end) spend_10d   -- 近7天平均花费
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.adset_num end) as adset_num_10d -- 近7日基建，阈值10条
                ,count(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.dt end) as days_10d
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) d0_amt_10d
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) std_amt_10d
                -- 历史总达标率，评估替补优先级，后续考虑加入花费
                ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end) d0_amt_all
                ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end) std_amt_all
                -- 判断基建
                ,ifnull(sum(case when b.is_newad=1  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0) as d0_amt_pow
                ,ifnull(sum(case when b.is_newad=1  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0) as std_amt_pow
                -- 老组达标率
                ,ifnull(sum(case when b.is_newad=0  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0) as d0_amt_pow_old
                ,ifnull(sum(case when b.is_newad=0  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end),0) as  std_amt_pow_old
                -- 后3天达标
                ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.d0_amt) end) d0_amt_af
                ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.std_amt) end) std_amt_af
            -- 有投放书籍&模板，指标
            from (
                select *
                    ,min(dt) over(partition by product,book_id)  first_time  -- 书籍首次投放日期
                from (
                    -- 有投放数据的
                    select
                        source2
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
                        ,sum(case when is_newad=1  then adset_num end) as adset_num
                        ,sum(case when is_newad=1  then spend end) as spend
                        ,sum(case when is_newad=1  then d0_amt end) as d0_amt
                        ,sum(case when is_newad=1  then std_amt end) as std_amt
                        ,sum(case when is_newad=1  then reg_num end) as reg_num
                        ,sum(case when is_newad=1  then reg_num_all end) as reg_num_all
                        ,sum(case when is_newad=1  then reg_num_new end) as reg_num_new
                        ,sum(case when is_newad=1  then new_amt_rate end) as new_amt_rate
                        -- 老组当日指标
                        ,sum(case when is_newad=0  then spend end) as old_spend
                        ,sum(case when is_newad=0  then d0_amt end) as old_d0_amt
                        ,sum(case when is_newad=0  then std_amt end) as old_std_amt
                    from z4
                    where spend>0 and adset_num>0 and days<360 -- 过去180天数据
                    group by 1,2,3,4,5,6,7,8,9,10,11,12
                ) x
            ) a
            -- 历史数据
            left join z4 b on a.product=b.product and a.book_id=b.book_id  and a.source2=b.source2 and a.core=b.core and a.template_id=b.template_id
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
        ) a
        -- 测试排期
        left join (
            select code_id
                ,project_code
                ,case when source_chl in ('fb') then 'meta'
                    when source_chl in('tt') then 'tiktok'
                    else source_chl end as source2
                ,update_time
                ,begin_date
                ,end_date
                ,code_stage
                ,code_lv
                ,test_status
            from ads.ads_srsv_ads_marketing_plan_view
            where is_del=0 and source_chl <>''
        ) p on a.dt>=p.begin_date and a.dt<=p.end_date and a.book_id=p.code_id and a.product=p.project_code and a.source2=p.source2  -- 进阶日前一天数据
        where a.core<=1 and if(days_diff(a.dt,p.update_time)>=0,ifnull(code_lv,''),'') not in('B') and if(days_diff(a.dt,p.update_time)>=0,ifnull(test_status,0),0) <2
    )
    select source2,
           project_code,
           core,
           dt,
           book_id,
           template_id,
           product,
           days,
           weekdays,
           book_code,
           languageid,
           current_language2,
           template_name,
           adset_num,
           spend,
           d0_amt,
           std_amt,
           reg_num,
           reg_num_all,
           reg_num_new,
           new_amt_rate,
           old_spend,
           old_d0_amt,
           old_std_amt,
           days_book,
           regnum_new_7d,
           regnum_all_7d,
           spend_10d,
           adset_num_10d,
           days_10d,
           d0_amt_10d,
           std_amt_10d,
           d0_amt_all,
           std_amt_all,
           d0_amt_pow,
           std_amt_pow,
           d0_amt_pow_old,
           std_amt_pow_old,
           d0_amt_af,
           std_amt_af,
           code_stage,
           code_lv,
           test_status,
           begin_date,
           end_date,
           off_begindate,
           off_enddate,
           now() as etl_time
    from z5  WHERE template_id IS NOT  NULL;
