----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_currency_qa_monitoring_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : consume_jifen
-- task_version     : 7
-- update_time      : 2024-10-16 11:49:04
-- sql_path         : \starrocks\tbl_ads_report_currency_qa_monitoring_info\consume_jifen
----------------------------------------------------------------
-- SQL语句
-- ------------------ consume  jifenmonthlog  ---------------------------
delete from ads.ads_report_currency_qa_monitoring_info where dt>= '${bf_1_dt}' and op_tp=2 and coin_tp in (3) ;

-- SQL语句
insert into    ads.ads_report_currency_qa_monitoring_info
select a.dt, a.product_id,
       case when acc.corever is null then -99 else acc.corever end as corever,
       case when acc.mt is null then -99 else acc.mt end as mt ,
       case when acc.appver is null then -99 else acc.appver end as appver,
       a.mod_type as source_tp, 3 as coin_tp, op_tp,
       c.enum_name  as source_name,
       count(distinct a.user_id) as cnt,sum(num) as amount,now() as etl_time
from (
         select a.dt,a.product_id, a.user_id, a.num,a.mod_type,op as op_tp
         from dwd.dwd_grant_readerlog_jifenmonthlog_view a
         where a.dt >= '${bf_1_dt}' and a.dt <= '${dt}'and a.product_id not in (7777,8888)
           and a.op=2
     )a left join (
    select product_id,id,CoreVer,mt,AppVer
    from dim.dim_user_account_info_view
) acc
                  on a.product_id=acc.product_id and a.user_id=acc.Id
        left join
     dim.dim_dic c
     on a.mod_type =c.enum_id and c.table_name ='dwd_grant_readerlog_jifenmonthlog_view'
group by  1,2,3,4,5 ,6,7,8 ,9 ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_currency_qa_monitoring_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : consume_money_giftmoney
-- task_version     : 6
-- update_time      : 2024-10-16 11:49:04
-- sql_path         : \starrocks\tbl_ads_report_currency_qa_monitoring_info\consume_money_giftmoney
----------------------------------------------------------------
-- SQL语句
-- -- consume money,giftmoney-----------------------------
delete from ads.ads_report_currency_qa_monitoring_info where dt>= '${bf_1_dt}' and op_tp=2 and coin_tp in (1,2) ;

-- SQL语句
insert into    ads.ads_report_currency_qa_monitoring_info
    select a.dt, a.product_id,
    case when a.corever is null then -99 else a.corever end as corever,
    case when a.mt is null then -99 else a.mt end as mt ,
case when a.appver is null then -99 else a.appver  end as appver,
  a.source_tp,a.coin_tp,a.op_tp,
    c.enum_name as source_name,
    a.cnt,a.amount,now() as etl_time
    from (
    select a.dt, a.product_id,a.corever,a.mt,a.appver, a.pay_type as source_tp, case when types=1 then 1 when types=2 then 2 end as coin_tp,2 as op_tp, count(distinct a.user_id) as cnt,round(sum(con_chp_amount)) as amount
   from dwm.dwm_consume_user_consume_mild_ed  a
    where a.dt >= '${bf_1_dt}' and a.dt <=  '${dt}'
    and a.product_id not in (7777,8888)
    and types in (1,2)
    and pay_type !=1103
   group by  1,2,3,4,5 ,6,7,8
 ) a
 left join
 ( select enum_id ,enum_name  from dim.dim_dic  where table_name ='dwd_consume_user_consume_di' and dic_column ='pay_type' ) c
 on a.source_tp=c.enum_id
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_currency_qa_monitoring_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : get _jifen
-- task_version     : 4
-- update_time      : 2024-10-16 11:49:04
-- sql_path         : \starrocks\tbl_ads_report_currency_qa_monitoring_info\get _jifen
----------------------------------------------------------------
-- SQL语句
-- -----------------get jifen  jifenitemmonthlog  ---------------------------
delete from ads.ads_report_currency_qa_monitoring_info where dt>= '${bf_1_dt}' and op_tp=1 and coin_tp in (3) ;

-- SQL语句
insert into    ads.ads_report_currency_qa_monitoring_info
  select  a.dt,a.product_id ,a.corever,a.mt,a.appver,a.source_tp,
  a.coin_tp,a.op_tp,
  case when a.source_tp ='invite' then '好友邀请活动'
       when a.source_tp ='MealTask' then '吃饭任务'
       when a.source_tp ='CoinExchange' then '商城阅币兑换积分' else
  c.content end as source_name,
  a.cnt,a.amount,
  now() as etl_time
  from (
select a.dt,a.product_id ,
case when a.corever is null then -99 else a.corever end as corever,
case when a.mt is null then -99 else a.mt end as mt ,
case when a.app_ver is null then -99 else a.app_ver  end as appver,
 LTRIM(case when  a.source_key is null then a.source else a.source_key end)as source_tp,
3 as coin_tp,op as op_tp,
count(distinct a.user_id) as cnt,
sum(send_num) as amount
from dwd.dwd_grant_jifenitemmonthlog a
     where a.dt >= '${bf_1_dt}' and a.dt <=  '${dt}'and a.product_id not in (7777,8888) and a.op=1
   group by  1,2,3,4,5 ,6,7 ,8
     ) a
left join
	dim.dim_apptranslationdb_translation_view c
	on a.source_tp=c.server_key
	;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_currency_qa_monitoring_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : get_giftmoney
-- task_version     : 5
-- update_time      : 2024-10-16 11:49:04
-- sql_path         : \starrocks\tbl_ads_report_currency_qa_monitoring_info\get_giftmoney
----------------------------------------------------------------
-- SQL语句
-- get giftmoney --------------------

delete from ads.ads_report_currency_qa_monitoring_info where dt>= '${bf_1_dt}' and op_tp=1 and coin_tp=2 ;

-- SQL语句
insert into   ads.ads_report_currency_qa_monitoring_info
select a.dt, a.product_id,
       case when acc.corever is null then -99 else acc.corever  end as corever ,
       case when acc.mt is null then -99 else acc.mt end as mt,
       case when acc.appver is null then -99 else acc.appver end as appver,
       a.source_key as source_tp, 2 as coin_tp,1 as op_tp,
       case when a.source_key in ('首次分享书籍' ,'首次分享書籍', 'Book sharing' ,'Libro compartido','Livre partagé pour la première fois','Partilha de livros','初めて書籍をしエアする','初めて書籍をしエアする','Berbagi buku','แชร์หนังสือครั้งแรก','Book sharing','Book sharing','Поделиться книгой') then '首次分享书籍'
            when c.content is null then a.source_key else c.content end as source_name ,
       count(distinct a.user_id) as cnt,
       sum(gift_num) as amount,now() as etl_time
from (
         select a.dt,a.product_id, a.user_id, a.gift_num,a.source_key
         from dwd.dwd_grant_user_giftlog a
         where a.dt >= '${bf_1_dt}' and a.dt <=  '${dt}'and a.product_id not in (7777,8888)
           and op_type =1
           and gift_type =0
     ) a left join (
    select product_id,id,CoreVer,mt,AppVer
    from dim.dim_user_account_info_view
) acc
                   on a.product_id=acc.product_id and a.user_id=acc.Id
         left join
     dim.dim_apptranslationdb_translation_view c
     on a.source_key=c.server_key
group by  1,2,3,4,5 ,6,7,8,9;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_currency_qa_monitoring_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : get_money
-- task_version     : 13
-- update_time      : 2024-10-16 11:49:04
-- sql_path         : \starrocks\tbl_ads_report_currency_qa_monitoring_info\get_money
----------------------------------------------------------------
-- SQL语句
-- get money ------------
delete from ads.ads_report_currency_qa_monitoring_info where dt>= '${bf_3_dt}' and op_tp=1 and coin_tp=1 ;

-- SQL语句
insert into    ads.ads_report_currency_qa_monitoring_info
select a.dt, a.product_id,
       case when  acc.corever  is null then -99 else acc.corever end as corever,
       case when  acc.mt  is null then -99 else acc.mt end as mt,
       case when acc.appver is null then -99 else acc.appver end as appver ,
       case when a.shopitem is null then 'other' else a.shopitem end as source_tp,
       1 as coin_tp,1 as op_tp,
       case when  a.shopitem =0 then  '普通充值'
            when  a.shopitem =800 then  '签到卡'
            when  a.shopitem =810 then  '会员卡'
            when  a.shopitem =830 then  '福利包'
            when  a.shopitem =840 then  '新福利包' else 'other' end as source_name,
       count(distinct a.user_id) as cnt,sum(real_get) as amount,now() as etl_time
from (
         select a.dt,a.product_id, a.user_id, a.real_get, a.reforder_id,b.shopitem
         from dwd.dwd_grant_readernovel_getmoneylog_view a
                  left join
              dwd.dwd_trade_user_payorder b
              on a.product_id =b.ProductId   and a.user_id =b.UserId and a.reforder_id= b.OrderId  and b.dt >= '${bf_5_dt}'
         where a.dt >= '${bf_3_dt}' and a.get_tm < date_sub(now(),interval 2 hour) and a.product_id not in (7777,8888)
         and a.charge_type  not in (5,100)
     )a left join (
    select product_id,id,CoreVer,mt,AppVer
    from dim.dim_user_account_info_view
) acc
                  on a.product_id=acc.product_id and a.user_id=acc.Id
group by  1,2,3,4,5 ,6,7,8,9;
