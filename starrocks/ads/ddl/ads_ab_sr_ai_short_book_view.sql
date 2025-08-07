----------------------------------------------------------------
-- 目标表： ads.ads_ab_sr_ai_short_book_view
-- 功能： 海阅大模型短篇书籍AB测试视图
-- 负责人： qhr
-- 开发日期： 2023-08-05
----------------------------------------------------------------

create or replace view ads.ads_ab_sr_ai_short_book_view (
     book_id       comment '书籍id'
    ,version_cd    comment '版本号'
)
comment '海阅大模型短篇书籍AB测试视图'
as
select SwBookId*1000+LangId     as book_id
      ,coalesce(Version, '')    as version_cd
  from ods.ods_shuangwen_tidb_en_shortstorybook
 where SwBookId is not null
;