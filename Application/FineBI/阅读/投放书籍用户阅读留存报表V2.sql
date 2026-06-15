-------------------------------------------------
-- 应用报表：阅读-书籍维度报表/投放书籍阅读留存报表
-------------------------------------------------

with z1 as (
select
  dt as `日`,
  t1.book_id,
  REGEXP_REPLACE(t1.book_code, '[0-9].*$', '') as `书籍系列`,
  concat(book_code,'/',dic_lang.remarks) as `语言`,
   book_chapter.max_serial_number as '发布章节数',
  book_chapter.total_length as '发布总字数',
  days_sub(dt,DAYOFWEEK(dt)-1) as `周`,
  days_sub(dt,day(dt)-1) as `月`,
  sum(fst_read_unt) as `首次阅读人数`,
  sum(if(days_num = 0,read_unt,0)) as `D0阅读人数`,
  sum(if(days_num = 1,read_unt,0)) as `D1阅读人数`,
  sum(if(days_num = 2,read_unt,0)) as `D2阅读人数`,
  sum(if(days_num = 3,read_unt,0)) as `D3阅读人数`,
  sum(if(days_num = 4,read_unt,0)) as `D4阅读人数`,
  sum(if(days_num = 5,read_unt,0)) as `D5阅读人数`,
  sum(if(days_num = 6,read_unt,0)) as `D6阅读人数`,
  sum(if(days_num = 7,read_unt,0)) as `D7阅读人数`
from ads.ads_sr_bi_read_consume_p_di t1
left join dim.dim_dic dic_lang  -- 注册/投放语言
on t1.lang_id  = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_dic  dic_mt  -- mt
 on t1.mt = dic_mt.enum_id
 and dic_mt.table_name = 'dim_user_accountinfo_df'
 and dic_mt.dic_column = 'mt'
 left join
(
    select book_id
    ,max(serial_number ) max_serial_number
    ,sum(chapter_length ) total_length
    from dim.dim_book_chapter_info
    where public_time<days_add(CURDATE(),1)
    group by 1
) book_chapter
on t1.book_id=book_chapter.book_id

  where t1.dt >= '${开始日期}'
	and t1.dt <= '${结束日期}'
    ${if(len(书籍ID) == 0,"","and t1.book_id in ('" + 书籍ID + "')")}
	${if(len(SOURCE) == 0,"","and source in ('" + SOURCE + "')")}
	${if(len(书籍语言) == 0,"","and dic_lang.remarks in ('" + 书籍语言 + "')")}
	${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
	${if(len(媒体用户类型) == 0,"","and case  when source_user_tp=1 then '新设备'
		when source_user_tp=2 then '归因老用户'
		when source_user_tp=3 then 'other'
		end in ('" + 媒体用户类型 + "')")}
   	${if(len(书籍代号) == 0,"","and book_code in  ('" + 书籍代号 + "')")}
     ${if(len(优化师) == 0,"","and  t1.nick_name in ('" + 优化师 + "')")}
     ${if(len(书籍系列) == 0,"","and REGEXP_REPLACE(t1.book_code, '[0-9].*$', '')  in ('" + 书籍系列 + "')")}
group by 1,2,3,4,5,6,7 )

, z2 as (
select
    dt
	,book_id
    ,count(1) as `read_num`
	,count(if( read_serial_number < normal_chapter_num_f * 0.2 or read_serial_number is null ,1,null))as `0~20%`
	,count(if( normal_chapter_num_f * 0.2 <= read_serial_number and read_serial_number < normal_chapter_num_f * 0.4,1,null)) as `20~40%`
	,count(if( normal_chapter_num_f * 0.4 <= read_serial_number and read_serial_number < normal_chapter_num_f * 0.6,1,null)) as `40~60%`
	,count(if( normal_chapter_num_f * 0.6 <= read_serial_number and read_serial_number < normal_chapter_num_f * 0.8,1,null)) as `60~80%`
	,count(if( normal_chapter_num_f * 0.8 <= read_serial_number  ,1,null)) as `80~100%`
    ,count(if( serial_number_r >=1 ,1,null)) serial_1
    ,count(if( serial_number_r >=31 ,1,null)) serial_30
    ,count(if( serial_number_r >=61 ,1,null)) serial_60
    ,count(if( serial_number_r >=91 ,1,null)) serial_90
    ,count(if( serial_number_r >=121 ,1,null)) serial_120
    ,count(if( serial_number_r >=151 ,1,null)) serial_150
    ,count(if( serial_number_r >=181 ,1,null)) serial_180
    ,count(if( serial_number_r >=211 ,1,null)) serial_210
    ,count(if( serial_number_r >=251 ,1,null)) serial_250
    ,count(if( serial_number_r >=301 ,1,null)) serial_300
    ,count(if( serial_number_r >=351 ,1,null)) serial_350
    ,count(if( serial_number_r >=401 ,1,null)) serial_400
    ,count(if( serial_number_r >=451 ,1,null)) serial_450
    ,count(if( serial_number_r >=501 ,1,null)) serial_500
from
(
	SELECT
       z1.dt
       ,z1.book_id
       ,z1.user_id
       ,MAX(z2.normal_chapter_num_f) AS normal_chapter_num_f  -- 发布总章节
       ,MAX(z3.read_serial_number) AS read_serial_number
       ,max(z3.serial_number_r) as serial_number_r
-- FROM ads.ads_sr_bi_read_consume_p_di_temp z1
FROM ads.ads_sr_bi_read_user_consume_p_di z1
left join dim.dim_dic dic_lang  -- 注册/投放语言
on z1.lang_id  = dic_lang.enum_id
and dic_lang.table_name = 'dim_producttype'
and dic_lang.dic_column = 'language_id'
left join dim.dim_dic  dic_mt  -- mt
 on z1.mt = dic_mt.enum_id
 and dic_mt.table_name = 'dim_user_accountinfo_df'
 and dic_mt.dic_column = 'mt'
LEFT JOIN dim.dim_shuangwen_book_read_consume_info z2
ON z1.book_id = z2.book_id
LEFT JOIN
(
	SELECT  hours_add(t1.fst_time,-13) AS dt
	       ,t1.user_id
	       ,t1.book_id
	       ,t1.chapter_id chapter_id
	       ,serial_number                 AS read_serial_number
           ,serial_number_r              as serial_number_r  -- 付费章的序号（付费第一章算1）
--    from dwd.dwd_read_user_chapter_view    -- 【20260211留存使用解锁来计算】
	FROM dwm.dwm_consume_user_consume_mild_ed t1
	LEFT JOIN (
    select book_id,
          chapter_id,
          serial_number,
          serial_number - min(serial_number) over(partition by book_id,free_chapter_num)+ 1 as  serial_number_r
  from dim.dim_book_chapter_info ) t2
	ON t1.book_id = t2.book_id AND t1.chapter_id = t2.chapter_id
	WHERE dt >= date_add('${开始日期}',-1)
	AND dt <= date_add('${结束日期}',31)   -- + 30天
    and types in (1,2)  -- 阅币和礼券

) z3
ON z1.book_id = z3.book_id AND z1.user_id = z3.user_id AND z1.dt >= date_add(z3.dt, -30)
 where z1.dt >= '${开始日期}'
	and z1.dt <= '${结束日期}'
    ${if(len(书籍ID) == 0,"","and z1.book_id in ('" + 书籍ID + "')")}
	${if(len(SOURCE) == 0,"","and source in ('" + SOURCE + "')")}
	${if(len(书籍语言) == 0,"","and dic_lang.remarks in ('" + 书籍语言 + "')")}
	${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
	${if(len(媒体用户类型) == 0,"","and case  when source_user_tp=1 then '新设备'
		when source_user_tp=2 then '归因老用户'
		when source_user_tp=3 then 'other'
		end in ('" + 媒体用户类型 + "')")}
   	${if(len(书籍代号) == 0,"","and z1.book_code in  ('" + 书籍代号 + "')")}
     ${if(len(优化师) == 0,"","and  z1.nick_name in ('" + 优化师 + "')")}
     ${if(len(书籍系列) == 0,"","and REGEXP_REPLACE(z1.book_code, '[0-9].*$', '')  in ('" + 书籍系列 + "')")}
GROUP BY  1 ,2 ,3
) z5
group by 1 ,2
)

select z1.*,
z2.read_num,
`0~20%`,
`20~40%`,
`40~60%`,
`60~80%`,
`80~100%`,
 serial_1,
 serial_30,
 serial_60,
 serial_90,
 serial_120,
 serial_150,
 serial_180,
 serial_210,
 serial_250,
 serial_300,
 serial_350,
 serial_400,
 serial_450,
serial_500
from z1
left join z2
  on z1.`日` = z2.dt
and z1.book_id = z2.book_id
