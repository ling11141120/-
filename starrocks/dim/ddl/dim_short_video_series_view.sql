create or replace view dim.dim_short_video_series_view (
     series_id          comment "id"
    ,series_code        comment "短剧代号"
    ,language           comment "语言"
    ,series_name        comment "剧名称"
    ,description        comment "短剧简介"
    ,cover_url          comment "封面"
    ,create_tm          comment "创建时间"
    ,update_tm          comment "修改时间"
    ,create_user        comment "上传人"
    ,publish_status     comment "上架状态(1上架 2下架)"
    ,publish_edat       comment "上架时间"
    ,un_publish_edat    comment "下架时间"
    ,last_epis          comment "更新至第几集"
    ,all_epis           comment "总集数"
    ,pay_epis_from      comment "收费起始集数"
    ,is_delete          comment "是否删除"
    ,producer
    ,re_commend         comment "推荐文案"
    ,source_series_id   comment "源语言短剧"
    ,price              comment "单集价格（分）"
    ,ending             comment "完结状态（1连载中 2已完结）"
    ,series_name_key
    ,description_key    comment "短剧简介转换key"
    ,re_commend_key     comment "推荐文案转换key"
    ,series_level       comment "等级 1.S 2.A 3.B 4.C"
    ,operate_level      comment "运营等级 1.S 2.A 3.B 4.C"
    ,work_type          comment "作品类型 1.男频  2.女频 3.双番"
    ,image_key          comment "轮播榜单配图id"
    ,list_recommend_key comment "轮播榜单推荐语key"
    ,list_recommend     comment "轮播榜单推荐语"
    ,core               comment "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)"
    ,is_ai              comment "是否是ai短剧,1是 0否,目前规则仅财务定义"
    ,sr_updatetime      comment "ods同步时间"
    ,sr_createtime      comment "starrocks数据注入时间"
)
comment '短剧维表视图'
as
select a1.SeriesId               as series_id          -- id
      ,a2.SeriesCode             as series_code        -- 短剧代号
      ,a1.Language               as language           -- 语言
      ,a1.SeriesName             as series_name        -- 剧名称
      ,a1.Description            as description        -- 短剧简介
      ,a1.CoverUrl               as cover_url          -- 封面
      ,a1.CreateTime             as create_tm          -- 创建时间
      ,a1.UpdateTime             as update_tm          -- 修改时间
      ,a1.CreateUser             as create_user        -- 上传人
      ,a1.PublishStatus          as publish_status     -- 上架状态(1上架 2下架)
      ,a1.PublishedAt            as publish_edat       -- 上架时间
      ,a1.UnPublishedAt          as un_publish_edat    -- 下架时间
      ,a1.LastEpis               as last_epis          -- 更新至第几集
      ,a1.AllEpis                as all_epis           -- 总集数
      ,a1.PayEpisFrom            as pay_epis_from      -- 收费起始集数
      ,a1.IsDelete               as is_delete          -- 是否删除
      ,a1.Producer               as producer
      ,a1.Recommend              as re_commend         -- 推荐文案
      ,a1.SourceSeriesId         as source_series_id   -- 源语言短剧
      ,a1.Price                  as price              -- 单集价格（分）
      ,a1.Ending                 as ending             -- 完结状态（1连载中 2已完结）
      ,a1.SeriesNameKey          as series_name_key
      ,a1.DescriptionKey         as description_key    -- 短剧简介转换key
      ,a1.RecommendKey           as re_commend_key     -- 推荐文案转换key
      ,a1.SeriesLevel            as series_level       -- 等级 1.S 2.A 3.B 4.C
      ,a1.OperateLevel           as operate_level      -- 运营等级 1.S 2.A 3.B 4.C
      ,a1.WorkType               as work_type          -- 作品类型 1.男频  2.女频 3.双番
      ,a1.ImageKey               as image_key          -- 轮播榜单配图id
      ,a1.ListRecommendKey       as list_recommend_key -- 轮播榜单推荐语key
      ,a1.ListRecommend          as list_recommend     -- 轮播榜单推荐语
      ,a1.Core                   as core               -- Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)
      ,case when a2.LocalType in(4,5) or a2.LocalSubType in(1,7) then 1
            else 0
        end                      as is_ai              -- 是否是ai短剧
      ,a1.sr_updatetime          as sr_updatetime      -- ods同步时间
      ,a1.sr_createtime          as sr_createtime      -- starrocks数据注入时间

  from ods.ods_tidb_short_video_series                      as a1
  left join ods.ods_tidb_short_video_admin_source_series    as a2
    on a1.SourceSeriesId = a2.SeriesId
 where a1.AppType = 1
;