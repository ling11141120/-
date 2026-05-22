----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_translate_book_cost_ed
-- workflow_version : 3
-- create_user      : zhengtt
-- task_name        : dws_content_translate_book_cost_ed
-- task_version     : 3
-- update_time      : 2024-01-24 16:49:56
-- sql_path         : \starrocks\tbl_dws_content_translate_book_cost_ed\dws_content_translate_book_cost_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_content_translate_book_cost_ed where dt >= date_sub('${dt}',interval 180 day);

-- SQL语句
insert into dws.dws_content_translate_book_cost_ed
select  a.dt,a.book_id,b.book_name,a.book_id % 1000 as site_id,b.author_name,
        (a.proofread_price_today+a.toufang_cost) as  book_cost,
        a.toufang_cost,a.toufang_cost_rmb,a.proofread_price_today as translate_cost,
        a.proofread_price_rmb_today as translate_cost_rmb,a.proofread_length_today,
        c.price,
        now() as etl_time
from
    (   select  coalesce(a.dt,b.dt) as dt,coalesce(a.book_id,b.book_id) as book_id,
                if(a.proofread_price_today is null,0,a.proofread_price_today) as proofread_price_today,
                if(a.proofread_price_rmb_today is null,0,a.proofread_price_rmb_today) as proofread_price_rmb_today,
                if(a.proofread_length_today is null,0,a.proofread_length_today) as proofread_length_today,
                if(b.toufang_cost is null,0,b.toufang_cost) as toufang_cost,
                if(b.toufang_cost_rmb is null,0,b.toufang_cost_rmb) as toufang_cost_rmb
        from
            (   select  a.dt as dt,a.to_book_id as book_id,
                        a.proofread_length_today,
                        a.proofread_price_today as proofread_price_today,
                        a.proofread_price_rmb_today as proofread_price_rmb_today
                from dwd.dwd_content_book_capacity_daily a
                left join dim.dim_book_shuangwen_en_objectbook_info_view b
                   on a.to_book_id = (b.swbook_id*1000+b.to_language)
                where a.dt >= '2024-01-01' and a.dt >= date_sub('${dt}',interval 180 day) and a.dt < '${dt}'
                  and b.object_book_type = 0
                  and a.to_language in (select distinct site_id from dim.dim_translate_book_price_info_view)
            ) a
                full join
            (   select  dt,book_id,sum(spend) as toufang_cost,sum(spend)*6.5 as toufang_cost_rmb
                from
                    (   select  date_start as dt,b.book_id as book_id,a.spend as spend
                        from dwd.dwd_advertisement_ltv_daily_insight_view a
                                 left join dwd.dwd_advertisement_adext_view b
                                           on a.ad_id = b.ad_id and a.product_id = b.product_id
                        where  a.date_start >= '2024-01-01' and a.date_start >= date_sub('${dt}',interval 180 day) and  a.date_start < '${dt}' and b.book_id is not null
                            and b.book_id % 1000 in (select distinct site_id from dim.dim_translate_book_price_info_view)
                            and a.product_id != 6833
                        union all
                        select  date_start as dt,b.book_id as book_id,a.spend  as spend
                        from dwd.dwd_advertisement_fbad_daily_insight_view a
                                 left join dwd.dwd_advertisement_adext_view b
                                           on a.ad_id = b.ad_id and a.product_id = b.product_id
                        where  a.date_start >= '2024-01-01' and a.date_start >= date_sub('${dt}',interval 180 day) and  a.date_start < '${dt}' and b.book_id is not null
                            and b.book_id % 1000 in (select distinct site_id from dim.dim_translate_book_price_info_view)
                            and a.product_id != 6833
                    ) a
                group by 1,2
            ) b
            on a.dt = b.dt and a.book_id = b.book_id
    ) a
        left join dim.dim_shuangwen_book_read_consume_info b
                  on a.book_id = b.book_id
        left join dim.dim_translate_book_price_info_view c
                  on a.book_id % 1000 = c.site_id;
