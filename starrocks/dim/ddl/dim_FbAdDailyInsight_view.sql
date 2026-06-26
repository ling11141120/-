create view dim_FbAdDailyInsight_view(
                                      Id comment "自增", AdId comment "广告id", AdStatus comment "广告状态",
                                      FbAccountId comment "fb账号id", date_start comment "投放开始时间(西五区)",
                                      date_stop comment "投放结束时间", AdName comment "广告名",
                                      Spend comment "花费金额",
                                      PutData comment "投放数据", Installs comment "安装数", Clicks comment "点击数",
                                      Impressions comment "展示数", Cpc comment "Cpc", Cpm comment "Cpm",
                                      Cpp comment "Cpp",
                                      Ctr comment "Ctr", UpdateTime comment "更新时间", Mt comment "平台",
                                      ProductId comment "产品id",
                                      Roas comment "Roas", AdSetId comment "广告系列", AdCampId comment "广告组",
                                      Amount comment "没什么用", FbAmount comment "金额,废弃",
                                      VideoViewCount comment "视频查看数",
                                      Video10sViewCount comment "10秒查看数",
                                      VideoAvgWatchedTime comment "平均视频查看时间", Installs2,
                                      ImageId, RowVersion, CreateTime comment "采集时间",
                                      LinkClick comment "Fb链接点击量",
                                      video_p100_watched_actions comment "100%播放率",
                                      video_p75_watched_actions comment "75%播放率",
                                      video_p50_watched_actions comment "50%播放率",
                                      video_p25_watched_actions comment "25%播放率",
                                      video_p95_watched_actions comment "95%播放率", Conversion comment "offsite转换数",
                                      Registration comment "去重注册数", ConvertSpend comment "广告投放花费（西五区）"
)
as
select id
     , if((AdId is null) or (AdId = ''), -99,AdId)                       as AdId
     , if((AdStatus is null) or (AdStatus = ''), -99,AdStatus)                   as AdStatus
     , if((FbAccountId is null) or (FbAccountId = ''), -99,FbAccountId)                as FbAccountId
     , if((date_start is null) or
          (date_start = ''), -99,
          date_start)                 as date_start
     , if((date_stop is null) or
          (date_stop = ''), -99,
          date_stop)                  as date_stop
     , if((AdName is null) or
          (AdName = ''), -99,
          AdName)                     as AdName
     , if((Spend is null) or
          (Spend = ''), 0,
          Spend)                      as Spend
     , if((PutData is null) or
          (PutData = ''), -99,
          PutData)                    as PutData
     , if((Installs is null) or
          (Installs = ''), 0,
          Installs)                   as Installs
     , if((Clicks is null) or
          (Clicks = ''), 0,
          Clicks)                     as Clicks
     , if((Impressions is null) or
          (Impressions = ''), 0,
          Impressions)                as Impressions
     , if((Cpc is null) or
          (Cpc = ''), -99,
          Cpc)                        as Cpc
     , if((Cpm is null) or
          (Cpm = ''), -99,
          Cpm)                        as Cpm
     , if((Cpp is null) or
          (Cpp = ''), -99,
          Cpp)                        as Cpp
     , if((Ctr is null) or
          (Ctr = ''), -99,
          Ctr)                        as Ctr
     , if((UpdateTime is null) or
          (UpdateTime = ''), '1970-01-01 00:00:00',
          UpdateTime)                 as UpdateTime
     , if((Mt is null) or
          (Mt = ''), -99,
          Mt)                         as Mt
     , if((ProductId is null) or
          (ProductId = ''), -99,
          ProductId)                  as ProductId
     , if((Roas is null) or
          (Roas = ''), -99,
          Roas)                       as Roas
     , if((AdSetId is null) or
          (AdSetId = ''), -99,
          AdSetId)                    as AdSetId
     , if((AdCampId is null) or
          (AdCampId = ''), -99,
          AdCampId)                   as AdCampId
     , if((Amount is null) or
          (Amount = ''), -99,
          Amount)                     as Amount
     , if((FbAmount is null) or
          (FbAmount = ''), -99,
          FbAmount)                   as FbAmount
     , if((VideoViewCount is null) or
          (VideoViewCount = ''), 0,
          VideoViewCount)             as VideoViewCount
     , if((Video10sViewCount is null) or
          (Video10sViewCount = ''), 0,
          Video10sViewCount)          as Video10sViewCount
     , if((VideoAvgWatchedTime is null) or
          (VideoAvgWatchedTime = ''), -99,
          VideoAvgWatchedTime)        as VideoAvgWatchedTime
     , if((Installs2 is null) or
          (Installs2 = ''), -99,
          Installs2)                  as Installs2
     , if((ImageId is null) or
          (ImageId = ''), -99,
          ImageId)                    as ImageId
     , if((RowVersion is null) or
          (RowVersion = ''), -99,
          RowVersion)                 as RowVersion
     , if((CreateTime is null) or
          (CreateTime = ''), '1970-01-01 00:00:00',
          CreateTime)                 as CreateTime
     , if((LinkClick is null) or
          (LinkClick = ''), 0,
          LinkClick)                  as LinkClick
     , if((video_p100_watched_actions is null) or
          (video_p100_watched_actions = ''), -99,
          video_p100_watched_actions) as video_p100_watched_actions
     , if((video_p75_watched_actions is null) or
          (video_p75_watched_actions = ''), -99,
          video_p75_watched_actions)  as video_p75_watched_actions
     , if((video_p50_watched_actions is null) or
          (video_p50_watched_actions = ''), -99,
          video_p50_watched_actions)  as video_p50_watched_actions
     , if((video_p25_watched_actions is null) or
          (video_p25_watched_actions = ''), -99,
          video_p25_watched_actions)  as video_p25_watched_actions
     , if((video_p95_watched_actions is null) or
          (video_p95_watched_actions = ''), -99,
          video_p95_watched_actions)  as video_p95_watched_actions
     , if((Conversion is null) or
          (Conversion = ''), -99,
          Conversion)                 as Conversion
     , if((Registration is null) or
          (Registration = ''), -99,
          Registration)               as Registration
     , if((ConvertSpend is null) or
          (ConvertSpend = ''), 0,
          ConvertSpend)               as Registration
  from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight;