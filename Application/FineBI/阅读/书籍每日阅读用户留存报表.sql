-------------------------------------------------
-- 应用报表：阅读-书籍维度报表/书籍每日阅读用户留存报表
-------------------------------------------------

WITH z00 as (
SELECT t1.book_id,
  max(coalesce( dic_booknature.enum_name,t2.book_nature)) as book_nature,
  max(coalesce( dic_lang.remarks,t1.lang_id))   as language
from ads.ads_read_retention_stat_p_da t1
left JOIN dim.dim_shuangwen_book_read_consume_info  t2
	on t1.book_id = t2.book_id
left join dim.dim_dic dic_lang  -- 注册/投放语言
  on t1.lang_id = dic_lang.enum_id
  and dic_lang.table_name = 'dim_producttype'
  and dic_lang.dic_column = 'language_id'
left join dim.dim_dic  dic_booknature  -- 书籍来源
  on t2.book_nature = dic_booknature.enum_id
  and dic_booknature.table_name = 'dim_shuangwen_book_read_consume_info'
  and dic_booknature.dic_column = 'book_nature'
left join dim.dim_dic  dic_mt  -- mt
 on t1.mt = dic_mt.enum_id
 and dic_mt.table_name = 'dim_user_accountinfo_df'
 and dic_mt.dic_column = 'mt'
  where t1.dt >= '${开始日期}' and t1.dt <= '${结束日期}'
    ${if(len(书籍ID) == 0,"","and  t1.book_id in ('" + 书籍ID + "')")}
    ${if(len(书籍语言) == 0,"","and dic_lang.remarks in ('" + 书籍语言 + "')")}
	${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
	${if(len(媒体用户类型) == 0,"","and case  when source_user_tp=1 then '新设备'
		when source_user_tp=2 then '归因老用户'
		when source_user_tp=3 then 'other'
		end in ('" + 媒体用户类型 + "')")}
    ${if(len(书籍代号) == 0,"","and t1.book_code in  ('" + 书籍代号 + "')")}
	${if(len(书籍来源) == 0,"","and dic_booknature.enum_name in ('" + 书籍来源 + "')")}
	${if(len(书籍ID) + len(书籍代号) + len(书籍语言) +len(书籍来源)  == 0,
	  "and consume_amount > 1000  group by t1.book_id  limit 3 ",
	  "group by t1.book_id ")} -- 默认筛选
    )
SELECT
         t1.book_id   as `书籍ID`
         ,max(t2.language)  as `语言ID`
         ,max(t1.book_name) as `书籍名称`
         ,max(t1.book_code ) as `书籍代号`
         ,max(t2.book_nature) as `书籍来源`
	     ,concat('D',date_stat_type)              as `阅读天数`
	     ,bitmap_union_COUNT(first_read_users)                                    AS `书籍阅读人数`
	     ,bitmap_union_COUNT(read_users)                                          AS `DAYN阅读人数`
	     ,bitmap_union_COUNT(read_users) /bitmap_union_COUNT(first_read_users)    AS `阅读留存率`
	     ,1 - bitmap_union_COUNT(read_users)/bitmap_union_COUNT(first_read_users) AS `流失率`
	     ,SUM(consume_amount/100)                                                 AS `阅币消费金额`
	     ,bitmap_union_COUNT(consume_users)                                       AS `阅币消费人数`
	     ,bitmap_union_COUNT(consume_users)/bitmap_union_COUNT(first_read_users)   AS `消费留存率`
         ,null as  `D3留存`
         ,null as  `D7留存`
	FROM ads.ads_read_retention_stat_p_da t1
    inner JOIN z00 t2 on t1.book_id = t2.book_id
    left join dim.dim_dic  dic_mt  -- mt
     on t1.mt = dic_mt.enum_id
     and dic_mt.table_name = 'dim_user_accountinfo_df'
     and dic_mt.dic_column = 'mt'
	where t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
    -- and t1.book_id
	${if(len(终端) == 0,"","and dic_mt.enum_name  in ('" + 终端 + "')")}
	${if(len(媒体用户类型) == 0,"","and case  when source_user_tp=1 then '新设备'
		when source_user_tp=2 then '归因老用户'
		when source_user_tp=3 then 'other'
		end in ('" + 媒体用户类型 + "')")}
	GROUP BY  t1.book_id
	         ,t1.date_stat_type
UNION  all
	SELECT
         t1.book_id   as `书籍ID`
         ,max(t2.language)  as `语言ID`
         ,max(t1.book_name) as `书籍名称`
         ,max(t1.book_code ) as `书籍代号`
         ,max(t2.book_nature) as `书籍来源`
	       ,'合计'                  as `阅读天数`
	       ,bitmap_union_COUNT(first_read_users)                                                                  AS `书籍阅读人数`
	       ,bitmap_union_COUNT(read_users)                                            AS `DAYN阅读人数`
	       ,bitmap_union_COUNT(if(date_stat_type = 0,null ,read_users))/bitmap_union_COUNT(first_read_users )     AS `阅读留存率`
	       ,1 - bitmap_union_COUNT(if(date_stat_type = 0,null ,read_users))/bitmap_union_COUNT(first_read_users ) AS `流失率`
	       ,SUM(consume_amount/100)                                                                               AS `阅币消费金额`
	       ,bitmap_union_COUNT(consume_users)                                                                     AS `阅币消费人数`
	       ,bitmap_union_COUNT(consume_users)/bitmap_union_COUNT(first_read_users)                                AS `消费留存率`
         ,bitmap_union_COUNT(if(date_stat_type = 2 ,d7_read_users,null))/bitmap_union_COUNT(first_read_users)   AS `D3留存`
         ,bitmap_union_COUNT(if(date_stat_type = 6 ,d7_read_users,null))/bitmap_union_COUNT(first_read_users)   AS `D7留存`
	FROM ads.ads_read_retention_stat_p_da t1
	    inner JOIN z00 t2 on t1.book_id = t2.book_id
    left join dim.dim_dic  dic_mt  -- mt
     on t1.mt = dic_mt.enum_id
     and dic_mt.table_name = 'dim_user_accountinfo_df'
     and dic_mt.dic_column = 'mt'
	where t1.dt >= '${开始日期}' and t1.dt <= '${结束日期}'
	${if(len(终端) == 0,"","and dic_mt.enum_name  in ('" + 终端 + "')")}
	${if(len(媒体用户类型) == 0,"","and case  when source_user_tp=1 then '新设备'
		when source_user_tp=2 then '归因老用户'
		when source_user_tp=3 then 'other'
		end in ('" + 媒体用户类型 + "')")}
	GROUP BY  t1.book_id
 --  Z00筛选符合条件书籍后关联主表