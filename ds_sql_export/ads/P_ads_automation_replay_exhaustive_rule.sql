----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_automation_replay_exhaustive_rule
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : ads_automation_replay_exhaustive_rule
-- task_version     : 6
-- update_time      : 2025-04-08 14:50:39
-- sql_path         : \starrocks\tbl_ads_automation_replay_exhaustive_rule\ads_automation_replay_exhaustive_rule
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_automation_replay_exhaustive_rule
-- 穷举规则1：分时数据按粗分条件汇总,不区分项目
with z1 as (
        select distinct
            a.product
            ,a.language
            ,a.source_chl
            ,t21.min as week_day_min
            ,t21.max as week_day_max
            ,t22.min as days_spend_min
            ,t22.max as days_spend_max
            ,t23.min as hours_spend_min
            ,t23.max as hours_spend_max
            ,t24.min as hn_spend_min
            ,t24.max as hn_spend_max
            ,t31.min as R0_min
            ,t31.max as R0_max
            ,t32.min as D0_CAC_min
            ,t32.max as D0_CAC_max
            ,t33.min as IR_rate_min
            ,t33.max as IR_rate_max
            ,t34.min as R0_bf1_min
            ,t34.max as R0_bf1_max
            ,t35.min as R0_bf2_n_min
            ,t35.max as R0_bf2_n_max
            ,concat(source_chl,lpad(language,2,0),ceiling(t21.min),ceiling(t22.min),lpad(ceiling(t23.min),2,0),lpad(ceiling(t31.min*100),3,0),lpad(ceiling(t32.min),3,0),lpad(ceiling(t33.min*100),3,0),lpad(ceiling(t34.min*100),3,0),lpad(ceiling(t35.min*100),3,0),ceiling(t24.min)) as rule_id
            ,concat(lpad(ceiling(t31.min*100),3,0),lpad(ceiling(t32.min),3,0),lpad(ceiling(t33.min*100),3,0),lpad(ceiling(t34.min*100),3,0),lpad(ceiling(t35.min*100),3,0)) as sort_id    -- 关闭规则剔除规则用desc，加量规则剔除asc，实际业务执行相反
        from (
            select *
            from ads.ads_ad_time_partitioned_data
            where days_diff(now(),dt)<400
        ) a
        join (
            select distinct
                case when min<6 then 1 else 6 end as min
                ,case when min<6 then 6 else 99 end as max
            from ads.ads_rough_sort_condition
            where name='week_day'
        ) t21 on a.week_day>=t21.min and a.week_day<t21.max
        join (
            select distinct
                case when min>=3 then 3 else min end as min
                ,case when min>=3 then 9999 else max end as max
            from ads.ads_rough_sort_condition
            where name='days_spend'
        ) t22 on a.dn>=t22.min and a.dn<t22.max
        join (
            select distinct
                case when min<4 then 2
                    when min<8 then 4
                    when min<12 then 8
                    when min<16 then 12
                    when min<20 then 16
                    else 20  end as min
                ,case when min<4 then 4
                    when min<8 then 8
                    when min<12 then 12
                    when min<16 then 16
                    when min<20 then 20
                    else 9999  end as max
            from ads.ads_rough_sort_condition
            where name='hours_spend'
        ) t23 on a.hours_spend>=t23.min and a.hours_spend<t23.max
        join (
            select *
            from ads.ads_rough_sort_condition
            where name='hn_spend'
        ) t24 on a.hn_cost>=t24.min and a.hn_cost<t24.max
        join (
            select *
            from ads.ads_rough_sort_condition
            where name='R0'
        ) t31 on a.hn_r0>=t31.min and a.hn_r0<t31.max
        join (
            select distinct
                case when min<40 then 0
                    when min<60 then 40
                    when min<80 then 60
                    when min<100 then 80
                    when min<120 then 100
                    when min<160 then 120
                    when min <200 then 160
                    when min <300 then 200
                    else 300 end as min
                ,case when min<40 then 40
                    when min<60 then 60
                    when min<80 then 80
                    when min<100 then 100
                    when min<120 then 120
                    when min<160 then 160
                    when min <200 then 200
                    when min <300 then 300
                    else 99999 end as max
            from ads.ads_rough_sort_condition
            where name='D0_CAC'
        ) t32 on a.hn_cac>=t32.min and a.hn_cac<t32.max
        join (
            select distinct
                case when min<0.3 then 0
                    when min<0.5 then  0.3
                    when min<0.7 then 0.5
                    when min<0.8 then 0.7
                    when min<0.9 then 0.8
                    when min<1 then 0.9
                    when min<1.1 then 1
                    when min<1.2 then 1.1
                    when min<1.4 then 1.2
                    when min<1.7 then 1.4
                    when min<2 then 1.7
                    else  2 end as min
                ,case when min<0.3 then 0.3
                    when min<0.5 then  0.5
                    when min<0.7 then 0.7
                    when min<0.8 then 0.8
                    when min<0.9 then 0.9
                    when min<1 then 1
                    when min<1.1 then 1.1
                    when min<1.2 then 1.2
                    when min<1.4 then 1.4
                    when min<1.7 then 1.7
                    when min<2 then 2
                    else  99999 end as max
            from ads.ads_rough_sort_condition
            where name='IR_rate'
        ) t33 on ifnull(a.ir_rate,0)>=t33.min and ifnull(a.ir_rate,0)<t33.max
        join (
            select distinct
                case when min<0.5 then 0
                    when min<0.7 then  0.5
                    when min<0.8 then 0.7
                    when min<0.9 then 0.8
                    when min<1 then 0.9
                    when min<1.1 then 1
                    when min<1.2 then 1.1
                    when min<1.4 then 1.2
                    else  1.4 end as min
                ,case when min<0.5 then 0.5
                    when min<0.7 then  0.7
                    when min<0.8 then 0.8
                    when min<0.9 then 0.9
                    when min<1 then 1
                    when min<1.1 then 1.1
                    when min<1.2 then 1.2
                    when min<1.4 then 1.4
                    else  99999 end as max
            from ads.ads_rough_sort_condition
            where name='R0_bf1'
        ) t34 on ifnull(a.R0_bf1,0)>=t34.min and ifnull(a.R0_bf1,0)<t34.max
        join (
            select distinct
                case when min<0.5 then 0
                    when min<0.7 then  0.5
                    when min<0.8 then 0.7
                    when min<0.9 then 0.8
                    when min<1 then 0.9
                    when min<1.1 then 1
                    when min<1.2 then 1.1
                    else  1.2 end as min
                ,case when min<0.5 then 0.5
                    when min<0.7 then  0.7
                    when min<0.8 then 0.8
                    when min<0.9 then 0.9
                    when min<1 then 1
                    when min<1.1 then 1.1
                    when min<1.2 then 1.2
                    else  99999 end as max
            from ads.ads_rough_sort_condition
            where name='R0_bf2_n'
        ) t35 on ifnull(a.R0_bf2_n,0)>=t35.min and ifnull(a.R0_bf2_n,0)<t35.max
    )
select
    rule_id,
    product,
    language,
    source_chl,
    week_day_min,
    week_day_max,
    days_spend_min,
    days_spend_max,
    hours_spend_min,
    hours_spend_max,
    hn_spend_min,
    hn_spend_max,
    R0_min,
    R0_max,
    D0_CAC_min,
    D0_CAC_max,
    IR_rate_min,
    IR_rate_max,
    R0_bf1_min,
    R0_bf1_max,
    R0_bf2_n_min,
    R0_bf2_n_max,
    sort_id,
    now() as etl_time
from z1;

-- SQL语句
-- 主键 rule_id
    -- 每天执行一次，插入数据;
