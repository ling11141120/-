insert into ads.ads_srsv_material_rating_probability

-- 底表2
    -- 素材维度，累计数据，截止当前数据
with t1 as (
    select  distinct
        a.asset_guid
        ,b.asset_guid as parent_iasset_guid
        ,b.language_name
        ,b.code
        ,b.materia_uid
        ,b.material_name
        ,b.bm_compelete_time
        ,b.source_chl_type
        ,b.tgt_type
        ,b.material_type
        ,if(b.language_name in('无文案')
            ,case when b.region_folder like '%欧美%' then '欧美'
                when b.region_folder like '%东南亚%' then '东南亚'
                else '全语种' end
            ,b.language_name) as language_asset  -- 素材语言
        ,case when b.code in ('无文案','通用','男频','狼人')   then '通用'
            when b.material_name like '%滚动%' then '定制'
            when b.material_name like '%滚屏%' then '定制'
            when b.material_name like '%解压%' then '定制'
            else '通用' end as  asset_type  -- 是否通用
        ,case when b.code in ('无文案','通用','男频','狼人')  then '通用'  else '定制' end as code_type   -- 素材分类
        -- ,case when concat(code,material_name) like '%男频%' then '男频'
        --     when concat(code,material_name) like '%狼人%' then '狼人'
        --     when concat(code,material_name) like '%古风%' then '古言'
        --     when concat(code,material_name) like '%古言%' then '古言'
        --     end as code_type   -- 素材分类
    from ads.ads_material_upload_log_view a
    inner join ads.ads_material_upload_log_view b on a.fission_parent_id = b.id and b.source_chl_type=2
    where a.upload_status=4 and a.bm_compelete_time>='2024-01-01' and (a.tgt_type=2 or (a.tgt_type=1 and a.material_full_name NOT REGEXP 'h1|h2|h3|H1|H2|H3|1\\.5'))  -- 上传成功
    and a.source_chl_type=2
) ,
t1_1 as (
	select
		ifnull(t1.parent_iasset_guid,a.asset_guid) as asset_guid
		,ifnull(t1.language_name,a.language_name) as language_name
		,ifnull(t1.code,a.code) as code
		,ifnull(t1.materia_uid,a.materia_uid) as materia_uid
		,ifnull(t1.material_name,a.materia_name) as material_name
		,ifnull(t1.bm_compelete_time,a.bm_compelete_time) as bm_compelete_time
		,a.project_code as project_code
		,a.source_chl as source_chl
		,ifnull(t1.source_chl_type,a.source_chl_type) as source_chl_type
		,ifnull(t1.language_asset,a.language_asset) as language_asset
		,ifnull(t1.asset_type,a.asset_type) as asset_type
		,ifnull(t1.code_type,a.code_type) as code_type
		,ifnull(t1.material_type,a.material_type) as material_type
		,a.date_key as date_key
		,a.is_mai as is_mai
		,a.book_id as book_id
		,a.channel as channel
		,a.new_cid_name as new_cid_name
		,sum(spend) as spend
		,sum(impressions) as impressions
		,sum(clicks) as clicks
		,sum(link_clicks) as link_clicks
		,sum(installs) as installs
		,sum(amount) as amount
		,sum(amount_std) as amount_std
	from ads.ads_srsv_material_rating_probability_pre a
	left join t1 on a.asset_guid = t1.asset_guid
	-- where ifnull(a.date_key, a.bm_compelete_time) >= date_sub(now(), interval 360 day) and ifnull(a.is_mai, 1)<>'MAI'
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
)
    , z3 as (
        select *
            -- 累计指标
            ,link_clicks_sum/impressions_sum as ctr_link_sum
            ,installs_sum/link_clicks_sum as  cvr_sum
            ,amount_sum/amount_std_sum as roas_sum
            ,log(spend_sum/impressions_sum*1000,2.2) as log_cpm_sum
            ,installs_sum/impressions_sum as ir_sum
            ,ln(spend_sum) as ln_spend_sum
            ,abs(link_clicks_sum/impressions_sum-installs_sum/link_clicks_sum) as ctr_cvr_sum
            ,(spend_sum/impressions_sum*1000) as cpm_sum
            -- Dn
            ,link_clicks_dn/impressions_dn as ctr_link_dn
            ,installs_dn/link_clicks_dn as  cvr_dn
            ,amount_dn/amount_std_dn as roas_dn
            ,log(spend_dn/impressions_dn*1000,2.2) as log_cpm_dn
            ,installs_dn/impressions_dn as ir_dn
            ,ln(spend_dn) as ln_spend_dn
            ,abs(link_clicks_dn/impressions_dn-installs_dn/link_clicks_dn) as ctr_cvr_dn
            ,spend_dn/impressions_dn*1000 as cpm_dn
        from (
            select  a.bm_compelete_time
                ,a.date_key
                ,a.asset_guid
                ,a.source_chl
                ,a.language_name
                ,a.book_id
                ,a.source_chl_type
                ,a.project_code
                ,a.code
                ,a.spend
                ,a.impressions
                ,a.clicks
                ,a.link_clicks
                ,a.installs
                ,a.amount
                ,a.amount_std  -- 收入目标
                ,a.channel      -- 男女频 1=女频，2=男频
                ,a.new_cid_name     -- 书籍分类
                ,a.grade_date
                ,a.first_date
                -- 用于评级取数依据
                ,days_diff(a.date_key,a.grade_date) as days
                ,a.language_asset    -- 素材语言或语言分类
                ,a.asset_type    -- 是否定制
                ,a.code_type       -- 素材分类
                ,a.material_type  -- 素材类型
                -- 累计dt,用户判断累计
                ,sum((b.date_key<=a.date_key)*b.spend) as spend_dt_sum
                ,sum((b.date_key<=a.date_key)*b.impressions) as impressions_dt_sum

                -- 累计当前时间，用于累计花费评级
                ,sum(b.spend) as spend_sum
                ,sum(b.impressions) as impressions_sum
                ,sum(b.clicks) as clicks_sum
                ,sum(b.link_clicks) as link_clicks_sum
                ,sum(b.installs) as installs_sum
                ,sum(b.amount) as amount_sum
                ,sum(b.amount_std) as amount_std_sum

                -- Dn指标，用于日花费>50的case
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.spend end) as spend_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.impressions end) as impressions_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.link_clicks end) as link_clicks_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.installs end) as installs_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.amount end) as amount_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.amount_std end) as amount_std_dn

            from (
                select *
                    ,min(case when  spend>=50 then date_key end) over(partition by concat(asset_guid,source_chl)) as grade_date  -- 首次花费>50的日期
                    ,min(date_key) over(partition by concat(asset_guid,source_chl)) as first_date  -- 首次花费时间
                from t1_1
                where ifnull(date_key, bm_compelete_time) >= date_sub(now(), interval 360 day) and ifnull(is_mai, 1)<>'MAI'
            ) a
            left join t1_1 b on a.asset_guid=b.asset_guid and a.source_chl=b.source_chl and ifnull(b.is_mai,1)<>'MAI'
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
        ) a
    )

    -- source_chl=null的处理
    , z3_1 as (
        select *
            ,source_chl as source_chl2
        from z3
        where source_chl is not null
        union all
        select a.*
            ,b.source_chl as source_chl2
        from (
            select *
            from z3
            where source_chl is null
        ) a
        left join (
            select distinct
                source_chl_type
                ,source_chl
            from z3
            where source_chl is not null
        ) b on a.source_chl_type=b.source_chl_type
    )

    -- 归一化阈值,样本=符合评级条件case
    , z5 as (
        select language_name
            ,source_chl
            ,project_code
            ,days
            -- 97%
            ,PERCENTILE_APPROX(ctr_link_dn,0.97) ctr_97
            ,PERCENTILE_APPROX(cvr_dn,0.97) cvr_97
            ,PERCENTILE_APPROX(roas_dn,0.97) roas_97
            ,PERCENTILE_APPROX(ir_dn,0.97) ir_97
            ,PERCENTILE_APPROX(ln_spend_dn,0.97) ln_spend_97
            ,PERCENTILE_APPROX(ctr_cvr_dn,0.97) ctr_cvr_97
            ,PERCENTILE_APPROX(log_cpm_dn,0.99) cpm_97
            -- 60%
            ,PERCENTILE_APPROX(ctr_link_dn,0.6) ctr_60
            ,PERCENTILE_APPROX(cvr_dn,0.6) cvr_60
            ,PERCENTILE_APPROX(roas_dn,0.6) roas_60
            ,PERCENTILE_APPROX(ir_dn,0.6) ir_60
            ,PERCENTILE_APPROX(ln_spend_dn,0.6) ln_spend_60
            ,PERCENTILE_APPROX(ctr_cvr_dn,0.6) ctr_cvr_60
            ,PERCENTILE_APPROX(log_cpm_dn,0.6) cpm_60
            -- min
            ,min(ctr_link_dn) ctr_min
            ,min(cvr_dn) cvr_min
            ,min(roas_dn) roas_min
            ,min(ir_dn) ir_min
            ,min(ln_spend_dn) ln_spend_min
            ,min(ctr_cvr_dn) as ctr_cvr_min
            ,min(log_cpm_dn) as cpm_min
        from z3
        where days>=0 and days<=3
        group by 1,2,3,4
    )

    -- 素材维度汇总指标
        -- 优先级level=1，用dn_max对应数据,days<=3内取最大日期
        -- level=2，用户累计数据,最新数据
        -- level=99，无评级，最新数据
    , z4 as (
        select a.bm_compelete_time
            ,a.date_key
            ,a.asset_guid
            ,a.source_chl2 as source_chl
            ,a.language_name
            ,a.code
            ,a.book_id
            ,a.source_chl_type
            ,a.project_code
            ,a.spend as spend_dt
            ,a.impressions
            ,a.clicks
            ,a.link_clicks
            ,a.installs
            ,a.amount
            ,a.amount_std  -- 收入目标
            ,a.channel      -- 男女频 1=女频，2=男频
            ,a.new_cid_name     -- 书籍分类
            ,coalesce(a.grade_date,a.spend150_date) as grade_date
            ,a.first_date
            ,a.days
            ,a.spend_dt_sum
            ,a.impressions_dt_sum
            ,a.spend_sum
            ,a.impressions_sum
            ,a.clicks_sum
            ,a.link_clicks_sum
            ,a.installs_sum
            ,a.amount_sum
            ,a.amount_std_sum  -- 收入目标
            ,a.spend_dn
            ,a.impressions_dn
            ,a.link_clicks_dn
            ,a.installs_dn
            ,a.amount_dn
            ,a.amount_std_dn  -- 收入目标
            ,a.ctr_link_sum
            ,a.cvr_sum
            ,a.roas_sum
            ,a.log_cpm_sum
            ,a.ir_sum
            ,a.ln_spend_sum
            ,a.ctr_cvr_sum
            ,a.ctr_link_dn
            ,a.cvr_dn
            ,a.roas_dn
            ,a.log_cpm_dn
            ,a.ir_dn
            ,a.ln_spend_dn
            ,a.ctr_cvr_dn
            ,a.level
            ,a.rn
            ,a.language_asset    -- 素材语言或语言分类
            ,a.asset_type    -- 是否定制
            ,a.code_type       -- 素材分类
            ,a.material_type  -- 素材类型
            ,case when level=1 then ctr_link_dn else ctr_link_sum end as ctr_link
            ,case when level=1 then cvr_dn else cvr_sum end as cvr
            ,case when level=1 then roas_dn else roas_sum end as roas
            ,case when level=1 then log_cpm_dn else log_cpm_sum end as log_cpm
            ,case when level=1 then ir_dn else ir_sum end as ir
            ,case when level=1 then ln_spend_dn else ln_spend_sum end as ln_spend
            ,case when level=1 then ctr_cvr_dn else ctr_cvr_sum end as ctr_cvr
            ,case when level=1 then spend_dn else spend_sum end as spend
            ,case when level=1 then cpm_dn else cpm_sum end as cpm
        from (
            select *
                ,row_number() over(partition by concat(x.asset_guid,x.source_chl2) order by level asc,ifnull(days, 0) desc,date_key desc) rn
            from (
                select a.*
                    ,b.spend150_date
                    ,case when a.grade_date is not null then 1
                        when a.spend_dt_sum>=50  then 2
                        when a.spend_dt_sum>0 then 3
                        else 99 end as level
                from z3_1 a
                -- 首次累计花费>50的日期
                left join (
                    select asset_guid
                        ,source_chl2
                        ,min(date_key) as spend150_date
                    from z3_1
                    where spend_dt_sum>=50
                    group by 1,2
                ) b on a.asset_guid=b.asset_guid and a.source_chl2=b.source_chl2
                where ifnull(a.days,0)>=0 and ifnull(a.days,0)<=3
            ) x
        ) a
        where rn=1
    )

    -- 2、评分方案
        -- ir评级方案,增加CPM负向值
        -- 评分 = ir*100+ cvr+ abs（cvr+ctr)+ ln_spend - cpm,加权，加权系数待定
    , z6 as (
        -- 评分1
        select *
            ,least(1,greatest(ifnull(ln_spend_sum/12,0),(18*ifnull(ir_to1,0) + 20*ifnull(cvr_to1,0) + 11*ifnull(ctr_cvr_to1,0) + 30*ifnull(ln_spend_to1,0) + 100*ifnull(roas_to1,0) - 28*ifnull(cpm_to1,0))/(18+20 +11 +30 +100 -28)))  as grade_score
        from (
            -- 指标归一处理
            select  a.*
                ,case when a.ir<ir_60 then  (a.ir-ir_min)/(ir_60-ir_min)*0.6 else  0.6+(a.ir-ir_60)/(ir_97 -ir_60)*0.4 end as ir_to1
                ,case when a.cvr<cvr_60  then  (a.cvr-cvr_min)/(cvr_60-cvr_min)*0.6 else  0.6+(a.cvr-cvr_60)/(cvr_97 -cvr_60)*0.4 end as cvr_to1
                ,least(2,case when a.ctr_cvr<ctr_cvr_60  then  (a.ctr_cvr-ctr_cvr_min)/(ctr_cvr_60-ctr_cvr_min)*0.6 else  0.6+(a.ctr_cvr-ctr_cvr_60)/(ctr_cvr_97 -ctr_cvr_60)*0.4 end) as ctr_cvr_to1
                ,case when a.ln_spend<ln_spend_60  then  (a.ln_spend-ln_spend_min)/(ln_spend_60-ln_spend_min)*0.6 else  0.6+(a.ln_spend-ln_spend_60)/(ln_spend_97 -ln_spend_60)*0.4 end as ln_spend_to1
                ,case when a.roas<roas_60  then  (a.roas-roas_min)/(roas_60-roas_min)*0.6 else  0.6+(a.roas-roas_60)/(roas_97 -roas_60)*0.4 end as  roas_to1
                ,least(1.5,greatest(0,(case when a.log_cpm<cpm_60  then  (a.log_cpm-cpm_min)/(cpm_60-cpm_min)*0.6 else  0.6+(a.log_cpm-cpm_60)/(cpm_97 -cpm_60)*0.4 end))) as  cpm_to1
            from z4 a
            -- 指标归一阈值参考
            left join z5 b on a.language_name=b.language_name and  a.source_chl=b.source_chl and (case when level=1  then a.days=b.days else b.days=3 end) and a.project_code=b.project_code
        ) x
    )

    -- days>3，取最新数据，开始评级4+最新日期4天数做加权
    , z7 as (
        select *
            ,least(1,greatest(ifnull(ln_spend/12,0),(18*ifnull(ir_to1,0) + 20*ifnull(cvr_to1,0) + 11*ifnull(ctr_cvr_to1,0) + 30*ifnull(ln_spend_to1,0) + 100*ifnull(roas_to1,0) - 28*ifnull(cpm_to1,0))/(18+20 +11 +30 +100 -28))) as grade_score
        from (
            select a.*
                ,case when a.ir<ir_60 then  (a.ir-ir_min)/(ir_60-ir_min)*0.6 else  0.6+(a.ir-ir_60)/(ir_97 -ir_60)*0.4 end as ir_to1
                ,case when a.cvr<cvr_60  then  (a.cvr-cvr_min)/(cvr_60-cvr_min)*0.6 else  0.6+(a.cvr-cvr_60)/(cvr_97 -cvr_60)*0.4 end as cvr_to1
                ,least(2,case when a.ctr_cvr<ctr_cvr_60  then  (a.ctr_cvr-ctr_cvr_min)/(ctr_cvr_60-ctr_cvr_min)*0.6 else  0.6+(a.ctr_cvr-ctr_cvr_60)/(ctr_cvr_97 -ctr_cvr_60)*0.4 end) as ctr_cvr_to1
                ,case when a.ln_spend<ln_spend_60  then  (a.ln_spend-ln_spend_min)/(ln_spend_60-ln_spend_min)*0.6 else  0.6+(a.ln_spend-ln_spend_60)/(ln_spend_97 -ln_spend_60)*0.4 end as ln_spend_to1
                ,case when a.roas<roas_60  then  (a.roas-roas_min)/(roas_60-roas_min)*0.6 else  0.6+(a.roas-roas_60)/(roas_97 -roas_60)*0.4 end as  roas_to1
                ,least(1.5,greatest(0,(case when a.log_cpm<cpm_60  then  (a.log_cpm-cpm_min)/(cpm_60-cpm_min)*0.6 else  0.6+(a.log_cpm-cpm_60)/(cpm_97 -cpm_60)*0.4 end))) as  cpm_to1
            from (
                select asset_guid
                    ,source_chl
                    ,project_code
                    ,language_name
                    ,book_id
                    ,bm_compelete_time
                    ,max(rn) as days
                    ,sum(spend) spend
                    ,sum(impressions) impressions
                    ,sum(clicks) clicks
                    ,sum(link_clicks) link_clicks
                    ,sum(installs) installs
                    ,sum(amount) amount
                    ,sum(installs)/sum(impressions) as ir
                    ,sum(installs)/sum(link_clicks) as cvr
                    ,abs(sum(link_clicks)/sum(impressions)-sum(installs)/sum(link_clicks)) as ctr_cvr
                    ,log(sum(spend)) as ln_spend
                    ,sum(amount)/sum(spend) as roas
                    ,log(sum(spend)/sum(impressions*1000),2.2) as log_cpm

                from (
                    select *
                        ,row_number() over(partition by concat(asset_guid,source_chl) order by date_key desc) rn
                    from z3
                    where spend>if(language_name='EN',10,5) and days > 3
                ) a
                where rn<=6
                group by 1,2,3,4,5,6
            ) a
            -- 指标归一阈值参考
            left join z5 b on a.language_name=b.language_name and  a.source_chl=b.source_chl and a.days-1=b.days and a.project_code=b.project_code
        ) x
    )

    -- 3、初始评分和最新评分，聚合子媒体，评分转概率
    , z8 as (
        select
            project_code
            ,asset_guid
            ,source_chl_type
            ,book_id
            ,language_name
            ,code
            ,language_asset    -- 素材语言或语言分类
            ,asset_type    -- 是否定制
            ,code_type       -- 素材分类
            ,material_type  -- 素材类型
            ,channel -- 频道
            ,new_cid_name -- 分类
            ,bm_compelete_time
            ,date_key
            ,grade_date
            ,first_date
            ,days
            ,level
            ,is_old_asset
            ,spend_dt_sum
            ,impressions_dt_sum
            ,spend_sum
            ,impressions_sum
            ,clicks_sum
            ,link_clicks_sum
            ,installs_sum
            ,amount_sum
            ,amount_std_sum   -- 收入目标
            ,grade_score_sum as grade_score_sum_raw
            ,ifnull(case when level>=3 then least(grade_score_sum,0.6) else grade_score_sum end,0) as grade_score_sum2
            -- 评分转概率
            -- ,case when level<=2 and grade_score_sum>=0.6 then pow(grade_score_sum,(1-grade_score_sum))
            --     when level<=2 and grade_score_sum<0.6 then pow(grade_score_sum,(1-grade_score_sum+0.6))
            --     when level=3 then pow(least(grade_score_sum,0.7),(1-least(grade_score_sum,0.7)+0.6))
            --     when level=99 then  0.6
            --     else 0 end as odds
            ,case when level<=3 and grade_score_sum<0.6 then pow(grade_score_sum,(1-grade_score_sum+0.7))
                when level<=3 and grade_score_sum>=0.6 then (grade_score_sum-0.6)/(1-0.6)*(0.9-0.6)+0.6
                when level=99 then 0.6
                else 0.6 end as odds
        from (
            select a.project_code
                ,a.asset_guid
                ,a.source_chl_type
                ,a.language_name
                ,a.code
                ,a.book_id
                ,a.bm_compelete_time
                ,a.language_asset    -- 素材语言或语言分类
                ,a.asset_type    -- 是否定制
                ,a.code_type       -- 素材分类
                ,a.material_type  -- 素材类型
                ,min(a.channel) as channel -- 频道
                ,a.new_cid_name -- 分类
                ,min(a.date_key) as date_key
                ,min(a.grade_date) as grade_date
                ,min(a.first_date) as first_date
                ,max(a.days) as days
                ,min(level) as level
                ,case when min(level)<=2 then 1 else 0 end as is_old_asset
                ,sum(a.spend_dt_sum) as spend_dt_sum
                ,sum(a.impressions_dt_sum) as impressions_dt_sum
                ,sum(a.spend_sum) as spend_sum
                ,sum(a.impressions_sum) as impressions_sum
                ,sum(a.clicks_sum) as clicks_sum
                ,sum(a.link_clicks_sum) as link_clicks_sum
                ,sum(a.installs_sum) as installs_sum
                ,sum(a.amount_sum) as amount_sum
                ,sum(a.amount_std_sum) as amount_std_sum
                ,greatest(ifnull(sum(a.grade_score_sum*a.spend_sum)/sum(a.spend_sum),0),0) as grade_score_sum
            from (
                select a.*
                    ,ifnull(case when level=1 then ((a.days+1)*a.grade_score+ifnull(b.days,0)*ifnull(b.grade_score,0))/(a.days+1+ifnull(b.days,0)) else  a.grade_score end,0) as grade_score_sum
                from z6 a
                left join z7 b on a.source_chl=b.source_chl and a.project_code=b.project_code and a.asset_guid=b.asset_guid and a.book_id=b.book_id
            ) a
            group by 1,2,3,4,5,6,7,8,9,10,11,13
        ) x
    )

    -- 底表2，MIR评分
    -- 累计指标
    , z13 as (
        select *
            -- 累计指标
            ,link_clicks_sum/impressions_sum as ctr_link_sum
            ,installs_sum/link_clicks_sum as  cvr_sum
            ,amount_sum/spend_sum as roas_sum
            ,log(spend_sum/impressions_sum*1000,2.2) as log_cpm_sum
            ,installs_sum/impressions_sum as ir_sum
            ,ln(spend_sum) as ln_spend_sum
            ,abs(link_clicks_sum/impressions_sum-installs_sum/link_clicks_sum) as ctr_cvr_sum
            ,(spend_sum/impressions_sum*1000) as cpm_sum
            -- Dn
            ,link_clicks_dn/impressions_dn as ctr_link_dn
            ,installs_dn/link_clicks_dn as  cvr_dn
            ,amount_dn/spend_dn as roas_dn
            ,log(spend_dn/impressions_dn*1000,2.2) as log_cpm_dn
            ,installs_dn/impressions_dn as ir_dn
            ,ln(spend_dn) as ln_spend_dn
            ,abs(link_clicks_dn/impressions_dn-installs_dn/link_clicks_dn) as ctr_cvr_dn
            ,spend_dn/impressions_dn*1000 as cpm_dn
        from (
            select  a.bm_compelete_time
                ,a.date_key
                ,a.asset_guid
                ,a.source_chl
                ,a.language_name
                ,a.book_id
                ,a.source_chl_type
                ,a.project_code
                ,a.code
                ,a.spend
                ,a.impressions
                ,a.clicks
                ,a.link_clicks
                ,a.installs
                ,a.amount
                ,a.grade_date
                ,a.first_date
                -- 用于评级取数依据
                ,days_diff(a.date_key,a.grade_date) as days
                ,a.language_asset    -- 素材语言或语言分类
                ,a.asset_type    -- 是否定制
                ,a.code_type       -- 素材分类
                ,a.material_type  -- 素材类型
                -- 累计dt,用户判断累计
                ,sum((b.date_key<=a.date_key)*b.spend) as spend_dt_sum
                ,sum((b.date_key<=a.date_key)*b.impressions) as impressions_dt_sum
                -- 累计当前时间，用于累计花费评级
                ,sum(b.spend) as spend_sum
                ,sum(b.impressions) as impressions_sum
                ,sum(b.clicks) as clicks_sum
                ,sum(b.link_clicks) as link_clicks_sum
                ,sum(b.installs) as installs_sum
                ,sum(b.amount) as amount_sum

                -- Dn指标，用于日花费>50的case
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.spend end) as spend_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.impressions end) as impressions_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.link_clicks end) as link_clicks_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.installs end) as installs_dn
                ,sum(case when b.date_key<=a.date_key and b.date_key>=a.grade_date then b.amount end) as amount_dn

            from (
                select *
                    ,min(case when impressions>=if(source_chl='facebook',500,1000) or spend>=5 then date_key end) over(partition by concat(asset_guid,source_chl)) as grade_date  -- 首次花费>50的日期
                    ,min(date_key) over(partition by concat(asset_guid,source_chl)) as first_date  -- 首次花费时间
                from t1_1
                where ifnull(date_key, bm_compelete_time) >= date_sub(now(), interval 360 day) and ifnull(is_mai,1)='MAI'
            ) a
            left join t1_1 b on a.asset_guid=b.asset_guid and a.source_chl=b.source_chl and ifnull(b.is_mai,1)='MAI'
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22
        ) x
    )

    -- 素材维度汇总指标
    , z14 as (
        select a.bm_compelete_time
            ,a.date_key
            ,a.asset_guid
            ,a.source_chl
            ,a.language_name
            ,a.code
            ,a.book_id
            ,a.source_chl_type
            ,a.project_code
            ,a.spend as spend_dt
            ,a.impressions
            ,a.clicks
            ,a.link_clicks
            ,a.installs
            ,a.amount
            ,coalesce(a.grade_date,a.spend150_date) as grade_date
            ,a.first_date
            ,a.days
            ,a.spend_dt_sum
            ,a.impressions_dt_sum
            ,a.spend_sum
            ,a.impressions_sum
            ,a.clicks_sum
            ,a.link_clicks_sum
            ,a.installs_sum
            ,a.amount_sum
            ,a.spend_dn
            ,a.impressions_dn
            ,a.link_clicks_dn
            ,a.installs_dn
            ,a.amount_dn
            ,a.ctr_link_sum
            ,a.cvr_sum
            ,a.roas_sum
            ,a.log_cpm_sum
            ,a.ir_sum
            ,a.ln_spend_sum
            ,a.ctr_cvr_sum
            ,a.ctr_link_dn
            ,a.cvr_dn
            ,a.roas_dn
            ,a.log_cpm_dn
            ,a.ir_dn
            ,a.ln_spend_dn
            ,a.ctr_cvr_dn
            ,a.level
            ,a.rn
            ,a.language_asset    -- 素材语言或语言分类
            ,a.asset_type    -- 是否定制
            ,a.code_type       -- 素材分类
            ,a.material_type  -- 素材类型
            ,0.4*case when level=1 then ctr_link_dn else ctr_link_sum end as ctr_link
            ,0.4*case when level=1 then cvr_dn else cvr_sum end as cvr
            ,case when level=1 then roas_dn else roas_sum end as roas
            ,case when level=1 then log_cpm_dn else log_cpm_sum end as log_cpm
            ,0.4*case when level=1 then ir_dn else ir_sum end as ir
            ,case when level=1 then ln_spend_dn else ln_spend_sum end as ln_spend
            ,case when level=1 then ctr_cvr_dn else ctr_cvr_sum end as ctr_cvr
            ,case when level=1 then spend_dn else spend_sum end as spend
            ,case when level=1 then cpm_dn else cpm_sum end as cpm
        from (
            select *
                ,row_number() over(partition by concat(x.asset_guid,x.source_chl) order by level asc,ifnull(days, 0) desc,date_key desc) rn
            from (
                select a.*
                    ,b.spend150_date
                    ,case when a.grade_date is not null then 1
                        when a.impressions_dt_sum>=if(a.source_chl='facebook',500,1000) or a.spend_dt_sum>=5 then 2
                        when a.impressions_dt_sum>0 then 3
                        else 99 end as level
                from z13 a
                -- 首次累计花费>50的日期
                left join (
                    select asset_guid
                        ,source_chl
                        ,min(date_key) as spend150_date
                    from z13
                    where ifnull(impressions_dt_sum,0)>=if(source_chl='facebook',500,1000) or ifnull(spend_dt_sum,0)>=5
                    group by 1,2
                ) b on a.asset_guid=b.asset_guid and a.source_chl=b.source_chl
                where ifnull(a.days,0)>=0 and ifnull(a.days,0)<=3
            ) x
        ) a
        where rn=1
    )


    -- 2、评分方案,汇总媒体评分
    , z16 as (
        select
            project_code
            ,asset_guid
            ,source_chl_type
            ,book_id
            ,language_name
            ,code
            ,language_asset    -- 素材语言或语言分类
            ,asset_type    -- 是否定制
            ,code_type       -- 素材分类
            ,material_type  -- 素材类型
            ,bm_compelete_time
            ,date_key
            ,grade_date
            ,first_date
            ,days
            ,level
            ,is_old_asset
            ,spend_dt_sum
            ,impressions_dt_sum
            ,spend_sum
            ,impressions_sum
            ,clicks_sum
            ,link_clicks_sum
            ,installs_sum
            ,amount_sum
            ,grade_score_sum as grade_score_sum_raw
            ,ifnull(case when level>=3 then least(grade_score_sum,0.6) else grade_score_sum end,0) as grade_score_sum2
            -- 评分转概率
            ,case when level<=3 and grade_score_sum<0.6 then pow(grade_score_sum,(1-grade_score_sum+0.7))
                when level<=3 and grade_score_sum>=0.6 then (grade_score_sum-0.6)/(1-0.6)*(0.9-0.6)+0.6
                when level=99 then 0.6
                else 0.6 end as odds
        from (
            select  project_code
                    ,asset_guid
                    ,source_chl_type
                    ,language_name
                    ,code
                    ,book_id
                    ,bm_compelete_time
                    ,language_asset    -- 素材语言或语言分类
                    ,asset_type    -- 是否定制
                    ,code_type       -- 素材分类
                    ,material_type  -- 素材类型
                    ,min(date_key) as date_key
                    ,min(grade_date) as grade_date
                    ,min(first_date) as first_date
                    ,max(days) as days
                    ,min(level) as level
                    ,case when min(level)<=2 then 1 else 0 end as is_old_asset
                    ,sum(spend_dt_sum) as spend_dt_sum
                    ,sum(impressions_dt_sum) as impressions_dt_sum
                    ,sum(spend_sum) as spend_sum
                    ,sum(impressions_sum) as impressions_sum
                    ,sum(clicks_sum) as clicks_sum
                    ,sum(link_clicks_sum) as link_clicks_sum
                    ,sum(installs_sum) as installs_sum
                    ,sum(amount_sum) as amount_sum
                    ,greatest(ifnull(sum(grade_score*spend_sum)/sum(spend_sum),0),0) as grade_score_sum
            from (
                select *
                    ,least(1,(18*ifnull(ir_to1,0) + 20*ifnull(cvr_to1,0) + 11*ifnull(ctr_cvr_to1,0))/(18+20 +11)) as grade_score
                from (
                    -- 指标归一处理
                    select  a.*
                        ,case when a.ir<ir_60 then  (a.ir-ir_min)/(ir_60-ir_min)*0.6 else  0.6+(a.ir-ir_60)/(ir_97 -ir_60)*0.4 end as ir_to1
                        ,case when a.cvr<cvr_60  then  (a.cvr-cvr_min)/(cvr_60-cvr_min)*0.6 else  0.6+(a.cvr-cvr_60)/(cvr_97 -cvr_60)*0.4 end as cvr_to1
                        ,least(2,case when a.ctr_cvr<ctr_cvr_60  then  (a.ctr_cvr-ctr_cvr_min)/(ctr_cvr_60-ctr_cvr_min)*0.6 else  0.6+(a.ctr_cvr-ctr_cvr_60)/(ctr_cvr_97 -ctr_cvr_60)*0.4 end) as ctr_cvr_to1
                        ,case when a.ln_spend<ln_spend_60  then  (a.ln_spend-ln_spend_min)/(ln_spend_60-ln_spend_min)*0.6 else  0.6+(a.ln_spend-ln_spend_60)/(ln_spend_97 -ln_spend_60)*0.4 end as ln_spend_to1
                        ,case when a.roas<roas_60  then  (a.roas-roas_min)/(roas_60-roas_min)*0.6 else  0.6+(a.roas-roas_60)/(roas_97 -roas_60)*0.4 end as  roas_to1
                        ,least(1.5,greatest(0,(case when a.log_cpm<cpm_60  then  (a.log_cpm-cpm_min)/(cpm_60-cpm_min)*0.6 else  0.6+(a.log_cpm-cpm_60)/(cpm_97 -cpm_60)*0.4 end))) as  cpm_to1
                    from z14 a
                    -- 指标归一阈值参考
                    left join z5 b on a.language_name=b.language_name and  a.source_chl=b.source_chl and (case when level=1  then a.days=b.days else b.days=3 end) and a.project_code=b.project_code
                ) x
            ) x
            group by 1,2,3,4,5,6,7,8,9,10,11
        ) x
    )

    -- AEO评分 + MAI评分
    , z20 as (
        select
            date(hours_sub(now(),13)) as dt,
            project_code,
            asset_guid,
            source_chl_type,
            ifnull(book_id,-99) as book_id,
            language_name,
            code,
            language_asset, -- 新增
            asset_type, -- 新增
            code_type, -- 新增
            material_type,  -- 素材类型
            channel, -- 频道
            new_cid_name, -- 分类
            bm_compelete_time,
            date_key,
            grade_date,
            first_date,
            days,
            level,
            is_old_asset,
            spend_dt_sum,
            spend_sum,
            impressions_sum,
            clicks_sum,
            link_clicks_sum,
            installs_sum,
            amount_sum,
            grade_score_sum_raw,
            grade_score_sum2,
            odds,
            need_mai, -- 新增
            odds_aeo, -- 新增
            grade_date_mai, -- 新增
            first_date_mai, -- 新增
            level_mai, -- 新增
            odds_mai, -- 新增
            spend_dt_sum_mai, -- 新增
            spend_sum_mai, -- 新增
            impressions_sum_mai, -- 新增
            clicks_sum_mai, -- 新增
            link_clicks_sum_mai, -- 新增
            installs_sum_mai, -- 新增
            amount_sum_mai, -- 新增
            grade_score_sum_raw_mai, -- 新增
            0 as is_general_score,   -- 是分类通用素材
            now() as etl_tm
        from (
            select
                coalesce(a.project_code,b.project_code) as project_code
                ,coalesce(a.asset_guid,b.asset_guid) as asset_guid
                ,coalesce(a.source_chl_type,b.source_chl_type) as source_chl_type
                ,coalesce(a.book_id,b.book_id) as book_id
                ,coalesce(a.language_name,b.language_name) as language_name
                ,coalesce(a.code,b.code) as code
                ,coalesce(a.language_asset,b.language_asset) as language_asset    -- 素材语言或语言分类
                ,coalesce(a.asset_type,b.asset_type) as asset_type    -- 是否定制
                ,coalesce(a.code_type,b.code_type) as code_type       -- 素材分类
                ,coalesce(a.material_type,b.material_type) as material_type       -- 素材类型
                ,a.channel -- 频道
                ,a.new_cid_name -- 分类
                ,coalesce(a.bm_compelete_time,b.bm_compelete_time) as bm_compelete_time
                ,coalesce(a.date_key,b.date_key) as date_key
                ,a.grade_date
                ,a.first_date
                ,a.days
                ,ifnull(a.level,99) as level
                ,ifnull(a.is_old_asset,0) as is_old_asset
                ,a.spend_dt_sum
                ,a.spend_sum
                ,a.impressions_sum
                ,a.clicks_sum
                ,a.link_clicks_sum
                ,a.installs_sum
                ,a.amount_sum
                ,a.grade_score_sum_raw
                ,a.grade_score_sum2
                -- AEO评分+MAI评分
                ,case when a.level<=2 then a.odds
                    when ifnull(a.spend_sum,0) +ifnull(b.impressions_sum,0)=0 then 0.6
                    else (ifnull(a.spend_sum,0)/50*ifnull(a.odds,0) + ifnull(b.impressions_sum,0)/1000*ifnull(b.odds,0))/(ifnull(a.spend_sum,0)/50+ifnull(b.impressions_sum,0)/1000)
                    end as odds
                -- 需要继续mai测试,
                ,case when ifnull(a.level,9)>=3 and ifnull(b.level,9)>=3 then 1 else 0 end as need_mai
                ,a.odds as odds_aeo
                ,b.grade_date as grade_date_mai
                ,b.first_date as first_date_mai
                ,b.level as level_mai
                ,b.odds as odds_mai
                ,b.spend_dt_sum as spend_dt_sum_mai
                ,b.spend_sum as spend_sum_mai
                ,b.impressions_sum as impressions_sum_mai
                ,b.clicks_sum as clicks_sum_mai
                ,b.link_clicks_sum as link_clicks_sum_mai
                ,b.installs_sum as installs_sum_mai
                ,b.amount_sum as amount_sum_mai
                ,b.grade_score_sum_raw as grade_score_sum_raw_mai
            from z8 a
            full join z16 b on a.project_code=b.project_code and a.asset_guid=b.asset_guid  and a.source_chl_type=b.source_chl_type and a.book_id=b.book_id
        ) t
    )


    -- 剔除：新素材创编7次，暂时剔除，直到累计花费达到50
    , z21 as (
        select a.*
        from (
            select *
            from z20
            where is_old_asset=0 and !(bm_compelete_time <= date_sub(now(), interval 60 day) and odds <= 0.6)
        ) a
        -- 素材和书籍维度，广告组数量
        left join (
            select if(a.product_id=6833,2,1) as project_code
                ,a.source_chl_type
                ,a.AssetGuid
                ,b.book_id
                ,count(distinct a.adset_id) as adset_num
            from (
                select  distinct
                    product_id
                    ,asset_source+1 as source_chl_type
                    ,AssetGuid
                    ,adset_id
                from ads.ads_advertisement_adassetltv_view
                where days_diff(now(),date_key)<180
            ) a
            left join (
                select product_id
                    ,ad_set_id
                    ,book_id
                    ,case when source_chl = 'tt' then 2
                        when source_chl in ('fbs2s','facebook') then 1 else null end as source_chl_type
                from ads.ads_advertisement_adext_view
                where (product_id=6833 and core=1) or product_id != 6833
            ) b on a.product_id=b.product_id and a.adset_id=b.ad_set_id and a.source_chl_type=b.source_chl_type
            group by 1,2,3,4
        ) b on a.project_code=b.project_code and a.asset_guid=b.AssetGuid and a.source_chl_type=b.source_chl_type and a.book_id=b.book_id
        where ifnull(b.adset_num,0)<=7
    )

    -- 剔除：odds<0.2 and 30天以上的素材，但新老素材各保底20条素材
    , z22 as (
        select *
        from (
            select *
                ,row_number() over(partition by concat(project_code,source_chl_type,book_id) order by odds desc,ifnull(first_date,curdate()) desc) rn
            from z20
            where is_old_asset=1 and odds >= if(project_code = 1, 0.5, 0.4)

            union all
            select *
                ,row_number() over(partition by concat(project_code,source_chl_type,book_id) order by 1*(odds>0.2) desc,ifnull(first_date,curdate()) desc) rn
            from z21
        ) x
        where !(rn>30 and  days_diff(curdate(),first_date)>30 and (odds<0.2 or (level<=2 and odds<0.4))) or ifnull(spend_sum,0)<if(language_name='EN',10,5)
    )
    select dt,
        project_code,
        z22.asset_guid,
        source_chl_type,
        book_id,
		b.material_name,
        language_name,
        code,
        language_asset,
        asset_type,
        code_type,
        material_type,
        bm_compelete_time,
        date_key,
        grade_date,
        first_date,
        days,
        level,
        is_old_asset,
        spend_dt_sum,
        spend_sum,
        impressions_sum,
        clicks_sum,
        link_clicks_sum,
        installs_sum,
        amount_sum,
        grade_score_sum_raw,
        grade_score_sum2,
        odds,
        need_mai,
        odds_aeo,
        grade_date_mai,
        first_date_mai,
        level_mai,
        odds_mai,
        spend_dt_sum_mai,
        spend_sum_mai,
        impressions_sum_mai,
        clicks_sum_mai,
        link_clicks_sum_mai,
        installs_sum_mai,
        amount_sum_mai,
        grade_score_sum_raw_mai,
        channel,
        new_cid_name,
        is_general_score,
        bm_id,
        etl_tm
    from z22
	left join (
		     -- 上传成功素材及属性
            select  distinct
                asset_guid
                ,material_name
				,make_date
                ,bm_id
            from ads.ads_material_upload_log_view
            where upload_status=4
              and bm_compelete_time>='2024-01-01'
              and (    -- (tgt_type = 2 and source_chl_type = 2)
                       (tgt_type = 2 and source_chl_type in (1, 2) and material_full_name not regexp 'h1|h2|h3|H1|H2|H3|1\\.5')
                    or (tgt_type = 1 and material_full_name not regexp 'h1|h2|h3|H1|H2|H3|1\\.5')
                  )
--               and (tgt_type=2 or (tgt_type=1 and material_full_name NOT REGEXP 'h1|h2|h3|H1|H2|H3|1\\.5'))  -- 上传成功
			and asset_guid is not null
	) b on z22.asset_guid=b.asset_guid
    where is_general_score != 1
	and b.make_date<= date(date_add('${dt}',interval 1 day ))
	and z22.asset_guid not in (
        'v10033g50000cv4pflfog65st24k2330',
        'v10033g50000cv4pernog65li7soocag',
        '992680906262149',
        '64f3b5157be1c99176984f1214c24303',
        '1035332261964102',
        'dae913639c54df0992d3600eb94da9b0',
        'e25150389228fc1a0798ded8576a3826',
        '74936e211fab1ca9282f41ce5fa2ebf0',
        '1366180277719758',
        '8593ad7b2a36535e15447841bc03ef35',
        '1316850d640bbe36edd61c1928d7591d',
        '0799ac7f45b70dbe52402e02860405fb',
        'e0c904607dac59d52fc89e780af878dc',
        '4fa8557fd3a1ba68c5adee4fdd023032',
        '1d8d3d3c11452e76aa66f12f4c73d1f8',
        'ee25f4307ce5a6ce1eaedad84f4c2587',
        '91c563c43bb718dbf9e0c4c72aaf0c4b',
        '37a2a245ec2e438c7b96a19726e19646',
        'cbdcc4023c59f6f12631a1f961d3ca1a',
        '73e5c3aa5808237138fe5f8f5693fd3f',
        '02390a046ed05483fb30f5ba39575255',
        '752a3cfdc7ecb5552e6b5ce65542fee2',
        'b4f0751a1d117a2010de5d96c006df82',
        '9580aacbdce1b4d1c60bc168244d97d1',
        '1121213406419714',
        '45b5655e21cc725dec2c255e6b28a09e',
        '3ce0e0bf176db40ed126a96ccb6c8960',
        '6fb4fd4b9798f0779830af874f3a827a',
        '301403852892dd06436737a27a99b7c4',
        'c97abbb393b54b20219af53a9bebe518',
        '711277552bc3d4b952d2b52b315add73',
        'efe8f2ad705ea088b0341fa15f97316d',
        'e398667b6f217a654fbb0fceaab0a4de',
        '1bc0729abe4b445e61b92e5ca3e12f0f',
        'd975329eacbf91b3183e6a38ccef8eda',
        '7297bc1a97e27f9e6335e56424168e4f',
        '1003429801672666',
        'e106b7d6677b8afcfb7d7bf6b23bc1cf',
        '9c4ebdc117a1f1af4cd3f244422c7f9f'
    );