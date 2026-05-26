----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_book_read_consume_inte3
-- workflow_version : 22
-- create_user      : linq
-- task_name        : ads_book_read_consume_inte_instation
-- task_version     : 12
-- update_time      : 2024-10-16 11:34:22
-- sql_path         : \starrocks\tbl_ads_book_read_consume_inte3\ads_book_read_consume_inte_instation
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_book_read_consume_inte_instation where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}';

-- SQL语句
insert into ads.ads_book_read_consume_inte_instation
with fst_r as (
    select dt, if(site_id in(775,885),777,site_id) as site_id, book_id,user_id,is_source from dws.dws_read_90_first_all_read_mid2
    where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}'
),common as (
    select cs.dt,cs.site_id,cs.book_id,cs.user_id,cs.is_source,cs.cs_dt,cs.types,cs.cs_user_id,cs.amount,if(rc.userid is not null,1,0) as is_recharge14
    from(
        select fst_r.dt,fst_r.site_id,fst_r.book_id,fst_r.user_id,fst_r.is_source,consume.dt as cs_dt,consume.types,consume.user_id as cs_user_id,consume.amount
        from fst_r
            left join (
                select dt,site_id,book_id,types,user_id,amount
                from dws.dws_consume_user_consume_ed
                where dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<='${bf_1_dt}' and types in (1, 2)
            ) consume on fst_r.dt<=consume.dt and fst_r.site_id=consume.site_id and fst_r.book_id=consume.book_id and fst_r.user_id=consume.user_id
    ) cs
    left join(
        select distinct a.dt, userid
        from (select datestr as dt from dim.dim_date where datestr >= date_sub('${bf_1_dt}', interval 30 day) and datestr <= '${bf_1_dt}') a
        left join
           (select dt,userid from dws.dws_trade_user_shopitem_charge_ed where dt>=date_sub('${bf_1_dt}',interval 45 day) and dt<='${bf_1_dt}') b
                on a.dt>=b.dt and a.dt<=date_add(b.dt,interval 14 day )
        )rc on cs.cs_dt=rc.dt and cs.user_id=rc.userid
)
select a.dt,a.site_id,a.book_id,b.types,a.is_source,a.first_read_cnt,b.first_consume_cnt,b.total_consume_cnt,
       D0_consume_amount,D1_consume_amount,D2_consume_amount,D3_consume_amount,D4_consume_amount,D5_consume_amount,
       D6_consume_amount,D7_consume_amount,D8_consume_amount,D9_consume_amount,D10_consume_amount,D11_consume_amount,
       D12_consume_amount,D13_consume_amount,D14_consume_amount,D15_consume_amount,D16_consume_amount,D17_consume_amount,
       D18_consume_amount,D19_consume_amount,D20_consume_amount,D21_consume_amount,D22_consume_amount,D23_consume_amount,
       D24_consume_amount,D25_consume_amount,D26_consume_amount,D27_consume_amount,D28_consume_amount,D29_consume_amount,
       D30_consume_amount,now() as etl_time
from (
         select dt, site_id, book_id,is_source,count(1) as first_read_cnt from fst_r group by 1, 2, 3,4
     ) a
inner join (
    select dt,site_id,book_id,ifnull(types, -99) as types,is_source,
           count(distinct if(cs_dt = dt, cs_user_id, null))               as first_consume_cnt,
           count(distinct if(cs_dt <= date_add(dt, interval 30 day), cs_user_id, null))  as total_consume_cnt,
           sum(if(cs_dt = dt, amount, 0))                                 as D0_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 1 day), amount,0))       as D1_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 2 day), amount,0))       as D2_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 3 day), amount,0))       as D3_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 4 day), amount,0))       as D4_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 5 day), amount,0))       as D5_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 6 day), amount,0))       as D6_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 7 day), amount,0))       as D7_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 8 day), amount,0))       as D8_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 9 day), amount,0))       as D9_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 10 day), amount,0))       as D10_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 11 day), amount,0))       as D11_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 12 day), amount,0))       as D12_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 13 day), amount,0))       as D13_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 14 day), amount,0))       as D14_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 15 day), amount,0))       as D15_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 16 day), amount,0))       as D16_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 17 day), amount,0))       as D17_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 18 day), amount,0))       as D18_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 19 day), amount,0))       as D19_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 20 day), amount,0))       as D20_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 21 day), amount,0))       as D21_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 22 day), amount,0))       as D22_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 23 day), amount,0))       as D23_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 24 day), amount,0))       as D24_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 25 day), amount,0))       as D25_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 26 day), amount,0))       as D26_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 27 day), amount,0))       as D27_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 28 day), amount,0))       as D28_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 29 day), amount,0))       as D29_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 30 day), amount,0))       as D30_consume_amount
    from common
    group by 1,2,3,4,5
) b on a.dt=b.dt and a.site_id=b.site_id and a.book_id=b.book_id and a.is_source=b.is_source
union all
select a.dt,a.site_id,a.book_id,b.types,a.is_source,a.first_read_cnt,b.first_consume_cnt,b.total_consume_cnt,
       D0_consume_amount,D1_consume_amount,D2_consume_amount,D3_consume_amount,D4_consume_amount,D5_consume_amount,
       D6_consume_amount,D7_consume_amount,D8_consume_amount,D9_consume_amount,D10_consume_amount,D11_consume_amount,
       D12_consume_amount,D13_consume_amount,D14_consume_amount,D15_consume_amount,D16_consume_amount,D17_consume_amount,
       D18_consume_amount,D19_consume_amount,D20_consume_amount,D21_consume_amount,D22_consume_amount,D23_consume_amount,
       D24_consume_amount,D25_consume_amount,D26_consume_amount,D27_consume_amount,D28_consume_amount,D29_consume_amount,
       D30_consume_amount,now() as etl_time
from (
         select dt, site_id, book_id, is_source,count(1) as first_read_cnt from fst_r group by 1, 2, 3,4
     ) a
inner join (
    select dt,site_id,book_id,if(types is null, -99,5) as types,is_source,
           count(distinct if(cs_dt = dt, cs_user_id, null))               as first_consume_cnt,
           count(distinct if(cs_dt <= date_add(dt, interval 30 day), cs_user_id, null))  as total_consume_cnt,
           sum(if(cs_dt = dt, amount, 0))                                 as D0_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 1 day), amount,0))       as D1_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 2 day), amount,0))       as D2_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 3 day), amount,0))       as D3_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 4 day), amount,0))       as D4_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 5 day), amount,0))       as D5_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 6 day), amount,0))       as D6_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 7 day), amount,0))       as D7_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 8 day), amount,0))       as D8_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 9 day), amount,0))       as D9_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 10 day), amount,0))       as D10_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 11 day), amount,0))       as D11_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 12 day), amount,0))       as D12_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 13 day), amount,0))       as D13_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 14 day), amount,0))       as D14_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 15 day), amount,0))       as D15_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 16 day), amount,0))       as D16_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 17 day), amount,0))       as D17_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 18 day), amount,0))       as D18_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 19 day), amount,0))       as D19_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 20 day), amount,0))       as D20_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 21 day), amount,0))       as D21_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 22 day), amount,0))       as D22_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 23 day), amount,0))       as D23_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 24 day), amount,0))       as D24_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 25 day), amount,0))       as D25_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 26 day), amount,0))       as D26_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 27 day), amount,0))       as D27_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 28 day), amount,0))       as D28_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 29 day), amount,0))       as D29_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 30 day), amount,0))       as D30_consume_amount
    from common
    group by 1,2,3,4,5
) b on a.dt=b.dt and a.site_id=b.site_id and a.book_id=b.book_id and a.is_source=b.is_source
union all
select a.dt,a.site_id,a.book_id,b.types,a.is_source,a.first_read_cnt,b.first_consume_cnt,b.total_consume_cnt,
       D0_consume_amount,D1_consume_amount,D2_consume_amount,D3_consume_amount,D4_consume_amount,D5_consume_amount,
       D6_consume_amount,D7_consume_amount,D8_consume_amount,D9_consume_amount,D10_consume_amount,D11_consume_amount,
       D12_consume_amount,D13_consume_amount,D14_consume_amount,D15_consume_amount,D16_consume_amount,D17_consume_amount,
       D18_consume_amount,D19_consume_amount,D20_consume_amount,D21_consume_amount,D22_consume_amount,D23_consume_amount,
       D24_consume_amount,D25_consume_amount,D26_consume_amount,D27_consume_amount,D28_consume_amount,D29_consume_amount,
       D30_consume_amount,now() as etl_time
from (
         select dt, site_id, book_id,is_source,count(1) as first_read_cnt from fst_r group by 1, 2, 3,4
     ) a
inner join (
    select dt,site_id,book_id,if(types is null, -99,6) as types,is_source,
           count(distinct if(cs_dt = dt, cs_user_id, null))               as first_consume_cnt,
           count(distinct if(cs_dt <= date_add(dt, interval 30 day), cs_user_id, null))  as total_consume_cnt,
           sum(if(cs_dt = dt, amount, 0))                                 as D0_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 1 day), amount,0))       as D1_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 2 day), amount,0))       as D2_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 3 day), amount,0))       as D3_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 4 day), amount,0))       as D4_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 5 day), amount,0))       as D5_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 6 day), amount,0))       as D6_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 7 day), amount,0))       as D7_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 8 day), amount,0))       as D8_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 9 day), amount,0))       as D9_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 10 day), amount,0))       as D10_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 11 day), amount,0))       as D11_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 12 day), amount,0))       as D12_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 13 day), amount,0))       as D13_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 14 day), amount,0))       as D14_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 15 day), amount,0))       as D15_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 16 day), amount,0))       as D16_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 17 day), amount,0))       as D17_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 18 day), amount,0))       as D18_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 19 day), amount,0))       as D19_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 20 day), amount,0))       as D20_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 21 day), amount,0))       as D21_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 22 day), amount,0))       as D22_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 23 day), amount,0))       as D23_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 24 day), amount,0))       as D24_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 25 day), amount,0))       as D25_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 26 day), amount,0))       as D26_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 27 day), amount,0))       as D27_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 28 day), amount,0))       as D28_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 29 day), amount,0))       as D29_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 30 day), amount,0))       as D30_consume_amount
    from common where types in(2) and is_recharge14=1
    group by 1,2,3,4,5
) b on a.dt=b.dt and a.site_id=b.site_id and a.book_id=b.book_id and a.is_source=b.is_source
union all
select a.dt,a.site_id,a.book_id,b.types,a.is_source,a.first_read_cnt,b.first_consume_cnt,b.total_consume_cnt,
       D0_consume_amount,D1_consume_amount,D2_consume_amount,D3_consume_amount,D4_consume_amount,D5_consume_amount,
       D6_consume_amount,D7_consume_amount,D8_consume_amount,D9_consume_amount,D10_consume_amount,D11_consume_amount,
       D12_consume_amount,D13_consume_amount,D14_consume_amount,D15_consume_amount,D16_consume_amount,D17_consume_amount,
       D18_consume_amount,D19_consume_amount,D20_consume_amount,D21_consume_amount,D22_consume_amount,D23_consume_amount,
       D24_consume_amount,D25_consume_amount,D26_consume_amount,D27_consume_amount,D28_consume_amount,D29_consume_amount,
       D30_consume_amount,now() as etl_time
from (
         select dt, site_id, book_id, is_source,count(1) as first_read_cnt from fst_r group by 1, 2, 3,4
     ) a
inner join (
    select dt,site_id,book_id,if(types is null, -99,7) as types,is_source,
           count(distinct if(cs_dt = dt, cs_user_id, null))               as first_consume_cnt,
           count(distinct if(cs_dt <= date_add(dt, interval 30 day), cs_user_id, null))  as total_consume_cnt,
           sum(if(cs_dt = dt, amount, 0))                                 as D0_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 1 day), amount,0))       as D1_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 2 day), amount,0))       as D2_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 3 day), amount,0))       as D3_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 4 day), amount,0))       as D4_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 5 day), amount,0))       as D5_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 6 day), amount,0))       as D6_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 7 day), amount,0))       as D7_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 8 day), amount,0))       as D8_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 9 day), amount,0))       as D9_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 10 day), amount,0))       as D10_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 11 day), amount,0))       as D11_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 12 day), amount,0))       as D12_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 13 day), amount,0))       as D13_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 14 day), amount,0))       as D14_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 15 day), amount,0))       as D15_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 16 day), amount,0))       as D16_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 17 day), amount,0))       as D17_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 18 day), amount,0))       as D18_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 19 day), amount,0))       as D19_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 20 day), amount,0))       as D20_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 21 day), amount,0))       as D21_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 22 day), amount,0))       as D22_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 23 day), amount,0))       as D23_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 24 day), amount,0))       as D24_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 25 day), amount,0))       as D25_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 26 day), amount,0))       as D26_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 27 day), amount,0))       as D27_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 28 day), amount,0))       as D28_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 29 day), amount,0))       as D29_consume_amount,
           sum(if(cs_dt <= date_add(dt, interval 30 day), amount,0))       as D30_consume_amount
    from common where types =1 or (types in(2) and is_recharge14=1)
    group by 1,2,3,4,5
) b on a.dt=b.dt and a.site_id=b.site_id and a.book_id=b.book_id and a.is_source=b.is_source;
