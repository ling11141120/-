----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data_v1
-- workflow_version : 71
-- create_user      : yanxh
-- task_name        : ads_srsv_bi_ad_optimizer_target_data_v1
-- task_version     : 31
-- update_time      : 2025-02-21 10:23:16
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data_v1\ads_srsv_bi_ad_optimizer_target_data_v1
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_srsv_bi_ad_optimizer_target_data_v1 where dt>='${bf_9_dt}'  and dt<='${dt}';

-- SQL语句
insert into  ads.ads_srsv_bi_ad_optimizer_target_data_v1
    with a1 as (
        select a.create_time,a.product_id,a.ad_set_id,a.cost_amount ,a.reg_num ,a.day0_amount ,a.day0_amount_by_ad ,a.source_chl,a.mt,a.day0_first_pay_num
            ,e.book_id
            ,e.ad_optimizer_uid
            ,e.ad_optimizer_group
			,e.book_channel
        from dwd.dwd_ad_fb_ad_roi_install_referrer_timezone_di_view a
        -- 广告组和优化
        left join (
            select product_id
                    ,ad_set_id
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
                    ,count(1) cnt
                from ads.ads_advertisement_adext_view
                group by 1,2,3,4,5,6
            ) x
            group by 1,2
        ) e on a.product_id=e.product_id and a.ad_set_id=e.ad_set_id
        where  a.create_time >= days_add(curdate(),-400)   and a.source_chl in ('facebook','fbs2s','tt','tiktok app')
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
                ,date(create_time) as dt
                ,sum(cost_amount) cost_amount
                ,sum(reg_num) reg_num
                ,sum(day0_amount+day0_amount_by_ad) amount
                ,sum(day0_first_pay_num) payers_num
            from a1
            where book_id is not null
            group by 1,2,3,4,5,6,7,8,9
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
            ,case when a.product in ('海剧') then coalesce(r2.r0_std,put2.r0_std) else coalesce(r.r0_std,put.r0_std) end r0_std
            ,case when a.source_chl in ('tt','tiktok app') then 'tiktok' else 'meta' end source2
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
            from dwd.dwd_advertisement_put_product_stdcfg_daily_view
             where  book_channel =1
        ) put on a.languageid=put.current_language2 and if(a.mt=0,1,a.mt)=put.mt and a.dt=put.date_key
        -- 最新书籍标准
        left join (
            select book_id
                ,mt
                ,r0_std
                ,h24_std
                ,date_key
            from dwd.dwd_advertisement_book_roi_stdcfg_daily_view
        ) r on a.book_id=r.book_id and if(a.mt=0,1,a.mt)=r.mt  and a.dt=r.date_key
        -- 海剧标准
        left join (
            select current_language2
                ,mt
                ,source_chl
                ,r0_std
                ,h24_std
                ,date_key
            from dwd.dwd_sv_ad_put_product_video_roi_stdCfg_daily_view
        ) put2 on a.languageid=put2.current_language2 and if(a.mt=0,1,a.mt)=put2.mt and a.source_chl=put2.source_chl and a.dt=put2.date_key
        -- 海剧分剧标准
        left join  dim.dim_sv_videoroistdcfgdaily_view r2 on a.languageid=r2.current_language2 and if(a.mt=0,1,a.mt)=r2.mt and a.source_chl=r2.source_chl and a.dt=r2.date_key  and a.book_id=r2.video_id
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
            ,book_id
            ,book_code
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
            ,a.adset_num
            ,a.spend
            ,a.d0_amt
            ,a.std_amt
            ,a.reg_num
            ,a.reg_num_all
            ,a.reg_num_new
            ,days_diff(curdate(),a.first_time) as days_book
            --近7天new占比
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_new end) as regnum_new_7d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<7 and a.dt>=b.dt then b.reg_num_all end) as regnum_all_7d
            --判断是否淘汰
            ,sum(case when b.is_newad=1  and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.spend end) spend_10d   -- 近7天平均花费
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.adset_num end) as adset_num_10d -- 近7日基建，阈值10条
            ,count(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then b.dt end) as days_10d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) d0_amt_10d
            ,sum(case when b.is_newad=1 and days_diff(a.dt,b.dt)<10 and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.72,days_diff(a.dt,b.dt)+1)) end) std_amt_10d
            --历史总达标率，评估替补优先级，后续考虑加入花费
            ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.8,days_diff(a.dt,b.dt)+1)) end) d0_amt_all
            ,sum(case when  a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.8,days_diff(a.dt,b.dt)+1)) end) std_amt_all
            --判断基建
            ,sum(case when b.is_newad=1  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end) d0_amt_pow
            ,sum(case when b.is_newad=1  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end) std_amt_pow
            --老组达标率
            ,sum(case when b.is_newad=0  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.d0_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end) d0_amt_pow_old
            ,sum(case when b.is_newad=0  and a.dt>=b.dt then (if(b.weekdays>5,0.9,1)*b.std_amt*pow(0.6,days_diff(a.dt,b.dt)+1)) end) std_amt_pow_old
            --后3天达标
            ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.d0_amt) end) d0_amt_af
            ,sum(case when b.is_newad=1  and a.dt<b.dt and days_diff(b.dt,a.dt)<4 then (if(b.weekdays>5,0.9,1)*b.std_amt) end) std_amt_af
        from (
            --新广告组
            select *
                ,min(dt) over(partition by product,book_id)  first_time  --书籍首次投放日期
            from z2
            where is_newad=1   and days<360 -- 过去180天数据
        ) a
        -- 历史数据
        left join z2 b on a.product=b.product and a.book_id=b.book_id and a.ad_optimizer_uid=b.ad_optimizer_uid
		-- 获取海剧优化师分组
		left join  dim.dim_sv_ad_optimizer_group_info c
		on a.product=c.product and a.ad_optimizer_uid=c.ad_optimizer_uid
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
    )

        --增加阶段，每日2阶以上书， 代号，书籍语言，近2天B级书过滤
    , z4 as (
        select a.dt
            ,case project_code when 1 then '海阅' when 2 then '海剧' end product
            ,case when source_chl in ('fb','fbs2s(ASC)') then 'meta' when source_chl in('tt') then 'tiktok' else '其他' end as source2
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
                    and p.code_stage>1   --2阶以上，刚进阶前一天数据
                    and  if(days_diff(curdate(),a.dt)<3,code_lv,'') not in('B')
                    and  if(days_diff(curdate(),a.dt)<2,test_status,'') not in(2)
    )

    -- 每日可投书籍，分优化师数据，小组汇总（席位用）
    , z5 as (
        select a.*
            ,if(dayofweek(a.dt)=1,7,dayofweek(a.dt)-1) weekdays
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
                            end as current_language
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
            --近7天new占比
            ,regnum_new_7d
            ,regnum_all_7d
            --判断是否淘汰
            ,spend_10d   -- 近7天平均花费
            ,adset_num_10d -- 近7日基建，阈值10条
            ,days_10d
            ,d0_amt_10d
            ,std_amt_10d
            --历史总达标率，评估替补优先级，后续考虑加入花费
            ,d0_amt_all
            ,std_amt_all
            --判断基建
            ,d0_amt_pow
            ,std_amt_pow
            --老组达标率
            ,d0_amt_pow_old
            ,std_amt_pow_old
            --每日书籍基建和指标
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
        from z4 a
        left join z3 b on a.dt=b.dt and a.product=b.product and a.source2=b.source2 and a.code_id=b.book_id
        -- 基建兜底，历史花费最大
        left join (
            select product
                ,source2
                ,book_id
                ,max_by(ad_optimizer_uid,std_amt_all) as ad_optimizer_uid
                ,max_by(nick_name,std_amt_all) as nick_name
            from z3
            where nick_name not like '%离职%'  --剔除离职
            group by 1,2,3
        ) s on a.product=s.product and a.source2=s.source2 and a.code_id=s.book_id
    )

    -- 每日专属组标签
    , book_group2 as (
        select product
            ,source2
            ,current_language
            ,code_id
            ,book_code
            ,code_stage
            ,begin_date
            ,dt
            ,frt_group
            ,if(product='海阅',3,if(left(concat(current_language,book_code),4)='ENXY',2,1))  as book_cycle
            ,min(ifnull(cycle_n,0)) cycle_n_min
            ,date(days_add(begin_date,least(ifnull(min(case when spend<cycle_n*spend_up then cycle_n end),3),if(product='海阅',3,if(left(concat(current_language,book_code),4)='ENXY',2,1)))*7)) end_date2  --海阅3周，海剧EN-XY的为2周，其他为1周
        from (
            select a.product
                ,a.source2
                ,a.current_language
                ,c.group_spend  as spend_up
                ,a.code_id
                ,a.book_code
                ,a.begin_date
                ,a.code_stage
                ,a.dt
                ,a.frt_group
                ,ceiling(days_diff(b.dt,a.begin_date)/7) as cycle_n
                ,max(b.dt) end_date  -- 单周期最后一天
                ,sum(b.cost_amount) spend
            from (
                -- 每日，专属组：最高阶前一周，花费最大小组
                select product
                    ,source2
                    ,current_language
                    ,code_id
                    ,book_code
                    ,code_stage
                    ,begin_date
                    ,dt
                    ,max_by(ad_optimizer_group,spend_bf7d) frt_group
                from (
                    select a.product
                        ,a.source2
                        ,a.current_language
                        ,a.code_id
                        ,a.book_code
                        ,a.code_stage
                        ,a.begin_date
                        ,a.dt
                        ,b.ad_optimizer_group
                        ,sum(b.spend) spend_bf7d
                    from z5 a
                    -- 专属组：最高阶前一周，花费最大小组
                    left join z3 b on a.product=b.product and a.code_id=b.book_id and a.source2=b.source2 and days_diff(a.begin_date,b.dt) between 0 and 7
                    group by 1,2,3,4,5,6,7,8,9
                ) x
                group by 1,2,3,4,5,6,7,8
            ) a
            left join
            -- 获取专属组花费
             dim.dim_srsv_ad_prduct_lang_rate c on a.product=c.product and  a.current_language=c.lang

            left join (
                -- 优化组、投放花费，用于判断是否出专属期
                select bb.ad_optimizer_group ad_optimizer_group2
                    ,aa.*
                from z1 aa
                -- 优化师和组
                left join (
                    select ad_optimizer_group
                        ,ad_optimizer_uid
                    from z3
                    where dt>=days_add(curdate(),-1)
                    group by 1,2
                ) bb on aa.ad_optimizer_uid=bb.ad_optimizer_uid
            ) b on  a.product=b.product and a.code_id=b.book_id and a.frt_group=b.ad_optimizer_group2 and a.source2=b.source2 and  b.dt>a.begin_date
            where a.frt_group is not null
            group by 1,2,3,4,5,6,7,8,9,10,11
        ) x
        group by 1,2,3,4,5,6,7,8,9,10
    )

    -- 替补和兜底优化师，剔除在投优化
        -- 近10天有无基建，std_amt_10d =花费* 目标
        -- 历史投放数据   std_amt_all
            -- 无投放数据，随机赋值逻辑
        -- 近期淘汰判断
            -- days_new_10d>=4
            -- adset_num_new_7d>=10
            -- 7d，
            -- 淘汰日期
            -- 周期，有效期7天

         , z6 as (
        select a.product
            ,a.dt
            ,a.source2
            ,a.current_language
            ,a.code_id
            ,a.book_code
            ,a.code_stage
            ,a.nick_name
            ,a.ad_optimizer_uid
            ,a.ad_optimizer_group
            ,a.frt_nickname
            ,a.nick_name_max
            ,a.rand_v
            ,days_diff(a.dt,max(b.dt)) last_days
            ,days_diff(a.dt,max(b.is_taotai_time))  last_taotai_time
            ,ifnull(max_by(d0_amt_all/std_amt_all,b.dt)/0.9,a.rand_v+0.99)  r0_all
            ,max_by(std_amt_all,b.dt) std_amt_all
        from (
            --每日书籍未投放优化师
            select a.*
                ,c.code_id
                ,c.book_code
                ,c.current_language
                ,c.code_stage
                ,c.frt_nickname
                ,c.nick_name_max
                ,f.rand_v
            from (
                --每日优化师
                select product
                    --,current_language
                    ,source2
                    ,nick_name
                    ,ad_optimizer_uid
                    ,ad_optimizer_group
                    ,dt
                from z5
                where nick_name is not null     -- 新增过滤
                group by 1,2,3,4,5,6
            ) a
            left join (
                -- 每日在投书
                select product
                    ,code_id
                    ,source2
                    ,current_language
                    ,book_code
                    ,code_stage
                    ,frt_nickname
                    ,nick_name_max
                    ,dt
                from z5
                group by 1,2,3,4,5,6,7,8,9
            ) c on a.product=c.product and a.source2=c.source2 and a.dt=c.dt  --and a.current_language=c.current_language
            -- 剔除在投优化师
            left join (
                select product
                    ,source2
                    ,code_id
                    ,dt
                    ,ad_optimizer_uid
                from z5
                group by 1,2,3,4,5
            ) b on a.product=b.product and a.dt=b.dt  and a.ad_optimizer_uid=b.ad_optimizer_uid and c.code_id=b.code_id and a.source2=b.source2
            -- 每日优化师随机值
           left join dim.dim_srsv_ad_product_rand_info_v1 f on c.code_id=f.code_id  and a.dt=f.dt and a.ad_optimizer_uid=f.ad_optimizer_uid and a.product=f.product
            where b.ad_optimizer_uid is null
        ) a
        -- 所有优化师
        left join (
            select *
                ,case when days_10d>=3 and adset_num_10d>=10 and d0_amt_10d/std_amt_10d<if(source2='meta',0.56,0.65) then dt end is_taotai_time  -- 是否淘汰
            from z5
            where spend>5
        ) b on a.product=b.product and a.dt>b.dt and a.ad_optimizer_uid=b.ad_optimizer_uid and a.code_id=b.code_id and a.source2=b.source2
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13
    )

-- data1:每日基建data
    select a.*
        ,b.frt_group
        ,if((b.end_date2>a.dt or (a.product='海阅' and a.code_stage=2 and days_diff(a.dt,ifnull(c.dt_nim,'2050-01-01'))<29))
            ,if(a.source2='tiktok' and ((a.product='海剧' and a.code_stage=2) or (a.product='海阅' and a.code_stage=3)),"",b.frt_group)
            ,"") as is_frt_group  --专属
        -- ,if((b.end_date>=a.dt or days_diff(a.dt,b.begin_date)<=7 or (a.product='海阅' and a.code_stage=2)),b.frt_group,"") as is_frt_group  --专属
        -- ,(b.end_date<a.dt or (day_diff(a.dt,b.begin_date)>7 and cycle_n is null)) as not_frt_group  --非专属
        ,case when a.days_10d>=if(a.product='海剧',3,4) and a.adset_num_10d>=if(a.product='海剧',6,10) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product='海剧',0.7,0.65),0.77) then a.dt end off_begindate
        ,date(days_add(case when a.days_10d>=if(a.product='海剧',3,4) and a.adset_num_10d>=if(a.product='海剧',6,10) and a.d0_amt_10d/a.std_amt_10d<if(a.source2='meta',if(a.product='海剧',0.7,0.65),0.77) then a.dt end,7)) off_enddate
        ,now() as etl_tm
    from z5  a
    -- 初始组
    left join book_group2 b on a.product=b.product and a.source2=b.source2 and a.code_id=b.code_id and a.dt=b.dt
    -- 起投日期
    left join (
        select product
            ,source2
            ,book_id
            ,min(dt) dt_nim
        from z2
        where spend>10
        group by 1,2,3
    ) c on a.product=c.product and a.source2=c.source2 and a.code_id=c.book_id
    where a.dt>='${bf_9_dt}'  and a.dt<='${dt}'
	;
