----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_user_install_info_ed
-- workflow_version : 1
-- create_user      : yanxh
-- task_name        : tbl_dwd_user_install_info_ed 
-- task_version     : 1
-- update_time      : 2023-10-12 15:55:44
-- sql_path         : \starrocks\tbl_dwd_user_install_info_ed\tbl_dwd_user_install_info_ed 
----------------------------------------------------------------
-- SQL语句
insert into  dwd.dwd_user_install_info_ed
       select   Id , dt ,ProductId Product_Id ,UserId User_Id , Source ,AdId Ad_Id , AdType Ad_Type ,InstallDate Install_Date ,AdAccountId AdAccount_Id ,AdSetId AdSet_Id ,
     BookId   Book_Id , Creative ,InstallOriginalRequest  Install_Original_Request , Login ,UniqueCdReaderId Unique_CdReaderId , Country , Mt , Core ,
   DataInsertDate     DataInsert_Date , Networkname Network_name , Chl2 ,CreateTime  Create_Time , adgroup_name ,CurrentLanguage2 Current_Language2 ,RemarketingTime Remarketing_Time ,
   AdQualityStatus    AdQuality_Status ,InstallDateEst Install_DateEst ,ReInstallDate ReInstall_Date ,AnalysisServerStatus Analysis_Server_Status ,NextAttributeTime  Next_Attribute_Time ,
   NextAttributeAdId     Next_Attribute_AdId ,NextAttributeSource Next_Attribute_Source ,PreAttributeTime Pre_Attribute_Time ,PreAttributeAdId  Pre_Attribute_AdId ,PreAttributeSource Pre_Attribute_Source ,
    IsReInstall    Is_ReInstall , PreAttributeDataId Pre_Attribute_DataId ,NextAttributeDataId  Next_Attribute_DataId , RawAdId RawAd_Id ,
     TraceId   Trace_Id , PixelId Pixel_Id , At , IsRemarketing Is_Remarketing ,NextAttributeIsRemarketing  Next_Attribute_IsRemarketing ,
   PreAttributeIsRemarketing  Pre_Attribute_IsRemarketing ,RemarkTimeSendToAppServer RemarkTime_SendTo_AppServer ,CustomAudiences Custom_Audiences ,IsDelete,row_update_time ,now() as etl_time
        from  ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
    where dt >=DATE_SUB(CURRENT_DATE(),interval 7 day );
