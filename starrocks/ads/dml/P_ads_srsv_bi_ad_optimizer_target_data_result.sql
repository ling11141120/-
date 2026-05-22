----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data_v1
-- workflow_version : 71
-- create_user      : yanxh
-- task_name        : ads_srsv_bi_ad_optimizer_target_data_result_v1
-- task_version     : 33
-- update_time      : 2025-01-07 16:43:02
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data_v1\ads_srsv_bi_ad_optimizer_target_data_result_v1
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.`ads_srsv_bi_ad_optimizer_target_data_result`  where dt>='${bf_9_dt}'  and dt<='${dt}';

-- SQL语句
insert into ads.`ads_srsv_bi_ad_optimizer_target_data_result`

WITH z1_1 AS
(
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
	       ,CASE WHEN t1.weekdays = 7 THEN t2.sunday_rate
	             WHEN t1.weekdays = 5 THEN t2.friday_rate  ELSE 1 END `星期系数`
	       ,power(if(regnum_all_7d = 0,0,regnum_new_7d/regnum_all_7d),2) N收入占比
	       ,coalesce(d0_amt_pow/std_amt_pow,0)         AS R0_新
	       ,coalesce(d0_amt_pow_old/std_amt_pow_old,0) AS R0_老
	FROM ads.ads_srsv_bi_ad_optimizer_target_data_v1 t1
	LEFT JOIN dim.dim_srsv_ad_prduct_lang_rate t2
	ON t1.product = t2.product AND t1.languageid = t2.lang_id
	LEFT JOIN dim.dim_srsv_ad_prduct_source_rate t3
	ON t1.product = t3.product AND t1.source2 = t3.source_plaform
	ORDER BY t1.days_10d
-- ), z1_2 AS
-- (
-- 	SELECT  z1_1.*
-- 	       ,(R0_新/new_std*new_r0_rate + R0_老/old_std*(1-new_r0_rate))/if(R0_老 < 0.1,0.8,1)   AS 增幅底数
-- 	       ,coalesce(log(log_num,10) - log(log_num,adset_num) + exp_a + lang_rate+ N收入占比 ,1) AS 增幅指数
-- 	       ,coalesce(power((spend/adset_num)/(spend_10d/adset_num_10d),spend_exp),1)         AS 平均花费系数
-- 	FROM z1_1
-- ), z1_3 AS
-- (
-- 	SELECT  z1_2.*
-- 	       ,power(增幅底数,if(增幅底数 > 1,增幅指数,non_compliance_exp)) AS `增幅倍数`
-- 	FROM z1_2
-- 10月2日优化
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
           ,power(case when 增幅底数<1 or ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)<1 then greatest(增幅底数,ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)) else least(增幅底数,ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)) end
                    ,if((case when 增幅底数<1 or ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)<1 then greatest(增幅底数,ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)) else least(增幅底数,ifnull(d0_amt,0)/new_std/ifnull(std_amt,0.00001)) end) > 1,增幅指数,non_compliance_exp)) AS `增幅倍数`
    FROM z1_2
)
, z1_4 AS
(
	SELECT  z1_3.*
	       ,round(least(`平均花费系数`*if(增幅倍数>0.95 and product='海剧',1.1,1)*增幅倍数*`星期系数`,5)*adset_num) 基建1
	FROM z1_3
), z1_5 AS
(
	SELECT  z1_4.*
	       ,if(code_stage = 2 AND product = '海阅',LEAST(if(weekdays IN (5,6),6,4),基建1),基建1 )                AS 基建2
	       ,if(dt >= coalesce(off_begindate,'1990-01-01') AND dt < coalesce(off_enddate,'1990-01-01'),0,1) AS 不淘汰
	FROM z1_4
)
-- 若淘汰 且 基建2<4 ,则 0；否则 max(2,基建2)
, z1_6 AS (
	SELECT  z1_5.*
	       ,if(不淘汰<>1 and 基建2<4,0,GREATEST(2,基建2)) AS 基建3
	FROM z1_5
)
 , z2 AS
(
	SELECT  *
	       ,SUM(基建3) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group)                                             AS 小组基建 -- 统计基建3求和 分组[日期，产品，书籍ID/短剧ID，优化师分组]
	       ,GREATEST(ifnull(floor(log(base_rate,SUM(基建3) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group))),0),1) AS 席位 -- 未匹配优化师时，取99，否则（当基建席位 = 0，取1，否则取1 和 ln（基建席位）中较大的值）
	       ,COUNT(CASE WHEN 基建3 > 0 THEN 1 ELSE null END ) OVER (PARTITION BY dt,product,code_id,source2,ad_optimizer_group )      AS 在投人数 -- 统计基建3大于0的 分组[日期，产品，书籍ID/短剧ID，优化师分组]
	       ,coalesce(SUM(regnum_new_7d) OVER (PARTITION BY dt,source2,product,code_id)/ SUM(regnum_all_7d) OVER (PARTITION BY dt,product,source2,code_id),0) AS 总new占比 -- 近7天新注册D0收入/近7天注册D0收入 分组[日期，产品，媒体，书籍ID/短剧ID]
	       ,if(product = '海阅' AND code_stage = '2',frt_group,is_frt_group)                                                         AS 专属组
	       ,SUM(基建3) OVER (PARTITION BY dt,product,source2,code_id)                                                                AS 书籍次日基建
	       ,if(nick_name is null or SUM(基建3) OVER (PARTITION BY dt,product,source2,code_id) = 0,1,0)                               AS 兜底书籍
           FROM z1_6
)

-- 10月10日，新增海剧补位逻辑
  -- 剧的总席位 = log（剧的总计划基建）
  -- 在投人数
-- 补全无投放小组初始基建
, z4_1 as (
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
    ,c.ad_optimizer_group
    ,b.adset_num
    ,b.spend
    ,b.d0_amt
    ,b.std_amt
    ,b.reg_num
    ,b.reg_num_all
    ,b.reg_num_new
    ,b.regnum_new_7d
    ,b.regnum_all_7d
    ,b.spend_10d
    ,b.adset_num_10d
    ,b.days_10d
    ,b.d0_amt_10d
    ,b.std_amt_10d
    ,b.d0_amt_all
    ,b.std_amt_all
    ,b.d0_amt_pow
    ,b.std_amt_pow
    ,b.d0_amt_pow_old
    ,b.std_amt_pow_old
    ,a.frt_nickname
    ,a.nick_name_max
    ,a.frt_group
    ,a.is_frt_group
    ,b.off_begindate
    ,b.off_enddate
    ,b.lang
    ,b.lang_rate
    ,b.group_spend
    ,b.sunday_rate
    ,b.friday_rate
    ,b.base_rate
    ,b.new_std
    ,b.old_std
    ,b.log_num
    ,b.log_num_median
    ,b.exp_a
    ,b.new_r0_rate
    ,b.non_compliance_exp
    ,b.spend_exp
    ,b.星期系数
    ,b.N收入占比
    ,b.R0_新
    ,b.R0_老
    ,b.增幅底数
    ,b.增幅指数
    ,b.平均花费系数
    ,b.增幅倍数
    ,b.基建1
    ,b.基建2
    ,b.不淘汰
    ,b.基建3
    ,b.小组基建
    ,ifnull(b.席位,1) 席位
    ,ifnull(b.在投人数,0) 在投人数
    ,a.总new占比
    ,a.专属组
    ,b.书籍次日基建
    ,b.兜底书籍
  from (
    --每日书籍
    select distinct dt
          ,product
          ,languageid
          ,current_language
          ,source2
          ,code_id
          ,book_code
          ,code_stage
          ,code_lv
          ,frt_group
          ,is_frt_group
          ,frt_nickname
          ,nick_name_max
          ,test_status
          ,begin_date
          ,end_date
          ,weekdays
          ,专属组
          ,总new占比
      from z2
  ) a
  -- 投放小组
  left join (
    select dt
        ,product
        ,ad_optimizer_group
        ,max_by(source2,spend) source2
    from (
      select dt
        ,product
        ,source2
        ,ad_optimizer_group
        ,sum(spend) spend
      from z2
      where ad_optimizer_group is not null
      group by 1,2,3,4
    ) x
    group by 1,2,3
  ) c on a.dt=c.dt and a.product=c.product   and a.source2=c.source2
  -- 每日基建
  left join z2 b on a.dt=b.dt and a.product=b.product and b.source2=a.source2 and a.code_id=b.code_id and b.ad_optimizer_group=c.ad_optimizer_group  and  b.nick_name is not null
  where (a.专属组='' or a.专属组 is null or a.专属组=c.ad_optimizer_group)   -- 可投书和小组
)

-- 小组补基建 ， 投放相关的指标不可用
, z4 as (
  select a.*
    ,if(a.在投人数=0 and a.专属组=a.ad_optimizer_group,if(a.product='海剧',ifnull(a.frt_nickname,b.nick_name),ifnull(a.nick_name_max,b.nick_name)),b.nick_name) as nick_name2
    --,b.ad_optimizer_uid as  ad_optimizer_uid2
    ,2 as 基建4
  from (
    select *
    from (
      select *
        ,row_number() over(partition by concat(dt,product,code_id,source2,ad_optimizer_group) order by spend) 是否补位
      from z4_1
      where 席位-在投人数>0
    ) x
    where 是否补位=1
  ) a
  -- 候补优先级排序
  left join ads.ads_srsv_bi_ad_optimizer_priority_v1  b on a.dt=b.dt and a.product=b.product and a.source2=b.source2 and a.code_id=b.code_id and b.rn<=(a.席位-a.在投人数) and a.ad_optimizer_group=b.ad_optimizer_group
)

--每日分剧分组随机定值
, z6_1 as (
  select a.dt
    ,a.product
    ,a.code_id
    ,b.source2
    ,c.ad_optimizer_group
    ,avg(a.rand_v) rank
  from  dim.dim_srsv_ad_product_rand_info_v1 a
  -- 优化师分组
  left join (
    select dt
      ,product
      ,ad_optimizer_group
      ,ad_optimizer_uid
    from ads.ads_srsv_bi_ad_optimizer_target_data_v1
    where ad_optimizer_group is not null  and ad_optimizer_uid  is not null
    group by 1,2,3,4
  ) c on a.dt=c.dt and a.product=c.product   and a.ad_optimizer_uid=c.ad_optimizer_uid
  -- 优化师小组
  left join (
    select dt
        ,product
        ,ad_optimizer_group
        ,max_by(source2,spend) source2
    from (
      select dt
        ,product
        ,source2
        ,ad_optimizer_group
        ,sum(spend) spend
      from z2
      where ad_optimizer_group is not null
      group by 1,2,3,4
    ) x
    group by 1,2,3
  ) b on a.dt=b.dt and a.product=b.product  and c.ad_optimizer_group=b.ad_optimizer_group
  group by 1,2,3,4,5
)

-- 剧有多余席位，当日小组人均基建少的优先剧集小组排序
, z6_2 as (
    select *
      ,ceiling(总席位/组数) as 每组席位数up
      ,1*(在投人数>=ceiling(总席位/组数)) as 是否超席位
      ,sum(在投人数*(在投人数>=ceiling(总席位/组数))) over(partition by dt,product,source2,code_id)  超席位组在投人数
      ,max(rn*(在投人数>=ceiling(总席位/组数))) over(partition by dt,product,source2,code_id)  超席位组最大rn
    from (
      select *
        ,ifnull(floor(log(base_rate*0.7,sum(组基建) over(partition by dt,product,source2,code_id))),0) 总席位
        ,sum(在投人数) over(partition by dt,product,source2,code_id) 总在投人数
        ,row_number() over(partition by dt,product,source2,code_id order by 在投人数 desc,组基建 desc,rank desc)  rn
        ,count() over(partition by dt,product,source2,code_id)  组数
      from (
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
            ,a.专属组
            ,a.base_rate
            ,b.ad_optimizer_group
            ,b.rank
            ,sum((a.ad_optimizer_group=b.ad_optimizer_group)*组基建) 组基建
            ,sum((a.ad_optimizer_group=b.ad_optimizer_group)*在投人数) 在投人数
        from z6_1 b
        join (
          select dt
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
            ,base_rate
            ,专属组
            ,ad_optimizer_group
            ,sum(基建3) 组基建
            ,sum(1*(基建3>0)) 在投人数
          from z2
          where  兜底书籍=0
          group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
        ) a on a.dt=b.dt and a.product=b.product and a.code_id=b.code_id  and a.source2=b.source2
        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
      ) x
    ) xx
    where 总席位> 总在投人数   -- 过滤条件
)

--小组补席位，并补充优化师
, z6_3 as (
  select a.*
    ,b.ad_optimizer_uid
    ,b.nick_name
  from (
    -- 非专属组，新增席位
    select *
      ,分配均值-在投人数+if(rn-超席位组最大rn<=余数,1,0) as  新增席位
    from (
      select *
        ,FLOOR((总席位-超席位组在投人数)/(组数-超席位组最大rn))  as 分配均值
        ,mod((总席位-超席位组在投人数),(组数-超席位组最大rn)) as 余数
      from z6_2
      where 是否超席位=0 and 专属组=''
    ) x
    union all
    -- 专属组
    select *
      ,0 as 分配均值
      ,0 as 余数
      ,总席位-在投人数 as 新增席位
    from z6_2
    where 专属组=ad_optimizer_group
  ) a
  -- 每日小组优化师随机值,需剔除在投
  left join (
    select a.*
      ,row_number() over(partition by a.dt,a.product,a.code_id,a.ad_optimizer_group  order by a.rand_v desc) rn
    from dim.dim_srsv_ad_product_rand_info_v1 a
    -- 在投优化师
    left join (
        select *
          ,0 as 是否补位
          ,nick_name as nick_name2
          ,基建3 as 基建4
        from z2
        where nick_name is not null and ifnull(基建3,0)>0
    ) b on a.dt=b.dt and a.product=b.product  and a.code_id=b.code_id and a.ad_optimizer_uid=b.ad_optimizer_uid
    where b.ad_optimizer_uid is null
  ) b on a.product=b.product and a.code_id=b.code_id and a.dt=b.dt and a.新增席位>=b.rn and a.ad_optimizer_group=b.ad_optimizer_group
)

--新增基建
, z6 as (
  select dt
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
    ,0 frt_nickname
    ,0 nick_name_max
    ,0 frt_group
    ,0 is_frt_group
    ,0 off_begindate
    ,0 off_enddate
    ,0 lang
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
    ,专属组
    ,0 书籍次日基建
    ,0 兜底书籍
    ,1 as 是否补位
    ,nick_name as nick_name2
    ,2 as 基建4
  from z6_3
  where 新增席位>0
)

, z7 as (
    select *
    ,0 as 是否补位
    ,nick_name as nick_name2
    ,基建3 as 基建4
  from z2
  where nick_name is not null and ifnull(基建3,0)>0
  union all
  -- 海阅补位
  select * from z4
  where nick_name2 is not null and product='海阅'
  -- 海剧兜底补
  union all
  select a.dt
    ,a.product
    ,a.source2
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
    ,b.nick_name
    ,a.ad_optimizer_uid
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
    ,0 frt_nickname
    ,0 nick_name_max
    ,0 frt_group
    ,0 is_frt_group
    ,0 off_begindate
    ,0 off_enddate
    ,0 lang
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
    ,专属组
    ,0 书籍次日基建
    ,a.兜底书籍
    ,1 as 是否补位
    ,a.nick_name_max as nick_name2
    ,2 as 基建4
  from (
    select *
    from z2
    where product='海剧' and ifnull(兜底书籍,1)=1
  ) a
  -- 优化师组
  left join (
    select ad_optimizer_group
      ,nick_name
      ,dt
      ,product
    from z2
    where nick_name is not null and ad_optimizer_group is not null
    group by 1,2,3,4
  ) b on a.nick_name_max=b.nick_name and a.product=b.product and a.dt=b.dt
  where b.ad_optimizer_group is not null
  -- 新增席位
  union all
  select *
  from z6
  where product='海剧'
)

select *
    ,now() as etl_tm
from z7
where dt>='${bf_9_dt}'  and dt<='${dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data_v1
-- workflow_version : 71
-- create_user      : yanxh
-- task_name        : delete_bf_9_dt
-- task_version     : 4
-- update_time      : 2025-01-10 18:47:43
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data_v1\delete_bf_9_dt
----------------------------------------------------------------
-- SQL语句
delete from  ads.`ads_srsv_bi_ad_optimizer_target_data_result`  where dt>='${bf_9_dt}'  and dt<='${dt}';
