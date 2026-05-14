-------------------------------------------------
-- 应用报表：海剧-用户维度报表/海剧用户留存报表
-------------------------------------------------

select
	dt,
	周,
    产品名称,
    core,
    终端,
    国家等级,
	国家,
    注册语言,
    投放渠道,
	投放媒体,
	短剧ID,
    用户类型,
	是否付费用户,
	媒体,
    ${维度} `维度`,
    用户数,
	第1日留存,
	第2日留存,
	第3日留存,
	第4日留存,
	第5日留存,
	第6日留存,
	第7日留存,
	第8日留存,
    第9日留存,
	第10日留存,
	第11日留存,
	第12日留存,
	第13日留存,
	第14日留存,
	第15日留存,
    第16日留存,
	第17日留存,
	第18日留存,
	第19日留存,
	第20日留存,
	第21日留存,
	第22日留存,
    第23日留存,
	第24日留存,
	第25日留存,
	第26日留存,
	第27日留存,
	第28日留存,
	第29日留存,
    第30日留存,
	第60日留存,
	第90日留存,
	第120日留存,
	第150日留存,
	第180日留存
from
	(
    select
		b.dt,
		weekofyear(b.dt) as "周",
		'海外短剧'  "产品名称",
        COALESCE(b.corever,'其他') as core,
		dic_mt.enum_name  "终端",
		case
			when b.country_level=1 then 'T1'
			when b.country_level=2 then 'T2'
			else '其他'
		end as "国家等级",
		c.country as "国家",
		dic_reglang.remarks "注册语言",
		case
			when b.source=1 then '自然和其他'
			when b.source=2 then '官网'
			when b.source=3 then '付费'
			else '其他'
		end as "投放渠道",
		b.last_source "投放媒体",
		cast(b.book_id as varchar) "短剧ID",
		case
			when b.user_period=1 then '新用户'
			when b.user_period=2 then '活跃用户'
			when b.user_period=3 then 'RMT(拉活用户)'
			else '其他'
		end as "用户类型",
		case
			when b.is_pay=1 then '付费用户'
			when b.is_pay=0 then '非付费用户'
			else '其他'
		end as "是否付费用户",
		b.chl as "媒体",
		sum(b.user_num) as "用户数",
		sum(a.retention_num1) as "第1日留存",
		sum(a.retention_num2) as "第2日留存",
		sum(a.retention_num3) as "第3日留存",
		sum(a.retention_num4) as "第4日留存",
		sum(a.retention_num5) as "第5日留存",
		sum(a.retention_num6) as "第6日留存",
		sum(a.retention_num7) as "第7日留存",
		sum(a.retention_num8) as "第8日留存",
		sum(a.retention_num9) as "第9日留存",
		sum(a.retention_num10) as "第10日留存",
		sum(a.retention_num11) as "第11日留存",
		sum(a.retention_num12) as "第12日留存",
		sum(a.retention_num13) as "第13日留存",
		sum(a.retention_num14) as "第14日留存",
		sum(a.retention_num15) as "第15日留存",
		sum(a.retention_num16) as "第16日留存",
		sum(a.retention_num17) as "第17日留存",
		sum(a.retention_num18) as "第18日留存",
		sum(a.retention_num19) as "第19日留存",
		sum(a.retention_num20) as "第20日留存",
		sum(a.retention_num21) as "第21日留存",
		sum(a.retention_num22) as "第22日留存",
		sum(a.retention_num23) as "第23日留存",
		sum(a.retention_num24) as "第24日留存",
		sum(a.retention_num25) as "第25日留存",
		sum(a.retention_num26) as "第26日留存",
		sum(a.retention_num27) as "第27日留存",
		sum(a.retention_num28) as "第28日留存",
		sum(a.retention_num29) as "第29日留存",
		sum(a.retention_num30) as "第30日留存",
		sum(a.retention_num60) as "第60日留存",
		sum(a.retention_num90) as "第90日留存",
		sum(a.retention_num120) as "第120日留存",
		sum(a.retention_num150) as "第150日留存",
		sum(a.retention_num180) as "第180日留存"
	from
		(
		select
			dt,
			product_id,
			corever,
			mt,
			country_level,
			reg_country,
			current_language2,
			source,
			last_source,
			book_id,
			user_period,
			is_pay,
			case
				when chl='moboreels-Android-GP' then '谷歌'
				when chl='moboreels-Android-UAxiaomi' then '小米'
				when chl='moboreels-Android-UAchuanyin' then '传音'
				when chl='moboreels-Android-YZnubia' then '努比亚'
				when chl='moboreels-Android-huaweistore' then '华为'
				when chl='moboreels-iOS-AppStore' then '苹果'
				when chl='en_core4_android_google' then '阅读core4'
				when chl='moboshort-Android-GP' then '短剧core2安卓'
				when chl='moboreels-Android-UAoppo' then 'OPPO'
				when chl='moboreels-Android-UAvivo' then 'VIVO'
				else '其他'
			end as chl,
			sum( case when reg_days = 1 then retention_num end ) as retention_num1,
			sum( case when reg_days = 2 then retention_num end ) as retention_num2,
			sum( case when reg_days = 3 then retention_num end ) as retention_num3,
			sum( case when reg_days = 4 then retention_num end ) as retention_num4,
			sum( case when reg_days = 5 then retention_num end ) as retention_num5,
			sum( case when reg_days = 6 then retention_num end ) as retention_num6,
			sum( case when reg_days = 7 then retention_num end ) as retention_num7,
			sum( case when reg_days = 8 then retention_num end ) as retention_num8,
			sum( case when reg_days = 9 then retention_num end ) as retention_num9,
			sum( case when reg_days = 10 then retention_num end ) as retention_num10,
			sum( case when reg_days = 12 then retention_num end ) as retention_num11,
			sum( case when reg_days = 12 then retention_num end ) as retention_num12,
			sum( case when reg_days = 13 then retention_num end ) as retention_num13,
			sum( case when reg_days = 14 then retention_num end ) as retention_num14,
			sum( case when reg_days = 15 then retention_num end ) as retention_num15,
			sum( case when reg_days = 16 then retention_num end ) as retention_num16,
			sum( case when reg_days = 17 then retention_num end ) as retention_num17,
			sum( case when reg_days = 18 then retention_num end ) as retention_num18,
			sum( case when reg_days = 19 then retention_num end ) as retention_num19,
			sum( case when reg_days = 20 then retention_num end ) as retention_num20,
			sum( case when reg_days = 21 then retention_num end ) as retention_num21,
			sum( case when reg_days = 22 then retention_num end ) as retention_num22,
			sum( case when reg_days = 23 then retention_num end ) as retention_num23,
			sum( case when reg_days = 24 then retention_num end ) as retention_num24,
			sum( case when reg_days = 25 then retention_num end ) as retention_num25,
			sum( case when reg_days = 26 then retention_num end ) as retention_num26,
			sum( case when reg_days = 27 then retention_num end ) as retention_num27,
			sum( case when reg_days = 28 then retention_num end ) as retention_num28,
			sum( case when reg_days = 29 then retention_num end ) as retention_num29,
			sum( case when reg_days = 30 then retention_num end ) as retention_num30,
			sum( case when reg_days = 60 then retention_num end ) as retention_num60,
			sum( case when reg_days = 90 then retention_num end ) as retention_num90,
			sum( case when reg_days = 120 then retention_num end ) as retention_num120,
			sum( case when reg_days = 150 then retention_num end ) as retention_num150,
			sum( case when reg_days = 180 then retention_num end ) as retention_num180
		from ads.ads_bi_wide_user_retention_info
		where
			product_id=6833
			and dt >= '${开始时间}' and dt <= '${结束时间}'
		group by 1,2,3,4,5,6,7,8,9,10,11,12,13
		) a
	right join (
		select
			dt,
			product_id,
			corever,
			mt,
			country_level,
			reg_country,
			current_language2,
			source,
			last_source,
			book_id,
			user_period,
			is_pay,
			case
				when chl='moboreels-Android-GP' then '谷歌'
				when chl='moboreels-Android-UAxiaomi' then '小米'
				when chl='moboreels-Android-UAchuanyin' then '传音'
				when chl='moboreels-Android-YZnubia' then '努比亚'
				when chl='moboreels-Android-huaweistore' then '华为'
				when chl='moboreels-iOS-AppStore' then '苹果'
				when chl='en_core4_android_google' then '阅读core4'
				when chl='moboshort-Android-GP' then '短剧core2安卓'
				when chl='moboreels-Android-UAoppo' then 'OPPO'
				when chl='moboreels-Android-UAvivo' then 'VIVO'
				else '其他'
			end as chl,
			count( distinct user_id ) user_num
		from dws.dws_srsv_wide_user_type_info_di
		where
			product_id=6833
			and dt >= '${开始时间}' and dt <= '${结束时间}'
		group by 1,2,3,4,5,6,7,8,9,10,11,12,13
		) b
	on a.dt = b.dt
		and a.product_id = b.product_id
		and a.corever=b.corever
		and a.mt = b.mt
		and a.country_level = b.country_level
		and a.reg_country =b.reg_country
		and a.current_language2 = b.current_language2
		and a.source = b.source
		and a.user_period = b.user_period
		and a.is_pay = b.is_pay
		and a.chl = b.chl
		and a.last_source=b.last_source
		and a.book_id=b.book_id
	left join (
		select
			country,
			code
		from dim.dim_country_dic
		) c
	on a.reg_country=c.code
    left join dim.dim_dic dic_reglang  -- 注册/投放语言
        on a.current_language2 = dic_reglang.enum_id
        and dic_reglang.table_name = 'dim_producttype'
        and dic_reglang.dic_column = 'language_id'
    left join dim.dim_dic  dic_mt  -- mt
        on a.mt = dic_mt.enum_id
        and dic_mt.table_name = 'dim_user_accountinfo_df'
        and dic_mt.dic_column = 'mt'
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    )a
where
	1=1
	${if(len(CORE) == 0,"","and  core in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and  终端 in ('" + 终端 + "')")}
	${if(len(国家等级) == 0,"","and 国家等级 in ('" + 国家等级 + "')")}
	${if(len(注册语言) == 0,"","and 注册语言 in ('" + 注册语言 + "')")}
	${if(len(投放渠道) == 0,"","and 投放渠道 in ('" + 投放渠道 + "')")}
	${if(len(投放媒体) == 0,"","and 投放媒体 in ('" + 投放媒体 + "')")}
	${if(len(用户类型) == 0,"","and 用户类型 in ('" + 用户类型 + "')")}
	${if(len(是否付费用户) == 0,"","and 是否付费用户 in ('" + 是否付费用户 + "')")}
	${if(len(媒体) == 0,"","and 媒体 in ('" + 媒体 + "')")}
	${if(len(短剧ID) == 0,"","and 短剧ID in ('" + 短剧ID + "')")}