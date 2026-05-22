----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_video_income_expand
-- workflow_version : 23
-- create_user      : linq
-- task_name        : ads_sv_video_income_expand_cnmid
-- task_version     : 9
-- update_time      : 2024-06-20 10:14:55
-- sql_path         : \starrocks\tbl_ads_sv_video_income_expand\ads_sv_video_income_expand_cnmid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_video_income_expand_cnmid where dt>=date_sub('${dt}',interval 3 day) and dt<date_sub('${dt}',interval 2 day);

-- SQL语句
insert into ads.ads_sv_video_income_expand_cnmid
with inex as(
    select dt,tv_id,round(max(cn_income_amt),2) as cn_income_amt,round(max(cn_expand),2) as cn_expand
    from(
        select dt, tv_id, sum(base_amount_rmb) as cn_income_amt,0 as cn_expand
        from (
            -- 支付成功订单
            select a.dt, b.tv_id, a.base_amount_rmb
            from dwd.dwd_trade_video_cn_payorder_view a
            inner join dwd.dwd_trade_cn_a_recharge_view b
               on a.dt = b.dt and a.coo_order_id = b.out_trade_no
            where a.dt >= date_sub('${dt}',interval 3 day ) and a.dt < date_sub('${dt}',interval 2 day ) and
                  a.coo_order_status in(1,2) and test_flag=0
            -- 退款订单
            union all
            select date(b.refund_time) as dt, b.tv_id, -a.base_amount_rmb as base_amount_rmb
            from dwd.dwd_trade_video_cn_payorder_view a
            inner join dwd.dwd_trade_cn_a_recharge_view b
               on a.dt = b.dt and a.coo_order_id = b.out_trade_no
            where b.refund_time>= date_sub('${dt}',interval 3 day ) and b.refund_time < date_sub('${dt}',interval 2 day ) and
                  a.coo_order_status in(2) and test_flag=0
        )t1
        where tv_id is not null and tv_id !=''
        group by 1,2
        union all
        select dt, tv_id, 0 as cn_income_amt,cn_expand
        from(
            select date(a.create_time) as dt,b.tv_id,sum(a.cost_amount) as cn_expand
            from dwd.dwd_FbAdRoiInstallReferrerVideo_view a
            left join dwd.dwd_advertisement_adext_view b
                on a.ad_id = b.ad_id and a.product_id = b.product_id
            where a.create_time>=date_sub('${dt}',interval 3 day ) and a.create_time<date_sub('${dt}',interval 2 day) and a.product_id=6883 and tv_id is not null
            group by 1,2
        )t1
        where cn_expand>0
    )t2
    group by 1,2
)
select dt, tv_id,
       max(video_id) as video_id,
       max(baseurl) as baseurl,
       max(rights_holder_id) as rights_holder_id,
       max(cn_income_amt) as cn_income_amt,
       max(cn_expand) as cn_expand,
       null as cn_distribute_expand,
       now() as etl_time
from(
    select inex.dt,inex.tv_id,c.id as video_id,tv.baseurl,rights_holder_id,inex.cn_income_amt,inex.cn_expand
    from inex
    left join dim.dim_cn_a_tv_view tv on inex.tv_id=tv.tv_id
    left join dim.dim_cn_video_info_view c on tv.baseurl=c.folder
)t1
group by 1,2;

-- SQL语句
-- 去重;
