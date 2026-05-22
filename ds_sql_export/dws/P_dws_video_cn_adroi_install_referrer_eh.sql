----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_cn_adroi_install_referrer_eh
-- workflow_version : 24
-- create_user      : zhugl
-- task_name        : tbl_dws_video_cn_adroi_install_referrer_eh
-- task_version     : 9
-- update_time      : 2023-11-24 17:02:35
-- sql_path         : \starrocks\tbl_dws_video_cn_adroi_install_referrer_eh\tbl_dws_video_cn_adroi_install_referrer_eh
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_video_cn_adroi_install_referrer_eh where create_time>='${bf_1_dt}';

-- SQL语句
insert into dws.dws_video_cn_adroi_install_referrer_eh
with reg_pay  as (select
	base_amount_rmb amount,
	pay.video_user_id ,
	create_time as pay_time ,
	install_date as reg_time,
	seconds_diff(create_time,install_date)/60/60 hours,
	attribution.chl2 ,
	attribution.mt,
	attribution.core,
	current_language2,
	case
		when source is null
		or source = '' then 'none'
		else source
	end as sourcechl,
	case
		when (attribution.ad_id is null
		or attribution.ad_id = '') then
		concat(
			 'AdId=none|SourceChl=',CASE WHEN Source is null OR Source = '' THEN 'none' ELSE Source END ,
			'|Mt=', concat(attribution.Mt, ''),
			'|Core=', concat(attribution.Core, ''),
			'|Chl2=',CASE WHEN Chl2 is null OR Chl2 = '' THEN 'none' ELSE Chl2 END,
			'|CurrentLanguage2=', concat(attribution.Current_Language2, ''))
		else attribution.ad_id
	end as adid
from dwd.dwd_trade_video_cn_payorder_view pay-- cdvideo_tidb_xcx.payorder tbpayorder
left join (
	select
		user_id,
		core,
		mt,
		install_date,
		remarketing_time ,
		chl2,
		source,
		ad_id,
		current_language2,
		next_attribute_time,
		Unique_CdReaderId
	from
	dwd.dwd_user_install_info_ed_view 	-- cdvideo_tidb_xcx.user_attribution
	where
		date(install_date) >='${bf_2_dt}' and date(install_date) <='${bf_0_dt}'
		and is_remarketing = 0
		and adaccount_id not in('6498009b0c801c4baafeb622')
		and product_id = '6883') attribution on
	pay.video_user_id = attribution.Unique_CdReaderId
	and pay.core = attribution.core
	and pay.create_time >= attribution.install_date
	and pay.create_time <= date_add(attribution.install_date,interval 24 hour)
	and pay.create_time <= attribution.next_attribute_time
	and pay.create_time <= attribution.remarketing_time
where
	date(pay.create_time)>='${bf_2_dt}' and date(pay.create_time)<='${bf_0_dt}'
	and attribution.user_id >0
	and coo_order_status = 1
	and test_flag = 0
	and pay.product_id = '6883'),
first_pay as (
select
reg_time,
adid,
core,
sum(if ( hours >=0 and hours <1 ,first_pay_num,0) )hour0FirstPayNum ,
sum(if ( hours >=1 and hours <2 ,first_pay_num,0) )hour1FirstPayNum ,
sum(if ( hours >=2 and hours <3 ,first_pay_num,0) )hour2FirstPayNum ,
sum(if ( hours >=3 and hours <4 ,first_pay_num,0) )hour3FirstPayNum ,
sum(if ( hours >=4 and hours <5 ,first_pay_num,0) )hour4FirstPayNum ,
sum(if ( hours >=5 and hours <6 ,first_pay_num,0) )hour5FirstPayNum ,
sum(if ( hours >=6 and hours <7 ,first_pay_num,0) )hour6FirstPayNum ,
sum(if ( hours >=7 and hours <8 ,first_pay_num,0) )hour7FirstPayNum ,
sum(if ( hours >=8 and hours <9 ,first_pay_num,0) )hour8FirstPayNum ,
sum(if ( hours >=9 and hours <10 ,first_pay_num,0) )hour9FirstPayNum ,
sum(if ( hours >=10 and hours <11 ,first_pay_num,0) )hour10FirstPayNum ,
sum(if ( hours >=11 and hours <12 ,first_pay_num,0) )hour11FirstPayNum ,
sum(if ( hours >=12 and hours <13 ,first_pay_num,0) )hour12FirstPayNum ,
sum(if ( hours >=13 and hours <14 ,first_pay_num,0) )hour13FirstPayNum ,
sum(if ( hours >=14 and hours <15 ,first_pay_num,0) )hour14FirstPayNum ,
sum(if ( hours >=15 and hours <16 ,first_pay_num,0) )hour15FirstPayNum ,
sum(if ( hours >=16 and hours <17 ,first_pay_num,0) )hour16FirstPayNum ,
sum(if ( hours >=17 and hours <18 ,first_pay_num,0) )hour17FirstPayNum ,
sum(if ( hours >=18 and hours <19 ,first_pay_num,0) )hour18FirstPayNum ,
sum(if ( hours >=19 and hours <20 ,first_pay_num,0) )hour19FirstPayNum ,
sum(if ( hours >=20 and hours <21 ,first_pay_num,0) )hour20FirstPayNum ,
sum(if ( hours >=21 and hours <22 ,first_pay_num,0) )hour21FirstPayNum ,
sum(if ( hours >=22 and hours <23 ,first_pay_num,0) )hour22FirstPayNum ,
sum(if ( hours >=23 and hours <24 ,first_pay_num,0) )hour23FirstPayNum
from
	(select
		count(distinct(video_user_id)) as first_pay_num,
		seconds_diff(create_time,reg_time)/60/60 hours,
		date_format(reg_time, '%Y-%m-%d %H:00:00') as reg_time,
		adid,
		core
	from
		(
		select
			pay.video_user_id,
			case
					when (COALESCE (attribution.adid,acc.adid) is null
					or COALESCE (attribution.adid,acc.adid) = '') then
					concat('AdId=none|SourceChl=',(case when acc.source_chl  is null or acc.source_chl = '' then 'none' else acc.source_chl end),
						   '|Mt=', concat(acc.mt2, ''),
						   '|Core=', concat(acc.corever2, ''),
						   '|Chl2=', case when acc.chl2 is null or acc.chl2 = '' then 'none' else acc.chl2 end,
						   '|CurrentLanguage2=', concat(acc.current_language2, ''))
					else COALESCE (attribution.adid,acc.adid)
				end as adid,
			pay.core,
			min(pay.create_time) as create_time,
			min(date_format(COALESCE(attribution.reg_time,acc.create_time), '%Y-%m-%d %H:00:00')) reg_time
		from
			dwd.dwd_trade_video_cn_payorder_view pay
		left join (
			select
				user_id,
				core as corever2,
				mt as mt2,
				install_date as reg_time,
				remarketing_time ,
				chl2,
				source as sourcechl,
				Unique_CdReaderId,
				case
					when (ad_id is null
					or ad_id = '') then
					concat('AdId=none|SourceChl=',(case when source is null or source = '' then 'none' else source end),
						   '|Mt=', concat(mt, ''),
						   '|Core=', concat(core, ''),
						   '|Chl2=', case when chl2 is null or chl2 = '' then 'none' else chl2 end,
						   '|CurrentLanguage2=', concat(current_language2, ''))
					else ad_id
				end as adid,
				current_language2,
				next_attribute_time
			from
				dwd.dwd_user_install_info_ed_view
			where
					IsDelete = 0
				and user_id >0
				and is_remarketing = 0
				and product_id = '6883'
				and date(install_date) >='${bf_2_dt}' and  date(install_date) <='${bf_0_dt}'
				) attribution on
			pay.video_user_id = attribution.Unique_CdReaderId
			and pay.create_time >='${bf_2_dt}'
			and pay.core = attribution.corever2
			and pay.create_time >= attribution.reg_time
			and pay.create_time <= date_add(attribution.reg_time, interval 24 hour)
			and pay.create_time <= attribution.next_attribute_time
			and pay.create_time <= attribution.remarketing_time
			left join dim.dim_video_cn_accountinfo_view acc
			on pay.video_user_id =  acc.account
			and pay.create_time >=acc.create_time
			and pay.create_time <=date_add(acc.create_time , interval 24 hour)
		where
			date(pay.create_time)>='${bf_2_dt}' and date(pay.create_time)<='${bf_0_dt}'
			and pay.pay_chanel_id  not in(336617, 336651)
			and pay.create_time >='2023-08-05 00:00:00'
			-- 支付渠道
			and coo_order_status = 1
			and test_flag = 0
			and pay.product_id = '6883'
		group by 1,2,3
) a where  adid is not  null and adid !=0 group by 2,3,4,5
)a group  by 1,2,3),
pay_h as (select
date_format(reg_time, '%Y-%m-%d %H:00:00') as reg_time,
core,
adid,
sum(if ( hours >=0 and hours <1 ,amount,0) )hour0Amount ,
sum(if ( hours >=0 and hours <0.5 ,amount,0) )HourHalfAmount ,
sum(if ( hours >=1 and hours <2 ,amount,0) )hour1Amount ,
sum(if ( hours >=2 and hours <3 ,amount,0) )hour2Amount ,
sum(if ( hours >=3 and hours <4 ,amount,0) )hour3Amount ,
sum(if ( hours >=4 and hours <5 ,amount,0) )hour4Amount ,
sum(if ( hours >=5 and hours <6 ,amount,0) )hour5Amount ,
sum(if ( hours >=6 and hours <7 ,amount,0) )hour6Amount ,
sum(if ( hours >=7 and hours <8 ,amount,0) )hour7Amount ,
sum(if ( hours >=8 and hours <9 ,amount,0) )hour8Amount ,
sum(if ( hours >=9 and hours <10 ,amount,0) )hour9Amount ,
sum(if ( hours >=10 and hours <11 ,amount,0) )hour10Amount ,
sum(if ( hours >=11 and hours <12 ,amount,0) )hour11Amount ,
sum(if ( hours >=12 and hours <13 ,amount,0) )hour12Amount ,
sum(if ( hours >=13 and hours <14 ,amount,0) )hour13Amount ,
sum(if ( hours >=14 and hours <15 ,amount,0) )hour14Amount ,
sum(if ( hours >=15 and hours <16 ,amount,0) )hour15Amount ,
sum(if ( hours >=16 and hours <17 ,amount,0) )hour16Amount ,
sum(if ( hours >=17 and hours <18 ,amount,0) )hour17Amount ,
sum(if ( hours >=18 and hours <19 ,amount,0) )hour18Amount ,
sum(if ( hours >=19 and hours <20 ,amount,0) )hour19Amount ,
sum(if ( hours >=20 and hours <21 ,amount,0) )hour20Amount ,
sum(if ( hours >=21 and hours <22 ,amount,0) )hour21Amount ,
sum(if ( hours >=22 and hours <23 ,amount,0) )hour22Amount ,
sum(if ( hours >=23 and hours <24 ,amount,0) )hour23Amount ,
0 Hour0AmountByAd   ,
0 Hour1AmountByAd   ,
0 Hour2AmountByAd   ,
0 Hour3AmountByAd   ,
0 Hour4AmountByAd   ,
0 Hour5AmountByAd   ,
0 Hour6AmountByAd   ,
0 Hour7AmountByAd   ,
0 Hour8AmountByAd   ,
0 Hour9AmountByAd   ,
0 Hour10AmountByAd  ,
0 Hour11AmountByAd  ,
0 Hour12AmountByAd  ,
0 Hour13AmountByAd  ,
0 Hour14AmountByAd  ,
0 Hour15AmountByAd  ,
0 Hour16AmountByAd  ,
0 Hour17AmountByAd  ,
0 Hour18AmountByAd  ,
0 Hour19AmountByAd  ,
0 Hour20AmountByAd  ,
0 Hour21AmountByAd  ,
0 Hour22AmountByAd  ,
0 Hour23AmountByAd,
sum(if ( hours >=0 and hours <1 ,1,0) )hour0paynum ,
sum(if ( hours >=1 and hours <2 ,1,0) )hour1paynum ,
sum(if ( hours >=2 and hours <3 ,1,0) )hour2paynum ,
sum(if ( hours >=3 and hours <4 ,1,0) )hour3paynum ,
sum(if ( hours >=4 and hours <5 ,1,0) )hour4paynum ,
sum(if ( hours >=5 and hours <6 ,1,0) )hour5paynum ,
sum(if ( hours >=6 and hours <7 ,1,0) )hour6paynum ,
sum(if ( hours >=7 and hours <8 ,1,0) )hour7paynum ,
sum(if ( hours >=8 and hours <9 ,1,0) )hour8paynum ,
sum(if ( hours >=9 and hours <10 ,1,0) )hour9paynum ,
sum(if ( hours >=10 and hours <11 ,1,0) )hour10paynum ,
sum(if ( hours >=11 and hours <12 ,1,0) )hour11paynum ,
sum(if ( hours >=12 and hours <13 ,1,0) )hour12paynum ,
sum(if ( hours >=13 and hours <14 ,1,0) )hour13paynum ,
sum(if ( hours >=14 and hours <15 ,1,0) )hour14paynum ,
sum(if ( hours >=15 and hours <16 ,1,0) )hour15paynum ,
sum(if ( hours >=16 and hours <17 ,1,0) )hour16paynum ,
sum(if ( hours >=17 and hours <18 ,1,0) )hour17paynum ,
sum(if ( hours >=18 and hours <19 ,1,0) )hour18paynum ,
sum(if ( hours >=19 and hours <20 ,1,0) )hour19paynum ,
sum(if ( hours >=20 and hours <21 ,1,0) )hour20paynum ,
sum(if ( hours >=21 and hours <22 ,1,0) )hour21paynum ,
sum(if ( hours >=22 and hours <23 ,1,0) )hour22paynum ,
sum(if ( hours >=23 and hours <24 ,1,0) )hour23paynum ,
sum(1)PayOrderNum ,
COUNT(distinct video_user_id)PayNum
from reg_pay
group  by 1,2,3),
reg_cnt as (
select
	Max(AdAccount_Id) as AdAccount_Id,
	count(1) as DevNum,
	CASE
		WHEN (a.Ad_Id IS NULL
		OR a.Ad_Id = '') THEN
		concat('AdId=none|SourceChl=', CASE WHEN Source is null OR Source = '' THEN 'none' ELSE Source END ,
			   '|Mt=', concat(a.Mt, ''),
			   '|Core=', concat(a.Core, ''),
			   '|Chl2=', CASE WHEN Chl2 is null OR Chl2 = '' THEN 'none' ELSE Chl2 END,
			   '|CurrentLanguage2=', concat(a.Current_Language2, ''))
		ELSE a.Ad_Id
	END as AdId,
	DATE_FORMAT(DATE_ADD(a.Install_Date, INTERVAL 0 HOUR), '%Y-%m-%d %H:00:00') as Reg_Time
from
	dwd.dwd_user_install_info_ed_view  a
where
	Is_Remarketing = 0
	AND AdAccount_Id not IN('6498009b0c801c4baafeb622')
	AND product_id = 6883
	and date(Install_Date) >= '${bf_2_dt}' and date(Install_Date) <= '${bf_0_dt}'
	and Unique_CdReaderId is not null
group by
	3,4
),
acc_cnt as (
select
	count(distinct(case when b.Unique_CdReaderId = '' or b.Unique_CdReaderId is null then replace(UUID(), '-', '') else b.Unique_CdReaderId end)) as RegNum,
	CASE
		WHEN (b.Ad_Id IS NULL
		OR b.Ad_Id = '') THEN
		concat('AdId=none|SourceChl=',(CASE WHEN Source_Chl is null OR Source_Chl = '' THEN 'none' ELSE Source_Chl END),
			   '|Mt=', concat(Mt2, ''),
			   '|Core=', concat(CoreVer2, ''),
			   '|Chl2=', CASE WHEN b.Chl2 is null OR b.Chl2 = '' THEN 'none' ELSE b.Chl2 END,
			   '|CurrentLanguage2=', concat(b.Current_Language2, ''))
		ELSE b.Ad_Id
	END as AdId,
	DATE_FORMAT(DATE_ADD(b.Create_Time, INTERVAL -0 HOUR), '%Y-%m-%d %H:00:00') as reg_Time
from
	dim.dim_video_cn_accountinfo_view a
left join dwd.dwd_user_install_info_ed_view  b on
	a.account = b.Unique_CdReaderId
	and Product_Id = 6883
where
	 AdAccount_Id not IN('6498009b0c801c4baafeb622')
	and date(b.Create_Time) >='${bf_2_dt}' and  date(b.Create_Time) <='${bf_0_dt}'
group by 2,3),
consumer as (
  -- 小时消耗表
select  spend,ad_name,ad_id,DATE_FORMAT(date_start,'%Y-%m-%d %H:00:00') date_start, account_id,mt,core,product_id,
ad_set_id,ad_camp_id,chl2,source_chl,rowversion,current_language2
from dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view where spend >=0  and date(date_start) >='${bf_2_dt}' and date(date_start) <='${bf_0_dt}'
),
ad_info as
(
select  a.ad_id,b.nick_name,c.campaign_name,d.product_name
FROM
(select ad_id,create_time,ad_name ,invite_code,ad_camp_id,fb_account from dwd.dwd_advertisement_adext_view where product_id  = 6883) a
left JOIN
dim.dim_ads_role_users_view b on a.invite_code = b.ref_id   -- 广告配置 @  没有 @刘小龙
left join
(select campaign_name,camp_id from dim.dim_advertisement_third_ad_campaign_view  where ad_platform_id > 0 )c
on a.ad_camp_id=c.camp_id   -- 广告项目表
left JOIN
(select account,product_name from  dim.dim_advertisement_third_ad_account_view where ad_platform_id > 0 and product_id =6883)d
 on a.fb_account = d.account -- 账号表
 )
select
consumer.ad_id, -- adid
consumer.date_start create_time,
HOUR(consumer.date_start)create_hour,
'[]' pay_list,
IFNULL( acc_cnt.RegNum,0),
IFNULL(consumer.spend,0) cost_amount,
consumer.product_id,
IFNULL(pay_h.paynum,0), -- 支付人数
now() update_time,
'[]' Pay_List_ByDays,
0 Check_Sum,
0 Login_Num2,
0 Login_Num3,
0 Login_Num7,
consumer.Core,
consumer.mt,
null FbAccount,
consumer.ad_set_id,
consumer.ad_camp_id,
IFNULL( reg_cnt.DevNum,0),
0 Group_Id,
consumer.source_chl,
consumer.Chl2,
consumer.RowVersion,
consumer.current_language2,
0 ads_quality,
now() Updater,
Hour0Amount,
HourHalfAmount,
Hour1Amount,
Hour2Amount,
Hour3Amount,
Hour4Amount,
Hour5Amount,
Hour6Amount,
Hour7Amount,
Hour8Amount,
Hour9Amount,
Hour10Amount,
Hour11Amount,
Hour12Amount,
Hour13Amount,
Hour14Amount,
Hour15Amount,
Hour16Amount,
Hour17Amount,
Hour18Amount,
Hour19Amount,
Hour20Amount,
Hour21Amount,
Hour22Amount,
Hour23Amount,
0 Hour0AmountByAd,
0 Hour1AmountByAd,
0 Hour2AmountByAd,
0 Hour3AmountByAd,
0 Hour4AmountByAd,
0 Hour5AmountByAd,
0 Hour6AmountByAd,
0 Hour7AmountByAd,
0 Hour8AmountByAd,
0 Hour9AmountByAd,
0 Hour10AmountByAd,
0 Hour11AmountByAd,
0 Hour12AmountByAd,
0 Hour13AmountByAd,
0 Hour14AmountByAd,
0 Hour15AmountByAd,
0 Hour16AmountByAd,
0 Hour17AmountByAd,
0 Hour18AmountByAd,
0 Hour19AmountByAd,
0 Hour20AmountByAd,
0 Hour21AmountByAd,
0 Hour22AmountByAd,
0 Hour23AmountByAd,
Hour0FirstPayNum,
Hour1FirstPayNum,
Hour2FirstPayNum,
Hour3FirstPayNum,
Hour4FirstPayNum,
Hour5FirstPayNum,
Hour6FirstPayNum,
Hour7FirstPayNum,
Hour8FirstPayNum,
Hour9FirstPayNum,
Hour10FirstPayNum,
Hour11FirstPayNum,
Hour12FirstPayNum,
Hour13FirstPayNum,
Hour14FirstPayNum,
Hour15FirstPayNum,
Hour16FirstPayNum,
Hour17FirstPayNum,
Hour18FirstPayNum,
Hour19FirstPayNum,
Hour20FirstPayNum,
Hour21FirstPayNum,
Hour22FirstPayNum,
Hour23FirstPayNum,
Hour0PayNum,
Hour1PayNum,
Hour2PayNum,
Hour3PayNum,
Hour4PayNum,
Hour5PayNum,
Hour6PayNum,
Hour7PayNum,
Hour8PayNum,
Hour9PayNum,
Hour10PayNum,
Hour11PayNum,
Hour12PayNum,
Hour13PayNum,
Hour14PayNum,
Hour15PayNum,
Hour16PayNum,
Hour17PayNum,
Hour18PayNum,
Hour19PayNum,
Hour20PayNum,
Hour21PayNum,
Hour22PayNum,
Hour23PayNum,
PayOrderNum,
ad_name,
nick_name,
campaign_name,
product_name,
account_id,
now() etl_time
from consumer left join  pay_h
 on consumer.ad_id  = pay_h.adid and consumer.date_start  = pay_h.reg_time
left join  first_pay
on pay_h.reg_time = first_pay.reg_time and pay_h.core = first_pay.core and pay_h.adid = first_pay.adid
left join reg_cnt
 on consumer.ad_id  = reg_cnt.adid and consumer.date_start  = reg_cnt.reg_time
 left join acc_cnt on
  consumer.ad_id  = acc_cnt.adid and consumer.date_start  = acc_cnt.reg_time
left join ad_info
on consumer.ad_id  = ad_info.ad_id
where  date(consumer.date_start)>='${bf_1_dt}';
