create or replace view dwd.dwd_user_install_info_ed_view (
     Id
    ,dt
    ,Product_Id
    ,User_Id
    ,Source
    ,Ad_Id
    ,Ad_Type
    ,Install_Date
    ,AdAccount_Id
    ,AdSet_Id
    ,Book_Id
    ,Creative
    ,Install_Original_Request
    ,Login
    ,Unique_CdReaderId
    ,Country
    ,mt
    ,Core
    ,DataInsert_Date
    ,Network_name
    ,Chl2
    ,Create_Time
    ,adgroup_name
    ,Current_Language2
    ,Remarketing_Time
    ,AdQuality_Status
    ,Install_DateEst
    ,ReInstall_Date
    ,Analysis_Server_Status
    ,Next_Attribute_Time
    ,Next_Attribute_AdId
    ,Next_Attribute_Source
    ,Pre_Attribute_Time
    ,Pre_Attribute_AdId
    ,Pre_Attribute_Source
    ,Is_ReInstall
    ,Pre_Attribute_DataId
    ,Next_Attribute_DataId
    ,RawAd_Id
    ,Trace_Id
    ,Pixel_Id
    ,At
    ,Is_Remarketing
    ,Next_Attribute_IsRemarketing
    ,Pre_Attribute_IsRemarketing
    ,RemarkTime_SendTo_AppServer
    ,Custom_Audiences
    ,IsDelete
    ,row_update_time
    ,c2rtime
)
as
select Id
      ,dt
      ,ProductId                                  as Product_Id
      ,UserId                                     as User_Id
      ,Source
      ,AdId                                       as Ad_Id
      ,AdType                                     as Ad_Type
      ,InstallDate                                as Install_Date
      ,AdAccountId                                as AdAccount_Id
      ,AdSetId                                    as AdSet_Id
      ,BookId                                     as Book_Id
      ,Creative
      ,InstallOriginalRequest                     as Install_Original_Request
      ,Login
      ,UniqueCdReaderId                           as Unique_CdReaderId
      ,Country
      ,if(Mt is not null and Mt != 0,Mt,RawMt)    as mt
      ,Core
      ,DataInsertDate                             as DataInsert_Date
      ,Networkname                                as Network_name
      ,Chl2
      ,CreateTime                                 as Create_Time
      ,adgroup_name
      ,CurrentLanguage2                           as Current_Language2
      ,RemarketingTime                            as Remarketing_Time
      ,AdQualityStatus                            as AdQuality_Status
      ,InstallDateEst                             as Install_DateEst
      ,ReInstallDate                              as ReInstall_Date
      ,AnalysisServerStatus                       as Analysis_Server_Status
      ,NextAttributeTime                          as Next_Attribute_Time
      ,NextAttributeAdId                          as Next_Attribute_AdId
      ,NextAttributeSource                        as Next_Attribute_Source
      ,PreAttributeTime                           as Pre_Attribute_Time
      ,PreAttributeAdId                           as Pre_Attribute_AdId
      ,PreAttributeSource                         as Pre_Attribute_Source
      ,IsReInstall                                as Is_ReInstall
      ,PreAttributeDataId                         as Pre_Attribute_DataId
      ,NextAttributeDataId                        as Next_Attribute_DataId
      ,RawAdId                                    as RawAd_Id
      ,TraceId                                    as Trace_Id
      ,PixelId                                    as Pixel_Id
      ,At
      ,IsRemarketing                              as Is_Remarketing
      ,NextAttributeIsRemarketing                 as Next_Attribute_IsRemarketing
      ,PreAttributeIsRemarketing                  as Pre_Attribute_IsRemarketing
      ,RemarkTimeSendToAppServer                  as RemarkTime_SendTo_AppServer
      ,CustomAudiences                            as Custom_Audiences
      ,IsDelete
      ,row_update_time
      ,c2rtime
  from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
 where ProductId not in (6883)
 union all
select Id
      ,date(InstallDate)             as dt
      ,ProductId                     as Product_Id
      ,UserId                        as User_Id
      ,Source
      ,AdId                          as Ad_Id
      ,AdType                        as Ad_Type
      ,InstallDate                   as Install_Date
      ,AdAccountId                   as AdAccount_Id
      ,AdSetId                       as AdSet_Id
      ,BookId                        as Book_Id
      ,Creative
      ,InstallOriginalRequest        as Install_Original_Request
      ,Login
      ,UniqueCdReaderId              as Unique_CdReaderId
      ,Country
      ,Mt
      ,Core
      ,DataInsertDate                as DataInsert_Date
      ,Networkname                   as Network_name
      ,Chl2
      ,CreateTime                    as Create_Time
      ,adgroup_name
      ,CurrentLanguage2              as Current_Language2
      ,RemarketingTime               as Remarketing_Time
      ,AdQualityStatus               as AdQuality_Status
      ,InstallDateEst                as Install_DateEst
      ,ReInstallDate                 as ReInstall_Date
      ,AnalysisServerStatus          as Analysis_Server_Status
      ,NextAttributeTime             as Next_Attribute_Time
      ,NextAttributeAdId             as Next_Attribute_AdId
      ,NextAttributeSource           as Next_Attribute_Source
      ,PreAttributeTime              as Pre_Attribute_Time
      ,PreAttributeAdId              as Pre_Attribute_AdId
      ,PreAttributeSource            as Pre_Attribute_Source
      ,IsReInstall                   as Is_ReInstall
      ,PreAttributeDataId            as Pre_Attribute_DataId
      ,NextAttributeDataId           as Next_Attribute_DataId
      ,RawAdId                       as RawAd_Id
      ,TraceId                       as Trace_Id
      ,PixelId                       as Pixel_Id
      ,At
      ,IsRemarketing                 as Is_Remarketing
      ,NextAttributeIsRemarketing    as Next_Attribute_IsRemarketing
      ,PreAttributeIsRemarketing     as Pre_Attribute_IsRemarketing
      ,RemarkTimeSendToAppServer     as RemarkTime_SendTo_AppServer
      ,CustomAudiences               as Custom_Audiences
      ,IsDelete
      ,null                          as row_update_time
      ,null                          as c2rtime
  from ods.ods_tidb_cdvideo_tidb_xcx_user_attribution
;