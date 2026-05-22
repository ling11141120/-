----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_negative_user_info
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : tbl_ads_report_negative_user_info
-- task_version     : 3
-- update_time      : 2023-11-06 18:56:43
-- sql_path         : \starrocks\tbl_ads_report_negative_user_info\tbl_ads_report_negative_user_info
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_report_negative_user_info   where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_report_negative_user_info
select a.dt,
            a.Productid as product_id,
            a.mt,
            case when a.corever =0 or a.corever is null then 1 else a.corever end as corever ,
            count(distinct a.userid) dau ,
            count(distinct case when  b.is_has_charge=1 then a.userid end ) pay_dau,
            count(distinct case when  b.is_has_charge=0 or b.is_has_charge is null  then a.userid end ) free_dau,
            count(distinct case when b.ads_type!='' and b.ads_quality=0 and b.is_has_charge=0 then a.userid end) iaa_dau,
            count(distinct case when b.is_negative_user=1  and  b.is_has_charge=1 then a.userid end) iap_dau,
            count(distinct case when b.is_negative_user=1   then a.userid end) negative_dau ,
            now() as etl_time
 from dws.dws_user_login_ed a
 left join
 dim.dim_user_all_info b
 on a.Productid =b.product_id  and a.userid =b.user_id
 where a.dt='${bf_1_dt}'
 and a.Productid  not in (7777,8888)
group by 1 ,2 ,3,4;
