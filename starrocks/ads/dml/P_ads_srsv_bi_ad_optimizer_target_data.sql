----------------------------------------------------------------
-- 程序功能： 海阅海剧 广告基建，优化师每日基建达标情况2
-- 程序名： P_ads_srsv_bi_ad_optimizer_target_data
-- 目标表： ads.ads_srsv_bi_ad_optimizer_target_data
-- 负责人： 050239
-- 开发日期：2026-05-26
----------------------------------------------------------------

delete from ads.ads_srsv_bi_ad_optimizer_target_data where dt >= '${bf_9_dt}' and dt <= '${dt}'

-- 底表1：预处理
insert into  ads.ads_srsv_bi_ad_optimizer_target_data
    with z1 as (
        select a.source_chl
            ,a.product_id
            ,a.product
            ,if(a.product=1,0,a.core) as core
            ,a.ad_set_id
            ,a.mt
            ,a.dt
            ,days_diff(curdate(),a.dt) days
            ,if(dayofweek(a.dt)=1,7,dayofweek(a.dt)-1)  as weekdays
            ,case when a.dx=1  then 1 else 0 end is_newad
            ,e.book_id
            ,e.ad_optimizer_uid
            ,d.code_value as ad_optimizer_group
            ,d.nick_name
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
                    ,source_chl
                    ,product_id
                    ,case when product_id in (6833) then 2 else 1 end  as product
                    ,core
                    ,mt
                    ,date(create_time) as dt
                    ,sum(cost_amount) cost_amount
                    ,sum(reg_num) reg_num
                    ,sum(day0_amount+day0_amount_by_ad) amount
                    ,sum(day0_first_pay_num) payers_num
                from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view
                where source_chl in ('facebook','fbs2s','tt','tiktok app') and create_time >= days_add(curdate(),-365)
                group by 1,2,3,4,5,6,7
            ) x
            where cost_amount>0
        ) a
        -- 书籍id,优化师id
        join (
            select product_id
                    ,ad_set_id
                    ,max_by(book_id,cnt) book_id
                    ,max_by(ad_optimizer_uid,cnt) ad_optimizer_uid
                    ,max_by(book_channel,cnt) book_channel
            from (
                select ad_set_id
                    ,product_id
                    ,book_id
                    ,ad_optimizer_uid
                    ,book_channel
                    ,count(1) cnt
                from ads.ads_advertisement_adext_view
                group by 1,2,3,4,5
            ) x
            where ad_optimizer_uid <>'unknown'
            group by 1,2
        ) e on a.product_id=e.product_id and a.ad_set_id=e.ad_set_id
        -- 优化师&组
        left join (
            select distinct a.code
                ,a.code_value
                ,left(a.code_value,2) as group_product
                ,b.nick_name
            from dim.dim_optimizer_groups_new_view a
            left join dim.dim_kpi_user_info_view b on a.code=b.account
            where left(a.code_value,2) in ('hj','hy')
        ) d on e.ad_optimizer_uid=d.code and if(e.product_id=6833,'hj','hy')=d.group_product
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    )

    -- 语言，代号
    , z2 as (
        select a.*
            ,if(a.product=2,s.source_series_code,b.book_code)  book_code
            ,if(a.product=2,s.language,b.languageid)  languageid
            ,UPPER(pt.abbreviation)  as current_language2
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
            select book_id
                ,date_key
                ,max(if(mt=1,r0_std,null))  ios_r0_std
                ,max(if(mt=4,r0_std,null))  and_r0_std
            from dwd.dwd_advertisement_book_roi_stdcfg_daily_view
            where date_key>days_add(curdate(),-360)
            group by 1,2
        ) r on a.book_id=r.book_id  and a.dt=r.date_key
        -- 最新阅读大盘标准
        left join (
            select current_language2
                ,date_key
                ,max(if(mt=1,r0_std,null))  ios_r0_std
                ,max(if(mt=4,r0_std,null))  and_r0_std
            from dwd.dwd_advertisement_put_product_stdcfg_daily_view
            where  book_channel =1 and date_key>days_add(curdate(),-360)
            group by 1,2
        ) put on a.languageid=put.current_language2 and a.dt=put.date_key
        -- 海剧分剧标准
        left join  (
            select date_key
                ,video_id
                ,source_chl
                ,max(if(mt=1,r0_std,null))  ios_r0_std
                ,max(if(mt=4,r0_std,null))  and_r0_std
            from dim.dim_sv_videoroistdcfgdaily_view
            where date_key>days_add(curdate(),-360)
            group by 1,2,3
        ) r2 on a.source_chl=r2.source_chl and a.dt=r2.date_key  and a.book_id=r2.video_id
        -- 海剧标准
        left join (
            select date_key
                ,current_language2
                ,source_chl
                ,max(if(mt=1,r0_std,null))  ios_r0_std
                ,max(if(mt=4,r0_std,null))  and_r0_std
            from dwd.dwd_sv_ad_put_product_video_roi_stdCfg_daily_view
            where date_key>days_add(curdate(),-360)
            group by 1,2,3
        ) put2 on a.languageid=put2.current_language2  and a.source_chl=put2.source_chl and a.dt=put2.date_key
    )

   -- 标准和指标处理,core过滤,book_id非null
    -- 优化师、新老组汇总
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
            ,ad_optimizer_uid
            ,ad_optimizer_group
            ,nick_name
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
                    ,0) as new_r0_rate
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
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    )

    -- 新广告组，基建评估指标 ,首个优化师，历史花费最大优化师
    -- 增加阶段， 代号，书籍语言，近2天B级书过滤
    -- core过滤
    -- 淘汰参数：
    , z5 as (
        select a.*
            ,p.code_stage
            ,p.code_lv  -- B级只对最近2天生效
            ,p.test_status -- 禁投只对最近2天生效
            ,date(p.begin_date) begin_date
            ,date(p.end_date) end_date
            ,FIRST_VALUE(nick_name) over(partition by concat(a.product,a.source2,a.book_id,a.core) order by case when ifnull(a.spend,0)<10 or nick_name like '%离职%' or nick_name is null then '2050-01-01' else dt end asc,nick_name)  as frt_nickname
            ,FIRST_VALUE(nick_name) over(partition by concat(a.product,a.source2,a.book_id,a.core) order by case when ifnull(a.spend,0)<10 or nick_name like '%离职%' or nick_name is null then 0 else std_amt_all end desc,nick_name)  as nick_name_max
        from (
            select a.dt
                ,a.first_time
                ,a.weekdays
                ,a.product
                ,a.core
                ,a.source2
                ,a.book_id
                ,a.book_code
                ,a.nick_name
                ,a.ad_optimizer_uid
                ,a.ad_optimizer_group
                ,a.languageid
                ,a.current_language2
                ,a.adset_num
                ,a.spend
                ,a.d0_amt
                ,a.std_amt
                ,a.reg_num
                ,a.reg_num_all
                ,a.reg_num_new
                ,a.new_r0_rate
                ,days_diff(curdate(),a.first_time) as days_book
                --近7天new占比
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_new end) as regnum_new_7d
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_all end) as regnum_all_7d
                --判断是否淘汰
                ,sum(case when b.is_newad=1  and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.spend end) spend_10d   -- 近7天平均花费
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.adset_num end) as adset_num_10d -- 近7日基建，阈值10条
                ,count(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.dt end) as days_10d
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) d0_amt_10d
                ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) std_amt_10d
                --历史总达标率，评估替补优先级，后续考虑加入花费
                ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end) d0_amt_all
                ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.98,days_diff(a.dt,b.dt)+1)) end) std_amt_all
                --判断基建
                ,ifnull(sum(case when b.is_newad=1  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.9,days_diff(a.dt,b.dt)+1)) end),0) as d0_amt_pow
                ,ifnull(sum(case when b.is_newad=1  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.9,days_diff(a.dt,b.dt)+1)) end),0) as std_amt_pow
                --老组达标率
                ,ifnull(sum(case when b.is_newad=0  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.9,days_diff(a.dt,b.dt)+1)) end),0) as d0_amt_pow_old
                ,ifnull(sum(case when b.is_newad=0  and a.dt>=b.dt and days_diff(a.dt,b.dt)<=14 then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.9,days_diff(a.dt,b.dt)+1)) end),0) as  std_amt_pow_old
                --后3天达标
                ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.d0_amt) end) d0_amt_af
                ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.std_amt) end) std_amt_af

            from (
                --新广告组
                select *
                    ,min(dt) over(partition by product,book_id)  first_time  --书籍首次投放日期
                from z4
                where is_newad=1   and days<360 -- 过去180天数据
            ) a
            -- 历史数据
            left join z4 b on a.product=b.product and a.book_id=b.book_id and a.ad_optimizer_uid=b.ad_optimizer_uid and a.source2=b.source2 and a.core=b.core
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
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
        where a.core<=1  and if(days_diff(a.dt,p.update_time)>=0,code_lv,'') not in('B') and if(days_diff(a.dt,p.update_time)>=0,test_status,0) <2
    )

    -- 每日专属组标签
    , book_group2 as (
        select product
            ,source2
            ,current_language2
            ,book_id
            ,book_code
            ,code_stage
            ,begin_date
            ,dt
            ,frt_group
            ,if(product=1,3,if(left(concat(current_language2,book_code),4)='ENXY',2,1))  as book_cycle
            ,min(ifnull(cycle_n,0)) cycle_n_min
            ,date(days_add(begin_date,least(ifnull(min(case when spend<cycle_n*spend_up then cycle_n end),3),if(product=1,3,if(left(concat(current_language2,book_code),4)='ENXY',2,1)))*7)) end_date2  --海阅3周，海剧EN-XY的为2周，其他为1周
        from (
            select a.product
                ,a.source2
                ,a.current_language2
                ,c.group_spend  as spend_up
                ,a.book_id
                ,a.book_code
                ,a.begin_date
                ,a.code_stage
                ,a.dt
                ,a.frt_group
                ,ceiling(days_diff(b.dt,a.begin_date)/7) as cycle_n
                ,max(b.dt) end_date  -- 单周期最后一天
                ,sum(b.spend) spend
            from (
                -- 每日，专属组：最高阶前一周，花费最大小组
                select product
                    ,source2
                    ,current_language2
                    ,book_id
                    ,book_code
                    ,code_stage
                    ,begin_date
                    ,dt
                    ,max_by(ad_optimizer_group,spend_bf7d) frt_group
                from (
                    select a.product
                        ,a.source2
                        ,a.current_language2
                        ,a.book_id
                        ,a.book_code
                        ,a.code_stage
                        ,a.begin_date
                        ,a.dt
                        ,b.ad_optimizer_group
                        ,sum(b.spend) spend_bf7d
                    from z5 a
                    -- 专属组：最高阶前一周，花费最大小组
                    left join z5 b on a.product=b.product and a.book_id=b.book_id and a.source2=b.source2 and days_diff(a.begin_date,b.dt) between 0 and 7
                    group by 1,2,3,4,5,6,7,8,9
                ) x
                group by 1,2,3,4,5,6,7,8
            ) a
            -- 获取专属组花费阈值
            left join dim.dim_srsv_ad_prduct_lang_rate c on a.product=c.product and  a.current_language2=c.lang
            -- 优化组、投放花费，用于判断是否出专属期
            left join z4 as b on  a.product=b.product and a.book_id=b.book_id and a.frt_group=b.ad_optimizer_group and a.source2=b.source2 and  b.dt>a.begin_date
            where a.frt_group is not null
            group by 1,2,3,4,5,6,7,8,9,10,11
        ) x
        group by 1,2,3,4,5,6,7,8,9,10
    )

    -- data1:每日基建data
    -- 专属组处理
    , frt_group as (
        select a.dt
            ,if(a.product=1,'海阅','海剧') as product
            ,a.source2
            ,a.book_id as code_id
            ,a.code_stage
            ,a.code_lv
            ,a.test_status
            ,a.begin_date
            ,a.end_date
            ,a.book_code
            ,a.languageid
            ,a.weekdays
            ,a.current_language2 as current_language
            ,a.nick_name
            ,a.ad_optimizer_uid
            ,a.ad_optimizer_group
            ,a.adset_num
            ,a.spend
            ,a.d0_amt
            ,a.std_amt
            ,a.reg_num
            ,a.reg_num_all
            ,a.reg_num_new
            ,a.regnum_new_7d
            ,a.regnum_all_7d
            ,a.spend_10d
            ,a.adset_num_10d
            ,a.days_10d
            ,a.d0_amt_10d
            ,a.std_amt_10d
            ,a.d0_amt_all
            ,a.std_amt_all
            ,a.d0_amt_pow
            ,a.std_amt_pow
            ,a.d0_amt_pow_old
            ,a.std_amt_pow_old
            ,a.frt_nickname
            ,a.nick_name_max
            ,b.frt_group
            -- ,if((b.end_date2>a.dt or (a.product=1 and a.code_stage=2 and days_diff(a.dt,ifnull(a.first_time,'2050-01-01'))<29))
            --     ,if(a.source2='tiktok' and ((a.product=2 and a.code_stage=2) or (a.product=1 and a.code_stage=3)),"",b.frt_group)
            --     ,"") as is_frt_group  --专属
            ,case when a.source2='tiktok' or a.code_stage<=1 or (a.product=1 and a.code_stage=2 and days_diff(a.dt,ifnull(a.first_time,'2050-01-01'))<29) then b.frt_group
                when b.end_date2>a.dt then b.frt_group
                else '' end as is_frt_group
            ,case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9 then null
                when a.days_10d>=if(a.product=2,3,4) and a.adset_num_10d>=if(a.product=2,6,10) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.7,0.65),0.77) then a.dt
                else null end as off_begindate
            ,date(days_add(case when (a.d0_amt_pow_old+a.d0_amt_pow)/(a.std_amt_pow_old+a.std_amt_pow)>0.9 then null
                            when a.days_10d>=if(a.product=2,3,4) and a.adset_num_10d>=if(a.product=2,6,10) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product=2,0.7,0.65),0.77) then a.dt
                            else null end
                            ,7)
                            ) as off_enddate
            ,now() as etl_tm
        from z5  a
        -- 每日专属组标签
        left join book_group2 b on a.product=b.product and a.source2=b.source2 and a.book_id=b.book_id and a.dt=b.dt
    )

    -- 无基建书籍，近2天B级或禁投书过滤
    , z6 as (
        select dt
            ,product
            ,source2
            ,x.code_id
            ,code_stage
            ,code_lv
            ,test_status
            ,begin_date
            ,end_date
            ,book_code
            ,languageid
            ,if(dayofweek(dt)=1,7,dayofweek(dt)-1)  as weekdays
            ,current_language
            ,null nick_name
            ,null ad_optimizer_uid
            ,null ad_optimizer_group
            ,null adset_num
            ,null spend
            ,null d0_amt
            ,null std_amt
            ,null reg_num
            ,null reg_num_all
            ,null reg_num_new
            ,null regnum_new_7d
            ,null regnum_all_7d
            ,null spend_10d
            ,null adset_num_10d
            ,null days_10d
            ,null d0_amt_10d
            ,null std_amt_10d
            ,null d0_amt_all
            ,null std_amt_all
            ,null d0_amt_pow
            ,null std_amt_pow
            ,null d0_amt_pow_old
            ,null std_amt_pow_old
            ,frt_nickname
            ,nick_name_max
            ,frt_group
            ,is_frt_group
            ,null off_begindate
            ,null off_enddate
            ,now() as etl_tm
        from (
            select a.dt
                ,c.*
                ,row_number() over(partition by concat(a.dt,c.product,c.source2,c.code_id,c.begin_date) order by dt_max desc) as rn
            from (
                -- 日期
                select distinct dt
                from frt_group
            ) a
            -- 测试排期
            join (
                select code_id
                    ,if(project_code=1,'海阅','海剧') as project_code
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
            ) p on a.dt>=p.begin_date and a.dt<=p.end_date and if(days_diff(a.dt,p.update_time)>=0,code_lv,'') not in('B') and if(days_diff(a.dt,p.update_time)>=0,test_status,0) <2  -- 进阶日前一天数据
            -- 书籍每日花费
            left join (
                select product
                    ,dt
                    ,source2
                    ,code_id
                    ,sum(adset_num) as adset_num
                from frt_group
                group by 1,2,3,4
            ) b on a.dt=b.dt and p.project_code=b.product and p.code_id=b.code_id and p.source2=b.source2
            join (
                select product
                    ,source2
                    ,code_id
                    ,code_stage
                    ,code_lv
                    ,test_status
                    ,begin_date
                    ,end_date
                    ,book_code
                    ,languageid
                    ,current_language
                    ,frt_nickname
                    ,nick_name_max
                    ,frt_group
                    ,is_frt_group  --专属
                    ,min(dt) as dt_min
                    ,max(dt) as dt_max
                from frt_group
                group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
            ) c on a.dt>=c.dt_min and if(a.dt<=c.dt_max,a.dt<=c.dt_max,(a.dt<c.end_date and a.dt>c.dt_max)) and p.project_code=c.product and p.code_id=c.code_id and p.source2=c.source2
            where b.code_id is null or b.adset_num=0
        ) x
        where rn=1
    )

    -- 昨日基建 + 兜底数据
    , r as (
        select * from z6
        union all
        select * from frt_group
    )

 select * from r;