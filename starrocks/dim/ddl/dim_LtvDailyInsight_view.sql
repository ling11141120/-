create view dim_LtvDailyInsight_view(
    Id comment "id", AdId comment "广告id", AdStatus comment "广告状态",
             date_start comment "投放开始时间", date_stop comment "投放结束时间", AdName comment "广告名",
             Spend comment "花费金额", PutData comment "投放数据", Installs comment "安装数",
             Clicks comment "点击数", Impressions comment "展示数", Cpc comment "Cpc", Cpm comment "Cpm",
             Cpp comment "Cpp", Ctr comment "Ctr", UpdateTime comment "更新时间", Mt comment "平台",
             Core comment "core", ProductId comment "产品id", Roas comment "Roas", AdSetId comment "广告系列",
             AdCampId comment "广告组", Country comment "国家", Amount comment "收入",
             SourceChl comment "广告投放渠道", Chl2 comment "渠道值", CreateUser comment "创建用户 没用",
             CreateType comment "创建类型 没用", CreateNum comment "创建数量 没用", RowVersion comment "版本",
             CurrentLanguage2 comment "投放语言", IsRemarketing comment "是否再营销",
             Account comment "广告所属账号", LinkClick comment "链接点击数", Conversion comment "offset转换数",
             Registration comment "去重注册人数", ConvertSpend comment "广告投放花费（西五区）"
)
as
select if((Id is null) or
          (Id = ''), -99,
          Id)               as Id
     , if((AdId is null) or
          (AdId = ''), -99,
          AdId)             as AdId
     , if((AdStatus is null) or
          (AdStatus = ''), -99,
          AdStatus)         as AdStatus
     , if((date_start is null) or
          (date_start = ''), '1970-01-01 00:00:00',
          date_start)       as date_start
     , if((date_stop is null) or
          (date_stop = ''), '1970-01-01 00:00:00',
          date_stop)        as date_stop
     , if((AdName is null) or
          (AdName = ''), -99,
          AdName)           as AdName
     , if((Spend is null) or
          (Spend = ''), -99,
          Spend)            as Spend
     , if((PutData is null) or
          (PutData = ''), -99,
          PutData)          as PutData
     , if((Installs is null) or
          (Installs = ''), 0,
          Installs)         as Installs
     , if((Clicks is null) or
          (Clicks = ''), 0,
          Clicks)           as Clicks
     , if((Impressions is null) or
          (Impressions = ''), 0,
          Impressions)      as Impressions
     , if((Cpc is null) or
          (Cpc = ''), -99,
          Cpc)              as Cpc
     , if((Cpm is null) or
          (Cpm = ''), -99,
          Cpm)              as Cpm
     , if((Cpp is null) or
          (Cpp = ''), -99,
          Cpp)              as Cpp
     , if((Ctr is null) or
          (Ctr = ''), -99,
          Ctr)              as Ctr
     , if((UpdateTime is null) or
          (UpdateTime = ''), '1970-01-01 00:00:00',
          UpdateTime)       as UpdateTime
     , if((Mt is null) or
          (Mt = ''), -99,
          Mt)               as Mt
     , if((Core is null) or
          (Core = ''), -99,
          Core)             as Core
     , if((ProductId is null) or
          (ProductId = ''), -99,
          ProductId)        as ProductId
     , if((Roas is null) or
          (Roas = ''), -99,
          Roas)             as Roas
     , if((AdSetId is null) or
          (AdSetId = ''), -99,
          AdSetId)          as AdSetId
     , if((AdCampId is null) or
          (AdCampId = ''), -99,
          AdCampId)         as AdCampId
     , if((Country is null) or
          (Country = ''), -99,
          Country)          as Country
     , if((Amount is null) or
          (Amount = ''), -99,
          Amount)           as Amount
     , if((SourceChl is null) or
          (SourceChl = ''), -99,
          SourceChl)        as SourceChl
     , if((Chl2 is null) or
          (Chl2 = ''), -99,
          Chl2)             as Chl2
     , if((CreateUser is null) or
          (CreateUser = ''), -99,
          CreateUser)       as CreateUser
     , if((CreateType is null) or
          (CreateType = ''), -99,
          CreateType)       as CreateType
     , if((CreateNum is null) or
          (CreateNum = ''), -99,
          CreateNum)        as CreateNum
     , if((RowVersion is null) or
          (RowVersion = ''), -99,
          RowVersion)       as RowVersion
     , if((CurrentLanguage2 is null) or
          (CurrentLanguage2 = ''), -99,
          CurrentLanguage2) as CurrentLanguage2
     , if((IsRemarketing is null) or
          (IsRemarketing = ''), -99,
          IsRemarketing)    as IsRemarketing
     , if((Account is null) or
          (Account = ''), -99,
          Account)          as Account
     , if((LinkClick is null) or
          (LinkClick = ''), -99,
          LinkClick)        as LinkClick
     , if((Conversion is null) or
          (Conversion = ''), -99,
          Conversion)       as Conversion
     , if((Registration is null) or
          (Registration = ''), 0,
          Registration)     as Registration
     , if((ConvertSpend is null) or
          (ConvertSpend = ''), 0,
          ConvertSpend)     as Registration
  from ods.ods_tidb_sharpengine_ads_global_LtvDailyInsight;