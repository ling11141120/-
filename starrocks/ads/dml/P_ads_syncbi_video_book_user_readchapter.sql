----------------------------------------------------------------
-- 程序功能： 海阅PWA用户章节阅读时长同步至海剧
-- 程序名： P_ads_syncbi_video_book_user_readchapter
-- 目标表： ads.syncbi_video_book_user_readchapter
-- 负责人：lwbl
-- 开发日期： 2026-06-25
----------------------------------------------------------------
insert overwrite ads.syncbi_video_book_user_readchapter (
     dt
    ,Productid
    ,Id
    ,BookId
    ,ChapterId
    ,UserId
    ,ProdId
    ,CreateTime
    ,AppId
    ,Time
    ,etl_tm
)
with video_user_device as (
    select Id               as video_user_id
         , UniqueCdReaderId as device_id
      from ods.ods_tidb_short_video_accountinfo
     where Id > 0
       and UniqueCdReaderId is not null
       and UniqueCdReaderId != ''

    union

    select Id                as video_user_id
         , UniqueCdReaderId2 as device_id
      from ods.ods_tidb_short_video_accountinfo
     where Id > 0
       and UniqueCdReaderId2 is not null
       and UniqueCdReaderId2 != ''

    union

    select AccountId as video_user_id
         , DeviceId  as device_id
      from ods.ods_tidb_short_video_device_account
     where AccountId > 0
       and DeviceId is not null
       and DeviceId != ''
       and IsBind = 1
       and coalesce(IsDelete, 0) = 0
)
, valid_read_user_mapping as (
    select read_user_id
         , video_user_id
      from (
          select pwa.user_id       as read_user_id
               , pwa.video_user_id as video_user_id
               , row_number() over (
                     partition by pwa.user_id
                     order by pwa.create_time desc, pwa.id desc
                 ) as rn
            from ods.ods_tidb_readerlog_en_log_pwaseriesIdlog pwa
            join video_user_device device_map
              on pwa.video_user_id = device_map.video_user_id
             and pwa.unique_cd_reader_id = device_map.device_id
           where pwa.user_id > 0
             and pwa.video_user_id > 0
             and pwa.unique_cd_reader_id is not null
             and pwa.unique_cd_reader_id != ''
      ) t
     where rn = 1
)
select a.dt
     , a.Productid
     , a.Id
     , a.BookId
     , a.ChapterId
     , mapping.video_user_id as UserId
     , a.ProdId
     , a.CreateTime
     , a.AppId
     , a.Time
     , now() as etl_tm
  from ods_log.ods_book_user_readchapter a
  join valid_read_user_mapping mapping
    on mapping.read_user_id = a.UserId
 where exists (
       select 1
         from ods.ods_tidb_short_video_admin_novel_book b
        where b.bookid = a.BookId
   )
;
