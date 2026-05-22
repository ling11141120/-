----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_advertisement_fbad_rd_cost_charge_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : ads_advertisement_fbad_rd_cost_charge_info
-- task_version     : 3
-- update_time      : 2024-10-16 11:07:25
-- sql_path         : \starrocks\ads_advertisement_fbad_rd_cost_charge_info\ads_advertisement_fbad_rd_cost_charge_info
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_advertisement_fbad_rd_cost_charge_info  where dt>='${bf_90_dt}';

-- SQL语句
-- ===========================阅读的脚本--------------------------------------
insert into ads.ads_advertisement_fbad_rd_cost_charge_info
with ins as
 (
select
date(install_date) as dt,
Country
,source
,book_id
, mt
,count(distinct user_id) as reg_unt -- 本地注册数
,sum(case when TIMESTAMPDIFF(hour, install_date,CreateTime)>=0 and TIMESTAMPDIFF(hour, install_date,CreateTime)<=24 then item_count else 0 end) as h24_amt
,sum(case when TIMESTAMPDIFF(day, install_date,CreateTime)>=0 and TIMESTAMPDIFF(day, install_date,CreateTime)<=7 then item_count else 0 end) as d7_amt
,sum(case when TIMESTAMPDIFF(day, install_date,CreateTime)>=0 and TIMESTAMPDIFF(day, install_date,CreateTime)<=30 then item_count else 0 end) as d30_amt
,sum(case when TIMESTAMPDIFF(day, install_date,CreateTime)>=0 and TIMESTAMPDIFF(day, install_date,CreateTime)<=90 then item_count else 0 end) as d90_amt
from (
select
z1.product_id,
z1.install_date
,z1.mt
,z1.source
,z1.user_id
,z1.Country
,z1.ad_id
,z1.book_id
,b.CreateTime
,b.item_count
from dws.dws_advertisement_fbad_install_info_temp z1
left join
(
select productid as product_id ,mt,userid as user_id,hours_add(createtime,-13) as CreateTime,itemcount as item_count
from dwd.dwd_trade_user_payorder
where
dt>=date_sub('${dt}',interval 90 day) and
createtime>=date_sub(date_add('${dt}',interval 13 hour),interval 90 day)
-- and createtime<date_add('2023-06-01',interval 13 hour)
and productid in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
and  testflag = 0
group by 1,2,3,4,5
) b
on z1.user_id=b.user_id and z1.product_id=b.product_id and z1.mt=b.mt
where z1.dt>=date_sub('${dt}',interval 90 day) and z1.product_tp=1 -- 阅读的---
) a
group by 1,2,3,4 ,5
 )

select source.dt,source.country,source.country_level,source.source_chl,source.book_id,source.mt,source.cost_amt,source.click_cnt,source.impression_cnt,source.source_reg_unt,source.pay_amt,source.pay_cnt,
ins.reg_unt,ins.h24_amt,ins.d7_amt,ins.d30_amt,ins.d90_amt,now() as etl_tm
from dws.dws_advertisement_fbad_country_daily_insight_info_temp source
 left join
ins
on source.dt= ins.dt and  source.country=ins.country and source.source_chl=ins.source  and source.book_id=ins.book_id and  source.mt =ins.mt
where source.dt>=date_sub('${dt}',interval 90 day) and source.product_tp=1 -- 阅读的---
;
