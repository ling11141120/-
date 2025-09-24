create or replace view ads.ads_if_books_view (
      id
     ,product_id
     ,book_id
     ,new_cid
     ,book_name
     ,author_name
     ,channel
     ,book_nature
     ,length
     ,book_no
     ,book_no_series
     ,speed_chapter_num
     ,book_reader_push
     ,price_per_thousand_cfg
     ,publish_length
     ,is_full
     ,remuneration_time
     ,publish_chapter_num
     ,ios_reduce_num
     ,android_reduce_num
     ,free_chapter_num
     ,vip_chapter_no
     ,book_language
     ,book_language_code
     ,price_per_thousand_cfg_tag
     ,ios_reduce_num_tag
     ,android_reduce_num_tag
     ,plan_content_type
     ,new_cid_name
     ,sr_createtime
     ,sr_updatetime
)
as
select id
      ,productid                 as product_id
      ,bookid                    as book_id
      ,newcid                    as new_cid
      ,bookname                  as book_name
      ,authorname                as author_name
      ,channel                   as channel
      ,booknature                as book_nature
      ,Length                    as Length
      ,bookno                    as book_no
      ,booknoseries              as book_no_series
      ,SpeedChapterNum           as speed_chapter_num
      ,BookReaderPush            as book_reader_push
      ,PricePerThousandCfg       as price_per_thousand_cfg
      ,PublishLength             as publish_length
      ,IsFull                    as is_full
      ,RemunerationTime          as remuneration_time
      ,PublishChapterNum         as publish_chapter_num
      ,IosReduceNum              as ios_reduce_num
      ,AndroidReduceNum          as android_reduce_num
      ,FreeChapterNum            as free_chapter_num
      ,VipChapterNo              as vip_chapter_no
      ,BookLanguage              as book_language
      ,BookLanguageCode          as book_language_code
      ,PricePerThousandCfgTag    as price_per_thousand_cfg_tag
      ,IosReduceNumTag           as ios_reduce_num_tag
      ,AndroidReduceNumTag       as android_reduce_num_tag
      ,PlanContentType           as plan_content_type
      ,newcidname                as new_cid_name
      ,sr_createtime             as sr_createtime
      ,sr_updatetime             as sr_updatetime
  from ods.ods_tidb_sharpengine_bi_if_books
;