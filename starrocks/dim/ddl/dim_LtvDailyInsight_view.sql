create view `dim_LtvDailyInsight_view`
            (`Id` comment "id", `AdId` comment "广告id", `AdStatus` comment "广告状态",
             `date_start` comment "投放开始时间", `date_stop` comment "投放结束时间", `AdName` comment "广告名",
             `Spend` comment "花费金额", `PutData` comment "投放数据", `Installs` comment "安装数",
             `Clicks` comment "点击数", `Impressions` comment "展示数", `Cpc` comment "Cpc", `Cpm` comment "Cpm",
             `Cpp` comment "Cpp", `Ctr` comment "Ctr", `UpdateTime` comment "更新时间", `Mt` comment "平台",
             `Core` comment "core", `ProductId` comment "产品id", `Roas` comment "Roas", `AdSetId` comment "广告系列",
             `AdCampId` comment "广告组", `Country` comment "国家", `Amount` comment "收入",
             `SourceChl` comment "广告投放渠道", `Chl2` comment "渠道值", `CreateUser` comment "创建用户 没用",
             `CreateType` comment "创建类型 没用", `CreateNum` comment "创建数量 没用", `RowVersion` comment "版本",
             `CurrentLanguage2` comment "投放语言", `IsRemarketing` comment "是否再营销",
             `Account` comment "广告所属账号", `LinkClick` comment "链接点击数", `Conversion` comment "offset转换数",
             `Registration` comment "去重注册人数", `ConvertSpend` comment "广告投放花费（西五区）")
as
select if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Id` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Id` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Id`)               as `Id`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdId` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdId` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdId`)             as `AdId`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdStatus` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdStatus` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdStatus`)         as `AdStatus`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_start` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_start` = ''), '1970-01-01 00:00:00',
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_start`)       as `date_start`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_stop` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_stop` = ''), '1970-01-01 00:00:00',
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`date_stop`)        as `date_stop`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdName` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdName` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdName`)           as `AdName`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Spend` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Spend` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Spend`)            as `Spend`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`PutData` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`PutData` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`PutData`)          as `PutData`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Installs` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Installs` = ''), 0,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Installs`)         as `Installs`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Clicks` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Clicks` = ''), 0,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Clicks`)           as `Clicks`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Impressions` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Impressions` = ''), 0,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Impressions`)      as `Impressions`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpc` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpc` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpc`)              as `Cpc`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpm` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpm` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpm`)              as `Cpm`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpp` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpp` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Cpp`)              as `Cpp`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Ctr` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Ctr` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Ctr`)              as `Ctr`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`UpdateTime` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`UpdateTime` = ''), '1970-01-01 00:00:00',
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`UpdateTime`)       as `UpdateTime`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Mt` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Mt` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Mt`)               as `Mt`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Core` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Core` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Core`)             as `Core`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ProductId` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ProductId` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ProductId`)        as `ProductId`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Roas` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Roas` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Roas`)             as `Roas`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdSetId` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdSetId` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdSetId`)          as `AdSetId`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdCampId` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdCampId` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`AdCampId`)         as `AdCampId`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Country` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Country` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Country`)          as `Country`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Amount` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Amount` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Amount`)           as `Amount`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`SourceChl` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`SourceChl` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`SourceChl`)        as `SourceChl`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Chl2` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Chl2` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Chl2`)             as `Chl2`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateUser` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateUser` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateUser`)       as `CreateUser`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateType` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateType` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateType`)       as `CreateType`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateNum` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateNum` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CreateNum`)        as `CreateNum`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`RowVersion` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`RowVersion` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`RowVersion`)       as `RowVersion`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CurrentLanguage2` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CurrentLanguage2` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`CurrentLanguage2`) as `CurrentLanguage2`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`IsRemarketing` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`IsRemarketing` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`IsRemarketing`)    as `IsRemarketing`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Account` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Account` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Account`)          as `Account`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`LinkClick` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`LinkClick` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`LinkClick`)        as `LinkClick`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Conversion` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Conversion` = ''), -99,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Conversion`)       as `Conversion`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Registration` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Registration` = ''), 0,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`Registration`)     as `Registration`
     , if((`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ConvertSpend` is null) or
          (`ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ConvertSpend` = ''), 0,
          `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`.`ConvertSpend`)     as `Registration`
  from `ods`.`ods_tidb_sharpengine_ads_global_LtvDailyInsight`;
utf8
utf8_general_ci