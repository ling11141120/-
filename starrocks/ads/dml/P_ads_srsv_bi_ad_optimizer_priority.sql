----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data
-- workflow_version : 18
-- create_user      : hufengju
-- task_name        : ads_srsv_bi_ad_optimizer_priority
-- task_version     : 6
-- update_time      : 2025-01-06 18:35:23
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data\ads_srsv_bi_ad_optimizer_priority
----------------------------------------------------------------
-- 前置SQL语句
delete  from  ads.ads_srsv_bi_ad_optimizer_priority where  dt>='${bf_9_dt}'   and dt<='${dt}';

-- SQL语句
/*
增加字段 rn_spend,std_amt_all,last_taotai_time
减少字段 book_code ,code_stage ,frt_nickname ,nick_name_max
*/
-- 增加书籍维度，花费倒序
-- (待开发）底表2：补位
insert into ads.ads_srsv_bi_ad_optimizer_priority
   with z7 as (
        select a.product
            ,a.dt
            ,a.source2
            ,a.current_language
            ,a.code_id
            ,a.nick_name
            ,a.ad_optimizer_uid
            ,a.ad_optimizer_group
            -- ,a.frt_nickname
            -- ,a.nick_name_max
            ,a.rand_v
            ,days_diff(a.dt,max(b.dt)) last_days
            ,days_diff(a.dt,max(b.off_begindate))  last_taotai_time
            ,ifnull(max_by(d0_amt_all/std_amt_all,b.dt)/0.9,a.rand_v)  r0_all
            ,max_by(std_amt_all,b.dt) std_amt_all
        from (
            select a.*
            from dim.dim_srsv_ad_product_rand_info a
            -- 在投优化师
            left join (
                select distinct
                    product
                    ,source2
                    ,code_id
                    ,dt
                    ,ad_optimizer_uid
                from ads.ads_srsv_bi_ad_optimizer_target_data
                where spend>0
            ) b on a.product=b.product and a.dt=b.dt  and a.ad_optimizer_uid=b.ad_optimizer_uid and a.code_id=b.code_id and a.source2=b.source2
            where b.ad_optimizer_uid is null
        ) a
        -- 优化师投放历史数据
        left join (
            select *
            from ads.ads_srsv_bi_ad_optimizer_target_data
            where spend>5
        ) b on a.product=b.product and a.dt>=b.dt and a.ad_optimizer_uid=b.ad_optimizer_uid and a.code_id=b.code_id and a.source2=b.source2
        group by 1,2,3,4,5,6,7,8,9
    )

    -- data2:候补data
        select
            dt
            ,product
            ,source2
            ,current_language
            ,code_id
            ,nick_name
            ,ad_optimizer_uid
            ,ad_optimizer_group
            ,case when last_taotai_time<7 then -1 else r0_all end r0_all
            ,row_number() over(partition by concat(product,source2,dt,code_id,ad_optimizer_group) order by case when last_taotai_time<7 then -1 else  r0_all  end desc) rn
            ,row_number() over(partition by concat(product,source2,dt,code_id) order by case when last_taotai_time<7 then -1 else  ifnull(std_amt_all,0)+r0_all  end desc) rn_spend
			,std_amt_all
			,last_taotai_time
          ,now() as etl_tm
        from z7
        where dt>='${bf_9_dt}'   and dt<='${dt}' and nick_name not like '%离职%'  --剔除离职;
