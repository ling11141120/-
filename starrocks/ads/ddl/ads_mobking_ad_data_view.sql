CREATE VIEW ads.ads_mobking_ad_data_view (
     Id            COMMENT "id"
    ,Date          COMMENT "日期"
    ,Appid         COMMENT "站点ID"
    ,Cpm           COMMENT "广告千次展现单价"
    ,FillRate      COMMENT "填充率"
    ,SubRevenue    COMMENT "流水(分成前)"
    ,SubNetRevenue COMMENT "收入(分成后)"
    ,AdReq         COMMENT "请求数"
    ,AdRes         COMMENT "填充数"
    ,Imp           COMMENT "展示数"
    ,Click         COMMENT "点击数"
    ,CreateTime    COMMENT "创建时间"
)
AS
SELECT Id
      ,Date
      ,Appid
      ,Cpm
      ,FillRate
      ,SubRevenue
      ,SubNetRevenue
      ,AdReq
      ,AdRes
      ,Imp
      ,Click
      ,CreateTime
  FROM ods.ods_tidb_mobkingaddata
;