----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_cr_book_income_expand_di
-- workflow_version : 23
-- create_user      : linq
-- task_name        : tbl_ads_cr_book_income_expand_di
-- task_version     : 8
-- update_time      : 2024-10-16 11:54:13
-- sql_path         : \starrocks\tbl_ads_cr_book_income_expand_di\tbl_ads_cr_book_income_expand_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_cr_book_income_expand_di where dt>=date_sub('${dt}',interval 1 day ) and dt<'${dt}';

-- SQL语句
insert into ads.ads_cr_book_income_expand_di
with inex as(
    select dt,book_id,
           round(max(cn_income_amt),2) as cn_income_amt,
           round(max(cn_expand),2) as cn_expand,
           round(max(cn_distribution_expand),2) as cn_distribution_expand
    from(
        select dt, book_id, sum(base_amount_rmb) as cn_income_amt,0 as cn_expand,0 as cn_distribution_expand
        from (
            -- 支付成功订单
            select date(a.create_time) as dt, b.book_id, a.base_amount_rmb
            from dwd.dwd_cr_trade_payorder_view a
            inner join dwd.dwd_cr_trade_original_recharge_view b
               on a.coo_order_id = b.out_trade_no
            where a.create_time >= date_sub('${dt}',interval 1 day ) and a.create_time < '${dt}' and
                  a.coo_order_status in(1,2) and test_flag=0
                  -- ---------------------------过滤星图和小程序推广------------------------
                  and a.ad_plat_form not in('xt','xingtu')
            -- 退款订单
            union all
            select date(a.refund_time) as dt, b.book_id, -(a.amount/100) as base_amount_rmb
            from dwd.dwd_cr_trade_payorder_view a
            inner join dwd.dwd_cr_trade_original_recharge_view b
               on a.coo_order_id = b.out_trade_no
            where a.refund_time>= date_sub('${dt}',interval 1 day ) and a.refund_time < '${dt}' and
                  a.coo_order_status in(2) and test_flag=0
                  -- ---------------------------过滤星图和小程序推广------------------------
                  and a.ad_plat_form not in('xt','xingtu')
        )t1
        where book_id in(select _id from dim.dim_cr_book_da_view) -- 过滤脏数据--
        group by 1,2
        union all
        select dt,tv_id  as book_id,0 as cn_income_amt,sum(cn_expand) as cn_expand,sum(cn_distribution_expand) as cn_distribution_expand
        from(
            -- --------------ads支出---------------------
            select dt, tv_id, cn_expand,0 as cn_distribution_expand
            from(
                select date(a.create_time) as dt,b.tv_id,sum(a.cost_amount) as cn_expand
                from dwd.dwd_FbAdRoiInstallReferrerVideo_view a
                left join dwd.dwd_advertisement_adext_view b
                    on a.ad_id = b.ad_id and a.product_id = b.product_id
                where a.create_time>=date_sub('${dt}',interval 1 day ) and a.create_time<'${dt}' and a.product_id=6773 and tv_id is not null
                group by 1,2
            )t1
            where cn_expand>0
            union all
            -- --------------分销支出--------------------
            select dt, book_id, 0 as cn_expand, cn_distribution_expand
            from(
            select date(a.create_time) as dt,b.book_id,round(a.base_amount_rmb*d.share_rate,2) as cn_distribution_expand
            from dwd.dwd_cr_trade_payorder_view a
            inner join dwd.dwd_cr_trade_original_recharge_view b on a.coo_order_id = b.out_trade_no
            inner join(-- --- 分销临时表
                select agent_id,agency_id,operate_type,share_rate
                from(
                    select agent._id as agent_id,agent.agency_id,b.share_rate,c.operate_type
                    from ods.ods_tidb_cr_cdnovel_tidb_xcx_sync_uni_id_users agent
                    left join ods.ods_tidb_cr_cdnovel_tidb_xcx_sync_agency_settle_info b on agent.agency_id=b.agency_id
                    left join ods.ods_tidb_cr_cdnovel_tidb_xcx_sync_uni_id_users c on b.agency_id=c._id and c.type=2 -- type=2 机构表
                    where agent.type=3 -- --type=3,代理商表-
                )t1
                where operate_type=2 and
                    agency_id is not null and agency_id !=''
            ) d on b.agent_id=d.agent_id
            where a.create_time >= date_sub('${dt}',interval 1 day ) and a.create_time<'${dt}' and
                  a.coo_order_status in(1,2) and test_flag=0
                  -- ---------------------------过滤星图和小程序推广------------------------
                  and a.ad_plat_form not in('xt','xingtu')
            )t2
            where book_id in(select _id from dim.dim_cr_book_da_view) -- 过滤脏数据--
        )ut1
        group by 1,2
    )t2
    group by 1,2
)
select inex.dt,
       md5(concat_ws('_',dt,book_id,original_id)) as md5_key,
       inex.book_id,b.original_id,inex.cn_income_amt,inex.cn_expand,inex.cn_distribution_expand,now() as etl_time
from inex
left join dim.dim_cr_book_da_view b on inex.book_id=b._id;
