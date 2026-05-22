----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_ex_account_info
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : ads_bi_ex_account_info
-- task_version     : 3
-- update_time      : 2024-01-24 09:27:20
-- sql_path         : \starrocks\tbl_ads_bi_ex_account_info\ads_bi_ex_account_info
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_ex_account_info where dt>='${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_ex_account_info
   select date(a.create_time) as dt,product_id,sex, mt,country,reg_country,appver as app_ver,ver,corever,current_language,
        current_language2,count(distinct a.id) as unt,now() as etl_tm
    from  dim.dim_user_account_info_view a
    inner join
  (
  -- -------有第三方账号的用户-----------------
  select  user_id from dim.dim_user_ex_account_info_view
  union all
  -- 有设置过密码的用户-------------------------
  select user_id from dim.dim_user_hk_account_info_view where has_user_setpwd=1
 ) b
 on a.id =b.user_id
 where a.create_time >='${bf_1_dt}'
group by 1,2,3,4,5,6,7,8,9,10,11;
