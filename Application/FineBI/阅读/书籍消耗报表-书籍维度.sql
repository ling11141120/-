with t123 as(
select
*
from
	(
	SELECT
		t1.*,
		t2.country,
		dic_mt.enum_name `终端`,
        dic_reglang.remarks as `注册语言`,
		case
			when t2.country ='US' THEN 'US'
			when t3.level is null then '未分类'
			else t3.level end `国家等级`
		from
			(
			  select
			   case
			   ${"when group_id in (" + group_id1 + ")  then '实验组1' "}
			   ${"when group_id in (" + group_id2 + ")  then '实验组2' "}
			   ${"when group_id in (" + group_id3 + ")  then '实验组3' "}
			   ${"when group_id in (" + group_id4 + ")  then '实验组4' "}
			   ${"when group_id in (" + group_id5 + ")  then '实验组5' "}
			   ${"when group_id in (" + group_id6 + ")  then '对照组' "}
			   end group_type,
			  group_id,product_id,user_id,
			  min(dt) min_day,
			  min(create_time) min_time,
			  row_number() over(partition by product_id,user_id order by min(create_time)) row_1
			  from ads.ads_market_realtime_group_log_view
			  where
				op_type=0
				and dt >= date_add('${开始时间}',-1)
				and dt <= date_add('${结束时间}',1)
				and create_time >= '${开始时间}'
				and create_time <= '${结束时间}'
			  ${if(len(group_id1) == 0,"","and ( group_id in (" + group_id1 + ")")}
			  ${if(len(group_id2) == 0,")","or  group_id in (" + group_id2 + ")")}
			  ${if(len(group_id3) == 0,")","or  group_id in (" + group_id3 + ")")}
			  ${if(len(group_id4) == 0,")","or  group_id in (" + group_id4 + ")")}
			  ${if(len(group_id5) == 0,")","or  group_id in (" + group_id5 + ")")}
			  ${if(len(group_id6) == 0,")","or  group_id in (" + group_id6 + ") )")}
			  group by 1,2,3,4
			) t1
	left join
		dim.dim_user_account_info_view  t2
	on t1.product_id =t2.product_id and t1.user_id = t2.id
	left join
		dim.dim_countrylevel t3
	on t2.product_id=t3.product_id and t2.country=t3.short_name
      left join dim.dim_dic  dic_mt  -- mt
   on t2.mt = dic_mt.enum_id
   and dic_mt.table_name = 'dim_user_accountinfo_df'
   and dic_mt.dic_column = 'mt'
   left join dim.dim_dic dic_reglang  -- 注册/投放语言
    on t2.current_language2 = dic_reglang.enum_id
    and dic_reglang.table_name = 'dim_producttype'
    and dic_reglang.dic_column = 'language_id'
	) ttt
where
	row_1 = 1
	${if(len(终端) == 0,"","and  终端 in ('" + 终端 + "')")}
	${if(len(国家等级) == 0,"","and  国家等级 in ('" + 国家等级 + "')")}
),

-- 书籍信息表，匹配书籍语言
book_info as(
select
	cast(book_id as varchar) book_id ,
	book_name,
	dic_booklang.enum_name as site_id
from dim.dim_book_chapter_info t1
  left join dim.dim_dic  dic_booklang  --书籍语言 332，333
  on t1.site_id = dic_booklang.enum_id
  and dic_booklang.table_name = 'dws_content_translate_remuneration_d'
  and dic_booklang.dic_column = 'site_id'
group by 1,2,3
),

-- 人群包关联阅读数据
z1 as(
select
	*,
	sum(case when group_type='对照组' then `group_uv` end) over(partition by book_id) group6_uv,
	sum(case when group_type='对照组' then `read_uv` end) over(partition by book_id) group6_read_uv
from
	(
	select
		group_type,
		t4.book_id,
		max(book_name) book_name,
		count(distinct t123.user_id) group_uv,
		count(distinct case when t4.create_time>t123.min_time then t4.user_id end) read_uv
	from t123
	left join
		(
		select
			a1.*,
			book_name,
			site_id
		from
			(
			select
				product_id,
				user_id,
				cast(book_id as varchar) book_id,
				create_time
			from ads.ads_read_user_chapter_view t4
			where
				dt >= date_add('${活动开始时间}',-1)
				and dt <= date_add('${活动结束时间}',1)
				and create_time >= '${活动开始时间}'
				and create_time <= '${活动结束时间}'
				${if(len(书籍ID) == 0,"","and  t4.book_id in ('" + 书籍ID + "')")}
			) a1
		left join book_info
		on a1.book_id = book_info.book_id
		) t4
	on t123.product_id =t4.product_id and t123.user_id = t4.user_id
	where
		1=1
		${if(len(书籍语言) == 0,"","and  site_id in ('" + 书籍语言 + "')")}
	group by 1,2
	) t5
),

-- 人群包关联消费数据
z2 as(
select
	*,
	sum(case when group_type='对照组' then `group_uv` end) over(partition by book_id) group6_uv,
	sum(case when group_type='对照组' then `consume_uv` end) over(partition by book_id) group6_consume_uv,
	sum(case when group_type='对照组' then `consume_amount` end) over(partition by book_id) group6_consume_amount,
	sum(case when group_type='对照组' then `coin_consume_amount_0` end) over(partition by book_id) group6_coin_consume_amount_0,
	sum(case when group_type='对照组' then `coin_consume_amount_1` end) over(partition by book_id) group6_coin_consume_amount_1
from
	(
	select
		group_type,
		t4.book_id,
		max(book_name) book_name,
		count(distinct t123.user_id) group_uv,
		count(distinct case when t4.createtime>t123.min_time then t4.user_id end) consume_uv,
		sum( case when t4.createtime>t123.min_time then amount end) /100 consume_amount,
		sum(case when t4.createtime>t123.min_time and types=1 and is_source=0 then amount end)/100 coin_consume_amount_0,
		sum(case when t4.createtime>t123.min_time and types=1 and is_source=1 then amount end)/100 coin_consume_amount_1
	from t123
	left join
		(
		select
			a1.*,
			book_name,
			site_id
		from
			(
			select
			  product_id,
			  user_id,
			  cast(book_id as varchar) book_id,
			  createtime,
			  amount,
			  types,
			  is_source
			from ads.ads_consume_user_consume_view  t4
			where
				types in (1,2)
				and dt >= date_add('${活动开始时间}',-1)
				and dt <= date_add('${活动结束时间}',1)
				and createtime >= '${活动开始时间}'
				and createtime <= '${活动结束时间}'
				${if(len(书籍ID) == 0,"","and  t4.book_id in ('" + 书籍ID + "')")}
			) a1
		left join book_info
		on a1.book_id = book_info.book_id
		) t4
	on t123.product_id =t4.product_id and t123.user_id = t4.user_id
	where  1=1
		${if(len(书籍语言) == 0,"","and  site_id in ('" + 书籍语言 + "')")}
	group by 1,2
	) t5
)


select
z1.group_type `组别`,
z1.book_id  `书籍ID`,
z1.book_name `书籍名称`,
z1.group_uv `入包人数`,
z1.read_uv `阅读人数`,
z1.group6_uv `对照组入包人数`,
z1.group6_read_uv `对照组阅读人数`,
z2.consume_uv `消费人数`,
z2.consume_amount `阅币礼券消费金额`,
z2.group6_consume_uv `对照组消费人数`,
z2.group6_consume_amount `对照组阅币礼券消费金额`,
z2.coin_consume_amount_0 `非引流阅币消耗金额`,
z2.coin_consume_amount_1 `引流阅币消耗金额`,
z2.group6_coin_consume_amount_0 `对照组非引流阅币消耗金额`,
z2.group6_coin_consume_amount_1 `对照组引流阅币消耗金额`
from z1
left join z2
on z1.group_type = z2.group_type and z1.book_id=z2.book_id