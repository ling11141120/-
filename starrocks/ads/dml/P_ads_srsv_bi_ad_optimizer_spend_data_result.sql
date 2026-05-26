----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_spend_data
-- workflow_version : 14
-- create_user      : hufengju
-- task_name        : ads_srsv_bi_ad_optimizer_spend_data_result
-- task_version     : 11
-- update_time      : 2025-07-11 15:45:12
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_spend_data\ads_srsv_bi_ad_optimizer_spend_data_result
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.`ads_srsv_bi_ad_optimizer_spend_data_result`  where dt>='${bf_9_dt}'  and dt<='${dt}';

-- SQL语句
insert into ads.`ads_srsv_bi_ad_optimizer_spend_data_result`

with z1_1 AS (
        SELECT  t1.dt
            ,t1.product
            ,t1.source2
            ,t1.code_id
            ,t1.code_stage
            ,t1.code_lv
            ,t1.test_status
            ,t1.begin_date
            ,t1.end_date
            ,t1.book_code
            ,t1.languageid
            ,t1.weekdays
            ,t1.current_language
            ,t1.nick_name
            ,t1.ad_optimizer_uid
            ,t1.ad_optimizer_group
            ,t1.adset_num
            ,t1.spend
            ,t1.d0_amt
            ,t1.std_amt
            ,t1.reg_num
            ,t1.reg_num_all
            ,t1.reg_num_new
            ,t1.regnum_new_7d
            ,t1.regnum_all_7d
            ,t1.spend_10d
            ,t1.adset_num_10d
            ,t1.days_10d
            ,t1.d0_amt_10d
            ,t1.std_amt_10d
            ,t1.d0_amt_all
            ,t1.std_amt_all
            ,t1.d0_amt_pow
            ,t1.std_amt_pow
            ,t1.d0_amt_pow_old
            ,t1.std_amt_pow_old
            ,t1.frt_nickname
            ,t1.nick_name_max
            ,t1.frt_group
            ,t1.is_frt_group
            ,coalesce(t1.off_begindate,'1990-01-01')    AS off_begindate
            ,coalesce(t1.off_enddate,'1990-01-01')      AS off_enddate
            ,t2.lang
            ,power(t2.lang_rate ,0.9 )                  AS lang_rate
            ,t2.group_spend
            ,t2.sunday_rate
            ,t2.friday_rate
            ,t2.base_rate
            ,t3.new_std
            ,t3.old_std
            ,t3.log_num
            ,t3.log_num_median
            ,t3.exp_a
            ,t3.new_r0_rate
            ,t3.non_compliance_exp
            ,t3.spend_exp
            ,CASE WHEN t1.weekdays = 7 THEN t2.sunday_rate/0.9
                    WHEN t1.weekdays = 5 THEN t2.friday_rate*0.9  ELSE 1 END `星期系数`    -- 9月30日bug
            ,power(if(regnum_all_7d = 0,0,regnum_new_7d/regnum_all_7d),2) N收入占比
            ,coalesce(d0_amt_pow/std_amt_pow,0)         AS R0_新
            ,coalesce(d0_amt_pow_old/std_amt_pow_old,0) AS R0_老
        FROM ads.ads_srsv_bi_ad_optimizer_spend_data t1
        LEFT JOIN dim.dim_srsv_ad_prduct_lang_rate t2
        ON t1.product = t2.product AND t1.languageid = t2.lang_id
        LEFT JOIN dim.dim_srsv_ad_prduct_source_rate t3
        ON t1.product = t3.product AND t1.source2 = t3.source_plaform
        ORDER BY t1.days_10d
    )
, z1_2 AS (
	SELECT  z1_1.*
	       ,(ifnull(d0_amt_pow,0)/new_std + ifnull(d0_amt_pow_old,0)/old_std)/(ifnull(std_amt_pow,0.00001)+ifnull(std_amt_pow_old,0.00001))   AS 增幅底数       -- 9月30日bug
	       ,greatest(exp_a + lang_rate+ ifnull(N收入占比,0.5) ,1) AS 增幅指数
           ,0 平均花费系数
	FROM z1_1
)
-- , z1_3 AS (
-- 	SELECT  z1_2.*
-- 	       ,power(增幅底数,if(增幅底数 > 1,增幅指数,non_compliance_exp)) AS `增幅倍数`
-- 	FROM z1_2
-- )
, z1_3 AS (
	SELECT  z1_2.*
	       ,power(case when 增幅底数<1 or ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)<1 then greatest(增幅底数,ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)) else least(增幅底数,ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)) end
                    ,if((case when 增幅底数<1 or ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)<1 then greatest(增幅底数,ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)) else least(增幅底数,ifnull(d0_amt,0)/0.9/ifnull(std_amt,0.00001)) end) > 1,增幅指数,non_compliance_exp)) AS `增幅倍数`
	FROM z1_2
)
, z1_4 AS (
	SELECT  z1_3.*
	       ,round(least(`增幅倍数`*`星期系数`,4)*spend) 基建1
	FROM z1_3
)
, z1_6 AS (
	SELECT  z1_4.*
        ,基建1 as 基建2
        ,1 as 不淘汰
        ,基建1 as 基建3
	FROM z1_4
)

        select *
            ,0 as 小组基建
            ,0 as 席位
            ,0 as 在投人数
            ,0 as 总new占比
            ,null as 专属组
            ,0 as 书籍次日基建
            ,0 as 兜底书籍
            ,0 as 是否补位
            ,nick_name as nick_name2
            ,基建3 as 基建4
            ,now() as etl_tm
        from z1_6  where dt>='${bf_9_dt}'  and dt<='${dt}'  and nick_name is not null
        ;

-- SQL语句
insert into ads.`ads_srsv_bi_ad_optimizer_spend_data_result`
-- 10月16日 增加补位逻辑
with z7_1 as (
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
        where  a.create_time >= days_add(curdate(),-200)   and a.source_chl in ('facebook','fbs2s','tt','tiktok app','adwords')
    )

    -- 分日新老广告组的D0汇总，书籍代号，优化师名称
    , z7_2 as (
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
            from z7_1
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
    , z7_3 as (
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
            from z7_2
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
                ,mt
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
                ,mt
                ,SourceChl
                ,R0Std
                ,H24Std
                ,DateKey
                ,AdTarget
            from ods.ods_ads_tidb_sharpengine_ads_global_PutProductVideoRoiStdCfgV2Daily
        ) put2 on put2.CurrentLanguage2=a.languageid and put2.Mt = if(a.mt=0,1,a.mt) and put2.SourceChl = a.source_chl and put2.DateKey=a.dt and IFNULL(put2.AdTarget,'') = IFNULL(a.ad_target,'')
        -- 海剧分剧标准
        left join ods.ods_ads_tidb_sharpengine_ads_global_VideoRoiStdCfgV2Daily r2 on r2.VideoId=a.book_id and r2.Mt=if(a.mt=0,1,a.mt) and r2.SourceChl = a.source_chl and r2.DateKey=a.dt and IFNULL(r2.AdTarget,'') = IFNULL(a.ad_target,'')
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

    -- 分语言的CAC标准，过去4个月
    , z7_4 as (
        select product
            ,languageid
            ,sum(cost_amount) cost_amount
            ,sum(reg_num) reg_num
            ,sum(payers_num) payers_num
            ,sum(cost_amount)/sum(payers_num)  d0_cac
        from z7_3
        where dt >days_add(curdate(),-120) and source2='meta'
        group by 1,2
    )

    -- 剧维度分组，分日花费维度，筛选：符合CAC*10的剧
    , z7_5 as (
        select a.*
            ,ifnull(c.rand_v,0.9) rand_v
            ,count(case when 组在投人数2>0 then a.ad_optimizer_group end) over(partition by a.dt,a.product,a.source2,a.code_id) 在投组数
        from (
            select *
                ,sum(组在投人数) over(partition by dt,product,source2,code_id) 剧在投人数
                ,sum(组在投人数2) over(partition by dt,product,source2,code_id) 剧在投人数2
                ,sum(adset_num) over(partition by dt,product,source2,code_id) adset_num_sum
                ,sum(adset_num2) over(partition by dt,product,source2,code_id) adset_num_sum2
                ,sum(spend) over(partition by dt,product,source2,code_id) spend_sum
                ,sum(基建4) over(partition by dt,product,source2,code_id) spend_sum2
                ,sum(d0_amt) over(partition by dt,product,source2,code_id) d0_amt_sum
                ,sum(std_amt) over(partition by dt,product,source2,code_id) std_amt_sum
                ,ceiling(ln(sum(adset_num) over(partition by dt,product,source2,code_id))) 剧席位
            from (
                select dt
                    ,product
                    ,current_language
                    ,languageid
                    ,source2
                    ,code_id
                    ,ad_optimizer_group
                    ,count(spend>30) 组在投人数
                    ,count(基建4>50) 组在投人数2
                    ,sum(adset_num) adset_num
                    ,sum(adset_num*增幅倍数) adset_num2
                    ,sum(spend) spend
                    ,sum(基建4) 基建4
                    ,sum(d0_amt) d0_amt
                    ,sum(std_amt) std_amt
                from ads.ads_srsv_bi_ad_optimizer_spend_data_result
                where dt>days_add(curdate(),-30)
                group by 1,2,3,4,5,6,7
            ) x
        ) a
        -- cac * 10倍作为阈值
        join   z7_4 b on a.product=b.product and a.languageid=b.languageid  and a.spend_sum2>b.d0_cac*10
        --分剧分组优先级
        left join (
            select dt
                ,product
                ,code_id
                ,ad_optimizer_group
                ,avg(rand_v) rand_v
            from  dim.dim_srsv_ad_product_rand_info
            group by 1,2,3,4
        ) c on a.dt=c.dt and a.product=c.product and a.code_id=c.code_id and a.ad_optimizer_group=c.ad_optimizer_group
    )

    -- 分组，新增席位
    , z7_8 as (
        select *
            ,分配均值-剧在投人数2+if(rn<=余数,1,0) as  新增席位
        from (
            select *
                ,FLOOR(剩余席位/组数)  as 分配均值
                ,mod(剩余席位,组数) as 余数
            from (
                select *
                    ,row_number() over(partition by concat(dt,product,source2,code_id) order by rand_v desc) rn
                    ,ceiling(剧席位/在投组数)  每组席位数up
                    ,剧席位-max(剧在投人数2) over(partition by concat(dt,product,source2,code_id))  剩余席位
                    ,count(1) over(partition by concat(dt,product,source2,code_id) order by rand_v desc) 组数
                from z7_5
                where 剧在投人数2<剧席位 and 组在投人数2< ceiling(剧席位/在投组数)
            ) x
        ) xx
    )
    -- 分组，补人优先级
    , z7_6 as (
        select *
            ,row_number() over(partition by concat(product,source2,dt,code_id,ad_optimizer_group) order by case when last_taotai_time<7 then -1 else  ifnull(r0_all,-2)  end desc) rn
        from (
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
                    from ads.ads_srsv_bi_ad_optimizer_spend_data
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
                    from ads.ads_srsv_bi_ad_optimizer_spend_data
                    group by 1,2,3,4,5,6,7,8,9
                ) c on a.product=c.product and a.source2=c.source2 and a.dt=c.dt  --and a.current_language=c.current_language
                -- 剔除在投优化师
                left join (
                    select product
                        ,source2
                        ,code_id
                        ,dt
                        ,ad_optimizer_uid
                    from ads.ads_srsv_bi_ad_optimizer_spend_data
                    where spend>20
                    group by 1,2,3,4,5
                ) b on a.product=b.product and a.dt=b.dt  and a.ad_optimizer_uid=b.ad_optimizer_uid and c.code_id=b.code_id and a.source2=b.source2
                -- 每日优化师随机值
                left join dim.dim_srsv_ad_product_rand_info f on c.code_id=f.code_id  and a.dt=f.dt and a.ad_optimizer_uid=f.ad_optimizer_uid and a.product=f.product
                where b.ad_optimizer_uid is null
            ) a
            -- 所有优化师
            left join (
                select *
                    ,case when days_10d>=3 and adset_num_10d>=10 and d0_amt_10d/std_amt_10d<if(source2='meta',0.56,0.65) then dt end is_taotai_time  -- 是否淘汰
                from ads.ads_srsv_bi_ad_optimizer_spend_data
                where spend>5
            ) b on a.product=b.product and a.dt>b.dt and a.ad_optimizer_uid=b.ad_optimizer_uid and a.code_id=b.code_id and a.source2=b.source2
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13
        ) x
        where nick_name not like '%离职%'
    )

    -- 结果：新增席位
    , z7 as (
        select a.dt
            ,a.product
            ,a.source2
            ,a.code_id
            ,null code_stage
            ,null code_lv
            ,null test_status
            ,'1990-01-01' begin_date
            ,'1990-01-01' end_date
            ,b.book_code
            ,a.languageid
            ,0 weekdays
            ,a.current_language
            ,b.nick_name
            ,b.ad_optimizer_uid
            ,a.ad_optimizer_group
            ,0 adset_num
            ,0 spend
            ,0 d0_amt
            ,0 std_amt
            ,0 reg_num
            ,0 reg_num_all
            ,0 reg_num_new
            ,0 regnum_new_7d
            ,0 regnum_all_7d
            ,0 spend_10d
            ,0 adset_num_10d
            ,0 days_10d
            ,0 d0_amt_10d
            ,0 std_amt_10d
            ,0 d0_amt_all
            ,0 std_amt_all
            ,0 d0_amt_pow
            ,0 std_amt_pow
            ,0 d0_amt_pow_old
            ,0 std_amt_pow_old
            ,b.frt_nickname
            ,b.nick_name_max
            ,null frt_group
            ,null is_frt_group
            ,'1990-01-01' off_begindate
            ,'1990-01-01' off_enddate
            ,null lang
            ,0 lang_rate
            ,0 group_spend
            ,0 sunday_rate
            ,0 friday_rate
            ,0 base_rate
            ,0 new_std
            ,0 old_std
            ,0 log_num
            ,0 log_num_median
            ,0 exp_a
            ,0 new_r0_rate
            ,0 non_compliance_exp
            ,0 spend_exp
            ,0 星期系数
            ,0 N收入占比
            ,0 R0_新
            ,0 R0_老
            ,0 增幅底数
            ,0 增幅指数
            ,0 平均花费系数
            ,0 增幅倍数
            ,0 基建1
            ,0 基建2
            ,0 不淘汰
            ,0 基建3
            ,0 小组基建
            ,0 席位
            ,0 在投人数
            ,0 总new占比
            ,null 专属组
            ,0 书籍次日基建
            ,0 兜底书籍
            ,1 是否补位
            ,b.nick_name nick_name2
            ,c.d0_cac*4 as 基建4
        from z7_8 a
        join z7_6 b on a.product=b.product and a.dt=b.dt and a.source2=b.source2 and a.code_id=b.code_id and a.ad_optimizer_group=b.ad_optimizer_group and b.rn<=a.新增席位
        left join z7_4 c on a.product=c.product and a.languageid=c.languageid
        where a.source2 in ('meta','tiktok') and a.新增席位>0
    )

    -- 结果：兜底席位
    , z8 as (
        select a.dt
            ,a.product
            ,a.source2
            ,a.code_id
            ,a.code_stage
            ,a.code_lv
            ,a.test_status
            ,a.begin_date
            ,a.end_date
            ,a.book_code
            ,a.languageid
            ,a.weekdays
            ,a.current_language
            ,b.nick_name
            ,b.ad_optimizer_uid
            ,b.ad_optimizer_group
            ,0 adset_num
            ,0 spend
            ,0 d0_amt
            ,0 std_amt
            ,0 reg_num
            ,0 reg_num_all
            ,0 reg_num_new
            ,0 regnum_new_7d
            ,0 regnum_all_7d
            ,0 spend_10d
            ,0 adset_num_10d
            ,0 days_10d
            ,0 d0_amt_10d
            ,0 std_amt_10d
            ,0 d0_amt_all
            ,0 std_amt_all
            ,0 d0_amt_pow
            ,0 std_amt_pow
            ,0 d0_amt_pow_old
            ,0 std_amt_pow_old
            ,a.frt_nickname
            ,a.nick_name_max
            ,null frt_group
            ,null is_frt_group
            ,'1990-01-01' off_begindate
            ,'1990-01-01' off_enddate
            ,null lang
            ,0 lang_rate
            ,0 group_spend
            ,0 sunday_rate
            ,0 friday_rate
            ,0 base_rate
            ,0 new_std
            ,0 old_std
            ,0 log_num
            ,0 log_num_median
            ,0 exp_a
            ,0 new_r0_rate
            ,0 non_compliance_exp
            ,0 spend_exp
            ,0 星期系数
            ,0 N收入占比
            ,0 R0_新
            ,0 R0_老
            ,0 增幅底数
            ,0 增幅指数
            ,0 平均花费系数
            ,0 增幅倍数
            ,0 基建1
            ,0 基建2
            ,0 不淘汰
            ,0 基建3
            ,0 小组基建
            ,0 席位
            ,0 在投人数
            ,0 总new占比
            ,null 专属组
            ,0 书籍次日基建
            ,1 兜底书籍
            ,1 是否补位
            ,b.nick_name nick_name2
            ,c.d0_cac*4 as 基建4
        from (
            select *
                ,count(基建4>50) over(partition by dt,product,source2,code_id) 投放人数
                ,row_number() over(partition by dt,product,source2,code_id order by spend) rn
            from ads.ads_srsv_bi_ad_optimizer_spend_data_result
            where dt>days_add(curdate(),-30)
        ) a
        -- 优化师组
        left join (
            select distinct dt
                ,product
                ,ad_optimizer_group
                ,ad_optimizer_uid
                ,nick_name
            from dim.dim_srsv_ad_product_rand_info
            where dt>days_add(curdate(),-60)
        ) b on a.dt=b.dt and a.product=b.product and a.nick_name_max=b.nick_name
        left join z7_4 c on a.product=c.product and a.languageid=c.languageid
        where a.投放人数=0 and a.source2 in ('meta','tiktok') and a.rn=1
    )

    -- 汇总
    , z9 as (

        select * from z7
        -- 兜底席位
        union all
        select * from z8
    )

select * ,now() as etl_tm from z9  where dt>='${bf_9_dt}'  and dt<='${dt}' and nick_name2 is not null ;
