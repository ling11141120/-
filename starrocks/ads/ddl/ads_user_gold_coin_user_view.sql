create or replace view ads.ads_user_gold_coin_user_view (
     user_id           comment '用户id'
    ,collect_email     comment '收集邮箱'
    ,create_time       comment '创建时间'
    ,update_time       comment '修改时间'
    ,is_golden         comment '是否金币网赚用户'
    ,is_dl             comment '是否DL用户'
    ,dl_update_time    comment 'DL用户修改时间'
    ,is_coin_dl        comment '是否金币DL用户'
    ,is_dl0_for_you    comment '是否C4 DL0跳转ForYou用户'
    ,currency_code     comment '网赚用户首次货币码'
)
comment '用户域金币网赚用户视图'
as
select a1.AccountId         -- 用户id
      ,a1.CollectEmail      -- 收集邮箱
      ,a1.CreateTime        -- 创建时间
      ,a1.UpdateTime        -- 修改时间
      ,a1.IsGolden          -- 是否金币网赚用户
      ,a1.IsDl              -- 是否DL用户
      ,a1.dlUpdateTime      -- DL用户修改时间
      ,a1.isCoinDl          -- 是否金币DL用户
      ,a1.is_dl0_for_you    -- 是否C4 DL0跳转ForYou用户
      ,a1.currencyCode      -- 网赚用户首次货币码
  from (select AccountId
              ,CollectEmail
              ,CreateTime
              ,UpdateTime
              ,IsGolden
              ,IsDl
              ,dlUpdateTime
              ,isCoinDl
              ,is_dl0_for_you
              ,currencyCode
              ,row_number() over(partition by AccountId order by UpdateTime desc)    as rn
          from ods.ods_tidb_short_video_account_extra
       )    as a1
 where rn = 1
;