insert overwrite dim.dim_sv_series_hi
select -- 剧
       a.SeriesId as series_id,a.Language as language,a.SeriesName as series_name,a.Description as description,
       a.CoverUrl as cover_url,a.CreateTime as create_time,a.UpdateTime as update_time,a.CreateUser as create_user,
       a.PublishStatus as publish_status,a.PublishedAt as published_at,a.UnPublishedAt as un_published_at,a.LastEpis as last_epis,
       a.AllEpis as all_epis,a.PayEpisFrom as pay_epis_from,a.IsDelete as is_delete,a.Producer as producer,a.Recommend as recommend,
       a.SourceSeriesId as source_series_id,a.Price as price,a.Ending as ending,a.SeriesNameKey as series_name_key,
       a.DescriptionKey as description_key,a.RecommendKey as recommend_key,
       -- 源剧
       b.SeriesName as source_series_name,b.Language as source_series_language,b.SeriesCode as source_series_code,
       b.CooperateType as source_cooperate_type,b.RightsHolderId as source_rights_holder_id,b.LangIds as source_lang_ids,
       b.Coef as source_coef,
       -- 分类
       c.series_type_ids,c.series_type_name,
       -- 版权方
       d.holder as source_rights_holder_name,d.Type as source_rights_holder_type,d.Coef as source_rights_holder_coef,
       d.LangIds as source_rights_holder_lang_ids,
       now() as etl_time
from ods.ods_tidb_short_video_series a
left join ods.ods_tidb_short_video_admin_source_series b on a.SourceSeriesId=b.SeriesId
left join(
    select srt.SeriesId,array_agg(srt.SeriesTypeId) as series_type_ids,array_agg(st.Name) as series_type_name
    from ods.ods_tidb_short_video_series_ref_type srt
    left join ods.ods_tidb_short_video_series_type st on srt.SeriesTypeId=st.Id
    group by 1
    ) c on a.SeriesId=c.SeriesId
left join ods.ods_tidb_short_video_admin_rights_holder d on b.RightsHolderId=d.Id;