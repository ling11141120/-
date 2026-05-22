----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_account_info
-- task_version     : 7
-- update_time      : 2025-01-22 13:56:12
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_account_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_account_info
select  '${bf_1_dt}' as dt,
        product_id,
        user_id,
        nick,sex,
        floor(datediff('${dt}',date(create_tm_account)) / 365.25) as age,
        reg_country,
        province,
        city,
        abs(murmur_hash3_32(concat(product_id,user_id))) as group_hash,
        abs(murmur_hash3_32(concat(product_id,user_id))) % 10 as group_id_1,
        abs(murmur_hash3_32(concat(product_id,user_id))) % 100 as group_id_2,
        abs(murmur_hash3_32(concat(product_id,user_id))) % 1000 as group_id_3,
        abs(murmur_hash3_32(concat(product_id,user_id))) % 10000 as group_id_4,
        ver,
        continue_sign_num,
        reg_country,
        province,
        city,
        create_tm_account,
        current_language2,
        current_language,
        money,
        gift_money,
        medal,
        datediff('${bf_1_dt}',date(create_tm_account)) as register_day,
        CASE
            WHEN datediff('${bf_1_dt}',date(create_tm_account)) <= 6 THEN 1
            ELSE 0
        END as is_new_user,
        is_has_charge,
        is_negative_user,
        CASE
            WHEN is_has_charge = 0 and ads_quality = 0 and ads_type != '' THEN 1
            ELSE 0
        END as is_iaa,
        has_invite_friends,
        medal_min_expire_time,
        last_buy_bonussign_card_tm,
        last_buybonussign_cardplus_tm,
        bonussign_card_tm,
        bonussign_cardplus_tm,
        user_maxcharge_amount,
        daily_jifen_to_gift_flag,
        ads_type,
        ads_quality,
        mt,
        corever,
        current_language2,
        reg_country,
        level,
        account,
        now() as etl_time
from dim.dim_user_all_info
where create_tm_account < '${dt}';
