----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sr_third_payment_exposure_pv_di
-- workflow_version : 21
-- create_user      : hufengju
-- task_name        : ads_bi_sr_third_payment_exposure_pv_di
-- task_version     : 21
-- update_time      : 2025-12-10 11:24:58
-- sql_path         : \starrocks\tbl_ads_bi_sr_third_payment_exposure_pv_di\ads_bi_sr_third_payment_exposure_pv_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_sr_third_payment_exposure_pv_di`
select
    a.dt
     ,ifnull(a.element_id ,-99) as  element_id
     ,ifnull(a.event_strategy_id ,-99) as  event_strategy_id
     ,a.core
     ,a.mt
     ,a.user_id
     ,ifnull(a.programme_id ,-99) as programme_id
     ,ifnull(a.recharge_type,-99) as recharge_type
     ,group_concat(distinct a.zffs_id_list)  as zffs_id_list
     ,group_concat(distinct case when unnest=0 and mt=1 then 'AppStore' when unnest=0 and mt=4 then 'GooglePlay' else b.payment end) as payment
     ,group_concat(distinct case when unnest=0 and mt=1 then 'AppStore' when unnest=0 and mt=4 then 'GooglePlay' else b.payment_way end) as payment_way
     ,COUNT(distinct left(event_tm,19))    AS exposure_pv -- `曝光PV`
     ,COUNT(1)   AS exposure_pv2 -- `曝光PV`
     ,now() as etl_time
from (select cast(concat('[', t0.zffs_id_list, ']') as ARRAY <int>)              as zffs_id_list_array
           , t0.dt
           , t0.element_id                                                       as element_id
           , case
                 when t0.element_id = '100708' and t0.element_type in (0, -1)                     then t0.event_strategy_id
                 when t0.element_id in (100024, 100025, 100126, 100365)                           then t0.event_strategy_id
                 when t0.element_id = '100400' and split(t0.pay_link, '_')[1] = 'returnrecommend' then split(t0.pay_link, '_')[4]
                 when t0.element_id = '100390' and split(t0.pay_link, '_')[1] = 'popup'           then split(t0.pay_link, '_')[4]
                 when t0.event_strategy_id > 0                                                    then t0.event_strategy_id
                 else t0.activity_id end                                             as event_strategy_id -- 策略ID
           , ifnull(t0.app_core_ver, -99)                                            as core
-- #            , case lower(t0.os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
           -- 在core=15的情况下要能区分ios和安卓
           , case when t0.mt is not null then t0.mt
                  when lower(t0.os) = 'ios'    then 1
                  when lower(t0.os) ='android' then 4
                  else if(t0.app_core_ver = 15 and t1.mt is not null, t1.mt, -99) end as mt
           , coalesce(t0.identity_user_id, t0.login_id)                              as user_id
           , t0.programme_id
           , t0.recharge_type
           , t0.event_tm
           , t0.zffs_id_list
      from ads.ads_sensors_production_rechargeexposure_view t0
               left join (
                             select distinct id as user_id, mt
                             from dim.dim_user_account_info_view
                         ) t1
                         on coalesce(t0.identity_user_id, t0.login_id) = t1.user_id
      where t0.dt >= '${bf_1_dt}'
        and t0.dt <= '${dt}'
        and t0.project_id = 5
        and t0.element_id not in ('100647', '100651', '100107')
             --and right(coalesce(identity_user_id,login_id),1)=1
             --and  login_id=135841721
     ) a
         left join unnest (zffs_id_list_array) as unnest on true
         left join ads.ads_tag_center_third_payment_rate_view b on unnest=b.id
where cast(a.user_id as int)>0
group by 1,2,3,4,5,6,7,8;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sr_third_payment_exposure_pv_di_copy_20250806164457482
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : ads_bi_sr_third_payment_exposure_pv_di
-- task_version     : 2
-- update_time      : 2025-08-06 16:45:15
-- sql_path         : \starrocks\tbl_ads_bi_sr_third_payment_exposure_pv_di_copy_20250806164457482\ads_bi_sr_third_payment_exposure_pv_di
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_bi_sr_third_payment_exposure_pv_di`
select
	 a.dt
	,ifnull(a.element_id ,-99) as  element_id
	,ifnull(a.event_strategy_id ,-99) as  event_strategy_id
	,a.core
	,a.mt
	,a.user_id
	,ifnull(a.programme_id ,-99) as programme_id
	,ifnull(a.recharge_type,-99) as recharge_type
	,group_concat(distinct a.zffs_id_list)  as zffs_id_list
	,group_concat(distinct case when unnest=0 and mt=1 then 'AppStore' when unnest=0 and mt=4 then 'GooglePlay' else b.payment end) as payment
	,group_concat(distinct case when unnest=0 and mt=1 then 'AppStore' when unnest=0 and mt=4 then 'GooglePlay' else b.payment_way end) as payment_way
	,COUNT(distinct left(event_tm,19))    AS exposure_pv -- `曝光PV`
	,COUNT(1)   AS exposure_pv2 -- `曝光PV`
	,now() as etl_time
FROM (
	select
		cast(concat('[',zffs_id_list,']') as ARRAY<int>) as zffs_id_list_array
		,dt
       ,element_id AS element_id
       ,CASE WHEN element_id = '100708' AND element_type IN (0,-1) THEN event_strategy_id
             WHEN element_id IN (100024,100025,100126,100365) THEN event_strategy_id
             WHEN element_id = '100400' AND split(pay_link,'_')[1] = 'returnrecommend' THEN split(pay_link,'_')[4]
             WHEN element_id = '100390' AND split(pay_link,'_')[1] = 'popup' THEN split(pay_link,'_')[4]
             WHEN event_strategy_id > 0 THEN event_strategy_id  ELSE t0.activity_id END   AS event_strategy_id -- 策略ID
		,ifnull(app_core_ver,-99) as core
		,case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
			,coalesce(identity_user_id,login_id)    AS user_id
      ,programme_id
      ,recharge_type
	  ,event_tm
	  ,zffs_id_list
	from ads.ads_sensors_production_rechargeexposure_view t0
	WHERE t0.dt='${bf_1_dt}'
	AND project_id = 5
	AND element_id NOT IN ('100647', '100651', '100107')
	--and right(coalesce(identity_user_id,login_id),1)=1
	--and  login_id=135841721
) a
left join unnest (zffs_id_list_array) as unnest on true
left join ads.ads_tag_center_third_payment_rate_view b on unnest=b.id
where cast(a.user_id as int)>0
group by 1,2,3,4,5,6,7,8;
