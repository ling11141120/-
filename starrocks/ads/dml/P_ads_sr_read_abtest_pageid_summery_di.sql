----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_read_abtest_pageid_summery_di
-- workflow_version : 25
-- create_user      : sjc
-- task_name        : tbl_ads_sr_read_abtest_pageid_summery_di_fb
-- task_version     : 23
-- update_time      : 2025-04-03 16:44:39
-- sql_path         : \starrocks\tbl_ads_sr_read_abtest_pageid_summery_di\tbl_ads_sr_read_abtest_pageid_summery_di_fb
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sr_read_abtest_pageid_summery_di where est>'${bf_7_dt}' and est<='${dt}';

-- SQL语句
--------------汇总表------------------

insert into ads.ads_sr_read_abtest_pageid_summery_di

-- 生成表： 聚合，用于bi
 with z5 as (
    select
        a.*
        ,if(a.abtest_pageid is null,'否','是') is_abtest
        ,b.ad_set_id															-- 广告组id
        ,b.ad_camp_id 															-- 广告系列
        ,b.ads_type   															--
        ,b.ad_name    															-- 广告名称
        ,b.ad_setname 															-- 广告组名称
        ,b.ad_campname															-- 广告系列名称
        -- ,fg.BookId                      				as book_id				-- 书籍id
        ,b.book_id
       ,fg.FileTitle				  					as file_title			-- h5标题
       ,coalesce(ab.file_name,ab1.file_name,log.file_name)	as file_name   		-- h5链接url
       ,coalesce(ab.put_url,ab1.put_url)				as put_url				-- abtest url
	   ,coalesce(ab.abtest_title,ab1.abtest_title)  	as abtest_title			-- ab测试链接标题
	   ,ab.update_time 									as abtest_update_time  --ab配置上传时间
       ,coalesce(k.book_code,s.source_series_code)		as code					-- 代号
       ,coalesce(k.languageid,s.language)				as languageid			-- 语言
    from (
        -- 聚合
        select
        	 est
            ,product_id   														-- 产品id
            ,source																-- 媒体值（广告投放平台）
            ,ad_id																-- 广告id
            ,mt																	-- 终端
            ,pageid																-- 落地页id
            ,abtest_pageid														-- abtest的页面编号
            ,chapterindex
            ,count(1) 									as view_total
            ,count(click_time) 							as click_total
            ,count(user_id) 							as reg_total
            ,sum(h24_amt) 								as h24_amt				-- h24收入
            ,sum((h24_amt>0)*1)							as h24_payers_total		-- h24付费人数
            ,sum(h24_order_total) 						as h24_order_total		-- h24订单数
            ,sum(d3_amt) 								as h24x3_amt			-- h24x3收入
            ,sum((d3_amt>0)*1)							as h24x3_payers_total	-- h24x3付费人数
            ,sum(d3_order_total) 						as h24x3_order_total	-- h24x3订单数
            ,sum(d7_amt) 								as h24x7_amt			-- h24x7收入
            ,sum((d7_amt>0)*1)							as h24x7_payers_total	-- h24x7付费人数
            ,sum(d7_order_total) 						as h24x7_order_total	-- h24x7订单数
        from
        	dwd.dwd_sr_read_abtest_pageid_detail_di
        where est > days_add('${dt}',-7) and ad_id <> ''
        group by 1,2,3,4,5,6,7,8
    ) a
    -- 广告信息
    left join (
    		select * from
			(select
             ad_set_id
            ,left(product_id,3)    			as product_id
            ,substr(ad_id,1,18)             as ad_id
            ,book_id
            ,ad_camp_id
            ,ads_type
            ,ad_name
            ,ad_setname
            ,ad_campname
            ,update_time
            ,row_number() over(partition by substr(ad_id,1,18),left(product_id,3) order by update_time desc) rn
        from
            ads.ads_advertisement_adext_view	    -- 广告信息
        where ad_id <> ''
        ) b where b.rn = 1

    ) b on a.product_id = b.product_id and a.ad_id = b.ad_id
    -- h5和bookid
    left join ods.ods_tidb_sharpengine_ads_global_AdHtml5Config fg on if(a.abtest_pageid is null,a.pageid,a.abtest_pageid)=fg.Id
    -- -- h5 abtest日志表
    left join (
		select
			book_id,book_code,put_url,id,abtest_title,config_id,file_name,update_time,
			lead(update_time,1,'2099-01-01 00:00:00') over (partition by id,config_id order by update_time) as end_time
		from (
				select
					book_id,book_code,put_url,id,abtest_title,config_id,file_name,update_time
				from (
					select
						 book_id										as book_id			-- 书籍ID
						,book_code									as book_code		-- 书籍代号
						,put_url										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page1,"$.PageId") as config_id
						,get_json_string(Page1,"$.FileName") as file_name
						,update_time
					from ads.ads_ad_html5_ab_test_config_log_view
					where ModifyType=3

					union all

					select
						 book_id										as book_id			-- 书籍ID
						,book_code									as book_code		-- 书籍代号
						,put_url										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page2,"$.PageId") as config_id
						,get_json_string(Page2,"$.FileName") as file_name
						,update_time
					from ads.ads_ad_html5_ab_test_config_log_view
					where ModifyType=3

					union all

					select
						 book_id										as book_id			-- 书籍ID
						,book_code									as book_code		-- 书籍代号
						,put_url										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page3,"$.PageId") as config_id
						,get_json_string(Page3,"$.FileName") as file_name
						,update_time
					from ads.ads_ad_html5_ab_test_config_log_view
					where ModifyType=3
				) url
				where config_id>0
				group by 1,2,3,4,5,6,7,8

				union all

				select book_id,book_code,put_url,id,abtest_title,config_id,file_name,update_time
				from (
					select
						 BookId										as book_id			-- 书籍ID
						,BookCode									as book_code		-- 书籍代号
						,PutUrl										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page1,"$.PageId") as config_id
						,get_json_string(Page1,"$.FileName") as file_name
						,CreateTime as update_time
					from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig_history
					--where Title ='EN-P83 H5文案测试'

					union all

					select
						 BookId										as book_id			-- 书籍ID
						,BookCode									as book_code		-- 书籍代号
						,PutUrl										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page2,"$.PageId") as config_id
						,get_json_string(Page2,"$.FileName") as file_name
						,CreateTime as update_time
					from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig_history

					union all

					select
						 BookId										as book_id			-- 书籍ID
						,BookCode									as book_code		-- 书籍代号
						,PutUrl										as put_url			-- 投放URL
						,id
						,title as abtest_title
						,get_json_string(Page3,"$.PageId") as config_id
						,get_json_string(Page3,"$.FileName") as file_name
						,CreateTime as update_time
					from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig_history
				) url
					where config_id>0
					group by 1,2,3,4,5,6,7,8
			) a
			group by 1,2,3,4,5,6,7,8
    ) ab  on a.pageid = ab.id and fg.Id = ab.config_id and a.est>=date(date_sub(ab.update_time,interval 13 hour))  and a.est<date(date_sub(ab.end_time,interval 13 hour))
	 -- -- h5 abtest配置表
    left join (
		select book_id,book_code,put_url,id,abtest_title,config_id,file_name
		from (
			select
				 BookId										as book_id			-- 书籍ID
				,BookCode									as book_code		-- 书籍代号
				,PutUrl										as put_url			-- 投放URL
				,id
				,title as abtest_title
				,get_json_string(Page1,"$.PageId") as config_id
				,get_json_string(Page1,"$.FileName") as file_name
			from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig
			--where Title ='EN-P83 H5文案测试'

			union all

			select
				 BookId										as book_id			-- 书籍ID
				,BookCode									as book_code		-- 书籍代号
				,PutUrl										as put_url			-- 投放URL
				,id
				,title as abtest_title
				,get_json_string(Page2,"$.PageId") as config_id
				,get_json_string(Page2,"$.FileName") as file_name
			from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig

			union all

			select
				 BookId										as book_id			-- 书籍ID
				,BookCode									as book_code		-- 书籍代号
				,PutUrl										as put_url			-- 投放URL
				,id
				,title as abtest_title
				,get_json_string(Page3,"$.PageId") as config_id
				,get_json_string(Page3,"$.FileName") as file_name
			from ods.ods_tidb_sharpengine_ads_global_AdHtml5AbTestConfig
		) url
		where config_id>0
		group by 1,2,3,4,5,6,7
    ) ab1  on a.pageid = ab1.id and fg.Id = ab1.config_id
	    --  获取url
    left join (
        select *
        from (
            select
                 ConfigId														-- AdHtml5Config配置Id
                ,FileName									as file_name		-- 文件名
                ,row_number() over (partition by ConfigId order by CreateTime desc) as rn
            from  ods.ods_tidb_sharpengine_ads_global_AdHtml5ConfigLog
        ) x
        where rn = 1
    ) log on fg.Id = log.ConfigId
    -- 书籍信息
    left join (
        select
             book_id
            ,site_id2
            ,book_code
            ,languageid
        from dim.dim_shuangwen_book_read_consume_info
        group by 1,2,3,4
    ) k on b.book_id =k.book_id and b.product_id <> '683'
    -- 短剧信息
    left join (
        select
             series_id
            ,language
            ,source_series_code
        from dim.dim_sv_series_hi
        group by 1,2,3
    ) s on b.book_id = s.series_id and b.product_id = '683'
)

, z6 as (
	select
		 a.*
		,UPPER(pt.abbreviation)  as abbreviation
		,now()                   as etl_time
	from z5 a
	left join (
	select
	 	langid
		,abbreviation
	from
		dim.DIM_ProductType
	) pt
	on a.languageid = pt.langid

)

select * from z6
;
