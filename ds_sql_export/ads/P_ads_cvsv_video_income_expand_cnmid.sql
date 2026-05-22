----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cvsv_video_income_expand
-- workflow_version : 14
-- create_user      : linq
-- task_name        : ads_cvsv_video_income_expand_cnmid
-- task_version     : 5
-- update_time      : 2024-10-16 15:30:55
-- sql_path         : \starrocks\tbl_ads_cvsv_video_income_expand\ads_cvsv_video_income_expand_cnmid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cvsv_video_income_expand_cnmid where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.ads_cvsv_video_income_expand_cnmid
with order_id as ( -- 需要过滤的订单数据--
    -- --星图------ 通过订单id来筛选出月9号到5月21号期间的星图数据---------------
    select out_trade_no
    from  dwd.dwd_trade_cn_a_recharge_view
    where  dt >= '2024-05-09' and  dt < '2024-05-22'   and appid ='tt3f83493ea0be37f901'
    union all
    -- --星图------ 5月22号开始通过机构id来区分星图和小程序推广---
    select out_trade_no
    from  dwd.dwd_trade_cn_a_recharge_view
    where  dt >= '2024-05-22' and dt>=date_sub('${dt}',interval 3 day ) and dt < date_sub('${dt}',interval 2 day )
      and pay_status =1  and  middleman_id in ( select ref_id from  dim.dim_ads_role_users_view where  type in(2,3))
    union all
    -- --应用程序--- 剔除微信小程序（畅享、糖情）以及抖音小程序（蚂蚁、梅花、红桃、方块)--
    select out_trade_no
    from  dwd.dwd_trade_cn_a_recharge_view
    where  dt>=date_sub('${dt}',interval 3 day ) and dt < date_sub('${dt}',interval 2 day )
    and appid in('wx00108d51e1e2eb89','wx0b1de00add8c2279','tt0fab7916909607dc01','tt7282043fedb40ec901','ttc282b43f5db4bec201','tt129864258dae6ed501')
),inex as(
    select dt,tv_id,
           round(max(cn_income_amt),2) as cn_income_amt,
           round(max(cn_expand),2) as cn_expand,
           round(max(cn_distribution_expand),2) as cn_distribution_expand
    from(
        select dt, tv_id, sum(base_amount_rmb) as cn_income_amt,0 as cn_expand,0 as cn_distribution_expand
        from (
            -- 支付成功订单
            select a.dt, b.tv_id, a.base_amount_rmb
            from dwd.dwd_trade_video_cn_payorder_view a
            inner join dwd.dwd_trade_cn_a_recharge_view b
               on a.dt = b.dt and a.coo_order_id = b.out_trade_no
            where a.dt >= date_sub('${dt}',interval 3 day ) and a.dt < date_sub('${dt}',interval 2 day ) and
                  a.coo_order_status in(1,2) and test_flag=0
                  -- ---------------------------过滤订单数据------------------------
                  and a.coo_order_id not in(select out_trade_no from order_id)
            -- 退款订单
            union all
            select date(b.refund_time) as dt, b.tv_id, -(a.amount/100) as base_amount_rmb
            from dwd.dwd_trade_video_cn_payorder_view a
            inner join dwd.dwd_trade_cn_a_recharge_view b
               on a.dt = b.dt and a.coo_order_id = b.out_trade_no
            where b.refund_time>= date_sub('${dt}',interval 3 day ) and b.refund_time < date_sub('${dt}',interval 2 day ) and
                  a.coo_order_status in(2) and test_flag=0
                  -- ---------------------------过滤订单数据------------------------
                  and a.coo_order_id not in(select out_trade_no from order_id)
        )t1
        where tv_id is not null and tv_id !=''
        group by 1,2
        union all
        select dt,tv_id,0 as cn_income_amt,sum(cn_expand) as cn_expand,sum(cn_distribution_expand) as cn_distribution_expand
        from(
            -- --------------ads支出---------------------
            select dt, tv_id, cn_expand,0 as cn_distribution_expand
            from(
                select date(a.create_time) as dt,b.tv_id,sum(a.cost_amount) as cn_expand
                from dwd.dwd_FbAdRoiInstallReferrerVideo_view a
                left join dwd.dwd_advertisement_adext_view b
                    on a.ad_id = b.ad_id and a.product_id = b.product_id
                where a.create_time>=date_sub('${dt}',interval 3 day ) and a.create_time<date_sub('${dt}',interval 2 day) and a.product_id=6883 and tv_id is not null
                group by 1,2
            )t1
            where cn_expand>0
            -- --------------分销支出--------------------
            union all
            select a.dt, b.tv_id,0 as cn_expand,round(a.base_amount_rmb*round(c.commission_rate,2),2) as cn_distribution_expand
            from dwd.dwd_trade_video_cn_payorder_view a
            inner join dwd.dwd_trade_cn_a_recharge_view b
               on a.dt = b.dt and a.coo_order_id = b.out_trade_no
            inner join ( -- 筛选出属于分销的数据---
                  select  ref_id,commission_rate
                  from  dim.dim_ads_role_users_view
                  where role_json like '%middleman%' and operation_type= 2
                ) c
                on b.middleman_id =c.ref_id  -- --------通过机构id来关联--------------------
            where a.dt >= date_sub('${dt}',interval 3 day ) and a.dt < date_sub('${dt}',interval 2 day ) and
                  a.coo_order_status in(1,2) and test_flag=0
            -- ---------------------------过滤订单数据------------------------
                  and a.coo_order_id not in(select out_trade_no from order_id)
        )ut1
        group by 1,2
    )t2
    group by 1,2
)
select dt, tv_id,
       max(rights_holder_id) as rights_holder_id,
       max(cn_income_amt) as cn_income_amt,
       max(cn_expand) as cn_expand,
       max(cn_distribution_expand) as cn_distribution_expand,
       now() as etl_time
from(
    select inex.dt,inex.tv_id,rights_holder_id,inex.cn_income_amt,inex.cn_expand,inex.cn_distribution_expand
    from inex
    left join(
        select story_id,cp_userinfo_uuid as rights_holder_id
        from dim.dim_sr_cp_story_view
        where product_type=1 and story_type=1 -- -------国剧------
    )b on inex.tv_id=b.story_id
)t1
group by 1,2;

-- SQL语句
-- 去重;
