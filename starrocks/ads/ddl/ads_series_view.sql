create or replace view ads.ads_series_view (
     SeriesId         comment "id"
    ,Language         comment "语言"
    ,SeriesName       comment "短剧名称"
    ,Description      comment "短剧简介"
    ,CoverUrl         comment "封面"
    ,CreateTime       comment "创建时间"
    ,UpdateTime       comment "修改时间"
    ,CreateUser       comment "上传人"
    ,PublishStatus    comment "上架状态(1上架 2下架)"
    ,PublishedAt      comment "上架时间"
    ,UnPublishedAt    comment "下架时间"
    ,LastEpis         comment "更新至第几集"
    ,AllEpis          comment "总集数"
    ,PayEpisFrom      comment "收费起始集数"
    ,IsDelete         comment "是否删除"
    ,Producer         comment "制作方"
    ,Recommend        comment "推荐文案"
    ,SourceSeriesId   comment "源语言短剧"
    ,Price            comment "单集价格（分）"
    ,Ending           comment "完结状态（1连载中 2已完结）"
    ,SeriesNameKey    comment "短剧名称转换key"
    ,DescriptionKey   comment "短剧简介转换key"
    ,RecommendKey     comment "推荐文案转换key"
    ,SeriesLevel      comment "等级 1.S 2.A 3.B 4.C"
    ,OperateLevel     comment "运营等级 1.S 2.A 3.B 4.C"
    ,WorkType         comment "作品类型 1.男频  2.女频 3.双番"
    ,ImageKey         comment "轮播榜单配图id"
    ,ListRecommendKey comment "轮播榜单推荐语key"
    ,ListRecommend    comment "轮播榜单推荐语"
    ,Core             comment "Core 多个用逗号隔开(1core1，2core2，3core3，4core4)"
)
comment "短集表"
as
select SeriesId
      ,Language
      ,SeriesName
      ,Description
      ,CoverUrl
      ,CreateTime
      ,UpdateTime
      ,CreateUser
      ,PublishStatus
      ,PublishedAt
      ,UnPublishedAt
      ,LastEpis
      ,AllEpis
      ,PayEpisFrom
      ,IsDelete
      ,Producer
      ,Recommend
      ,SourceSeriesId
      ,Price
      ,Ending
      ,SeriesNameKey
      ,DescriptionKey
      ,RecommendKey
      ,SeriesLevel
      ,OperateLevel
      ,WorkType
      ,ImageKey
      ,ListRecommendKey
      ,ListRecommend
      ,Core
  from ods.ods_tidb_short_video_series
 where IsDelete = 0
   and AppType = 1
;
