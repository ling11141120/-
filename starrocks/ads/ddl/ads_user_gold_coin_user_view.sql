----------------------------------------------------------------
-- 目标表： ads.ads_user_gold_coin_user_view
-- 来源表： dwd.dwd_user_gold_coin_user
-- 功能： 用户域金币网赚用户视图
----------------------------------------------------------------

create or replace view ads.ads_user_gold_coin_user_view (
     dt                   comment '分区日期'
    ,user_id              comment '用户id'
    ,is_gold_coin_user    comment '是否金币网赚用户'
    ,create_time          comment '创建时间'
    ,etl_time             comment '数据入库时间'
)
comment '用户域金币网赚用户视图'
as
select dt
      ,user_id
      ,is_gold_coin_user
      ,create_time
      ,etl_time
  from dwd.dwd_user_gold_coin_user
;
