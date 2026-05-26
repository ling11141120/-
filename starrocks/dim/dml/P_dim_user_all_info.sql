----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_user_all_info
-- workflow_version : 16
-- create_user      : zhugl
-- task_name        : tbl_dim_user_all_info
-- task_version     : 16
-- update_time      : 2025-03-27 22:02:28
-- sql_path         : \starrocks\tbl_dim_user_all_info\tbl_dim_user_all_info
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_user_all_info
select
    a.product_id,
    a.Id,
    a.Account,
    a.Nick,
    a.Sex,
    a.Create_Time,
    a.Last_Login_Time,
    a.Chl,
    a.MT,
    a.IMEI,
    a.IMSI,
    a.MAC,
    a.Money,
    a.Phone,
    a.Device_GUID,
    a.Device_Token,
    a.EMail,
    a.Has_Charge,
    a.Province,
    a.City,
    a.Birthday,
    a.Country,
    a.Prod_Id,
    a.Code,
    a.Gift_Money,
    a.Award_Money,
    a.Chl2,
    a.IP,
    a.Point,
    a.AppVer,
    a.Ver,
    a.IDFA,
    a.AD_ID,
    a.Ad_Type,
    a.Android_Id,
    a.Reg_IP,
    a.Reg_Country,
    a.Has_Bound_Email,
    a.Email_Bound_Status,
    a.JiFen,
    a.CoreVer,
    a.Is_Fire_base,
    a.App_Id,
    a.App_Id2,
    a.Current_Language,
    a.Row_Update_Timestamp,
    a.Android_Id_For_Device_GUID,
    a.MT2,
    a.CoreVer2,
    a.DeepLink_Plat_form,
    a.Reg_Country2,
    a.Book_Id,
    a.Unique_CdReader_Id,
    a.Current_Language2,
    a.Has_Change_Lang	,
    b.ads_type,  -- ads_type varchar(60) NULL COMMENT "------ADSTYPE",
    b.ads_quality,  -- ads_quality COMMENT int(11) "------",
    b.default_into_page_type, -- default_into_page_type int(11) NULL COMMENT "------",
    b.default_into_page_time, -- default_into_page_time datetime COMMENT "----",
    b.is_negative_user, -- is_negative_user int(11)  COMMENT "------",
    b.remarketing_time, -- remarketing_time datetime COMMENT "-----",
    c.low_vip_seconds_start_tm, -- low_vip_seconds_start_tm datetime NULL COMMENT "vip--------",
    c.low_vip_expire_tm, -- low_vip_expire_tm datetime NULL COMMENT "------",
    c.low_vip_expire_time_seconds, -- low_vip_expire_time_seconds bigint(20) NULL COMMENT "------,vip---------",
    c.last_buy_bonussign_card_tm,  -- last_buy_bonussign_card_tm datetime COMMENT "---------",
    c.last_buybonussign_cardplus_tm, -- last_buybonussign_cardplus_tm datetime COMMENT "----plus-----",
    c.bonussign_card_tm, -- bonussign_card_tm datetime COMMENT "---------",
    c.bonussign_cardplus_tm, -- bonussign_cardplus_tm datetime COMMENT "-----plus----",
    c.user_maxcharge_amount, -- user_maxcharge_amount decimal64(10, 0) COMMENT "------",
    LEVEL,
    case when b.ads_type !='' and b.ads_quality =0 then '1'
         when a.has_charge=0 and b.is_negative_user =1 then '2'
         when a.has_charge=1 and b.is_negative_user = 1 then '3'
         else '4' end  as user_type,
    now(),
    c.ram,
    c.sys_releasever,
    c.device,
    c.brand,
	a.continue_sign_num,a.medal,a.medal_min_expire_time,a.daily_jifen_to_gift_flag,b.has_invite_friends,c.total_read_times,
    udf.ip2country(ip) last_country_name,user_ad_source
from (select dt,product_id,id,account,nick,sex,head_id,create_time,last_login_time,chl,mt,imei,imsi,
mac,money,phone,last_sign_time,continue_sign_num,continue_login_num,device_guid,consume_level,last_stat_time,
send_reward_num,ticket,ticket_time,curmonth_consume,last_month_consume,curmonth_reward,last_month_reward,device_token,
curmonth_ticket,acc,email,client_id,is_auto_account,has_charge,has_sent_welcome,`exp`,money_first_date,province,city,
birthday,country,prod_id,send_gift_consume_total,is_first,benefit_send,code,operate_over,gift_money,gift_money_ex,
award_money,award_money_ex,chl2,ip,total_coin,head_image_url,need_push_shelf_book,read_num,recharge_type,
recharge_type_expire_time,`point`,appver,ver,is_special_consumer,is_can_consume,idfa,month_card_expire_date,sales_man_type,
voice_inviter_id,voice_sales_man_type,phone_bind_time,ut_coff_set,voice_sales_man_expire_time,sales_man_expire_time,
last_buy_month_card_date,last_buy_month_card_id,introduction,ad_id,ad_type,android_id,install_date,reg_ip,reg_country,
plat_form,has_bound_email,email_bound_status,has_buy_old_card,jifen,last_report_time,corever,back_gound_img_url,
has_charge_before,config_ver,is_fire_base,has_buy_old_vip_card,app_id,app_id2,current_language,
month_card_plus_expire_date,last_buy_month_card_plus_date,last_buy_month_card_plus_id,row_update_timestamp,
android_id_for_device_guid,last_item_price,mt2,corever2,deeplink_plat_form,reg_country2,energy,total_energy,
book_id,screen_lock_time,real_last_login_time,unique_cdreader_id,current_language2,has_change_lang,medal,medal_min_expire_time,
daily_jifen_to_gift_flag,continue_sign_num2,continue_sign_num3,sign_round,bengin_sign_round_time,bengin_sign_time3,
bengin_sign_time2 from dim.dim_user_account_info_view  ) a
         left join
     (
         select
             id,
             ads_type,  -- ads_type varchar(60) NULL COMMENT "-------ADSTYPE",
             ads_quality,  -- ads_quality COMMENT int(11) "------",
             default_into_page_type, -- default_into_page_type int(11) NULL COMMENT "------",
             default_into_page_time, -- default_into_page_time datetime COMMENT "----",
             is_negative_user, -- is_negative_user int(11)  COMMENT "------",
             remarketing_time, -- remarketing_time datetime COMMENT "-----",
             product_id,
             has_invite_friends,
			 user_ad_source
         from dim.dim_user_other_info_view
     )b on a.product_id = b.product_id and a.id = b.id
         left join
     (
         select
             id,
             low_vip_seconds_start_tm, -- low_vip_seconds_start_tm datetime NULL COMMENT "vip--------",
             low_vip_expire_tm, -- low_vip_expire_tm datetime NULL COMMENT "------",
             low_vip_expire_time_seconds, -- low_vip_expire_time_seconds bigint(20) NULL COMMENT "------,vip---------",
             last_buy_bonussign_card_tm,  -- last_buy_bonussign_card_tm datetime COMMENT "---------",
             last_buybonussign_cardplus_tm, -- last_buybonussign_cardplus_tm datetime COMMENT "----plus-----",
             bonussign_card_tm, -- bonussign_card_tm datetime COMMENT "---------",
             bonussign_cardplus_tm, -- bonussign_cardplus_tm datetime COMMENT "-----plus----",
             user_maxcharge_amount, -- user_maxcharge_amount decimal64(10, 0) COMMENT "------",
             product_id ,
             ram,
             brand,
             total_read_times,
             sys_releasever,
             device
         from dim.dim_user_userdata_view
     ) c  on a.product_id = c.product_id and a.id = c.id
         LEFT  JOIN dim.dim_countrylevel d on a.product_id = d.product_id and a.Reg_Country = d.short_name;
