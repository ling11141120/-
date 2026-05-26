----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_cv_exposure_recharge_di
-- workflow_version : 14
-- create_user      : yanxh
-- task_name        : dws_flow_cv_exposure_recharge_di
-- task_version     : 14
-- update_time      : 2025-03-27 18:36:59
-- sql_path         : \starrocks\tbl_dws_flow_cv_exposure_recharge_di\dws_flow_cv_exposure_recharge_di
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_cv_exposure_recharge_di where dt='${bf_1_dt}';

-- SQL语句
insert into  dws.dws_flow_cv_exposure_recharge_di
with exp_user as
(

  select ex.dt,
       ex.cz_template_id,ex.cz_template_name,
       ex.app_id,   -- if(ex.app_id='tt04bb72069b87c57401','抖音','微信') as product_tps, -- 产品类型
       ex.real_recharge,-- 档位金额
       ex.login_id as user_id,  -- 曝光用户
       ex.shortplay_id, -- 短剧id
       b.tv_name ,-- 剧名称
       -- c.middle_man_id,-- 机构id
       if(d.tps is null ,1 ,d.tps) as recharge_tps,  -- 1:自营 2：分销 3：星图，4：小程序推广
       ex.event_tm
       from  ods_log.ods_sensors_cd_video_production_rechargeexposure ex
       left join
       dim.dim_cn_a_tv_view  b  on ex.shortplay_id=b.tv_id
       left join
       dim.dim_video_cn_accountinfo_view c
       on ex.login_id=c.video_user_id
   left join   -- 通过表C的机构id 关联来区别充值来源-------------
(
-- ------------ 分销的 --------------------
select distinct  ref_id ,2 as tps from  dim.dim_ads_role_users_view where role_json like '%middleman%' and  operation_type= 2
 union all    -- 筛选出属于星图推广的数据
select  ref_id, 3 as tps from  dim.dim_ads_role_users_view where  type= 2
union all   -- 筛选出属于小程序推广的数据
select  ref_id,4 as tps from  dim.dim_ads_role_users_view where  type= 3
) d
 on c.middle_man_id =d.ref_id
where  ex.dt='${bf_1_dt}'  and ex.product_id=6883
and ex.cz_template_id is not null
and ex.cz_template_id !=''
) ,

 ads as (

 select exp_user.dt,
       ad.ads_optimizer,
       exp_user.cz_template_id,
       exp_user.cz_template_name,
       exp_user.app_id,   -- if(ex.app_id='tt04bb72069b87c57401','抖音','微信') as product_tps, -- 产品类型
       exp_user.real_recharge,-- 档位金额
       exp_user.user_id ,
        exp_user.shortplay_id ,
        exp_user.tv_name ,
		exp_user.recharge_tps,
       exp_user.event_tm
from  exp_user
left join

 -- 获取近30天内最新一条数据的优化师名字字段---
(
select  user_id,ads_optimizer
from (
 select a.Unique_CdReaderId as user_id,a.ad_id,b.ads_optimizer,max(a.dt) as dt from dwd.dwd_user_install_info_ed_view  a
left join dwd.dwd_advertisement_adext_view b
on a.ad_id=b.ad_id
where a.dt>=date_sub('${bf_1_dt}',interval 30  day) and a.Product_Id =6883 and a.ad_id is not null
-- and a.Unique_CdReaderId= '65f2f62f8b0da4a4e449c8b1'
group by 1,2,3
 ) v
QUALIFY row_number() over (partition by user_id order by dt desc ) =1

) ad
on exp_user.user_id =ad.user_id

)

-- select * from ads order by 7
,

 re as (

  select dt,cz_template_id,cz_template_name,app_id,real_recharge,ads_optimizer,user_id,event_tm
 from (
 select ads.dt,ads.user_id ,ads.app_id,ads.cz_template_id,ads.cz_template_name,ads.real_recharge,ads.ads_optimizer,ads.event_tm ,b.create_time,timeDIFF(b.create_time,ads.event_tm ) as time_diff,
 ROW_NUMBER()over(partition by ads.dt,ads.user_id ,ads.app_id,ads.cz_template_id,ads.cz_template_name,ads.real_recharge,ads.ads_optimizer   order by timeDIFF(b.create_time,ads.event_tm ) ) as rk
from  ads
 inner join
 (
select  a.dt, a.video_user_id as user_id ,b.template_id , a.amount/100 as recharge_amt,a.create_time
from dwd.dwd_trade_video_cn_payorder_view a
-- 获取用户的充值模板id （通过充值选项id来关联获取）
left join ods.ods_tidb_cdvideo_tidb_xcx_sync_recharge_template_option b
on a.option_snap_shot_id=b.option_snapshot_id
where a.dt='${bf_1_dt}'   and  a.coo_order_status = 1 and a.test_flag = 0
 -- and a.option_snap_shot_id ='6602e339e0ec199b188c6d20' --  对应的 template_id=6602e2d9a09a9b12d78cacb3
-- and a.video_user_id='6607bcb9213929f866a88a1e'
 ) b
 on ads.dt=b.dt and ads.user_id=b.user_id and ads.cz_template_id=b.template_id  and ads.real_recharge=b.recharge_amt    and b.create_time>=ads.event_tm
 ) x where rk=1

 )

  -- select  count(exp_user),count(recharge_user),count(distinct  recharge_user),sum(real_recharge),count(recharge_tps) from (
 -- select *from re
  select  ads.dt,
       ads.ads_optimizer,
       ads.cz_template_id,ads.cz_template_name,
      if(ads.app_id='tt04bb72069b87c57401','抖音','微信') as product_tps, -- 产品类型
       ads.real_recharge,-- 档位金额
       ads.user_id as exp_user,  -- 曝光用户id
       re.user_id as recharge_user, -- 充值用户id
	    ads.shortplay_id, -- 短剧id
        ads.tv_name, -- 短剧名称
		ads.recharge_tps,
       now() as etl_tm
      from ads
    left join  re
 on
 ads.dt=re.dt and  ads.cz_template_id=re.cz_template_id
 and ads.cz_template_name=re.cz_template_name and ads.app_id=re.app_id
 and ads.real_recharge=re.real_recharge
 -- and ads.ads_optimizer=re.ads_optimizer
 and ads.user_id=re.user_id
and  ads.event_tm=re.event_tm
 --  vv;
