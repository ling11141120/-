----------------------------------------------------------------
-- 程序功能：海阅 PWA 用户书架、阅读进度及阅读时长同步至海剧
-- 程序名： P_ads_bi_short_video_novel_user_read_device_di
-- 目标表：ads.ads_bi_short_video_novel_user_read_device_di
-- 负责人：lwb
-- 开发日期：2026-06-18
----------------------------------------------------------------

delete from ads.ads_bi_short_video_novel_user_read_device_di
 where dt = '${bf_1_dt}';

insert into ads.ads_bi_short_video_novel_user_read_device_di (
     dt
    ,product_id
    ,video_user_id
    ,unique_cd_reader_id
    ,read_user_id
    ,reader_book_id
    ,pwa_app_id
    ,user_device_mapping_time
    ,bookshelf_collect_time
    ,last_read_chapter_id
    ,last_read_chapter_index
    ,last_read_chapter_name
    ,last_read_time
    ,total_read_time
    ,etl_time
)
with video_user_device as (
    -- 海剧账号当前/首次设备，以及仍有效的账号设备绑定关系。
    select video_user_id
         , unique_cd_reader_id
      from (
          select Id               as video_user_id
               , UniqueCdReaderId as unique_cd_reader_id
            from ods.ods_tidb_short_video_accountinfo
           where Id > 0
             and UniqueCdReaderId is not null
             and UniqueCdReaderId != ''

          union all

          select Id                as video_user_id
               , UniqueCdReaderId2 as unique_cd_reader_id
            from ods.ods_tidb_short_video_accountinfo
           where Id > 0
             and UniqueCdReaderId2 is not null
             and UniqueCdReaderId2 != ''

          union all

          select AccountId as video_user_id
               , DeviceId  as unique_cd_reader_id
            from ods.ods_tidb_short_video_device_account
           where AccountId > 0
             and DeviceId is not null
             and DeviceId != ''
             and IsBind = 1
             and coalesce(IsDelete, 0) = 0
      ) t
     group by video_user_id, unique_cd_reader_id
)
, pwa_user_device as (
    -- PWA日志提供海阅用户、海剧用户和设备的关联，海剧设备表负责校验关系有效性。
    select read_user_id
         , video_user_id
         , unique_cd_reader_id
         , series_id
         , pwa_app_id
         , user_device_mapping_time
      from (
          select pwa.UserId           as read_user_id
               , pwa.VideoUserId      as video_user_id
               , pwa.UniqueCdReaderId as unique_cd_reader_id
               , pwa.SeriesId         as series_id
               , pwa.AppId            as pwa_app_id
               , pwa.CreateTime       as user_device_mapping_time
               , row_number() over (
                     partition by pwa.UserId, pwa.UniqueCdReaderId, pwa.SeriesId
                     order by pwa.CreateTime desc, pwa.Id desc
                 ) as rn
            from ads.ads_readerlog_en_pwa_series_id_view pwa
            join video_user_device device_map
              on pwa.VideoUserId = device_map.video_user_id
             and pwa.UniqueCdReaderId = device_map.unique_cd_reader_id
           where pwa.dt <= '${bf_1_dt}'
             and pwa.UserId > 0
             and pwa.VideoUserId > 0
             and pwa.UniqueCdReaderId is not null
             and pwa.UniqueCdReaderId != ''
             and pwa.SeriesId > 0
      ) t
     where rn = 1
)
, bookshelf as (
    -- 每个海阅用户、产品和书籍仅保留最近更新的一条云书架进度。
    select read_user_id
         , product_id
         , reader_book_id
         , bookshelf_collect_time
         , last_read_chapter_id
         , last_read_chapter_index
         , read_largest_chapter
         , last_read_chapter_name
         , last_read_time
      from (
          select UserId              as read_user_id
               , Productid           as product_id
               , BookId              as reader_book_id
               , CollectTime         as bookshelf_collect_time
               , ChapterId           as last_read_chapter_id
               , ChapterIndex        as last_read_chapter_index
               , ReadLargestChapter  as read_largest_chapter
               , LastReadChapterName as last_read_chapter_name
               , LastReadTime        as last_read_time
               , row_number() over (
                     partition by UserId, Productid, BookId
                     order by coalesce(LastReadTime, cast('1970-01-01 00:00:00' as datetime)) desc,
                              coalesce(UpdateTime, cast('1970-01-01 00:00:00' as datetime)) desc,
                              coalesce(CollectTime, cast('1970-01-01 00:00:00' as datetime)) desc,
                              coalesce(CreateTime, cast('1970-01-01 00:00:00' as datetime)) desc,
                              ID desc
                 ) as rn
            from ods.ods_tidb_readernovel_tidb_bookshelftouser
           where UserId > 0
             and Productid > 0
             and BookId > 0
      ) t
     where rn = 1
)
, series_book_mapping as (
    -- 海阅书籍id不能直接作为海剧剧id，必须使用短剧后台映射。
    select SeriesId as series_id
         , BookId   as reader_book_id
      from ods.ods_tidb_short_video_admin_series
     where AppType = 1
       and coalesce(IsDelete, 0) = 0
       and SeriesId > 0
       and BookId > 0
)
, matched_user_book_raw as (
    -- 先收敛到实际需要同步的用户、设备、剧和书，避免后续扫描无关用户数据。
    select bookshelf.product_id
         , mapping.series_id
         , pwa.video_user_id
         , pwa.unique_cd_reader_id
         , pwa.read_user_id
         , bookshelf.reader_book_id
         , pwa.pwa_app_id
         , pwa.user_device_mapping_time
         , bookshelf.bookshelf_collect_time
         , bookshelf.last_read_chapter_id
         , bookshelf.last_read_chapter_index
         , bookshelf.read_largest_chapter
         , bookshelf.last_read_chapter_name
         , bookshelf.last_read_time
      from pwa_user_device pwa
      join bookshelf
        on pwa.read_user_id = bookshelf.read_user_id
      join series_book_mapping mapping
        on pwa.series_id = mapping.series_id
       and bookshelf.reader_book_id = mapping.reader_book_id
)
, matched_user_book as (
    select product_id
         , video_user_id
         , unique_cd_reader_id
         , read_user_id
         , reader_book_id
         , pwa_app_id
         , user_device_mapping_time
         , bookshelf_collect_time
         , last_read_chapter_id
         , last_read_chapter_index
         , read_largest_chapter
         , last_read_chapter_name
         , last_read_time
      from (
          select matched.*
               , row_number() over (
                     partition by product_id, video_user_id, unique_cd_reader_id, read_user_id, reader_book_id
                     order by user_device_mapping_time desc, series_id desc
                 ) as rn
            from matched_user_book_raw matched
      ) t
     where rn = 1
)
, chapter_info as (
    -- ChapterIndex 为空时，按书架记录的 ChapterId 回查章节序号。
    select chapter.book_id            as reader_book_id
         , chapter.chapter_id
         , max(chapter.serial_number) as chapter_index
      from dim.dim_book_chapter_info chapter
      join (
          select reader_book_id
               , last_read_chapter_id
            from matched_user_book
           where last_read_chapter_id > 0
           group by reader_book_id, last_read_chapter_id
      ) matched
        on chapter.book_id = matched.reader_book_id
       and chapter.chapter_id = matched.last_read_chapter_id
     group by chapter.book_id, chapter.chapter_id
)
, user_read_time as (
    -- User cumulative reading time from userdata.
    select userdata.product_id
         , userdata.Id as read_user_id
         , max(coalesce(userdata.TotalReadTime, 0)) as total_read_time
      from ods.ods_tidb_readernovel_tidb_userdata userdata
      join (
          select product_id
               , read_user_id
            from matched_user_book
           group by product_id, read_user_id
      ) matched
        on userdata.product_id = matched.product_id
       and userdata.Id = matched.read_user_id
     group by userdata.product_id, userdata.Id
)
select cast('${bf_1_dt}' as date)        as dt
     , matched.product_id
     , matched.video_user_id
     , matched.unique_cd_reader_id
     , matched.read_user_id
     , matched.reader_book_id
     , matched.pwa_app_id
     , matched.user_device_mapping_time
     , matched.bookshelf_collect_time
     , matched.last_read_chapter_id
     , coalesce(matched.last_read_chapter_index,
                chapter_info.chapter_index,
                matched.read_largest_chapter) as last_read_chapter_index
     , matched.last_read_chapter_name
     , matched.last_read_time
     , coalesce(user_read_time.total_read_time, 0) as total_read_time
     , now()                             as etl_time
  from matched_user_book matched
  left join chapter_info
    on matched.reader_book_id = chapter_info.reader_book_id
   and matched.last_read_chapter_id = chapter_info.chapter_id
  left join user_read_time
    on matched.product_id = user_read_time.product_id
   and matched.read_user_id = user_read_time.read_user_id
;
