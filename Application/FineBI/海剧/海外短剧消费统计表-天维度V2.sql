-------------------------------------------------
-- 应用报表：海剧-短剧维度报表/海外短剧消费统计报表
-------------------------------------------------

-- 剧维度的观看、消费数据
with z1 as(
SELECT
	dt,
    series_id,
    max(series_name) series_name,
    max(series_code) series_code,
    max(series_tp) series_tp,
    max(last_epis) last_epis,
    min(publish_tm) publish_tm,
  	max(is_toufang) is_toufang,
    -- bitmap_union_count(video_watch_user_bitmap) watch_user,
    bitmap_union_count(video_consume_user_bitmap) consume_user,
    bitmap_union_count(video_coin_consume_user_bitmap) consume_user_coin,
    sum(video_consume_amt) consume_amount,
    sum(video_coin_consume_amt) consume_amount_coin
from
    (
    select
     t1.*,
     dic_lang.remarks  reg_language,
     dic_mt.enum_name as  `平台`
    from ads.ads_bi_short_video_consume_stat  t1
      left join dim.dim_dic dic_lang  -- 注册/投放语言
      on t1.series_language = dic_lang.enum_id
      and dic_lang.table_name = 'dim_producttype'
      and dic_lang.dic_column = 'language_id'
     left join dim.dim_dic  dic_mt  -- mt
     on t1.mt = dic_mt.enum_id
     and dic_mt.table_name = 'dim_user_accountinfo_df'
     and dic_mt.dic_column = 'mt'
    WHERE
		product_id = 6833
		and dt >= '${开始时间}' and dt<= '${结束时间}'
		${if(是否引流=='全部用户',"and is_toufang=0",
		if(是否引流=='引流用户',"and is_toufang=1"," and is_toufang=2") )}
		${if(len(短剧ID) == 0,"","and  series_id in ('" + 短剧ID + "')")}
		${if(len(SOURCE) == 0,"","and  source in ('" + SOURCE + "')")}
       	${if(len(短剧语言) == 0,"","and  dic_lang.remarks in ('" + 短剧语言 + "')")}
        ${if(len(终端) == 0,"","and  dic_mt.enum_name  in ('" + 终端 + "')")}
		${if(len(CORE) == 0,"","and  core  in ('" + CORE + "')")}
    ) t1
group by 1,2
),



-- 短剧信息
z5 as(
select
  series_id ,
  max(
  case
  when publish_status = 1 then '上架'
  when publish_status = 2 then '下架'
  when publish_status = 3 then '软下架'
  end)  publish_status,
  max(
  case
  when ending=1 then '连载中'
  when ending=2 then '已完结'
  end)  ending,
  cast(max(source_series_id) as varchar) source_series_id
from dim.dim_short_video_series_view
group by 1

),

z6 as (
select
	SeriesId,
	case
		when SeriesLevel = 1 then 'S'
		when SeriesLevel = 2 then 'A'
		when SeriesLevel = 3 then 'B'
		when SeriesLevel = 4 then 'C'
		else '其他'
	end as SeriesLevel
from ads.ads_short_video_admin_series_view
group by 1,2
)




select
	dt `日期`,
	cast(z1.series_id as varchar) `短剧id`,
	source_series_id `源剧ID`,
	series_name `短剧名称`,
	series_code `短剧代号`,
	z6.SeriesLevel `短剧等级`,
	series_tp `短剧分类`,
	publish_status `上下架状态`,
	ending `是否完结`,
	cast(publish_tm as varchar)  `上架时间`,
	cast(last_epis as varchar) `发布剧集数`,
	consume_user `消费人数-合计`,
	consume_user_coin `消费人数-观看币`,
	consume_amount `消费金额-合计`,
	consume_amount_coin `消费金额-观看币`
from  z1
inner join z6
on z1.series_id = z6.SeriesId
full join z5
on z1.series_id = z5.series_id
where
	1=1
	${if(len(短剧等级) == 0,"","and z6.SeriesLevel in ('" + 短剧等级 + "')")}