----------------------------------------------------------------
-- 程序功能： 客户端上报错误
-- 程序名： P_dws_flow_app_client_biz_admobaderror_ed
-- 目标表： dws.dws_flow_app_client_biz_admobaderror_ed
-- 负责人： 050239
-- 开发日期：2026-05-19
----------------------------------------------------------------

insert into dws.dws_flow_app_client_biz_admobaderror_ed
select dt
     , app_id
     , case when app_channel is not null and array_length(split(app_channel, '_')) = 4 then split(app_channel, '_')[2]
            when appchannel is not null and array_length(split(appchannel, '_')) = 4 then split(appchannel, '_')[2]
            when ifnull(app_core_ver,appcorever) is not null then concat('core',ifnull(app_core_ver,appcorever))
            else ''
        end                    as core
     , upper (case when app_channel is not null and array_length(split(app_channel, '_')) = 4 then split(app_channel, '_')[3]
                   when appchannel is not null and array_length(split(appchannel, '_')) = 4 then split(appchannel, '_')[3]
                   when lib is not null then lib
                   else ''
               end
             )                 as mt
     , case when app_channel is not null and array_length(split(app_channel, '_')) = 4 then split(app_channel, '_')[1]
            when appchannel is not null and array_length(split(appchannel, '_')) = 4 then split(appchannel, '_')[1]
            else ''
        end as product_id
     , ifnull(app_version,'')  as app_version
     , ifnull(biz_type,'')     as biz_type
     , ifnull(biz_ads_type,'') as biz_ads_type
     , case when biz_error_message is not null then if(regexp(biz_error_message, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)') = 1, regexp_extract(biz_error_message, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)', 2), biz_error_message )
            when biz_error_msg is not null then if(regexp(biz_error_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)') = 1, regexp_extract(biz_error_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)', 2), biz_error_msg )
            when biz_msg is not null then if(regexp(biz_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)') = 1, regexp_extract(biz_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)', 2), biz_msg )
            else null
        end                    as biz_msg
     , count(1) cnt
     , NOW()
  from dwd.dwd_flow_apperror_log_cdappclientbiz_view
 where dt >= '${bf_1_dt}'
   and biz_type = 'AdMobAdError'
   and  lib != 'js'
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9
;
