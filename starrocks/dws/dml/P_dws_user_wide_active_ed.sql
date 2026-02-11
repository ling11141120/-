----------------------------------------------------------------
-- 程序功能： 阅读线-用户域登录阅读充值消耗事件汇总活跃表
-- 程序名： P_dws_user_wide_active_ed
-- 目标表： dws.dws_user_wide_active_ed
-- 负责人： qhr
-- 开发日期： 2026-02-11
----------------------------------------------------------------

-- 昨天
insert into dws.dws_user_wide_active_ed
with lang_mapping as (
    select prod.prod_val
         , lang.lang_val
      from (select cd_val    as prod_val
                 , case when cd_val_desc = '繁体畅读' then '繁体'
                        else if(cd_val_desc = '英文阅读', '英语', replace(cd_val_desc, '阅读', ''))
                    end      as prod_desc
              from dim.dim_pub_code_mapping_dict
             where cd_col = 'product_id'
               and app_plat = 'pub'
               and cd_val_desc is not null
           )         as prod
      left join (select cd_val         as lang_val
                      , cd_val_desc    as lang_desc
                   from dim.dim_pub_code_mapping_dict
                  where cd_col = 'lang_cd'
                    and app_plat = 'pub'
                )    as lang
        on prod.prod_desc = lang.lang_desc
     where lang.lang_val is not null
)
select b.dt
     , b.Productid                     as product_id
     , b.UserId                        as user_id
     , acc.corever
     , acc.mt
     , acc.ver
     , acc.current_language            as current_language
     , acc.currentlanguage2            as currentlanguage2
     , acc.reg_country
     , acc.level
     , acc.appver
     , acc.create_time
     , datediff(b.dt, acc.create_time) as reg_days
     , acc.sex
     , if(c.user_id is not null, 1, 0) as is_pay
     , if(d.user_id is not null, 1, 0) as is_pay_current
     , now()                           as etl_time
  from (select dt
             , Productid
             , UserId
          from (select dt            as dt
                     , Productid     as Productid
                     , UserId        as UserId
                  from dwd.dwd_user_appstartlog          -- 登录
                 where dt = '${bf_1_dt}'
                   and UserId != 0
                 union all
                select dt            as dt
                     , Productid     as Productid
                     , UserId        as UserId
                  from dwd.dwd_trade_user_payorder       -- 交易
                 where dt = '${bf_1_dt}'
                   and UserId != 0
                 union all
                select dt            as dt
                     , product_id    as Productid
                     , user_id       as UserId
                  from dwd.dwd_consume_user_consume      -- 消耗
                 where dt = '${bf_1_dt}'
                   and user_id != 0
                 union all
                select dt            as dt
                     , Product_id    as Productid
                     , User_Id       as UserId
                  from dwd.dwd_read_user_chapter_view    -- 阅读事件
                 where dt = '${bf_1_dt}'
                   and user_id != 0
               )    as a
         group by 1, 2, 3
       )            as b
  left join (select a.product_id
                  , a.id
                  , if(a.corever is null or a.CoreVer = 0, 1, a.CoreVer) as corever
                  , a.mt
                  , a.ver
                  , a.current_language
                  , case when a.current_language2 is null or a.current_language2 = 0 then lang.lang_val
                         else a.current_language2
                     end                                                 as currentlanguage2
                  , a.reg_country
                  , b.level
                  , a.appver
                  , a.create_time
                  , a.sex
               from dim.dim_user_account_info_view as a
               left join dim.dim_countrylevel      as b
                 on a.product_id = b.product_id
                and a.reg_country = b.short_name
               left join lang_mapping              as lang
                 on a.product_id = lang.prod_val
            )       as acc
    on b.Productid = acc.product_id
   and b.UserId = acc.Id
  left join(select ProductId     as product_id
                 , userid        as user_id
              from dwd.dwd_trade_user_payorder    -- 历史是否付费
             where dt < '${bf_1_dt}'
             group by 1, 2
           )        as c
    on b.Productid = c.product_id
   and b.UserId = c.user_id
  left join (select dt
                  , ProductId    as product_id
                  , userid       as user_id
               from dwd.dwd_trade_user_payorder    -- 当天是否付费
              where dt = '${bf_1_dt}'
              group by 1, 2, 3
            )       d
    on b.dt = d.dt
   and b.Productid = d.product_id
   and b.UserId = d.user_id
;

-- 当天
insert into dws.dws_user_wide_active_ed
with lang_mapping as (
    select prod.prod_val
         , lang.lang_val
      from (select cd_val    as prod_val
                 , case when cd_val_desc = '繁体畅读' then '繁体'
                        else if(cd_val_desc = '英文阅读', '英语', replace(cd_val_desc, '阅读', ''))
                    end      as prod_desc
              from dim.dim_pub_code_mapping_dict
             where cd_col = 'product_id'
               and app_plat = 'pub'
               and cd_val_desc is not null
           )         as prod
      left join (select cd_val         as lang_val
                      , cd_val_desc    as lang_desc
                   from dim.dim_pub_code_mapping_dict
                  where cd_col = 'lang_cd'
                    and app_plat = 'pub'
                )    as lang
        on prod.prod_desc = lang.lang_desc
     where lang.lang_val is not null
)
select b.dt
     , b.Productid                     as product_id
     , b.UserId                        as user_id
     , acc.corever
     , acc.mt
     , acc.ver
     , acc.current_language            as current_language
     , acc.currentlanguage2            as currentlanguage2
     , acc.reg_country
     , acc.level
     , acc.appver
     , acc.create_time
     , datediff(b.dt, acc.create_time) as reg_days
     , acc.sex
     , if(c.user_id is not null, 1, 0) as is_pay
     , if(d.user_id is not null, 1, 0) as is_pay_current
     , now()                           as etl_time
  from (select dt
             , Productid
             , UserId
          from (select dt            as dt
                     , Productid     as Productid
                     , UserId        as UserId
                  from dwd.dwd_user_appstartlog          -- 登录
                 where dt = '${dt}'
                   and UserId != 0
                 union all
                select dt            as dt
                     , Productid     as Productid
                     , UserId        as UserId
                  from dwd.dwd_trade_user_payorder       -- 交易
                 where dt = '${dt}'
                   and UserId != 0
                 union all
                select dt            as dt
                     , product_id    as Productid
                     , user_id       as UserId
                  from dwd.dwd_consume_user_consume      -- 消耗
                 where dt = '${dt}'
                   and user_id != 0
                 union all
                select dt            as dt
                     , Product_id    as Productid
                     , User_Id       as UserId
                  from dwd.dwd_read_user_chapter_view    -- 阅读事件
                 where dt = '${dt}'
                   and user_id != 0
              )    as a
         group by 1, 2, 3
        )          as b
  left join (select a.product_id
                  , a.id
                  , if(a.corever is null or a.CoreVer = 0, 1, a.CoreVer) as corever
                  , a.mt
                  , a.ver
                  , a.current_language
                  , case when a.current_language2 is null or a.current_language2 = 0 then lang.lang_val
                         else a.current_language2
                     end                                                 as currentlanguage2
                  , a.reg_country
                  , b.level
                  , a.appver
                  , a.create_time
                  , a.sex
               from dim.dim_user_account_info_view    as a
               left join dim.dim_countrylevel         as b    -- 获取国家等级
                 on a.product_id = b.product_id
                and a.reg_country = b.short_name
               left join lang_mapping                 as lang
                 on a.product_id = lang.prod_val
             )     as acc
    on b.Productid = acc.product_id
   and b.UserId = acc.Id
  left join (select ProductId    as product_id
                  , userid       as user_id
               from dwd.dwd_trade_user_payorder    -- 历史是否付费
              where dt < '${dt}'
              group by 1, 2
            )     as c
    on b.Productid = c.product_id
   and b.UserId = c.user_id
  left join (select dt
                  , ProductId    as product_id
                  , userid       as user_id
               from dwd.dwd_trade_user_payorder    -- 当天是否付费
              where dt = '${dt}'
              group by 1, 2, 3
            )     as d
    on b.dt = d.dt
   and b.Productid = d.product_id
   and b.UserId = d.user_id
;