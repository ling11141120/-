----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_material_grade_data_result
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : ads_sv_material_grade_data_result
-- task_version     : 18
-- update_time      : 2025-02-13 14:23:54
-- sql_path         : \starrocks\tbl_ads_sv_material_grade_data_result\ads_sv_material_grade_data_result
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_material_grade_data_result where dt>='${bf_1_dt}' ;

-- SQL语句
insert into ads.ads_sv_material_grade_data_result
with z3 as (
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
            select  a.date_key
                ,a.material_id
                ,a.material_type
                ,a.source_chl
                ,a.language_name
                ,a.code
                ,a.materia_uid
                ,a.nick_name
                ,a.materia_name
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
                -- 累计dt,用户判断累计
                ,sum((b.date_key<=a.date_key)*b.spend) as spend_dt_sum

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
                    ,min(case when spend>=50 then date_key end) over(partition by concat(material_id,source_chl)) as grade_date  -- 首次花费>50的日期
                    ,min(date_key) over(partition by concat(material_id,source_chl)) as first_date  -- 首次花费时间
                from dws.dws_sv_material_result_ed
                where date_key>'${bf_360_dt}'
            ) a
            left join dws.dws_sv_material_result_ed b on a.material_id=b.material_id and a.source_chl=b.source_chl
            group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
        ) x
    )

    -- 素材维度汇总指标
        -- 优先级level=1，用dn_max对应数据,days<=3内取最大日期
        -- level=2，用户累计数据,最新数据
        -- level=99，无评级，最新数据
    , z4 as (
        select a.date_key
            ,a.material_id
            ,a.material_type
            ,a.source_chl
            ,a.language_name
            ,a.code
            ,a.materia_uid
            ,a.nick_name
            ,a.materia_name
            ,a.impressions
            ,a.clicks
            ,a.link_clicks
            ,a.installs
            ,a.amount
            ,coalesce(a.grade_date,a.spend150_date) as grade_date
            ,a.first_date
            ,a.days
            ,a.spend_dt_sum
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
                ,row_number() over(partition by concat(x.material_id,x.source_chl) order by level asc,ifnull(days, 0) desc,date_key desc) rn
            from (
                select a.*
                    ,b.spend150_date
                    ,case when a.grade_date is not null then 1
                        when a.spend_sum>=150 then 2
                        else 99 end as level
                from z3 a
                -- 首次花费>150
                left join (
                    select material_id
                        ,source_chl
                        ,min(date_key) as spend150_date
                    from z3
                    where spend_dt_sum>=150
                    group by 1,2
                ) b on a.material_id=b.material_id and a.source_chl=b.source_chl
                where ifnull(a.days,0)>=0 and ifnull(a.days,0)<=3
            ) x
        ) a
        where rn=1
    )

    -- 归一化阈值,样本=符合评级条件case
    , z5 as (
        select language_name
            ,source_chl
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
        group by 1,2,3
    )

-- 2、评分方案
    -- ir评级方案,增加CPM负向值
        -- 评分 = ir*100+ cvr+ abs（cvr+ctr)+ ln_spend - cpm,加权，加权系数待定
    , z8 as (
        select date(hours_sub(now(),13)) as dt
            ,a.material_id
            ,a.date_key
            ,a.material_type
            ,a.source_chl
            ,a.language_name
            ,a.code
            ,a.materia_uid
            ,a.nick_name
            ,a.materia_name
            ,a.impressions
            ,a.clicks
            ,a.link_clicks
            ,a.installs
            ,a.amount
            ,a.grade_date
            ,a.first_date
            ,a.days
            ,a.spend_dt_sum
            ,a.spend_sum
            ,a.impressions_sum
            ,a.clicks_sum
            ,a.link_clicks_sum
            ,a.installs_sum
            ,a.amount_sum
            ,a.level
            ,a.ctr_link
            ,a.cvr
            ,a.roas
            ,a.ir
            ,a.ctr_cvr
            ,a.spend
            ,a.cpm
            ,a.ir_to1
            ,a.cvr_to1
            ,a.ctr_cvr_to1
            ,a.ln_spend_to1
            ,a.roas_to1
            ,a.cpm_to1
            ,a.grade_score
            ,case when level=99 then '无'
                when a.grade_score>=4 then '爆款'
                when a.grade_score>=3 then '好'
                else '差' end grade
            ,b.create_time as score_createtime
            ,b.creator
            ,avg_score
            ,now() as etl_time
        from (
            -- 评分1
            select *
                -- 花费>500,
                ,5*least(1,greatest(ln_spend_sum/12,(18*ir_to1 + 20*cvr_to1 + 11*ctr_cvr_to1 + 30*ln_spend_to1 + 40*roas_to1 - 28*cpm_to1)/(18+20 +11 +30 +40 -28)))  as grade_score
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
                left join z5 b on a.language_name=b.language_name and  a.source_chl=b.source_chl and (case when level=1  then a.days=b.days else b.days=3 end)
            ) x
        ) a
        -- 关联人工评分
        left join ads.ads_material_score_view b on a.material_id =b.material_id
    )

select * from z8;

-- 后置SQL语句
delete from ads.ads_sv_material_grade_data_result where dt<='${bf_10_dt}';
