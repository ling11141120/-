-------------------------------------------------
-- 应用报表：阅读-策略效果报表/内容活动实验报表
-------------------------------------------------

WITH t123 as
(
	SELECT  *
	FROM
	(
		SELECT  t1.*
		       ,t2.country
		       ,dic_mt.enum_name `终端`
		       ,dic_lang.remarks `注册语言`
		       ,CASE WHEN t2.country = 'US' THEN 'US'
		             WHEN t3.level is null THEN '未分类'
                 ELSE t3.level END `国家等级`
		       ,t2.corever
		FROM
		(
			SELECT
            case
		       ${"when group_id in (" + group_id1 + ")  then '实验组1' "}
			   ${"when group_id in (" + group_id2 + ")  then '实验组2' "}
			   ${"when group_id in (" + group_id3 + ")  then '实验组3' "}
			   ${"when group_id in (" + group_id4 + ")  then '实验组4' "}
			   ${"when group_id in (" + group_id5 + ")  then '实验组5' "}
			   ${"when group_id in (" + group_id6 + ")  then '对照组' "}
            end group_type
			       ,group_id
			       ,product_id
			       ,user_id
			       ,MIN(dt) min_day
			       ,MIN(create_time) min_time
			       ,ROW_NUMBER() over(PARTITION BY product_id,user_id ORDER BY  MIN(create_time)) row_1
			FROM ads.ads_market_realtime_group_log_view
			WHERE op_type = 0
			AND dt >= date_add('${开始时间}', -1)
			AND dt <= date_add('${结束时间}', 1)
			AND create_time >= '${开始时间}'
			AND create_time <= '${结束时间}'
			AND group_id IN (${group_id1}, ${group_id2}, ${group_id3}, ${group_id4}, ${group_id5}, ${group_id6}) -- 必填
			GROUP BY  1,2,3,4
		) t1
		LEFT JOIN dim.dim_user_account_info_view t2
		ON t1.product_id = t2.product_id AND t1.user_id = t2.id
		LEFT JOIN dim.dim_countrylevel t3
		ON t2.product_id = t3.product_id AND t2.country = t3.short_name
		LEFT JOIN dim.dim_dic dic_lang -- 注册/投放语言
		ON t2.current_language2 = dic_lang.enum_id AND dic_lang.table_name = 'dim_producttype' AND dic_lang.dic_column = 'language_id'
		LEFT JOIN dim.dim_dic dic_mt -- mt
		ON t2.mt = dic_mt.enum_id AND dic_mt.table_name = 'dim_user_accountinfo_df' AND dic_mt.dic_column = 'mt'
	) tt
	WHERE row_1 = 1
   ${IF(len(终端) == 0, "", "and  终端 in ('" + 终端 + "')")}
   ${if(len(国家等级) == 0, "", "and  国家等级 in ('" + 国家等级 + "')")}
)

select
  group_type as `组别`,
  min_day as `入包时间`,
  count(distinct t123.user_id) as `入包UV`,
  count(distinct t1.userid) as `嗨点策略命中UV`,
  count(distinct t2.user_id) as `嗨点曝光UV`,
  ${IF(len(嗨点策略ID) == 0,
 "count(distinct if(t3.excitingpoint_strategy <> 0 and t3.book_id = t2.book_id,t3.identity_login_id,null)) as `嗨点解锁UV`,",
 "count(distinct if(t3.excitingpoint_strategy in("+ 嗨点策略ID +") and t3.book_id = t2.book_id,t3.identity_login_id,null)) as `嗨点解锁UV`,")}
  count(distinct t3.identity_login_id) as `章节解锁UV`

from t123
left join ads.ads_Log_UserHighBookStrategyLog_view t1  -- 嗨点策略下发
	on t123.user_id = t1.userid
	and t123.min_time <= t1.createtime
    and t1.createtime >= '${活动开始时间}'
    and t1.createtime <= '${活动结束时间}'
    ${IF(len(嗨点策略ID) == 0, "", "and  StrategyId in ('" + 嗨点策略ID + "')")}
left join ads.ads_read_user_chapter_view t2  -- 阅读表
	on t1.UserId  = t2.user_id
	and t1.BookId  = t2.book_id
	and t1.chapterid = t2.chapter_id
	and t1.createtime <= t2.create_time
    and t2.dt >= '${活动开始时间}'
    and t2.dt <= '${活动结束时间}'
	-- and t2.dt >= '2024-10-01'
left join ads.ads_sensors_production_unlockchapter_view  t3  -- 章节解锁
	on t123.user_id = t3.identity_login_id
    and t3.dt >= '${活动开始时间}'
    and t3.dt <= '${活动结束时间}'
    and t123.min_time <= t3.event_tm
group by  group_type,  min_day