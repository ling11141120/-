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
where product_id not in (8858) and product_id<>6883 and product_id<>6833
	${if(len(书籍ID) == 0,"","and  t1.book_id in ('" + 书籍ID + "')")}

		${if(len(系列) == 0,"","and REGEXP_REPLACE(book_code, '[0-9].*$', '')  in ('" + 系列 + "')")}
),
b as(
select
    t1.dt,
    COALESCE( dic_product.enum_name ,t1.product_id) as 产品名称,
	t1.product_id,
	cast( book_id as varchar ) book_id,
	count( distinct t1.user_id ) as read_num,
	count( distinct case when is_channel_book=1 then t1.user_id end) as yinliu_read_num,
	count( distinct case when is_channel_book=0 then t1.user_id end) as feiyinliu_read_num
from ads.ads_bi_user_read_book_info  t1

  left join dim.dim_dic dic_product  -- 产品名称
   on t1.product_id = dic_product.enum_id
   and dic_product.table_name = 'dwd_consume_user_consume_di'
   and dic_product.dic_column = 'product_id'
where t1.product_id not in (6883 ,6833)
	${if(len(书籍ID) == 0,"","and  book_id in ('" + 书籍ID + "')")}
	${if(len(CORE) == 0,"","and  t1.corever in ('" + CORE + "')")}
	${if(len(是否引流) == 0 ,"",
         "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
	and t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
	${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
group by 1,2,3,4
),
c as(
select
    dt,
    product_id,
	cast( book_id as varchar ) book_id,
	count( distinct user_id ) as "合计消耗人数",
	count( distinct case when is_channel_book=0 then user_id end) as "合计消耗人数非引流",
	count( distinct case when is_channel_book=1 then user_id end) as "合计消耗人数引流",
	sum(amount)/100 as "合消耗金额",
	sum(case when is_channel_book=0 then amount end)/100 as "合消耗金额非引流",
	sum(case when is_channel_book=1 then amount end)/100 as "合消耗金额引流",
	count( distinct case when types=1 then user_id end) as "阅币消耗人数",
	count( distinct case when types=1 and is_channel_book=0 then user_id end) as "阅币消耗人数非引流",
	count( distinct case when types=1 and is_channel_book=1 then user_id end) as "阅币消耗人数引流",
	sum(case when types=1 then amount end)/100 as "阅币消耗金额",
	sum(case when types=1 and is_channel_book=0 then amount end)/100 as "阅币消耗金额非引流",
	sum(case when types=1 and is_channel_book=1 then amount end)/100 as "阅币消耗金额引流",
	count( distinct case when types in(1,2) then user_id end) as "阅币礼券消耗人数" ,
	sum(case when types in(1,2) then amount end)/100 as "阅币礼券消耗金额",
	count(distinct case when types=1 and amount>=1500 then user_id end) as "阅币消耗1500人数",
	count(distinct case when types=1 and amount>=3000 then user_id end) as "阅币消耗3000人数",
	sum(case when  types=1 then con_chapter_nums end) "阅币消耗章节数",
	sum(con_chapter_nums ) "消耗章节数"
from
(
select
	t1.dt,
	t1.product_id,
	book_id,
	t1.user_id,
	is_channel_book,
	types,
	sum(amount) amount,
	sum(con_chapter_nums) con_chapter_nums
from ads.ads_bi_user_book_consume_info t1

where t1.product_id not in (6883,6833)
	and t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
	${if(len(书籍ID) == 0,"","and book_id in ('" + 书籍ID + "')")}
	${if(len(CORE) == 0,"","and t1.corever in ('" + CORE + "')")}
    ${if(len(是否引流) == 0 ,"",
           "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
          ${if(len(解锁类型) == 0,"","and case when types = 1 then '阅币'
                                            when types = 2 then '礼券'
                                            when types = 3 then '赠送币'
                                            when types = 4 then 'VIP' end in ( '" + 解锁类型 + "')")}
	${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}

group by 1,2,3,4,5,6
)a
group by 1,2,3
),

d as(
select
    dt,
	product_id,
	cast( book_id as varchar ) book_id,
	bitmap_union_count(expo_unt) expo_unt,
	bitmap_union_count(cli_unt) cli_unt
 from  (
 SELECT
  dt,
  product_id,
  book_id,
  expo_unt,
  cli_unt
from ads.ads_bi_book_itemexposure_info t1
where  product_id<>6883 and product_id<>6833
	${if(len(书籍ID) == 0,"","and book_id in ('" + 书籍ID + "')")}
	${if(len(CORE) == 0,"","and t1.corever in ('" + CORE + "')")}
   -- and is_channel_book = 0
   ${if(len(是否引流) == 0 ,"",       "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
	and dt >= '${开始日期}'
	and dt <= '${结束日期}'
  ${if(len(终端) == 0,"","and case when mt='ios' then 'iOS' when mt='android' then 'Android' else '其他' end  in ( '" + 终端 + "')")}
UNION all  -- 补充非引流点击
select
  t1.dt,
  t1.product_id ,
  book_id,
  bitmap_agg(t1.user_id ) as expo_unt ,
  bitmap_agg(t1.user_id ) as cli_unt
from ads.ads_bi_user_read_book_info t1

where  t1.dt >= '${开始日期}' and t1.dt <= '${结束日期}'
  and t1.corever = 1
  ${if(len(书籍ID) == 0,"","and  book_id in ('" + 书籍ID + "')")}
  ${if(len(是否引流) == 0 ,"",  "and case when  is_channel_book= 0 then '非引流' end in ('" + 是否引流 + "')")}
  ${if(len(CORE) == 0,"","and t1.corever in ('" + CORE + "')")}
  ${if(len(终端) == 0,"","and case when mt=1 then 'iOS' when mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
group by 1,2,3
 ) d0
group by 1,2,3
),
e as (
    SELECT
	       a.dt
		  ,a.product_id
          ,a.book_id
          ,count(distinct case when serial_number=3 then a.user_id end) "第3章阅读人数"
          ,count(distinct case when serial_number=5 then a.user_id end) "第5章阅读人数"
          ,count(distinct case when serial_number=10 then a.user_id end) "第10章阅读人数"
          ,count(distinct case when serial_number=30 then a.user_id end)  "第30章阅读人数"
    FROM   ads.ads_read_user_chapter_view  AS a
    INNER JOIN
    (
        SELECT  dim_book_chapter_info.book_id
               ,dim_book_chapter_info.chapter_id
               ,dim_book_chapter_info.serial_number
        FROM dim.dim_book_chapter_info
        WHERE serial_number IN (3, 5, 10, 30)
    ) b
    ON a.book_id = b.book_id AND a.chapter_id = b.chapter_id
    LEFT JOIN ads.ads_bi_user_read_book_info AS c
    ON a.user_id = c.user_id AND a.book_id = c.book_id and a.dt = c.dt
	left join dws.dws_user_wide_active_period_ed t2
      on c.user_id = t2.user_id
     and c.dt = t2.dt
	 and t2.period_type = 'ctt'
  where a.product_id<>6883 and a.product_id<>6833
  	${if(len(书籍ID) == 0,"","and  a.book_id in ('" + 书籍ID + "')")}
  ${if(len(是否引流) == 0 ,"",
         "and case when  is_channel_book= 1 then '引流' else '非引流' end in ('" + 是否引流 + "')")}
  	and a.dt >= '${开始日期}'
  	and a.dt <= '${结束日期}'
	${if(len(终端) == 0,"","and case when t2.mt=1 then 'iOS' when t2.mt=4 then 'Android' else '其他' end  in ( '" + 终端 + "')")}
 	${if(len(CORE) == 0,"","and  t2.corever in ('" + CORE + "')")}
  GROUP BY  1,2,3
)

select
    b.dt,
	b.产品名称 as "产品名称",
	b.product_id as productid,
	a.book_id as "书籍id",
	site_id as "书籍语言",
    book_code as "书籍代号",
	book_name as "书籍名称",
	book_nature as "书籍来源",
	new_cname as "书籍分类",
	build_time as "上架时间",
	normal_chapter_num_f as "发布章节",
	expo_unt,
	cli_unt,
	read_num,
	yinliu_read_num,
	feiyinliu_read_num,
	合计消耗人数,
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
from a
left join  b
on a.book_id = b.book_id
left join c
on a.book_id = c.book_id and b.product_id = c.product_id and b.dt = c.dt
left join d
on a.book_id = d.book_id and b.product_id = d.product_id and b.dt = d.dt
left join e
on a.book_id = e.book_id and b.product_id = e.product_id and b.dt = e.dt
where
	1=1
	${if(len(书籍语言) == 0,"","and  site_id in ('" + 书籍语言 + "')")}
    ${if(len(产品名称) == 0,"","and b.产品名称 in ( '" + 产品名称 + "')")}