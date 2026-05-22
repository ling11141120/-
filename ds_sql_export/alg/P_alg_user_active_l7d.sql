----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_user_active_l7d
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : tbl_alg_user_active_l7d
-- task_version     : 6
-- update_time      : 2023-12-05 14:51:59
-- sql_path         : \starrocks\tbl_alg_user_active_l7d\tbl_alg_user_active_l7d
----------------------------------------------------------------
-- 前置SQL语句
delete from alg.alg_user_active_l7d where dt = '${bf_1_dt}';

-- SQL语句
insert into alg.alg_user_active_l7d

with user_read_books_chpts as (
    select
    user_id,
    product_id,
    count(distinct if(datediff(date_sub('${dt}',interval 1 day ), dt)=0, book_id, null)) read_books_1d,
    count(distinct if(datediff(date_sub('${dt}',interval 1 day ), dt)<3, book_id, null)) read_books_3d,
    count(distinct book_id) read_books_7d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0, read_chpts, 0)) read_chpts_1d,
    sum(if(datediff( date_sub('${dt}',interval 1 day ), dt)<3, read_chpts, 0)) read_chpts_3d,
    sum(ifnull(read_chpts,0))  read_chpts_7d
    from dws.dws_read_user_read_book_info_ed
    where  dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1, 2
    ) ,

    user_last_read_info as (
    select user_id ,product_id ,last_read_chpts,last_max_serial_number from
    (
    select
    user_id,
    product_id,
    dt,
    sum(read_chpts) last_read_chpts,
    max(max_serial_number) last_max_serial_number,
    row_number() over (partition by product_id,user_id order by dt desc) indexs
    from dws.dws_read_user_read_book_info_ed
    where dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1,2,3
    )  a where a.indexs=1
    ) ,

    user_consume_info as (
    select
    user_id,
    product_id,
    count(distinct if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and types=5 , book_id, null)) csum_books_1d,
    count(distinct if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and types=5 , book_id, null)) csum_books_3d,
    count(distinct if(datediff(date_sub('${dt}',interval 1 day ), dt)<7 and types=5 , book_id, null)) csum_books_7d,
    count(distinct case when types=5 then book_id end)  csum_books_60d,

    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and types=5 , con_chapter_nums, 0)) con_chapter_num_1d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and types=5 , con_chapter_nums, 0)) con_chapter_num_3d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<7 and types=5 , con_chapter_nums, 0)) con_chapter_num_7d,
    sum(ifnull(case when types=5 then con_chapter_nums end,0)) con_chapter_num_60d,

    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and types=1 , amount, 0)) coin_consumption_1d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and types=1, amount, 0)) coin_consumption_3d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<7 and types=1, amount, 0)) coin_consumption_7d,
    sum(ifnull(case when types=1 then amount end,0)) coin_consumption_60d,

    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and types=2, amount, 0)) certificate_consumption_1d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and types=2, amount, 0)) certificate_consumption_3d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<7 and types=2, amount, 0)) certificate_consumption_7d,
    sum(ifnull(case when types=2 then amount end,0)) certificate_consumption_60d
    from dws.dws_consume_user_consume_ed
    where  dt>=date_sub('${dt}',interval 60 day ) and dt<'${dt}'
    group  by 1,2
    ),

    user_pay_info as (

    select
    user_id,
    product_id,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<7, pay_num, 0)) pay_num_7d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<7, pay_total, 0)) pay_total_7d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<180, pay_num, 0)) pay_num_180d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<180, pay_total, 0)) pay_total_180d,
    sum(ifnull(pay_num,0)) pay_num,
    sum(ifnull(pay_total,0)) pay_total
    from
    (
    select dt, userid as user_id,
    productid as product_id ,
    sum(chargecount) as pay_num,
    sum(chargeitemcount) as pay_total
    from dws.dws_trade_user_shopitem_charge_ed
    where dt>='2020-06-01' and dt<'${dt}'
    group by 1,2 ,3
    ) a group by 1,2

    ),

    user_last_pay_info as
    (
    select user_id,product_id,diff_days from (
    select
    user_id,
    product_id,
    dt,
    datediff(date_sub('${dt}',interval 1 day ), dt) as  diff_days,
    row_number() over (partition by product_id,user_id order by dt desc) indexs
    from
    (
    select dt, userid as user_id,
    productid as product_id ,
    sum(chargecount) as pay_num,
    sum(chargeitemcount) as pay_total
    from dws.dws_trade_user_shopitem_charge_ed
    where dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1,2 ,3
    ) a
    group by 1,2 ,3
    ) b  where  indexs=1
    )    ,

    user_gift_info as (

    select
    user_id,
    product_id,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and op_type=1, amount , 0)) send_gift_num_1d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and op_type=1, amount, 0)) send_gift_num_3d,
    sum(ifnull(if(op_type=1,amount,0),0)) send_gift_num_7d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)=0 and op_type=2, amount  , 0)) expire_gift_num_1d,
    sum(if(datediff(date_sub('${dt}',interval 1 day ), dt)<3 and op_type=2, amount  , 0)) expire_gift_num_3d,
    sum(ifnull(if(op_type=2,amount,0),0)) expire_gift_num_7d
    from dws.dws_grant_user_giftlog_ed
    where dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1,2
    ),

    user_last_gift_info as
    (
    select user_id,product_id,diff_days from (
    select
    user_id,
    product_id,
    dt,
    datediff(date_sub('${dt}',interval 1 day ), dt) as  diff_days,
    row_number() over (partition by product_id,user_id order by dt desc) indexs
    from dws.dws_grant_user_giftlog_ed
    where dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1,2 ,3
    ) a where a.indexs=1
    ) ,

    user_login_info as
    (
    select
    userid as  user_id,
    productid  as product_id,
    count(distinct dt) visit_days
    from dws.dws_user_login_ed
    where  dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1, 2

    ),

    user_last_login_info as
    (
    select user_id,product_id,diff_days from (
    select
    userid as  user_id,
    productid  as product_id,
    dt,
    datediff(date_sub('${dt}',interval 1 day ), dt) as  diff_days,
    row_number() over (partition by productid,userid order by dt desc) indexs
    from dws.dws_user_login_ed
    where dt>=date_sub('${dt}',interval 7 day ) and dt<'${dt}'
    group by 1,2 ,3
    ) a where a.indexs=1
    )

select '${bf_1_dt}' as dt,u.product_id,
       u.user_id,
       u.mt,
       u.corever,
       acc.register_days,

       ifnull(user_read_books_chpts.read_books_1d,0) as read_books_1d,
       ifnull(user_read_books_chpts.read_books_3d,0) as read_books_3d,
       ifnull(user_read_books_chpts.read_books_7d,0) as read_books_7d,
       ifnull(user_read_books_chpts.read_chpts_1d,0) as read_chpts_1d,
       ifnull(user_read_books_chpts.read_chpts_3d,0) as read_chpts_3d,
       ifnull(user_read_books_chpts.read_chpts_7d,0) as read_chpts_7d,

       ifnull(user_last_read_info.last_read_chpts,0) as last_read_chpts,
       ifnull(user_last_read_info.last_max_serial_number,0) as last_max_serial_number,

       ifnull(user_consume_info.csum_books_1d,0) as csum_books_1d,
       ifnull(user_consume_info.csum_books_3d,0) as csum_books_3d,
       ifnull(user_consume_info.csum_books_7d,0) as csum_books_7d,
       ifnull(user_consume_info.csum_books_60d,0) as csum_books_60d,
       ifnull(user_consume_info.con_chapter_num_1d,0) as con_chapter_num_1d,
       ifnull(user_consume_info.con_chapter_num_3d,0) as con_chapter_num_3d,
       ifnull(user_consume_info.con_chapter_num_7d,0) as con_chapter_num_7d,
       ifnull(user_consume_info.con_chapter_num_60d,0) as con_chapter_num_60d,
       ifnull(user_consume_info.coin_consumption_1d,0) as coin_consumption_1d,
       ifnull(user_consume_info.coin_consumption_3d,0) as coin_consumption_3d,
       ifnull(user_consume_info.coin_consumption_7d,0) as coin_consumption_7d,
       ifnull(user_consume_info.coin_consumption_60d,0) as coin_consumption_60d,
       ifnull(user_consume_info.certificate_consumption_1d,0) as certificate_consumption_1d,
       ifnull(user_consume_info.certificate_consumption_3d,0) as certificate_consumption_3d,
       ifnull(user_consume_info.certificate_consumption_7d,0) as certificate_consumption_7d,
       ifnull(user_consume_info.certificate_consumption_60d,0) as certificate_consumption_60d,

       ifnull(user_pay_info.pay_num_7d,0) as pay_num_7d,
       ifnull(user_pay_info.pay_total_7d,0) as pay_total_7d,
       ifnull(user_pay_info.pay_num_180d,0) as pay_num_180d,
       ifnull(user_pay_info.pay_total_180d,0) as pay_total_180d,
       ifnull(user_pay_info.pay_num,0) as pay_num,
       ifnull(user_pay_info.pay_total,0) as pay_total,

       ifnull(user_last_pay_info.diff_days, 10) as last_pay_days,

       ifnull(user_gift_info.send_gift_num_1d,0) as send_gift_num_1d,
       ifnull(user_gift_info.send_gift_num_3d,0) as send_gift_num_3d,
       ifnull(user_gift_info.send_gift_num_7d,0) as send_gift_num_7d,
       ifnull(user_gift_info.expire_gift_num_1d,0) as expire_gift_num_1d,
       ifnull(user_gift_info.expire_gift_num_3d,0) as expire_gift_num_3d,
       ifnull(user_gift_info.expire_gift_num_7d,0) as expire_gift_num_7d,

       ifnull(user_last_gift_info.diff_days, 10) as last_get_gift_days,

       ifnull(user_login_info.visit_days, 0)  as visit_days,
       ifnull(user_last_login_info.diff_days, 10) as  last_visit_days

from (
         select productid as product_id,userid as user_id,mt,corever
         from dws.dws_user_login_ed
         where dt>=date_sub('${dt}',interval 30 day ) and dt<'${dt}'
           and userid>0
         group by 1,2,3,4
     ) u
         left join
     ( select product_id,id as user_id ,DATEDIFF(date_sub('${dt}',interval 1 day ),date(create_time) ) as register_days from dim.dim_user_account_info_view ) acc
     on u.product_id=acc.product_id and u.user_id =acc.user_id
         left join   user_read_books_chpts
                     on u.product_id=user_read_books_chpts.product_id and u.user_id =user_read_books_chpts.user_id
         left join  user_last_read_info
                    on u.product_id=user_last_read_info.product_id and u.user_id =user_last_read_info.user_id
         left join  user_consume_info
                    on u.product_id=user_consume_info.product_id and u.user_id =user_consume_info.user_id
         left join  user_pay_info
                    on u.product_id=user_pay_info.product_id and u.user_id =user_pay_info.user_id
         left join  user_last_pay_info
                    on u.product_id=user_last_pay_info.product_id and u.user_id =user_last_pay_info.user_id
         left join  user_gift_info
                    on u.product_id=user_gift_info.product_id and u.user_id =user_gift_info.user_id
         left join  user_last_gift_info
                    on u.product_id=user_last_gift_info.product_id and u.user_id =user_last_gift_info.user_id
         left join  user_login_info
                    on u.product_id=user_login_info.product_id and u.user_id =user_login_info.user_id
         left join  user_last_login_info
                    on u.product_id=user_last_login_info.product_id and u.user_id =user_last_login_info.user_id;
