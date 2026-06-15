-------------------------------------------------
-- 应用报表：阅读-书籍维度报表/收入位报表
-------------------------------------------------

WITH book_info AS
(
    SELECT  cast( book_id  AS varchar ) book_id
           ,book_name as 书籍名称
           ,book_code as 书籍代号
           ,coalesce(dic_booklang.enum_name,t1.site_id2)  AS 书籍语言
           ,build_time as 上架时间
           ,new_cname as 书籍分类
           ,coalesce(dic_booknature.enum_name ,t1.book_nature) AS 书籍来源
           ,cast( normal_chapter_num_f    AS varchar ) 发布章节
           ,(select max(chapter_id)  from dim.dim_book_chapter_info t2 where Free_Chapter_Num = 0   and t1.book_id = t2.book_id  )  as max_free_chapter
    FROM dim.dim_shuangwen_book_read_consume_info t1
  left join dim.dim_dic  dic_booklang  --书籍语言 332，333
  on t1.site_id2 = dic_booklang.enum_id
  and dic_booklang.table_name = 'dws_content_translate_remuneration_d'
  and dic_booklang.dic_column = 'site_id'
  left join dim.dim_dic  dic_booknature  -- 书籍来源
  on t1.book_nature = dic_booknature.enum_id
  and dic_booknature.table_name = 'dim_shuangwen_book_read_consume_info'
  and dic_booknature.dic_column = 'book_nature'
  where 1=1
  ${if(len(书籍语言) == 0,"","and dic_booklang.enum_name in ('" + 书籍语言 + "')")}
  ${if(len(书籍ID) == 0,"","and  book_id in ('" + 书籍ID + "')")}
  ${if(len(书籍代号) == 0,"","and  book_code in ('" + 书籍代号 + "')")}
  ${if(len(书籍来源) == 0,"","and coalesce(dic_booknature.enum_name ,t1.book_nature) in ('" + 书籍来源 + "')")}
)
SELECT
    z1.*
    ,'${开始时间}'   as 开始推荐时间
    ,'${结束时间}'  as 推荐结束时间
    ,z2.书籍名称    ,z2.书籍代号    ,z2.书籍语言    ,z2.书籍来源    ,z2.书籍分类    ,z2.上架时间    ,z2.发布章节
FROM
(
    SELECT
           CASE WHEN is_source = 1 THEN '引流用户'  ELSE '非引流用户' END is_source
           ,t1.site_id
           ,t1.book_id
           ,COUNT(distinct t1.user_id) 阅读UV
           ,SUM(if(t2.dt <= '${结束时间}', consume,0))   AS `合计消费金额`
           ,COUNT(distinct if(t2.dt <= '${结束时间}' and tps = 2 ,t2.user_id,null))     AS 合计消费人数
           ,SUM(if(t2.dt <= '${结束时间}' and types = 1 ,consume,0))     AS 阅币消费金额
           ,COUNT(distinct if(t2.dt <= '${结束时间}' and types = 1 ,t2.user_id,null))    AS 阅币消费人数
            ,${if(统计周期='H24',
            'SUM(if(t2.dt <= date_add(t1.dt,0) and tps = 2,consume,0))    AS DN合计消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,0) and tps = 2, t2.user_id, null))  AS DN合计消费人数
            ,SUM(if(t2.dt <= date_add(t1.dt,0) and types = 1 and tps = 2,consume,0))  AS DN阅币消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,0) and types = 1 and tps = 2,t2.user_id,null)) AS DN阅币消费人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,0) and tps = 1 and mark_pay = 1, t2.user_id, null))AS DN付费章阅读人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,0) and tps = 1 and mark_max_free = 1, t2.user_id, null)) AS DN付费前章阅读人数
            ,"H24" ',
            if(统计周期='D3',
            'SUM(if(t2.dt <= date_add(t1.dt,3) and tps = 2,consume,0))    AS DN合计消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,3) and tps = 2, t2.user_id, null))  AS DN合计消费人数
            ,SUM(if(t2.dt <= date_add(t1.dt,3) and types = 1 and tps = 2,consume,0))  AS DN阅币消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,3) and types = 1 and tps = 2,t2.user_id,null)) AS DN阅币消费人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,3) and tps = 1 and mark_pay = 1, t2.user_id, null)) AS DN付费章阅读人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,3) and tps = 1 and mark_max_free = 1, t2.user_id, null)) AS DN付费前章阅读人数
            ,"D3"',
            if(统计周期='D7',
            'SUM(if(t2.dt <= date_add(t1.dt,7) and tps = 2,consume,0))    AS DN合计消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,7) and tps = 2, t2.user_id, null))  AS DN合计消费人数
            ,SUM(if(t2.dt <= date_add(t1.dt,7) and types = 1 and tps = 2,consume,0))  AS DN阅币消费金额
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,7) and types = 1 and tps = 2,t2.user_id,null)) AS DN阅币消费人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,7) and tps = 1 and mark_pay = 1, t2.user_id, null)) AS DN付费章阅读人数
            ,COUNT(distinct if(t2.dt <= date_add(t1.dt,7) and tps = 1 and mark_max_free = 1, t2.user_id, null)) AS DN付费前章阅读人数
            ,"D7" ',
                ,0
                )))}
    FROM ads.ads_read_90_first_all_read_mid2_view t1 -- 东八区
    LEFT JOIN
    (  -- ----------------阅读的明细----------------------------------
    select dt,user_id,tt1.book_id,1 as tps,0 as types ,0 as consume ,
    COUNT(distinct if(chapter_id <=max_free_chapter,1,null)) as mark_free,
    COUNT(distinct if(chapter_id = max_free_chapter,1,null)) as mark_max_free,
    COUNT(distinct if(chapter_id > max_free_chapter,1,null)) as mark_pay
      from dwd.dwd_read_user_chapter_view  tt1
        inner JOIN book_info   ON tt1.book_id = book_info.book_id
        where dt >= '${开始时间}'
          and dt <= date_add('${结束时间}' ,7)
        group by 1,2,3,4
   union all -- ---------章节解锁的明细-----------------------
    select  dt,user_id,tt1.book_id,2 as tps,types,sum(con_chp_amount)/100 as consume ,
    COUNT(distinct if(chapter_id <=max_free_chapter,1,null)) as mark_free,
    COUNT(distinct if(chapter_id = max_free_chapter,1,null)) as mark_max_free,
    COUNT(distinct if(chapter_id > max_free_chapter,1,null)) as mark_pay
         from  dwm.dwm_consume_user_consume_mild_ed tt1
        inner JOIN book_info ON tt1.book_id = book_info.book_id
        where dt >= '${开始时间}'
           and dt <= date_add('${结束时间}' ,7)
           and types in (1,2)
        group by 1,2,3,4,5
    ) t2
    ON t1.user_id = t2.user_id AND t1.book_id = t2.book_id
     inner JOIN book_info   -- 取交集
         ON t1.book_id = book_info.book_id
    where t1.dt >= '${开始时间}'
      and t1.dt <= '${结束时间}'
      ${if(len(是否引流) == 0,"","and CASE WHEN is_source = 1 THEN '引流用户'  ELSE '非引流用户' END  in ('" + 是否引流 + "')")}
    GROUP BY  1             ,2             ,3
) z1
inner JOIN book_info z2
ON z1.book_id = z2.book_id