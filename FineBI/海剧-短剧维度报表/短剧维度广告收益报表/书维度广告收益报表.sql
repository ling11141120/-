select
	dt,
	t1.book_id ,
	t3.series_name,
	t3.series_code,
	amt
from dws.dws_advertisement_user_position_amt_ed t1
left join dim.dim_sv_ads_position_view t2
on t1.positions =t2.ad_position
left join dim.dim_short_video_series_view t3
on t1.book_id=t3.series_id
left join dim.dim_dic  dic_mt  -- mt
on t1.mt = dic_mt.enum_id
	and dic_mt.table_name = 'dim_user_accountinfo_df'
	and dic_mt.dic_column = 'mt'
where
	t1.product_id=6833
	and appver >='3.3.0'
	and dt between '${开始时间}' and '${结束时间}'
	${if(len(CORE) == 0,"","and t1.core in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
	${if(len(广告类型) == 0,"","and ad_show_type_name in ('" + 广告类型 + "')")}
	${if(len(广告位置) == 0,"","and ad_position_name in ('" + 广告位置 + "')")}
	${if(len(书籍ID) == 0,"","and t1.book_id in ('" + 书籍ID + "')")}
	${if(len(书籍代号) == 0,"","and t3.series_code in ('" + 书籍代号 + "')")}