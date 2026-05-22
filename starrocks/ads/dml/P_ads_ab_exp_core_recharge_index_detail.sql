----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_ab_exp_core_recharge_index_detail_1
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads_ab_exp_core_recharge_index_detail_1
-- task_version     : 4
-- update_time      : 2025-03-21 17:35:52
-- sql_path         : \starrocks\tbl_ads_ab_exp_core_recharge_index_detail_1\ads_ab_exp_core_recharge_index_detail_1
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_ab_exp_core_recharge_index_detail`
select
	 a.exp_id, -- 实验ID
     a.exp_grp_id, -- 实验组ID
     '${dt}' as dt,
     c.project_id as project_id, -- 项目id
     c.exp_grp_type as experimentType, -- 实验类型
     a.exp_grp_ver_id, -- 流量版本
     datediff(a.dt,b.datestr)+1 as windowNum,
     ifnull(avg( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.recharge_amount END),0) AS divideTrafficNum, -- 单人曝光ARPU均值
     ifnull(variance( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.recharge_amount END),0)  AS strategyHitNum, -- 单人曝光ARPU方差
     ifnull(avg( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.signin_recharge_amount+a.svip_recharge_amount END),0) AS divideTrafficNum, -- 单人曝光ARPU(订阅)均值
     ifnull(variance( case when   date('${dt}')-a.dt<= datediff(a.dt,b.datestr) THEN a.signin_recharge_amount+a.svip_recharge_amount END),0)  AS strategyHitNum, -- 单人曝光ARPU(订阅)方差
     now(),
     now()
	from dwm.`dwm_ab_exp_recharge_data_di` a
	left join dim.dim_date b on a.dt>=b.datestr and b.datestr>=date_sub(a.dt,interval 29 day)
	left join dwd.dwd_ab_exp_version_detail c
     ON a.exp_id = c.exp_id
         AND a.exp_grp_id = c.exp_grp_id
         AND a.exp_grp_ver_id = c.exp_grp_ver_id
    WHERE a.dt >= DATE_ADD('${dt}', -30)
    AND a.dt < DATE_ADD('${dt}', 1)
    and date(c.exp_end_time) >='${dt}'
group by 1,2,3,4,5,6,7
;
