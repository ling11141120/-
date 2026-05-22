----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_advertisement_fbad_rd_cost_charge_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dws_advertisement_fbad_country_daily_insight_info_temp
-- task_version     : 3
-- update_time      : 2024-11-26 20:53:59
-- sql_path         : \starrocks\ads_advertisement_fbad_rd_cost_charge_info\dws_advertisement_fbad_country_daily_insight_info_temp
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_advertisement_fbad_country_daily_insight_info_temp where dt >='${bf_7_dt}';

-- SQL语句
insert into dws.dws_advertisement_fbad_country_daily_insight_info_temp
select a.dt  ,
       a.product_id,
       a.country,
       a.country_level,
       b.source_chl ,
       b.book_id,
       a.mt,
       a.Core,
       product_tp,
    sum(a.spend) cost_amt,  -- 花费
    sum(linkclick)  click_cnt, -- 链接点击
    sum(impressions) impression_cnt,  -- 展示
    sum(case when b.source_chl = 'fbs2s' then registration  -- fbs2s的注册
        when b.source_chl = 'facebook' then installs -- facebook注册
        else null end) as source_reg_unt, -- 媒体注册用户数
    sum(case when b.source_chl = 'fbs2s' then pixelpurchasevalue
        when b.source_chl = 'facebook' then apppurchasevalue
        else null end) as pay_amt,  -- 充值收入
    sum(case when b.source_chl = 'fbs2s' then pixelpurchase
        when b.source_chl = 'facebook' then apppurchase
        else null end) as pay_cnt, -- 充值次数
        now() as etl_tm
from (
select a.dt,a.product_id,a.ad_id,a.mt,a.country,b.Core,
case when a.product_id not in (6883,6833) then 1 when  a.product_id=6833 then 2 end as product_tp, -- product_tp  1:阅读 2:海剧
case when a.product_id=6833 then null  -- 海剧没有国家等级
when  a.product_id not in (6883,6833) and c.`level` is null then 2  -- 配置表中没有匹配到的国家即为T2
when  a.product_id not in (6883,6833) and c.`level` is not null then c.`level` end  as country_level,
   sum(a.spend) as spend -- 投放花费
                ,sum(a.installs) as installs  -- facebook注册
                ,sum(a.regist_ration) as registration  -- fbs2s的注册
                ,sum(a.app_purchase_value)  as apppurchasevalue  -- facebook充值金额
                ,sum(a.pixel_purchase_value) as pixelpurchasevalue  -- fbs2s充值金额
                ,sum(a.app_purchase)  as apppurchase -- facebook充值次数
                ,sum(a.pixel_purchase) as pixelpurchase  -- fbs2s充值次数
                ,sum(a.link_click) linkclick  -- 链接点击
                ,sum(a.impressions) impressions  -- 展示
    from dwd.dwd_advertisement_fbad_country_daily_insight_view  a
     left join dim.dim_FbAccount_view b on a.fb_account_id = b.Account
     left join
       dim.dim_countrylevel c
 on a.product_id =c.product_id  and a.country =c.short_name
    where a.dt >= '${bf_7_dt}' --   and a.dt<'2024-01-15'
    and (a.app_purchase_value is not null or a.pixel_purchase_value is not null) and  a.product_id not in (6883) -- -剔除缺失数据
    group by 1,2,3,4,5,6,7,8
  ) a
inner join
   ( select   ad_id, source_chl ,book_id   from  dwd.dwd_advertisement_adext_view  where  source_chl in ('facebook','fbs2s') group by 1,2 ,3) b
on a.ad_id = b.ad_id
group by  1,2,3,4,5,6 ,7,8,9;
