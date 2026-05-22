----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_user_dau_ed
-- workflow_version : 14
-- create_user      : yanxh
-- task_name        : tbl_ads_report_user_mau_ed
-- task_version     : 6
-- update_time      : 2024-11-29 14:09:40
-- sql_path         : \starrocks\tbl_ads_report_user_dau_ed\tbl_ads_report_user_mau_ed
----------------------------------------------------------------
-- SQL语句
insert into   ads.ads_report_user_mau_ed
select
         year(a.dt) as years,
                month(a.dt) as months,
        if(a.product_id ='' or a.product_id is null,-99,a.product_id) product_id ,
        if(a.CoreVer ='' or a.CoreVer is null or a.CoreVer=0,1,a.CoreVer) CoreVer ,
        if(a.Current_Language ='' or a.Current_Language is null,-99,a.Current_Language) Current_Language,
		if(a.Current_Language2 ='' or a.Current_Language2 is null,-99,a.Current_Language2) Current_Language2,
		if(a.AppVer ='' or a.AppVer is null,-99,a.AppVer) App_Ver,
		if(a.MT ='' or a.MT is null,-99,a.MT) MT ,
		if(a.Ver ='' or a.Ver is null,-99,a.Ver) Ver ,
		if(a.Reg_Country ='' or a.Reg_Country is null,-99,a.Reg_Country) reg_country,
		case when year(a.dt)=year(a.reg_time)  and month(a.dt)= month(a.reg_time)  then 0 else 1 end as user_types, -- 0 ---  1 ---
	      bitmap_union(to_bitmap(a.user_id))  as user_id --  -------
		 ,now() as etl_time
 from
dws.dws_user_wide_active_ed a
 where   a.dt >=DATE_SUB(date_trunc('month',CURRENT_DATE()),interval 1 month)
group by 1,2 ,3,4 ,5,6,7,8,9,10 ,11;
