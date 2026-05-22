----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_series_income_dn
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_sr_series_income_dn
-- task_version     : 3
-- update_time      : 2024-12-17 15:55:01
-- sql_path         : \starrocks\tbl_ads_sr_series_income_dn\ads_sr_series_income_dn
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_series_income_dn
select
    current_language2,
    mt,
    source,
    book_id,
    ifnull(code, '') as code,
    days,
    dn,
    reg_num,
    amount,
    payers_num,
    payers_num2,
    DENSE_RANK() over(partition by current_language2,book_id,mt order by days) days_rank,
    now() as etl_time
from (
    select
        current_language2,mt,source,book_id,code,days,dn,reg_num,amount,payers_num
        ,sum((dn=-1)*payers_num) over(partition by book_id,mt,days) as payers_num2
    from (
        select
            d.current_language2,d.mt,source
            ,IF(source in ('organic', 'other_ad'), 0, book_id) as book_id
            ,IF(source in ('organic', 'other_ad'), null, code) as code
            ,days_diff(date(hours_add(current_timestamp(),-13)),date(d.install_date)) as days -- 用于权重  0.9^days
            ,case when date(create_time) = date(d.install_date) then -1
                when hours_diff(create_time,install_date) <24 then 0
            else days_diff(date(create_time),date(d.install_date)) end as dn
            ,count(distinct concat(date(d.install_date),d.user_id,d.product_id)) as reg_num
            ,sum(p.base_amount) as amount
            ,count(distinct concat(d.user_id,d.install_date,d.product_id)) as payers_num -- 充值用户数
        from (
            select
                dt, product_id, current_language2, mt, source,book_id, code, install_date, user_id, next_time
            from ads.ads_sr_user_attribution_info
            where dt >= date_add('${bf_3_dt}', interval -121 day)
        ) d
        -- 充值记录
        join (
            select
                concat(substr(product_id,1,3),'00',core) appid
                ,product_id,user_id,base_amount,hours_add(create_time,-13)  create_time
            from ads.ads_trade_sharpenginepaycenter_payorder_view
            where Test_Flag = 0 and base_amount >0  and order_status=1 and  dt >='2024-02-01' and Product_Id not in(6833,6883)
        ) p on d.user_id = p.user_id and d.product_id = p.product_id and p.create_time between d.install_date and ifnull(d.next_time,'2050-01-01') and days_diff(date(create_time),date(d.install_date)) < 122
        where days_diff(CURDATE(),date(d.install_date)) > 1
        group by 1,2,3,4,5,6,7
    ) x
) xx
where current_language2 is not null and payers_num2 > 0 and dn < 121;
