-------------------------------------------------
-- 应用报表：阅读-书籍维度报表/书籍消费统计报表
-------------------------------------------------


-- 书籍信息表
with a as(
select
	cast( t1.book_id as varchar ) book_id,
	book_name,
	book_code,
	Channel,
	COALESCE(dic_booklang.enum_name ,t1.site_id2)  as site_id,
    COALESCE( dic_product.enum_name ,t1.product_id) as 产品名称,
    t1.product_id,
	build_time,
	new_cname,
    COALESCE( dic_booknature.enum_name ,t1.book_nature) as book_nature,
	cast( normal_chapter_num_f as varchar ) normal_chapter_num_f ,
    is_washing_book
from dim.dim_shuangwen_book_read_consume_info  t1
  left join dim.dim_dic  dic_booklang  --书籍语言 332，333
    on t1.site_id2 = dic_booklang.enum_id
    and dic_booklang.table_name = 'dws_content_translate_remuneration_d'
    and dic_booklang.dic_column = 'site_id'
  left join dim.dim_dic dic_product  -- 产品名称
   on t1.product_id = dic_product.enum_id
   and dic_product.table_name = 'dwd_consume_user_consume_di'
   and dic_product.dic_column = 'product_id'
  left join dim.dim_dic  dic_booknature  -- 书籍来源
  on t1.book_nature = dic_booknature.enum_id
  and dic_booknature.table_name = 'dim_shuangwen_book_read_consume_info'
  and dic_booknature.dic_column = 'book_nature'
  left join (select
         concat(book_id,site_id) as book_id ,
        if( max(is_washing_book) =  1, '是' ,'否') as is_washing_book
        from  dim.`dim_edit_book_view`
group by 1 ) t2 on t1.book_id = t2.book_id
where product_id not in (8858,6883,6833)
	${if(len(书籍ID) == 0,"","and  t1.book_id in ('" + 书籍ID + "')")}
	${if(len(系列) == 0,"","and REGEXP_REPLACE(book_code, '[0-9].*$', '')  in ('" + 系列 + "')")}
	${if(len(书籍语言) == 0,"","and  dic_booklang.enum_name in ('" + 书籍语言 + "')")}
    ${if(len(产品名称) == 0,"","and dic_product.enum_name in ( '" + 产品名称 + "')")}

),
b as(
select
    a.site_id,
	count( distinct t1.user_id ) as read_num,
	count( distinct case when is_channel_book=1 then t1.user_id end) as yinliu_read_num,
	count( distinct case when is_channel_book=0 then t1.user_id end) as feiyinliu_read_num
from a
left join 	ads.ads_bi_user_read_book_info  t1
 on a.book_id =t1.book_id

left join dim.dim_dic dic_product  -- 产品名称
    on t1.product_id = dic_product.enum_id
   and dic_product.table_name = 'dwd_consume_user_consume_di'
   and dic_product.dic_column = 'product_id'
where  t1.product_id not in (6883, 6833)
	${if(len(CORE) == 0,"","and t1.corever in ('" + CORE + "')")}
	${if(len(是否引流) == 0 ,"",
         "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
	and t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
	${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
group by 1
),
c as(
select
    a.site_id,
	count( distinct t1.user_id ) as "合计消耗人数",
	count( distinct if( types = 4,t1.user_id,null) ) as "VIP消耗人数",
	count( distinct case when is_channel_book=0 then t1.user_id end) as "合计消耗人数非引流",
	count( distinct case when is_channel_book=1 then t1.user_id end) as "合计消耗人数引流",
	sum(amount)/100 as "合消耗金额",
	sum(case when is_channel_book=0 then amount end)/100 as "合消耗金额非引流",
	sum(case when is_channel_book=1 then amount end)/100 as "合消耗金额引流",
	count( distinct case when types=1 then t1.user_id end) as "阅币消耗人数",
	count( distinct case when types=1 and is_channel_book=0 then t1.user_id end) as "阅币消耗人数非引流",
	count( distinct case when types=1 and is_channel_book=1 then t1.user_id end) as "阅币消耗人数引流",
	sum(case when types=1 then amount end)/100 as "阅币消耗金额",
	sum(case when types=1 and is_channel_book=0 then amount end)/100 as "阅币消耗金额非引流",
	sum(case when types=1 and is_channel_book=1 then amount end)/100 as "阅币消耗金额引流",
	count( distinct case when types in(1,2) then t1.user_id end) as "阅币礼券消耗人数" ,
	sum(case when types in(1,2) then amount end)/100 as "阅币礼券消耗金额",
	count(distinct case when types=1 and amount>=1500 then t1.user_id end) as "阅币消耗1500人数",
	count(distinct case when types=1 and amount>=3000 then t1.user_id end) as "阅币消耗3000人数",
	sum(case when  types=1 then con_chapter_nums end) "阅币消耗章节数",
	sum(con_chapter_nums ) "消耗章节数"
from a
left join  ads.ads_bi_user_book_consume_info t1
on a.book_id =t1.book_id
where t1.product_id not in (6883, 6833)
	${if(len(CORE) == 0,"","and t1.corever in ('" + CORE + "')")}
    ${if(len(是否引流) == 0 ,"",
           "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
	and t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
   ${if(len(解锁类型) == 0,"","and case when types = 1 then '阅币'
                        when types = 2 then '礼券'
                        when types = 3 then '赠送币'
                        when types = 4 then 'VIP' end in ( '" + 解锁类型 + "')")}
	${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
group by 1
),
d as (
	select
		site_id,
		bitmap_union_count(expo_unt) expo_unt,
		bitmap_union_count(cli_unt) cli_unt
	from  (
		SELECT
          a.site_id,
          a.book_id,
          expo_unt,
          cli_unt
		from a
		left join ads.ads_bi_book_itemexposure_info t1
		on a.book_id = t1.book_id
		where  t1.product_id not in (6883, 6833)
			and dt >= '${开始日期}'
			and dt <= '${结束日期}'
			${if(len(CORE) == 0,"","and  corever in ('" + CORE + "')")}
            --  and is_channel_book = 0
 			${if(len(是否引流) == 0 ,"", "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
            ${if(len(终端) == 0,"","and case when mt='ios' then 'iOS' when mt='android' then 'Android' else '其他' end  in ( '" + 终端 + "')")}
		UNION all
		select
          a.site_id,
          a.book_id,
          bitmap_agg(t1.user_id ) as expo_unt ,
          bitmap_agg(t1.user_id ) as cli_unt
		from a
        left join ads.ads_bi_user_read_book_info t1
		on a.book_id = t1.book_id
		where  t1.dt >= '${开始日期}' and t1.dt <= '${结束日期}'
 		   and t1.corever = 1
		${if(len(是否引流) == 0 ,"", "and case when  is_channel_book= 0 then '非引流' end in ('" + 是否引流 + "')")}
		${if(len(CORE) == 0,"","and  t1.corever in ('" + CORE + "')")}
		${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
		group by 1,2
	) d0
group by 1
),
e as (
    SELECT a.site_id
          ,count(distinct case when serial_number=3 then t1.user_id end) "第3章阅读人数"
          ,count(distinct case when serial_number=5 then t1.user_id end) "第5章阅读人数"
          ,count(distinct case when serial_number=10 then t1.user_id end) "第10章阅读人数"
          ,count(distinct case when serial_number=30 then t1.user_id end)  "第30章阅读人数"
    FROM   a
	left join ads.ads_read_user_chapter_view  t1
	on a.book_id= t1.book_id
	left join dws.dws_user_wide_active_period_ed t2
      on t1.user_id = t2.user_id
     and t1.dt = t2.dt
	 and t2.period_type = 'ctt'
    INNER JOIN
    (
        SELECT  dim_book_chapter_info.book_id
               ,dim_book_chapter_info.chapter_id
               ,dim_book_chapter_info.serial_number
        FROM dim.dim_book_chapter_info
        WHERE serial_number IN (3, 5, 10, 30)
    ) b
    ON t1.book_id = b.book_id AND t1.chapter_id = b.chapter_id
    LEFT JOIN ads.ads_bi_user_read_book_info AS c
    ON t1.user_id = c.user_id AND t1.book_id = c.book_id and t1.dt = c.dt
  where t1.product_id not in (6883, 6833)
  ${if(len(是否引流) == 0 ,"",
         "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
  	and t1.dt >= '${开始日期}'
  	and t1.dt <= '${结束日期}'
	${if(len(终端) == 0,"","and case when t1.mt=1 then 'iOS' when t1.mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
  	${if(len(CORE) == 0,"","and  t2.corever in ('" + CORE + "')")}
  GROUP BY  1
)
select
	b.site_id as "书籍语言",
	expo_unt,
	cli_unt,
	read_num,
	yinliu_read_num,
	feiyinliu_read_num,
	合计消耗人数,
    VIP消耗人数,
	合计消耗人数非引流,
	合计消耗人数引流,
	合消耗金额,
	合消耗金额非引流,
	合消耗金额引流,
	阅币消耗人数,
	阅币消耗人数非引流,
	阅币消耗人数引流,
	阅币消耗金额,
	阅币消耗金额非引流,
	阅币消耗金额引流,
	阅币礼券消耗人数,
	阅币礼券消耗金额,
	阅币消耗1500人数,
	阅币消耗3000人数,
	消耗章节数,
	阅币消耗章节数,
	第3章阅读人数,
	第5章阅读人数,
	第10章阅读人数,
	第30章阅读人数
from    b
left join c
on b.site_id = c.site_id
left join d
on b.site_id = d.site_id
left join e
on b.site_id = e.site_id