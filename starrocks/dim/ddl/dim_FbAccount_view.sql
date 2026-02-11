create or replace view dim.dim_FbAccount_view (
     Id                                comment "主键id"
    ,Account                           comment "FB投放账户ID"
    ,Secret                            comment "Fb API Secret"
    ,PageId                            comment "页面"
    ,AppId                             comment "appId"
    ,AppUrl                            comment "Facebook AppUrl"
    ,CreateTime                        comment "创建时间"
    ,ProductId                         comment "产品id"
    ,ProductName                       comment "产品 账号名"
    ,Mt                                comment "设备"
    ,Token                             comment "Facebook API Token"
    ,InsId                             comment "Facebook InsId"
    ,Status                            comment "0-禁用 1-启用"
    ,AutoFillAd                        comment "自动填充 0 否 1 是"
    ,UpdateStatus                      comment "更新状态"
    ,Chl                               comment "渠道"
    ,Core                              comment "core"
    ,FbAdRuleId                        comment "自动关闭规则Id"
    ,AdAutoActive                      comment "广告自动激活"
    ,StatusChangeTime                  comment "状态更新时间"
    ,FbAccountType                     comment "1表示再营销 0正常新增投放"
    ,RowVersion                        comment "同步数据用的"
    ,SpendCap                          comment "额度金额"
    ,AmountSpent                       comment "已经花费的金额"
    ,PutProductId                      comment "投放语言ID"
    ,CurrentLanguage2                  comment "投放语言"
    ,AccountAdType                     comment "账号广告类型"
    ,ExchangeRate                      comment "汇率"
    ,IsProductPutAccount               comment "是否书籍目录投放账号"
    ,LastPutTime                       comment "最新的投放数据的时间"
    ,FbAdNetworkType                   comment "fb投放类型，1app 2web"
    ,AccountChangeToRemarketingTime    comment "何时设置为再营销类型"
    ,ThirdPayDatasetId                 comment "第三方充值上传的fb中的datasetid"
    ,LastInsightInfo                   comment "最后一次抓取dailyinsight的信息"
    ,InstId                            comment "机构ID"
)
comment "fb投放账号表"
as
select Id
     , if(coalesce(Account, '') = '', -99, Account)                                                                    as Account
     , if(coalesce(Secret, '') = '', -99, Secret)                                                                      as Secret
     , if(coalesce(PageId, '') = '', -99, PageId)                                                                      as PageId
     , if(coalesce(AppId, '') = '', -99, AppId)                                                                        as AppId
     , if(coalesce(AppUrl, '') = '', -99, AppUrl)                                                                      as AppUrl
     , if(coalesce(creattime, '') = '', '1970-01-01 00:00:00', creattime)                                              as CreateTime
     , if(coalesce(ProductId, '') = '', -99, ProductId)                                                                as ProductId
     , if(coalesce(ProductName, '') = '', -99, ProductName)                                                            as ProductName
     , if(coalesce(Mt, '') = '', -99, Mt)                                                                              as Mt
     , if(coalesce(Token, '') = '', -99, Token)                                                                        as Token
     , if(coalesce(InsId, '') = '', -99, InsId)                                                                        as InsId
     , if(coalesce(Status, '') = '', -99, Status)                                                                      as Status
     , if(coalesce(AutoFillAd, '') = '', -99, AutoFillAd)                                                              as AutoFillAd
     , if(coalesce(UpdateStatus, '') = '', -99, UpdateStatus)                                                          as UpdateStatus
     , if(coalesce(Chl, '') = '', -99, Chl)                                                                            as Chl
     , if(coalesce(Core, '') = '', -99, Core)                                                                          as Core
     , if(coalesce(FbAdRuleId, '') = '', -99, FbAdRuleId)                                                              as FbAdRuleId
     , if(coalesce(AdAutoActive, '') = '', -99, AdAutoActive)                                                          as AdAutoActive
     , if(coalesce(StatusChangeTime, '') = '', '1970-01-01 00:00:00', StatusChangeTime)                                as StatusChangeTime
     , if(coalesce(FbAccountType, '') = '', -99, FbAccountType)                                                        as FbAccountType
     , if(coalesce(RowVersion, '') = '', -99, RowVersion)                                                              as RowVersion
     , if(coalesce(SpendCap, '') = '', -99, SpendCap)                                                                  as SpendCap
     , if(coalesce(AmountSpent, '') = '', -99, AmountSpent)                                                            as AmountSpent
     , if(coalesce(PutProductId, '') = '', -99, PutProductId)                                                          as PutProductId
     , if(coalesce(CurrentLanguage2, '') = '', -99, CurrentLanguage2)                                                  as CurrentLanguage2
     , if(coalesce(AccountAdType, '') = '', -99, AccountAdType)                                                        as AccountAdType
     , if(coalesce(ExchangeRate, '') = '', -99, ExchangeRate)                                                          as ExchangeRate
     , if(coalesce(IsProductPutAccount, '') = '', -99, IsProductPutAccount)                                            as IsProductPutAccount
     , if(coalesce(LastPutTime, '') = '', '1970-01-01 00:00:00', LastPutTime)                                          as LastPutTime
     , if(coalesce(FbAdNetworkType, '') = '', -99, FbAdNetworkType)                                                    as FbAdNetworkType
     , if(coalesce(AccountChangeToRemarketingTime, '') = '', '1970-01-01 00:00:00', AccountChangeToRemarketingTime)    as AccountChangeToRemarketingTime
     , if(coalesce(ThirdPayDatasetId, '') = '', -99, ThirdPayDatasetId)                                                as ThirdPayDatasetId
     , if(coalesce(LastInsightInfo, '') = '', -99, LastInsightInfo)                                                    as LastInsightInfo
     , if(coalesce(InstId, '') = '', -99, InstId)                                                                      as InstId
  from ods.ods_tidb_sharpengine_ads_global_FbAccount
;