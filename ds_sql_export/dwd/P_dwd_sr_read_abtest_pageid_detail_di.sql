----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sr_read_abtest_pageid_detail_di
-- workflow_version : 24
-- create_user      : sjc
-- task_name        : tbl_dwd_sr_read_abtest_pageid_detail_di_fbs2s
-- task_version     : 22
-- update_time      : 2025-02-07 16:02:38
-- sql_path         : \starrocks\tbl_dwd_sr_read_abtest_pageid_detail_di\tbl_dwd_sr_read_abtest_pageid_detail_di_fbs2s
----------------------------------------------------------------
-- SQL语句
-- 生成表明细表：分别是fbs2s，tt 用于分析

insert into dwd.dwd_sr_read_abtest_pageid_detail_di

-- 有激活，fbs2s，用户落地页访问数，点击数
with  z1 as  (
    select
    	 a.dt
        ,if(a.product_id=0,c.product_id,a.product_id) 				as product_id						-- 产品id
        ,a.user_id																						-- 用户id
        ,a.source																						-- 媒体值（广告投放平台）
        ,a.ad_id																						-- 广告id
        ,a.trace_id																						-- s2s的追踪id
        ,a.install_date																					-- 激活安装时间
        ,a.mt																							-- 终端
        ,a.abtest_pageid																				-- 落地页AB测
        ,a.create_time																					-- 新增时间
        ,a.next_attribute_time																			-- 下一次归因时间
        ,max_by(b.pageid,b.create_time) 							as pageid
        ,min(b.create_time) view_time
        ,max(case when exaction='readmore' then b.create_time end) 	as click_time
        ,max(case when exaction='readmore' then b.chapterindex end) as chapterindex
    from (
        select
        	 dt
            ,left(product_id,3)												as product_id				-- 产品id
            ,user_id																					-- 用户id
            ,source																						-- 媒体值（广告投放平台）
            ,substr(ad_id,1,18)		 										as ad_id					-- 广告id
            ,trace_id																					-- s2s的追踪id
            ,install_date																				-- 激活安装时间
            ,book_id																					-- 书籍id
            ,mt																							-- 终端
            ,abtest_pageid																				-- 落地页AB测
            ,country																					-- 国家
            ,create_time																				-- 新增时间
            ,next_attribute_time																		-- 下一次归因时间

        from
        	ads.ads_user_install_info_view						-- 阅读及海外短剧广告用户安装记录表
        where  source in ('fbs2s')
            and isdelete = 0
            and dt >= days_add('${dt}',-7)
            and minutes_diff(next_attribute_time,install_date) > 1
            and trace_id <> ''
            and user_id <> -1
    ) a
     -- 广告信息
    left join (
        select
             ad_set_id
            ,left(product_id,3)  											as product_id
            ,substr(ad_id,1,18)                                             as ad_id
            ,book_id
            ,ad_camp_id
            ,ads_type
            ,ad_name
            ,ad_setname
            ,ad_campname
        from
            ads.ads_advertisement_adext_view 	    -- 广告信息
        where ad_id is not null
    ) c on a.ad_id=c.ad_id
    -- fb广告点击表
    left join (
        select
        	 trace_id
			,pageid
			,exaction
			,chapterindex
			,create_time
        from ads.ads_fbs2s_notify_view							-- facebook广告推送点击表
        where create_time >= days_add('${dt}',-7)
    ) b
    on  a.trace_id = b.trace_id
        and a.install_date >= b.create_time
        and days_diff(a.install_date,b.create_time) < 1
    group by 1,2,3,4,5,6,7,8,9,10,11

)

-- 充值数据
, z2 as (
    select
		 a.product_id											-- 产品id
        ,a.user_id											-- 用户id
        ,a.source											-- 媒体值（广告投放平台）
        ,a.ad_id											-- 广告id
        ,a.trace_id											-- s2s的追踪id
        ,a.install_date										-- 激活安装时间
        ,a.mt												-- 终端
        ,a.pageid
        ,a.abtest_pageid									-- 落地页AB测
        -- ,a.next_attribute_time							-- 下一次归因时间
        ,a.view_time
        ,a.click_time
        ,a.chapterindex
        ,sum(case when days_diff(b.create_time,a.install_date)<1 then b.base_amount end) 		as h24_amt
        ,sum(case when days_diff(b.create_time,a.install_date)<3 then b.base_amount end) 		as d3_amt
        ,sum(case when days_diff(b.create_time,a.install_date)<8 then b.base_amount end) 		as d7_amt
        ,count(case when days_diff(b.create_time,a.install_date)<1 then b.base_amount end) 		as h24_order_total
        ,count(case when days_diff(b.create_time,a.install_date)<3 then b.base_amount end) 		as d3_order_total
        ,count(case when days_diff(b.create_time,a.install_date)<8 then b.base_amount end) 		as d7_order_total
    from z1 a
    -- 充值订单
    left join (
        select
			left(product_id,3)		product_id				-- 产品id
			,user_id
			,create_time
			,base_amount
        from ads.ads_trade_sharpenginepaycenter_payorder_view
        where Test_Flag = 0 and base_amount >0  and order_status=1 and  create_time >= days_add('${dt}',-7)
    ) b
    	on  a.product_id = b.product_id
    		and a.user_id = b.user_id
    		and b.create_time >= a.install_date
    		and b.create_time < a.next_attribute_time
    group by 1,2,3,4,5,6,7,8,9,10,11,12
)

-- 无激活，落地页访问，点击数
, z3 as (
    select
         a.product_id										-- 产品id
        ,null user_id	 									-- 用于区分是否激活
        ,'fbs2s' 			source							-- 媒体值（广告投放平台）
        ,a.ad_id											-- 广告id
        ,a.trace_id											-- s2s的追踪id
        ,null install_date									-- 激活安装时间
        ,a.mt												-- 终端
        ,a.pageid
        ,a.abtest_pageid									-- 落地页AB测
        ,max(a.create_time) as view_time
        ,max(case when exaction='readmore' then a.create_time end) click_time
        ,max(case when exaction='readmore' then a.chapterindex end) chapterindex
    from (
        select
			 left(app_id,3)												as product_id
			,substr(adid,1,18)  										as ad_id
			,trace_id
			,mt
			,pageid
			,create_time
			,exaction
			,chapterindex
			,abtest_pageid
        from ads.ads_fbs2s_notify_view							-- facebook广告推送点击表
        where create_time >= days_add('${dt}',-7)
        	  and app_id <> 0
        	  and trace_id <> ''
    ) a
    -- 剔除已激活用户
    left join (
        select
        	 dt
            ,left(product_id,3)		as product_id				-- 产品id
            ,user_id											-- 用户id
            ,source												-- 媒体值（广告投放平台）
            ,substr(ad_id,1,18)  	as ad_id					-- 广告id
            ,trace_id											-- s2s的追踪id
            ,install_date										-- 激活安装时间
            ,book_id											-- 书籍id
            ,mt													-- 终端
            ,abtest_pageid										-- 落地页AB测
            ,country											-- 国家
            ,create_time										-- 新增时间
            ,next_attribute_time								-- 下一次归因时间
        from ads.ads_user_install_info_view						-- 阅读及海外短剧广告用户安装记录表
        where  source = 'fbs2s'
            and isdelete = 0
            and dt >= days_add('${dt}',-7)
            and minutes_diff(next_attribute_time,install_date) > 1
    ) b on a.trace_id=b.trace_id and b.install_date>=a.create_time and days_diff(b.install_date,a.create_time)<1
    where
    	b.trace_id is null
		-- and a.mt <> 0
    group by 1,2,3,4,5,6,7,8,9
)
-- 生成表：访问明细表用户数据
, z4 as (
    select
		 date(hours_add(ifnull(view_time,install_date),-13))	as est		-- 日期分区
		,trace_id															-- s2s的追踪id
		,product_id   														-- 产品id
		,user_id															-- 用户id
		,source																-- 媒体值（广告投放平台）
		,ad_id																-- 广告id
		,install_date														-- 激活安装时间
		,mt																	-- 终端
		,pageid																-- 落地页id
		,abtest_pageid														-- abtest的页面编号
		,view_time															-- 访问时间
		,click_time															-- 点击时间
		,chapterindex														-- 章节序号
		,h24_amt															-- h24收入
		,d3_amt																-- d3收入
		,d7_amt																-- d7收入
		,h24_order_total													-- h24订单数
		,d3_order_total														-- d3订单数
		,d7_order_total														-- d7订单数
		,now()							as etl_time							-- etl时间

    from (
        select * from z2
        union all
        select *
            ,0 as h24_amt
            ,0 as d3_amt
            ,0 as d7_amt
            ,0 as h24_order_total
            ,0 as d3_order_total
            ,0 as d7_order_total
        from z3
    ) x
)

select * from z4
;
