----------------------------------------------------------------
-- 程序功能： 用户域-短剧全量用户信息
-- 程序名： P_dim_user_sv_userinfo_f
-- 目标表： dim.dim_user_sv_userinfo_f
-- 负责人： qhr
-- 开发日期： 2026-04-07
----------------------------------------------------------------

insert into dim.dim_user_sv_userinfo_f (
     product_id               -- product_id
    ,user_id                  -- 用户id
    ,sex                      -- 性别编码
    ,sex_name                 -- 性别名称
    ,create_time              -- 创建时间
    ,user_status              -- 用户状态编码
    ,user_status_name         -- 用户状态名称
    ,is_delete                -- 是否删除
    ,create_core              -- 创建时core
    ,current_login_core       -- 当前登录时core
    ,init_language            -- 初始语言编码
    ,init_language_name       -- 初始语言名称
    ,current_language         -- 当前语言编码
    ,current_language_name    -- 当前语言名称
    ,reg_country              -- 注册国家
    ,member_level             -- 会员等级编码
    ,member_level_name        -- 会员等级名称
    ,etl_time
)
select 6833                     as product_id               -- product_id
     , svai.Id                  as user_id                  -- 用户id
     , svai.Sex                 as sex                      -- 性别编码
     , null                     as sex_name                 -- 性别名称
     , svai.CreateTime          as create_time              -- 创建时间
     , svai.Status              as user_status              -- 用户状态编码
     , case when svai.Status = 0 then '正常'
            when svai.Status = 1 then '禁用'
            when svai.Status = 2 then '审核中'
            when svai.Status = 3 then '审核拒绝'
            else '未知'
       end                      as user_status_name         -- 用户状态名称
     , svai.IsDelete            as is_delete                -- 是否删除
     , svai.CoreVer2            as create_core              -- 创建时core
     , svai.CoreVer             as current_login_core       -- 当前登录时core
     , svai.CurrentLanguage2    as init_language            -- 初始语言编码
     , lang1.cd_val_desc        as init_language_name       -- 初始语言名称
     , svai.CurrentLanguage     as current_language         -- 当前语言编码
     , lang2.cd_val_desc        as current_language_name    -- 当前语言名称
     , svai.Country             as reg_country              -- 注册国家
     , svai.Level               as member_level             -- 会员等级编码
     , case when svai.Level = 0 then '普通用户'
            when svai.Level = 1 then 'svip'
            else '未知'
       end                      as member_level_name        -- 会员等级名称
     , now()                    as etl_time
  from ods.ods_tidb_short_video_accountinfo    as svai
  left join dim.dim_pub_code_mapping_dict      as lang1
    on svai.CurrentLanguage2 = lang1.cd_val
      and lang1.app_plat = 'pub'
      and lang1.cd_col = 'lang_cd'
  left join dim.dim_pub_code_mapping_dict      as lang2
    on svai.CurrentLanguage = lang2.cd_val
   and lang2.app_plat = 'pub'
   and lang2.cd_col = 'lang_cd'
;

insert into dim.dim_user_sv_userinfo_f (
     product_id
    ,user_id
    ,is_gold_coin_user
    ,etl_time
)
select 6833         as product_id           -- product_id
     , AccountId    as user_id              -- 用户id
     , IsGolden     as is_gold_coin_user    -- 是否金币网赚用户
     , now()        as etl_time             -- 数据入库时间
  from ods.ods_tidb_short_video_account_extra
 where CreateTime >= '${bf_2_dt}'
   and CreateTime < '${af_1_dt}'
   and UpdateTime >= '${bf_1_dt}'
   and UpdateTime < '${af_1_dt}'
qualify row_number() over (partition by AccountId order by Id desc) = 1