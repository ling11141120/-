-- 剧维度的观看、消费数据
with z1 as(
SELECT
    '汇总' series_id,
    -- max(series_name) series_name,
    -- max(series_code) series_code,
    -- max(series_tp) series_tp,
    -- max(last_epis) last_epis,
    -- min(publish_tm) publish_tm,
  	-- max(is_toufang) is_toufang,
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
    from ads.ads_bi_short_video_consume_stat t1
      left join dim.dim_dic dic_lang  -- 注册/投放语言
      on t1.series_language = dic_lang.enum_id
      and dic_lang.table_name = 'dim_producttype'
      and dic_lang.dic_column = 'language_id'
     left join dim.dim_dic  dic_mt  -- mt
     on t1.mt = dic_mt.enum_id
     and dic_mt.table_name = 'dim_user_accountinfo_df'
     and dic_mt.dic_column = 'mt'
    WHERE product_id = 6833
		and dt >= '${开始时间}' and dt<= '${结束时间}'
		${if(是否引流=='全部用户',"and is_toufang=0",
		  if(是否引流=='引流用户',"and is_toufang=1"," and is_toufang=2") )}
		${if(len(短剧ID) == 0,"","and  series_id in ('" + 短剧ID + "')")}
		${if(len(SOURCE) == 0,"","and  source in ('" + SOURCE + "')")}
       	${if(len(短剧语言) == 0,"","and  dic_lang.remarks in ('" + 短剧语言 + "')")}
        ${if(len(终端) == 0,"","and  dic_mt.enum_name  in ('" + 终端 + "')")}
		${if(len(CORE) == 0,"","and  core  in ('" + CORE + "')")}
    ) t1
group by 1
),

-- 剧维度的曝光、点击、解锁数据
z4 as(
SELECT
    '汇总'  series_id,
    bitmap_union_count(exposure_user_bitmap) exposure_user,
    bitmap_union_count(click_user_bitmap) click_user,
    bitmap_union_count(all_unlock_user_bitmap) unlock_user,
	bitmap_union_count(watch_user_bitmap) watch_user,
	bitmap_union_count(svip_watch_user_bitmap) svip_watch_user,
	bitmap_union_count(svip_unlock_user_bitmap) +  	bitmap_union_count(consume_unlock_user_bitmap )-
  bitmap_union_count(bitmap_and(svip_unlock_user_bitmap,consume_unlock_user_bitmap))  all_unlock_user,
	sum(all_unlock_epis_cnt)  unlock_user_epis_cnt,
	sum(consume_unlock_epis_cnt) consume_unlock_epis_cnt,
	sum(svip_unlock_epis_cnt) svip_unlock_epis_cnt,
	sum(ad_unlock_epis_cnt) ad_unlock_epis_cnt,
	bitmap_union_count (ad_unlock_user_bitmap ) ad_unlock_user_bitmap
from
    (
    select
    *,
      dic_lang.remarks  reg_language,
      dic_mt.enum_name as  `平台`
    from ads.ads_bi_short_video_action_stat  t1
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
group by 1
),


-- 分桶的周期内短剧消费人数
z3 as(
select
	series_id,
	count(DISTINCT case when epis_coin_consume_amount>=600 then user_id end) consume_user_600,
	count(DISTINCT case when epis_coin_consume_amount>=1500 then user_id end) consume_user_1500,
	count(DISTINCT case when epis_coin_consume_amount>=3000 then user_id end) consume_user_3000,
	count(DISTINCT case when epis_coin_consume_amount>=5000 then user_id end) consume_user_5000
from
	(
	select
		'汇总' series_id,
		user_id,
		sum(epis_coin_consume_amount) epis_coin_consume_amount
	from
		(
		select
			t1.*,
			dic_mt.enum_name as  `平台`
		from ads.ads_short_video_user_epis_consume_view t1
         left join dim.dim_dic  dic_mt  -- mt
         on t1.mt = dic_mt.enum_id
         and dic_mt.table_name = 'dim_user_accountinfo_df'
         and dic_mt.dic_column = 'mt'
		WHERE
			dt >= '${开始时间}' and dt<= '${结束时间}'
			${if(是否引流=='全部用户',"and is_toufang=0",
			if(是否引流=='引流用户',"and is_toufang=1"," and is_toufang=2") )}
			and product_id = 6833
			${if(len(短剧ID) == 0,"","and  series_id in ('" + 短剧ID + "')")}
			${if(len(SOURCE) == 0,"","and  source in ('" + SOURCE + "')")}
			${if(len(CORE) == 0,"","and  core  in ('" + CORE + "')")}
		) t3
	where
		1=1
		${if(len(终端) == 0,"","and  平台 in ('" + 终端 + "')")}
	group by 1,2
	) t31
group by 1
)





select
	cast(z1.series_id as varchar) `短剧id`,
	watch_user `观看人数`,
	exposure_user `曝光用户`,
	click_user `点击用户`,
	unlock_user `解锁用户`,
	svip_watch_user `SVIP观看用户数`,
	all_unlock_user  `解锁用户数（包含svip观看付费集）`,
	consume_unlock_epis_cnt 解锁总集数（合计消费）,
	svip_unlock_epis_cnt 解锁总集数（SVIP）,
	ad_unlock_epis_cnt 解锁总集数（广告）,
	ad_unlock_user_bitmap  解锁用户数（广告）,
	unlock_user_epis_cnt 解锁总集数,
	consume_user `消费人数-合计`,
	consume_user_coin `消费人数-观看币`,
	consume_amount `消费金额-合计`,
	consume_amount_coin `消费金额-观看币`,
	z3.consume_user_600 `600观看币消耗人数`,
	z3.consume_user_1500 `1500观看币消耗人数`,
	z3.consume_user_3000 `3000观看币消耗人数`,
	z3.consume_user_5000 `5000观看币消耗人数`,
	consume_user_coin/watch_user `观看币消费率`,
	consume_amount_coin/watch_user `ARPU`,
	consume_amount_coin/consume_user_coin `ARPPU`
from  z1
-- full join  z3
full join  z3
on z1.series_id = z3.series_id
-- full join z4
full join  z4
on z1.series_id = z4.series_id
where
	1=1
	${if(len(短剧等级) == 0,"","and z8.SeriesLevel in ('" + 短剧等级 + "')")}
