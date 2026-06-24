create view ads_advertisement_if_user_attribution_queue_view (
     dt                           comment "日期"
    ,product_id                   comment "产品id"
    ,id                           comment "自增id"
    ,user_id                      comment "用户id"
    ,source                       comment "来源"
    ,ad_id                        comment "广告id"
    ,ad_type                      comment "广告类型"
    ,install_date                 comment "安装时间"
    ,ad_account_id                comment "广告账户id"
    ,ad_set_id                    comment "广告系列id"
    ,book_id                      comment "书籍id"
    ,creative                     comment "广告创意"
    ,install_original_request     comment "安装原始请求"
    ,login                        comment "登录信息"
    ,unique_cd_reader_id          comment "设备信息"
    ,country                      comment "国家"
    ,mt                           comment "终端"
    ,core                         comment "core"
    ,data_insert_date             comment "插入时间"
    ,networkname                  comment "媒体值"
    ,chl2                         comment "渠道值"
    ,create_time                  comment "新增时间"
    ,adgroup_name                 comment "广告组名称"
    ,current_language2            comment "注册时语言"
    ,remarketing_time             comment "再营销时间"
    ,trace_id                     comment "追踪Id,和 Notify表数据关联"
    ,pixel_id                     comment "Fb像素Id"
    ,ad_quality_status            comment "广告质量状态"
    ,install_date_est             comment "西五区激活日期"
    ,next_attribute_time          comment "下一次归因时间"
    ,next_attribute_ad_id         comment "下一次归因广告id"
    ,next_attribute_source        comment "下一次归因来源"
    ,pre_attribute_time           comment "上一次归因来源时间"
    ,pre_attribute_ad_id          comment "上一次归因广告id"
    ,pre_attribute_source         comment "上一次归因来源"
    ,is_re_install                comment "是否再安装"
    ,status                       comment "处理状态"
    ,desc_info                    comment "描述信息"
    ,remark                       comment "备注"
    ,is_remarketing               comment "是否再营销"
    ,drop_time_send_to_app_server comment "丢弃通知服务器状态.默认值为null, 0需要发送 1发送成功"
    ,row_update_time
    ,raw_data_create_time
    ,raw_data_source
    ,c2rtime                      comment "广告点击时间"
    ,status2
    ,attribution_raw_data
    ,app_install_time
    ,last_click_time
    ,is_delete
    ,status3
    ,ad_name
    ,ad_set_name
    ,ad_camp_name
    ,ad_camp_id
    ,send_flag
    ,abtestpageid
    ,send_own_ads_status
    ,attributed
)
as
select date(CreateTime) as dt
     , ProductId
     , Id
     , UserId
     , Source
     , AdId
     , AdType
     , InstallDate
     , AdAccountId
     , AdSetId
     , BookId
     , Creative
     , InstallOriginalRequest
     , Login
     , UniqueCdReaderId
     , Country
     , Mt
     , Core
     , DataInsertDate
     , Networkname
     , Chl2
     , CreateTime
     , adgroup_name
     , CurrentLanguage2
     , RemarketingTime
     , TraceId
     , PixelId
     , AdQualityStatus
     , InstallDateEst
     , NextAttributeTime
     , NextAttributeAdId
     , NextAttributeSource
     , PreAttributeTime
     , PreAttributeAdId
     , PreAttributeSource
     , IsReInstall
     , Status
     , DescInfo
     , Remark
     , IsRemarketing
     , DropTimeSendToAppServer
     , row_update_time
     , RawDataCreateTime
     , RawDataSource
     , c2rtime
     , Status2
     , AttributionRawData
     , AppInstallTime
     , LastClickTime
     , IsDelete
     , Status3
     , AdName
     , AdSetName
     , AdCampName
     , AdCampId
     , SendFlag
     , abtestpageid
     , SendOwnAdsStatus
     , Attributed
  from ods.ods_tidb_sharpengine_ads_hk_bak_if_user_attribution_queue
;