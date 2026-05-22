----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_reco_firstpay
-- workflow_version : 21
-- create_user      : admin
-- task_name        : alg_firstpay_feature_tmp
-- task_version     : 8
-- update_time      : 2025-04-02 20:30:08
-- sql_path         : \starrocks\tbl_alg_reco_firstpay\alg_firstpay_feature_tmp
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_firstpay_feature_tmp;

-- SQL语句
insert into  alg.alg_firstpay_feature_tmp
select
	case when a.sex = 2 then 0 when a.sex = 1 then 1 else -99 end sex,
	case when null_or_empty(a.emailsuffix) =1 then -99 else a.emailsuffix end emailsuffix,
	case when null_or_empty(a.regcountry) =1 or a.regcountry='unknown' then -99 else a.regcountry end regcountry,
	case when null_or_empty(a.mt) =1 then -99 else a.mt end mt,
	a.productid,
	case when null_or_empty(a.corever) =1 then -99 else a.corever end corever,
	case when null_or_empty(a.chl) =1 then -99 else a.chl end chl,
	case when null_or_empty(a.chl2) =1 then -99 else a.chl2 end chl2,
	case when null_or_empty(a.bookid) =1 then -99 else a.bookid end bookid,
	case when null_or_empty(a.adstype) =1 then -99 else a.adstype end adstype,
	case when null_or_empty(a.adsquality) =1 then -99 else a.adsquality end adsquality,
	case when null_or_empty(a.device) =1 then -99 else a.device end device,
	case when null_or_empty(a.sysreleasever) =1 then -99 else a.sysreleasever end sysreleasever,
	case when null_or_empty(a.ram) =1 then -99 else a.ram end ram,
	case when null_or_empty(a.brand) =1 then -99 else a.brand end brand,
	case when null_or_empty(a.currentlanguage) =1 then -99 else a.currentlanguage end currentlanguage,
	case when null_or_empty(a.currentlanguage2) =1 then -99 else a.currentlanguage2 end currentlanguage2,
	b.itemcount,
	b.pay_index,
	count(1) pay_num,
	CURRENT_TIMESTAMP() etl_tm
from(
  select
    user_id userid,
    max(sex) sex,
	max(current_language) currentlanguage,
    max(current_language2) currentlanguage2,
    max(split(lower(email), '@')[2]) emailsuffix,
    max(lower(email)) email,
    max(email_bound_status) emailboundstatus,

    max(lower(reg_country)) regcountry,
    max(lower(province)) province,
    max(lower(city)) city,

    max(mt) mt,
    max(product_id) productid,
    min(corever) corever,

    max(lower(chl)) chl,
    max(lower(chl2)) chl2,
    max(book_id_account) bookid,

    max(lower(device)) device,
    max(lower(sys_releasever)) sysreleasever,
    max(ram) ram,
    max(lower(brand)) brand,
    max(lower(ads_type)) adstype,
    max(coalesce(ads_quality, -99)) adsquality
  from dim.dim_user_all_info
  where to_date(create_tm_account)>='2023-01-01'
  group by user_id
) a inner join(
	 select
	    userid,
	    itemcount,
	    count(1) pay_num,
	    createtime,
	    row_number () over (partition by userid order by createtime ) as pay_index
	  from dwd.dwd_trade_user_payorder
	  where testflag=0 and dt between date_sub('${bf_1_dt}',29) and '${bf_1_dt}'
	  group by userid, itemcount, createtime
) b on a.userid=b.userid
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19;
