----------------------------------------------------------------
-- 程序功能： 短剧明细字段需求
-- 程序名： P_ads_sv_finance_series_info
-- 目标表： ads.ads_sv_finance_series_info
-- 负责人： xiejc
-- 开发日期：2026-06-12
----------------------------------------------------------------

-- TODO 短剧明细字段需求
insert into ads.ads_sv_finance_series_info
select '6833'            as '产品id'
     , a.series_id       as '短剧id'
     , b.series_code     as '短剧代号'
     , a.series_name     as '短剧名称'
     , a.all_epis        as '总集数'
     , a.language        as '语言id'
     , d.abbreviation    as '短剧语言'
     , c.type_name       as '分类'
     , b.rightsholder_id as '版权方'
     , b.series_id       as '源剧id'
     , b.series_name     as '源剧名称'
     , b.language        as '源剧语言id'
     , e.abbreviation    as '源剧语言'
     , b.begin_date      as '源剧合作开始日期'
     , b.end_date        as '源剧合作结束日期'
     , a.publish_status  as '上下架状态'
     , case when a.publish_status = 1 then '上架'
            when a.publish_status = 2 then '下架'
            when a.publish_status = 3 then '软下架'
            else '未知'
        end              as '短剧上下架状态'
     , a.publish_edat    as '上架日期'
     , b.local_type      as '来源id'
     , case when b.local_sub_type = 0 then '本土剧-真人'
            when b.local_sub_type = 1 then '本土剧-AI短剧'
            when b.local_sub_type = 2 then '动态漫-手绘'
            when b.local_sub_type = 3 then '动态漫-转绘'
            when b.local_sub_type = 4 then '动态漫-AI'
            when b.local_sub_type = 5 then '动态漫-仿真人'
            when b.local_sub_type = 6 then '本土剧-AI换脸'
            when b.local_sub_type = 7 then '译制剧-AI'
            when b.local_sub_type = 8 then '译制剧-真人'
            else '未知'
        end              as '来源类型'
     , a.create_tm
     , now()             as etl_time
     , case when b.local_type in(4, 5) or b.local_sub_type in(1, 7) then 1 else 0 end as is_ai
  from dim.dim_short_video_series_view as a
  left join dim.dim_short_video_source_series_view as b
    on a.source_series_id = b.series_id
  left join (select a.series_id
                  , group_concat(c.name) as type_name
               from dim.dim_short_video_series_view as a
               left join dim.dim_short_video_series_ref_type_view as b
                 on a.series_id = b.series_id
               left join dim.dim_short_video_series_type_view as c
                 on b.series_type_id = c.id
              group by a.series_id
            ) as c
    on a.series_id = c.series_id
  left join dim.DIM_ProductType as d
    on a.language = d.langid
   and d.abbreviation != 'and2'
  left join dim.DIM_ProductType as e
    on b.language = e.langid
   and e.abbreviation != 'and2'
where a.series_name not rlike '作废|废弃|测试|文案书|素材'
;
