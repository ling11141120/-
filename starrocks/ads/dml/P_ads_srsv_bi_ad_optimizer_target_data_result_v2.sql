----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data
-- workflow_version : 18
-- create_user      : hufengju
-- task_name        : ads_srsv_bi_ad_optimizer_target_data_result
-- task_version     : 13
-- update_time      : 2025-01-07 16:42:01
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data\ads_srsv_bi_ad_optimizer_target_data_result
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.`ads_srsv_bi_ad_optimizer_target_data_result_v2`  where dt>='${bf_9_dt}'  and dt<='${dt}';

-- SQL语句
-- 底表3：计算次日达标率
 insert into ads.`ads_srsv_bi_ad_optimizer_target_data_result_v2`
   with z1_1 AS (
        SELECT  t1.*
            ,t2.lang
            ,power(t2.lang_rate ,0.9)                  AS lang_rate
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
            ,CASE WHEN t1.weekdays = 7 THEN t2.sunday_rate
                    WHEN t1.weekdays = 5 THEN t2.friday_rate  ELSE 1 END `星期系数`
            ,power(if(regnum_all_7d = 0,0,regnum_new_7d/regnum_all_7d),2) N收入占比
            ,coalesce(d0_amt_pow/std_amt_pow,0)         AS R0_新
            ,coalesce(d0_amt_pow_old/std_amt_pow_old,0) AS R0_老
            ,ifnull(t1.d0_amt/t3.new_std/t1.std_amt,0) as R0_bf1
        FROM ads.`ads_srsv_bi_ad_optimizer_target_data` t1
        LEFT JOIN dim.dim_srsv_ad_prduct_lang_rate t2
        ON t1.product = t2.product AND t1.languageid = t2.lang_id
        LEFT JOIN dim.dim_srsv_ad_prduct_source_rate t3
        ON t1.product = t3.product AND t1.source2 = t3.source_plaform
    )

    , z1_2 AS (
        SELECT  z1_1.*
            ,case when R0_老>1 or R0_老<0.1 then (R0_新/new_std) else (R0_新/new_std*new_r0_rate + R0_老/old_std*(1-new_r0_rate)) end AS 增幅底数      -- 10月12日调整
            ,greatest(ifnull(log(log_num,10) - log(log_num,adset_num) + exp_a + lang_rate+ N收入占比,1) ,1) AS 增幅指数
            ,greatest(ifnull(power((spend/adset_num)/(spend_10d/adset_num_10d),spend_exp),1),1)        AS 平均花费系数
        FROM z1_1
    )

    , z1_3 AS (
        SELECT  z1_2.*
            ,power(case when 增幅底数<1 and R0_bf1<1 then greatest(增幅底数,R0_bf1)
                        when 增幅底数>=1 and R0_bf1>=1 then least(增幅底数, R0_bf1)
                        else least(1,增幅底数*R0_bf1) end
                    ,if((case when 增幅底数<1 and R0_bf1<1 then greatest(增幅底数,R0_bf1)
                            when 增幅底数>=1 and R0_bf1>=1 then least(增幅底数, R0_bf1)
                            else least(1,(增幅底数+R0_bf1)/2) end ) > 1
                        ,增幅指数
                        ,non_compliance_exp)
                ) AS `增幅倍数`
        FROM z1_2
    )
    , z1_4 AS (
        SELECT  z1_3.*
            ,round(least(`平均花费系数`*if(product='海剧' and 增幅倍数>1,1.5,1)*`增幅倍数`*`星期系数`,4)*adset_num) 基建1
        FROM z1_3
    )
    -- 1阶和2阶上限
    -- 1阶和（海阅2阶）不淘汰
    , z1_5 AS (
        SELECT  z1_4.*
            ,case when code_stage=1 or (code_stage = 2 AND product = '海阅') then LEAST(if(weekdays IN (5,6),6,4),基建1) else 基建1 end  AS 基建2
            ,case when (dt >= coalesce(off_begindate,'1990-01-01') AND dt < coalesce(off_enddate,'1990-01-01')) or (code_stage=1 or (code_stage = 2 AND product = '海阅')) then 0 else 1 end  AS 不淘汰
        FROM z1_4
    )
    -- 若淘汰 且 基建2<4 ,则 0；否则 max(2,基建2)
    , z1_6 AS (
        SELECT  dt
            ,product
            ,source2
            ,code_id
            ,code_stage
            ,code_lv
            ,test_status
            ,begin_date
            ,end_date
            ,book_code
            ,languageid
            ,weekdays
            ,current_language
            ,nick_name
            ,ad_optimizer_uid
            ,ad_optimizer_group
            ,adset_num
            ,spend
            ,d0_amt
            ,std_amt
            ,reg_num
            ,reg_num_all
            ,reg_num_new
            ,regnum_new_7d
            ,regnum_all_7d
            ,spend_10d
            ,adset_num_10d
            ,days_10d
            ,d0_amt_10d
            ,std_amt_10d
            ,d0_amt_all
            ,std_amt_all
            ,d0_amt_pow
            ,std_amt_pow
            ,d0_amt_pow_old
            ,std_amt_pow_old
            ,frt_nickname
            ,nick_name_max
            ,frt_group
            ,is_frt_group
            ,off_begindate
            ,off_enddate
            ,lang
            ,lang_rate
            ,group_spend
            ,sunday_rate
            ,friday_rate
            ,base_rate
            ,new_std
            ,old_std
            ,log_num
            ,log_num_median
            ,exp_a
            ,new_r0_rate
            ,non_compliance_exp
            ,spend_exp
            ,星期系数
            ,N收入占比
            ,R0_新
            ,R0_老
            ,增幅底数
            ,增幅指数
            ,平均花费系数
            ,增幅倍数
            ,基建1
            ,基建2
            ,不淘汰
            ,ifnull(if(不淘汰<>1 and 基建2<4,0,GREATEST(2,基建2)),0) AS 基建3
        FROM z1_5
    )

    -- 小组基建
    , z22 AS (
        SELECT  *
            ,SUM(基建3) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group)                                             AS 小组基建 -- 统计基建3求和 分组[日期，产品，书籍ID/短剧ID，优化师分组]
            ,ifnull(floor(log(base_rate,SUM(基建3) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group))),0)             AS 组席位
            ,COUNT(CASE WHEN 基建3 > 0 THEN 1 ELSE null END ) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group )      AS 组在投人数 -- 统计基建3大于0的 分组[日期，产品，书籍ID/短剧ID，优化师分组]
            ,coalesce(SUM(regnum_new_7d) OVER (PARTITION BY dt,source2,product,code_id)/ SUM(regnum_all_7d) OVER (PARTITION BY dt,product,source2,code_id),0) AS 总new占比 -- 近7天新注册D0收入/近7天注册D0收入 分组[日期，产品，媒体，书籍ID/短剧ID]
            ,case when  code_stage<=1 or (product = '海阅' AND code_stage<=2) then frt_group else  is_frt_group end                   AS 专属组
            ,SUM(基建3) OVER (PARTITION BY dt,product,source2,code_id)                                                                AS 书籍次日基建
            ,if(SUM(基建3) OVER (PARTITION BY dt,product,source2,code_id) = 0,1,0)                                                    AS 兜底书籍
            FROM z1_6
    )

     -- 新增席位，小组兜底
    , z31 as (
        select
            a.dt
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
            ,a.ad_optimizer_group
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
            ,a.frt_nickname
            ,a.nick_name_max
            ,a.frt_group
            ,a.is_frt_group
            ,null off_begindate
            ,null off_enddate
            ,null lang
            ,null lang_rate
            ,null group_spend
            ,null sunday_rate
            ,null friday_rate
            ,null base_rate
            ,null new_std
            ,null old_std
            ,null log_num
            ,null log_num_median
            ,null exp_a
            ,null new_r0_rate
            ,null non_compliance_exp
            ,null spend_exp
            ,null 星期系数
            ,null N收入占比
            ,null R0_新
            ,null R0_老
            ,null 增幅底数
            ,null 增幅指数
            ,null 平均花费系数
            ,null 增幅倍数
            ,null 基建1
            ,null 基建2
            ,null 不淘汰
            ,null 基建3
            ,null 小组基建
            ,null 席位
            ,null 在投人数
            ,null 总new占比
            ,专属组
            ,null 书籍次日基建
            ,a.兜底书籍
            ,a.是否补位
            ,b.nick_name as nick_name2
            ,2 as 基建4

        from (
            -- 补位，非兜底
            -- 日期，书籍，小组，席位，预期席位
            select distinct dt
                ,product
                ,source2
                ,code_id
                ,code_stage
                ,code_lv
                ,test_status
                ,begin_date
                ,end_date
                ,book_code
                ,languageid
                ,weekdays
                ,current_language
                ,ad_optimizer_group
                ,frt_nickname
                ,nick_name_max
                ,frt_group
                ,is_frt_group
                ,专属组
                ,组席位-组在投人数 as 新增席位
                ,兜底书籍
                ,1 as 是否补位
            from z22
            where if((product='海阅' and code_stage<=2) or (product='海剧' and code_stage<=1),least(2,组席位),组席位)-组在投人数>0 and 兜底书籍=0
            -- 补位，兜底
            union all (
                select b.dt
                    ,b.product
                    ,b.source2
                    ,b.code_id
                    ,b.code_stage
                    ,b.code_lv
                    ,b.test_status
                    ,b.begin_date
                    ,b.end_date
                    ,b.book_code
                    ,b.languageid
                    ,b.weekdays
                    ,b.current_language
                    ,a.ad_optimizer_group
                    ,b.frt_nickname
                    ,b.nick_name_max
                    ,b.frt_group
                    ,b.is_frt_group
                    ,专属组
                    ,1 as 新增席位
                    ,1 as 兜底书籍
                    ,1 as 是否补位
                from (
                    -- 非专属，非兜底，海阅
                    select   dt
                        ,product
                        ,source2
                        ,code_id
                        ,code_stage
                        ,code_lv
                        ,test_status
                        ,begin_date
                        ,end_date
                        ,book_code
                        ,languageid
                        ,weekdays
                        ,current_language
                        ,frt_nickname
                        ,nick_name_max
                        ,frt_group
                        ,is_frt_group
                        ,专属组
                        ,count(distinct ad_optimizer_group) group_num
                        ,max_by(基建3,ad_optimizer_group) as ad_optimizer_group_max
                        -- ,ad_optimizer_group
                    from z22
                    where product='海阅' and source2='meta' and code_stage>=2 and 专属组='' and is_frt_group='' and 兜底书籍=0 and 组在投人数>0
                    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
                ) b
                -- 日期，书籍 & 相关维度
                join (
                    -- 每日小组
                    select distinct
                        dt
                        ,source2
                        ,ad_optimizer_group
                    from ads.ads_srsv_bi_ad_optimizer_priority
                    where product='海阅' and source2='meta'
                ) a on a.dt=b.dt and b.group_num=1 and a.ad_optimizer_group<>b.ad_optimizer_group_max and a.source2=b.source2
            )
        ) a
        left join ads.ads_srsv_bi_ad_optimizer_priority b on a.dt=b.dt and a.product=b.product and a.source2=b.source2 and a.code_id=b.code_id and a.ad_optimizer_group=b.ad_optimizer_group and a.新增席位>=b.rn
    )

    -- 兜底席位
   , z32 as (
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
            ,d.code as ad_optimizer_uid
            ,d.code_value as ad_optimizer_group
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
            ,a.frt_nickname
            ,a.nick_name_max
            ,a.frt_group
            ,a.is_frt_group
            ,null off_begindate
            ,null off_enddate
            ,null lang
            ,null lang_rate
            ,null group_spend
            ,null sunday_rate
            ,null friday_rate
            ,null base_rate
            ,null new_std
            ,null old_std
            ,null log_num
            ,null log_num_median
            ,null exp_a
            ,null new_r0_rate
            ,null non_compliance_exp
            ,null spend_exp
            ,null 星期系数
            ,null N收入占比
            ,null R0_新
            ,null R0_老
            ,null 增幅底数
            ,null 增幅指数
            ,null 平均花费系数
            ,null 增幅倍数
            ,null 基建1
            ,null 基建2
            ,null 不淘汰
            ,null 基建3
            ,null 小组基建
            ,null 席位
            ,null 在投人数
            ,null 总new占比
            ,专属组
            ,null 书籍次日基建
            ,a.兜底书籍
            ,a.是否补位
            ,coalesce(b.nick_name,a.nick_name_max) as nick_name2
            ,2 as 基建4
        from (
            select distinct dt
                ,product
                ,source2
                ,code_id
                ,code_stage
                ,code_lv
                ,test_status
                ,begin_date
                ,end_date
                ,book_code
                ,languageid
                ,weekdays
                ,current_language
                ,frt_nickname
                ,nick_name_max
                ,frt_group
                ,is_frt_group
                ,专属组
                ,兜底书籍
                ,0 as 是否补位
            from z22
            where  兜底书籍=1
        ) a
        left join ads.ads_srsv_bi_ad_optimizer_priority b on a.dt=b.dt and a.product=b.product and a.source2=b.source2 and a.code_id=b.code_id and rn_spend=1
        -- 优化师&组
        left join (
            select distinct a.code
                ,a.code_value
                ,left(a.code_value,2) as group_product
                ,b.nick_name
            from dim.dim_optimizer_groups_new_view a
            left join dim.dim_kpi_user_info_view b on a.code=b.account
            where left(a.code_value,2) in ('hj','hy')
        ) d on coalesce(b.nick_name,a.nick_name_max)=d.nick_name and if(a.product='海剧','hj','hy')=d.group_product
    )

    -- 输出
    , z33 as (
        -- 昨日有基建
        select *
            ,0 as 是否补位
            ,nick_name as nick_name2
            ,基建3 as 基建4
        from z22
        where ad_optimizer_uid is not null
        -- 新增席位，小组兜底
        union all
        select * from z31
        -- 书籍兜底
        union all
        select * from z32
    )

select *
    ,now() as etl_tm
from z33
where dt>='${bf_9_dt}'  and dt<='${dt}';
