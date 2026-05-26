----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_user_amt_ecpm_a
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : dws_advertisement_user_amt_ecpm_a
-- task_version     : 4
-- update_time      : 2024-10-16 15:40:33
-- sql_path         : \starrocks\tbl_dws_advertisement_user_amt_ecpm_a\dws_advertisement_user_amt_ecpm_a
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_advertisement_user_amt_ecpm_a
 with  update_ecpm as (
select product_id,user_id,
max(round(latest_banner_ad_ecpm,2)) latest_banner_ad_ecpm ,
max(round(latest_native_ad_ecpm,2)) latest_native_ad_ecpm,
max(round(latest_incentive_ad_ecpm,2)) latest_incentive_ad_ecpm,
max(round(latest_flashscreen_ad_ecpm,2)) latest_flashscreen_ad_ecpm ,
max(round(latest_interstitial_ad_ecpm,2)) latest_interstitial_ad_ecpm,
max(create_time) as last_time,
      now() as update_time,
      now() as etl_time
      from (

 select a.product_id,
       a.user_id,
       a.create_tm as create_time  ,
        case when  a.ad_show_type =1 then ad_position_amt*1000 end as latest_banner_ad_ecpm,
        case when  a.ad_show_type =2 then ad_position_amt*1000 end as latest_native_ad_ecpm,
        case when  a.ad_show_type =3 then ad_position_amt*1000 end as latest_incentive_ad_ecpm,
        case when  a.ad_show_type =4 then ad_position_amt*1000 end as latest_flashscreen_ad_ecpm,
        case when  a.ad_show_type =6 then ad_position_amt*1000 end as latest_interstitial_ad_ecpm,
        row_number()over(partition by a.product_id,a.user_id,a.ad_show_type order by a.create_tm desc ) as rk_desc
	   from  dwd.dwd_advertisement_user_position_amt_p_di a
       where a.dt >= '${bf_1_dt}'  and  a.create_tm<date_add(now(),interval -1 minute)
) x
where rk_desc=1
group by 1, 2

)

select '${bf_1_dt}' as dt,a.product_id ,a.user_id,
 case when  b.latest_banner_ad_ecpm is not null then b.latest_banner_ad_ecpm
      when b.latest_banner_ad_ecpm is null and a.latest_banner_ad_ecpm is null then b.latest_banner_ad_ecpm
      when b.latest_banner_ad_ecpm is null and a.latest_banner_ad_ecpm is not null then  a.latest_banner_ad_ecpm  end as latest_banner_ad_ecpm,
 case when  b.latest_native_ad_ecpm is not null then b.latest_native_ad_ecpm
      when b.latest_native_ad_ecpm is null and a.latest_native_ad_ecpm is null then b.latest_native_ad_ecpm
      when b.latest_native_ad_ecpm is null and a.latest_native_ad_ecpm is not null then  a.latest_native_ad_ecpm  end as latest_native_ad_ecpm,
case when  b.latest_incentive_ad_ecpm is not null then b.latest_incentive_ad_ecpm
      when b.latest_incentive_ad_ecpm is null and a.latest_incentive_ad_ecpm is null then b.latest_incentive_ad_ecpm
      when b.latest_incentive_ad_ecpm is null and a.latest_incentive_ad_ecpm is not null then  a.latest_incentive_ad_ecpm  end as latest_incentive_ad_ecpm,
case when  b.latest_flashscreen_ad_ecpm is not null then b.latest_flashscreen_ad_ecpm
      when b.latest_flashscreen_ad_ecpm is null and a.latest_flashscreen_ad_ecpm is null then b.latest_flashscreen_ad_ecpm
      when b.latest_flashscreen_ad_ecpm is null and a.latest_flashscreen_ad_ecpm is not null then  a.latest_flashscreen_ad_ecpm  end as latest_flashscreen_ad_ecpm,
case when  b.latest_interstitial_ad_ecpm is not null then b.latest_interstitial_ad_ecpm
      when b.latest_interstitial_ad_ecpm is null and a.latest_interstitial_ad_ecpm is null then b.latest_interstitial_ad_ecpm
      when b.latest_interstitial_ad_ecpm is null and a.latest_interstitial_ad_ecpm is not null then  a.latest_interstitial_ad_ecpm  end as latest_interstitial_ad_ecpm,
b.last_time,
now() as update_time,now() as etl_time
from (
 select product_id ,user_id,latest_banner_ad_ecpm,latest_native_ad_ecpm,latest_incentive_ad_ecpm,latest_flashscreen_ad_ecpm,latest_interstitial_ad_ecpm,last_time from
 dws.dws_advertisement_user_amt_ecpm_a
 where dt='${bf_2_dt}' and concat(product_id,user_id) in (select distinct  concat(product_id,user_id) from update_ecpm)) a
 inner join
(select product_id ,user_id,latest_banner_ad_ecpm,latest_native_ad_ecpm,latest_incentive_ad_ecpm,latest_flashscreen_ad_ecpm,latest_interstitial_ad_ecpm,last_time from update_ecpm  ) b
  on a.product_id=b.product_id and a.user_id=b.user_id
union all
 select '${bf_1_dt}' as dt,product_id ,user_id,latest_banner_ad_ecpm,latest_native_ad_ecpm,latest_incentive_ad_ecpm,latest_flashscreen_ad_ecpm,latest_interstitial_ad_ecpm,last_time,update_time,now() as etl_time from
 dws.dws_advertisement_user_amt_ecpm_a
 where dt='${bf_2_dt}'  and concat(product_id,user_id) not in  (select distinct  concat(product_id,user_id) from update_ecpm )
union all
 select '${bf_1_dt}' as dt,product_id ,user_id,latest_banner_ad_ecpm,latest_native_ad_ecpm,latest_incentive_ad_ecpm,latest_flashscreen_ad_ecpm,latest_interstitial_ad_ecpm,last_time,now() as update_time,now() as etl_time from
update_ecpm
 where concat(product_id,user_id) not in  (select concat(product_id,user_id) from  dws.dws_advertisement_user_amt_ecpm_a  where dt='${bf_2_dt}' );
