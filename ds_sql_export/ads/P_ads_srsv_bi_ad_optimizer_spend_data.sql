----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_spend_data
-- workflow_version : 14
-- create_user      : hufengju
-- task_name        : ads_srsv_bi_ad_optimizer_spend_data
-- task_version     : 7
-- update_time      : 2025-07-11 15:45:12
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_spend_data\ads_srsv_bi_ad_optimizer_spend_data
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_srsv_bi_ad_optimizer_spend_data  where dt>='${bf_9_dt}'  and dt<='${dt}';

-- SQL语句
insert into  ads.ads_srsv_bi_ad_optimizer_spend_data

    with a1 as (
        select a.create_time,a.product_id,a.ad_set_id,a.cost_amount ,a.reg_num ,a.day0_amount ,a.day0_amount_by_ad ,a.source_chl,a.mt,a.day0_first_pay_num
            ,e.book_id
            ,e.ad_optimizer_uid
            ,e.ad_optimizer_group
			,e.book_channel
            ,e.ad_target
            ,e.story_type
        from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view a
        -- 广告组和优化
        left join (
            select product_id
                    ,ad_set_id
                    ,ad_target
                    ,story_type
                    ,max_by(book_id,cnt) book_id
                    ,max_by(ad_optimizer_uid,cnt) ad_optimizer_uid
                    ,max_by(ad_optimizer_group,cnt) ad_optimizer_group
					,max_by(book_channel,cnt) book_channel
            from (
                select ad_set_id
                    ,product_id
                    ,book_id
                    ,ad_optimizer_uid
                    ,ad_optimizer_group
					,book_channel
                    ,ad_target
                    ,story_type
                    ,count(1) cnt
                from ads.ads_advertisement_adext_view
                group by 1,2,3,4,5,6,7,8
            ) x
            group by 1,2,3,4
        ) e on a.product_id=e.product_id and a.ad_set_id=e.ad_set_id
        where  a.create_time >= days_add(curdate(),-400)   and a.source_chl in ('facebook','fbs2s','tt','tiktok app','adwords')
    )

    -- 分日新老广告组的D0汇总，书籍代号，优化师名称
    , a2 as (
        select case when a.product_id in (6833) then '海剧' else '海阅' end product
            ,if(a.product_id in (6833),s.source_series_code,b.book_code)  book_code
            ,if(a.product_id in (6833),s.language,b.languageid)  languageid
            ,d.nick_name
            ,a.*
        from (
            select book_id
                ,ad_set_id as adset_id
                ,source_chl
                ,cast(ad_optimizer_uid as varchar) ad_optimizer_uid
                ,ad_optimizer_group
                ,product_id
                ,mt
				,book_channel
                ,ad_target
                ,story_type
                ,date(create_time) as dt
                ,sum(cost_amount) cost_amount
                ,sum(reg_num) reg_num
                ,sum(day0_amount+day0_amount_by_ad) amount
                ,sum(day0_first_pay_num) payers_num
            from a1
            where book_id is not null
            group by 1,2,3,4,5,6,7,8,9,10,11
        ) a
        -- 书籍信息
        left join (
            select book_id
                ,site_id2
                ,book_code
                ,languageid
            from dim.dim_shuangwen_book_read_consume_info
            group by 1,2,3,4
        ) b on a.book_id=b.book_id
        -- 短剧信息
        left join (
            select series_id
                ,language
                ,source_series_code
            from dim.dim_sv_series_hi
            group by 1,2,3
        ) s on a.book_id=s.series_id
        -- 优化师名称
        left join dim.dim_kpi_user_info_view d on a.ad_optimizer_uid=d.account
    )

    -- 新老广告组明细,D0标准，new收入占比
    , z1 as (
        select a.*
            ,case when a.product in ('海剧') then coalesce(r2.R0Std,put2.R0Std) else coalesce(r.R0Std,put.R0Std) end r0_std
            ,case when a.source_chl in ('fbs2s','fb','fbs2s(ASC)','facebook') then 'meta' when a.source_chl in('tt','tiktok app') then 'tiktok' when a.source_chl in('adwords') then 'adwords' else '其他' end as source2
            ,n.day0_amt reg_num_all
            ,n.day0_amt_new reg_num_new
        from (
            -- dx
            select *
                ,DENSE_RANK() over(partition by concat(source_chl,adset_id) order by dt asc) dx
                ,lag(dt,1) over(partition by concat(source_chl,adset_id) order by dt asc) date_key_prev
                ,sum(cost_amount) over(partition by concat(source_chl,adset_id,dt)) spend_mt
            from a2
        ) a
        -- 最新阅读大盘标准
        left join (
            select *
            from ods.ods_ads_tidb_sharpengine_ads_global_PutProductRoiStdCfgV2Daily
             where  BookChannel =1
        ) put on put.CurrentLanguage2=a.languageid and put.Mt = if(a.mt=0,1,a.mt) and put.BookChannel = (if(a.book_channel not in (0, 1), 1, a.book_channel))
            and put.DateKey=a.dt and put.SourceChl = a.source_chl and IFNULL(put.AdTarget,'') = IFNULL(a.ad_target,'') and put.BookType = a.story_type
        -- 最新书籍标准
        left join (
            select BookId
                ,Mt
                ,R0Std
                ,H24Std
                ,DateKey
                ,SourceChl
                ,AdTarget
            from ods.ods_ads_tidb_sharpengine_ads_global_BookRoiStdCfgV2Daily
        ) r on r.BookId=a.book_id and r.Mt=if(a.mt=0,1,a.mt) and r.DateKey=a.dt and r.SourceChl = a.source_chl and IFNULL(r.AdTarget,'') = IFNULL(a.ad_target,'')
        -- 海剧标准
        left join (
            select CurrentLanguage2
                ,Mt
                ,SourceChl
                ,R0Std
                ,H24Std
                ,DateKey
                ,AdTarget
            from ods.ods_ads_tidb_sharpengine_ads_global_PutProductVideoRoiStdCfgV2Daily
        ) put2 on put2.CurrentLanguage2=a.languageid and put2.Mt = if(a.mt=0,1,a.mt) and put2.SourceChl = a.source_chl and put2.DateKey=a.dt and IFNULL(put2.AdTarget,'') = IFNULL(a.ad_target,'')
        -- 海剧分剧标准
        left join ods.ods_ads_tidb_sharpengine_ads_global_VideoRoiStdCfgV2Daily r2
         on r2.VideoId=a.book_id and r2.Mt=if(a.mt=0,1,a.mt) and r2.SourceChl = a.source_chl and r2.DateKey=a.dt and IFNULL(r2.AdTarget,'') = IFNULL(a.ad_target,'')
        -- new占比
        left join (
            select a.install_date
                ,e.ad_set_id
                ,a.product_id
                ,sum(day0_amt ) day0_amt
                ,sum(day0_amt_new ) day0_amt_new
            from ads.ads_bi_ad_new_user_value_ed a
            left join ads.ads_advertisement_adext_view e on a.product_id=e.product_id and a.ad_id=e.ad_id
            where a.install_date>days_add(curdate(),-420)
            group by 1,2,3
        ) n on  a.adset_id=n.ad_set_id and a.dt=date(n.install_date)  and a.product_id=n.product_id
        where a.spend_mt>0
    )

    -- 书籍、优化，分日汇总,TT组剔除fb基建
    , z2 as (
        select dt
            ,days_diff(curdate(),dt) days
            ,if(dayofweek(dt)=1,7,dayofweek(dt)-1) weekdays
            ,product
            ,source2
            ,case when source2='adwords' then languageid else book_id end as book_id
            ,case when source2='adwords' then languageid else book_code end as book_code
            ,nick_name
            ,ad_optimizer_uid
            ,ad_optimizer_group
            ,languageid
            ,case languageid  when 2 then 'FT'
                            when 3 then 'EN'
                            when 4 then 'SP'
                            when 5 then 'PT'
                            when 6 then 'FR'
                            when 7 then 'RU'
                            when 9 then 'JP'
                            when 11 then 'ID'
                            when 12 then 'TH'
                            when 13 then '越语'
                            when 14 then 'KR'
                            when 16 then 'DE'
							when 8 then 'IT'
							when 10 then 'AR'
                            end as current_language2
            ,case when dx=1  then 1 else 0 end is_newad
            ,count(distinct adset_id) adset_num
            ,sum(cost_amount) spend
            ,sum(reg_num) reg_num
            ,sum(amount)/sum(cost_amount*r0_std) r0
            ,sum(amount) d0_amt
            ,sum(cost_amount*r0_std) std_amt
            ,sum(reg_num_all) reg_num_all
            ,sum(reg_num_new) reg_num_new
        from z1
      --  where source_chl in ('tt','tiktok app')  or (source_chl in ('facebook','fbs2s')  and ad_optimizer_uid not in (230240,141683,140041))
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13
    )

    -- 基建指标，优化师汇总 ,-- 优化师分组自定义
    , z3 as (
        select a.dt
            ,a.weekdays
            ,a.product
            ,a.source2
            ,a.book_id
            ,a.book_code
            ,a.nick_name
            ,a.ad_optimizer_uid
            ,case when a.product ='海阅' then right(a.ad_optimizer_group,1) else c.ad_optimizer_group end as ad_optimizer_group
            ,a.current_language2
            ,a.languageid
            ,a.adset_num
            ,a.spend
            ,a.d0_amt
            ,a.std_amt
            ,a.reg_num
            ,a.reg_num_all
            ,a.reg_num_new
            ,days_diff(curdate(),a.first_time) as days_book
            -- 近7天new占比
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_new end) as regnum_new_7d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_all end) as regnum_all_7d
            -- 判断是否淘汰
            ,sum(case when b.is_newad=1  and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.spend end) spend_10d   -- 近7天平均花费
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.adset_num end) as adset_num_10d -- 近7日基建，阈值10条
            ,count(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.dt end) as days_10d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) d0_amt_10d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) std_amt_10d
            -- 历史总达标率，评估替补优先级，后续考虑加入花费
            ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.8,days_diff(a.dt,b.dt)+1)) end) d0_amt_all
            ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.8,days_diff(a.dt,b.dt)+1)) end) std_amt_all
            -- 判断基建
            ,sum(case when b.is_newad=1  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.4,days_diff(a.dt,b.dt)+1)) end) d0_amt_pow
            ,sum(case when b.is_newad=1  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.4,days_diff(a.dt,b.dt)+1)) end) std_amt_pow
            -- 老组达标率
            ,sum(case when b.is_newad=0  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.4,days_diff(a.dt,b.dt)+1)) end) d0_amt_pow_old
            ,sum(case when b.is_newad=0  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.4,days_diff(a.dt,b.dt)+1)) end) std_amt_pow_old
            -- 后3天达标
            ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.d0_amt) end) d0_amt_af
            ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.std_amt) end) std_amt_af
        from (
            -- 每天优化分书花费
            select *
                ,min(dt) over(partition by product,book_id)  first_time  --书籍首次投放日期
            from (
                select dt
                    ,weekdays
                    ,product
                    ,source2
                    ,book_id
                    ,book_code
                    ,nick_name
                    ,ad_optimizer_uid
                    ,ad_optimizer_group
                    ,current_language2
                    ,languageid
                    ,sum(adset_num) adset_num
                    ,sum(spend) spend
                    ,sum(d0_amt) d0_amt
                    ,sum(std_amt) std_amt
                    ,sum(reg_num) reg_num
                    ,sum(reg_num_all) reg_num_all
                    ,sum(reg_num_new) reg_num_new
                from z2
                where  days<360 -- 过去180天数据
                group by 1,2,3,4,5,6,7,8,9,10,11
            ) x
        ) a
        -- 历史数据
        left join z2 b on a.product=b.product and a.book_id=b.book_id and a.ad_optimizer_uid=b.ad_optimizer_uid and a.source2=b.source2
		-- 获取海剧优化师分组
		left join  dim.dim_sv_ad_optimizer_group_info c
		on a.product=c.product and a.ad_optimizer_uid=c.ad_optimizer_uid
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
    )

    -- 增加阶段，每日2阶以上书， 代号，书籍语言
    , z4 as (
        select a.dt
            ,case project_code when 1 then '海阅' when 2 then '海剧' end product
            ,case when source_chl in ('fbs2s','fb','fbs2s(ASC)','facebook') then 'meta' when source_chl in('tt','tiktok app') then 'tiktok' when source_chl in('adwords') then 'adwords' else '其他' end as source2
            ,code_id
            ,code_stage
            ,code_lv  -- B级只对最近2天生效
            ,test_status -- 禁投只对最近2天生效
            ,date(begin_date) begin_date
            ,date(end_date) end_date
            ,if(p.project_code  in (2),s.source_series_code,b.book_code)  book_code
            ,if(p.project_code  in (2),s.language,b.languageid)  languageid
        from (
            select dt
            from z3
            group by 1
        ) a
        -- 测试排期
        left join ads.ads_srsv_ads_marketing_plan_view p on a.dt>=p.begin_date and a.dt<=p.end_date  -- 进阶日前一天数据
        -- 书籍信息
        left join (
            select book_id
                ,site_id2
                ,book_code
                ,languageid
            from dim.dim_shuangwen_book_read_consume_info
            group by 1,2,3,4
        ) b on p.code_id =b.book_id
        -- 短剧信息
        left join (
            select series_id
                ,language
                ,source_series_code
            from dim.dim_sv_series_hi
            group by 1,2,3
        ) s on p.code_id =s.series_id
        where p.is_del=0   and  source_chl<>''
                    and p.code_stage>1   -- 2阶以上，刚进阶前一天数据
                    -- and  if(days_diff(curdate(),a.dt)<3,code_lv,'') not in('B')
                    and  if(days_diff(curdate(),a.dt)<2,test_status,'') not in(2)
    )

    -- 每日可投书籍，分优化师数据，小组汇总（席位用）,adowrds用fb的状态
    , z5 as (
        select b.dt
            ,b.product
            ,b.source2
            ,b.book_id code_id
            ,a.code_stage
            ,a.code_lv  -- B级只对最近2天生效
            ,a.test_status -- 禁投只对最近2天生效
            ,a.begin_date
            ,a.end_date
            ,b.book_code
            ,b.languageid
            ,if(dayofweek(b.dt)=1,7,dayofweek(b.dt)-1) weekdays
            ,b.current_language2
            ,b.nick_name
            ,b.ad_optimizer_uid
            ,b.ad_optimizer_group
            ,b.adset_num
            ,b.spend
            ,b.d0_amt
            ,b.std_amt
            ,b.reg_num
            ,b.reg_num_all
            ,b.reg_num_new
            -- 近7天new占比
            ,regnum_new_7d
            ,regnum_all_7d
            -- 判断是否淘汰
            ,spend_10d   -- 近7天平均花费
            ,adset_num_10d -- 近7日基建，阈值10条
            ,days_10d
            ,d0_amt_10d
            ,std_amt_10d
            -- 历史总达标率，评估替补优先级，后续考虑加入花费
            ,d0_amt_all
            ,std_amt_all
            -- 判断基建
            ,d0_amt_pow
            ,std_amt_pow
            -- 老组达标率
            ,d0_amt_pow_old
            ,std_amt_pow_old
            -- 每日书籍基建和指标
            /*,sum(b.adset_num) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_adset_num
            ,sum(b.spend) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_spend
            ,sum(b.spend_10d) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_spend_10d
            ,sum(b.adset_num_10d) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_adset_num_10d
            ,sum(b.d0_amt_pow) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_d0_amt_pow
            ,sum(b.std_amt_pow) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_std_amt_pow
            ,sum(b.d0_amt_pow_old) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_d0_amt_pow_old
            ,sum(b.std_amt_pow_old) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_std_amt_pow_old
            --new占比大盘值
            ,sum(b.regnum_new_7d) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_regnum_new_7d
            ,sum(b.regnum_all_7d) over(partition by concat(a.product,a.code_id,a.source2,a.dt,b.ad_optimizer_group)) bk_regnum_all_7d */
            ,FIRST_VALUE(b.nick_name) over(partition by concat(a.product,a.source2,a.code_id) order by case when ifnull(b.spend,0)<10 or b.nick_name like '%离职%' then '2050-01-01' else b.dt end asc,b.nick_name) frt_nickname
            ,s.nick_name as nick_name_max
        from z3 b
        left join z4 a on a.dt=b.dt and a.product=b.product and a.source2=if(b.source2='adwords','meta',b.source2)  and a.code_id=b.book_id
        -- 基建兜底，历史花费最大
        left join (
            select product
                ,source2
                ,book_id
                ,max_by(ad_optimizer_uid,std_amt_all) as ad_optimizer_uid
                ,max_by(nick_name,std_amt_all) as nick_name
            from z3
            where nick_name not like '%离职%'  --剔除离职,非当前架构
            group by 1,2,3
        ) s on b.product=s.product and b.source2=s.source2 and b.book_id=s.book_id
    )

-- data1:每日基建data,
    select a.*
        ,'' frt_group
        ,'' is_frt_group  -- 专属
        ,'' off_begindate
        ,'' off_enddate
        -- ,case when a.days_10d>=4 and a.spend_10d>=10000 and a.d0_amt_10d/a.std_amt_10d<0.8 then a.dt end  off_begindate
        -- ,date(days_add(case when a.days_10d>=4 and a.adset_num_10d>=10 and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',0.49,0.56) then a.dt end,7)) off_enddate
        ,now() as etl_tm
    from z5 a
    where a.dt>='${bf_9_dt}'  and a.dt<='${dt}'
    order by a.dt desc,a.adset_num  desc
    ;
