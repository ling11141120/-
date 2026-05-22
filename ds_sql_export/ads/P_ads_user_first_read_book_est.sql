----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_first_read_book_est
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : ads_user_first_read_book_est
-- task_version     : 2
-- update_time      : 2025-02-19 16:50:54
-- sql_path         : \starrocks\tbl_ads_user_first_read_book_est\ads_user_first_read_book_est
----------------------------------------------------------------
-- SQL语句
insert into ads.`ads_user_first_read_book_est`
WITH z1 AS
(
       SELECT  t1.dt
              ,t1.product_id
              ,t1.user_id
              ,t3.corever
              ,t1.book_id
              ,hours_add(fst_read_tm,13)                                                                            AS fst_read_tm
              ,t2.source
              ,t2.book_id                                                                                           AS `ad_source_book`
              ,t4.activity_link
              ,(LENGTH(activity_link) - LENGTH(REPLACE(activity_link,'_','')))                                      AS `link_length`
              ,CASE WHEN t2.book_id is not null THEN '投放书籍'  ELSE '站内' END                                          AS `is_ad_source`
              ,first_read_source_name AS first_read_source_name
       -- , split(t4.activity_link , '_')[1] AS `source_position`
              ,CASE WHEN t2.book_id is not null THEN '投放书籍'
                    WHEN split(t4.activity_link ,'_')[1] IN ('flashscreen','popup','netmonitor','centertab','banner','halfscreen-banner','rewards-banner','special-banner','reading','chapterpush','news','batterybar','returnrecommend','topbookshelf','trends-tag','trends-book','push','nextbook','bookshelf-add','bookshelf-add0','searchbar','quit-recommend','actcenter') THEN 'TAG资源位'
                    WHEN split(t4.activity_link ,'_')[1] IN ('bookstore','endchapter','bookdetail','pushbookpop','searchpage','vippage','walfarecenter') THEN '书籍分发' --
                    WHEN split(t4.activity_link , '_')[1] IN ('EDN') THEN 'EDN'
                    WHEN split(t4.activity_link ,'_')[1] IN ('bookshelf') THEN '书架'
                    WHEN split(t4.activity_link ,'_')[1] IN ('authorpage') THEN '作者主页'  ELSE '其他' END               AS `source_position_type`
              ,CASE WHEN t2.book_id is not null THEN '投放书籍'
                    WHEN split(t4.activity_link ,'_')[1] = 'flashscreen' THEN '闪屏'
                    WHEN split(t4.activity_link ,'_')[1] = 'popup' THEN '弹窗'
                    WHEN split(t4.activity_link ,'_')[1] = 'netmonitor' THEN '悬浮窗'
                    WHEN split(t4.activity_link ,'_')[1] = 'centertab' THEN 'TAB推荐'
                    WHEN split(t4.activity_link ,'_')[1] = 'banner' THEN '书城Banner'
                    WHEN split(t4.activity_link ,'_')[1] = 'halfscreen-banner' THEN '半屏Banner'
                    WHEN split(t4.activity_link ,'_')[1] = 'rewards-banner' THEN '福利中心Banner'
                    WHEN split(t4.activity_link ,'_')[1] = 'special-banner' THEN '专题榜单BANNER'
                    WHEN split(t4.activity_link ,'_')[1] = 'reading' THEN '阅读页触达'
                    WHEN split(t4.activity_link ,'_')[1] = 'chapterpush' THEN '章末推送'
                    WHEN split(t4.activity_link ,'_')[1] = 'news' THEN '私信'
                    WHEN split(t4.activity_link ,'_')[1] = 'batterybar' THEN '电池栏'
                    WHEN split(t4.activity_link ,'_')[1] = 'returnrecommend' THEN '阅读器返回推'
                    WHEN split(t4.activity_link ,'_')[1] = 'topbookshelf' THEN '书架顶部'
                    WHEN split(t4.activity_link ,'_')[1] = 'trends-tag' THEN '搜索热词-活动标签'
                    WHEN split(t4.activity_link ,'_')[1] = 'trends-book' THEN '搜索热词-书籍推荐'
                    WHEN split(t4.activity_link ,'_')[1] = 'push' THEN 'PUSH'
                    WHEN split(t4.activity_link ,'_')[1] = 'nextbook' THEN '串书'
                    WHEN split(t4.activity_link ,'_')[1] = 'bookshelf-add' THEN '定时推'
                    WHEN split(t4.activity_link ,'_')[1] = 'bookshelf-add0' THEN '装机推'
                    WHEN split(t4.activity_link ,'_')[1] = 'searchbar' THEN '搜索栏推荐'
                    WHEN split(t4.activity_link ,'_')[1] = 'quit-recommend' THEN '返回推书'
                    WHEN split(t4.activity_link ,'_')[1] = 'actcenter' THEN '活动中心'
                    WHEN split(t4.activity_link ,'_')[1] = 'bookstore' THEN '书城'
                    WHEN split(t4.activity_link ,'_')[1] = 'endchapter' THEN '末页推'
                    WHEN split(t4.activity_link ,'_')[1] = 'bookdetail' THEN '详情页'
                    WHEN split(t4.activity_link ,'_')[1] = 'pushbookpop' THEN '推书弹窗'
                    WHEN split(t4.activity_link ,'_')[1] = 'searchpage' THEN '搜索中间页'
                    WHEN split(t4.activity_link ,'_')[1] = 'vippage' THEN 'VIP专题落地页'
                    WHEN split(t4.activity_link ,'_')[1] = 'walfarecenter' THEN '福利中心书籍'
                    WHEN split(t4.activity_link ,'_')[1] = 'bookshelf' THEN '书架'
                    WHEN split(t4.activity_link ,'_')[1] = 'authorpage' THEN '作者主页'  ELSE '其他' END                  AS `source_position_name`
              ,CASE WHEN split(t4.activity_link ,'_')[2] = '2' THEN 'PUSH'
                    WHEN split(t4.activity_link ,'_')[2] = '4' THEN '推书（指定书籍）'
                    WHEN split(t4.activity_link ,'_')[2] = '7' THEN '组合活动'
                    WHEN split(t4.activity_link ,'_')[2] = '8' THEN '推书（书单）' --
                    WHEN split(t4.activity_link ,'_')[2] = '13' THEN '限免卡活动'
                    WHEN split(t4.activity_link ,'_')[2] = '22' THEN '专题活动'  ELSE '无' END                           AS `activity_type`
       FROM dws.dws_user_first_read_book_est_temp t1
       LEFT JOIN ads.ads_user_install_info_view t2
       ON t1.book_id = t2.book_id AND t1.user_id = t2.user_id
       LEFT JOIN dim.dim_user_account_info_view t3
       ON t1.user_id = t3.id
       LEFT JOIN
       (
              SELECT  distinct_id
                     ,book_id
                     ,min_by(send_id,event_tm)
                     ,min_by(activity_link,event_tm)           AS activity_link
                     ,min_by(first_read_source_name ,event_tm) AS first_read_source_name
              FROM ads.ads_sensors_production_startreadingchapter_view
              WHERE dt >= '${bf_3_dt}' -- AND distinct_id = '171852089' -- AND book_id = '13565409'
              GROUP BY  distinct_id
                       ,book_id
       ) t4
       ON t1.book_id = t4.book_id AND t1.user_id = t4.distinct_id
       WHERE t1.dt >= '${bf_3_dt}'
)
SELECT  date(`fst_read_tm`) as dt
		,product_id
       ,user_id
	   ,book_id
       ,corever
       ,fst_read_tm
       ,source
       ,ad_source_book
       ,activity_link
       ,source_position_type
       ,source_position_name
       ,activity_type
       ,CASE WHEN source_position_type = 'TAG资源位' THEN split(activity_link ,'_')[3]
             WHEN source_position_type = 'EDM' THEN split(activity_link ,'_')[3]  ELSE 0 END    AS activity_id -- activity_id
       ,CASE WHEN source_position_type = 'TAG资源位' THEN split(activity_link ,'_')[4]  ELSE 0 END AS strategy_id -- strategy_id
       ,CASE WHEN source_position_type = 'TAG资源位' THEN split(activity_link ,'_')[5]  ELSE 0 END AS group_id -- group_id
       ,CASE WHEN source_position_type = '书籍分发' THEN split(activity_link ,'_')[2]  ELSE 0 END   AS program_id -- program_id
       ,CASE WHEN source_position_type = '书籍分发' THEN split(activity_link ,'_')[3]  ELSE 0 END   AS chanel_id -- chanel_id
       ,CASE WHEN source_position_type = '书籍分发' THEN split(activity_link ,'_')[4]  ELSE 0 END   AS list_id -- list_id
       ,CASE WHEN source_position_type = '书籍分发' THEN split(activity_link ,'_')[5]  ELSE 0 END   AS book_list_id -- book_list_id
       ,first_read_source_name
	   ,now() as etl_tm
FROM z1
WHERE date(`fst_read_tm`) = '${bf_1_dt}'
;
