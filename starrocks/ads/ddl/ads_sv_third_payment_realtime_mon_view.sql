create view ads.ads_sv_third_payment_realtime_mon_view as
select stat_time
      ,product_id
      ,user_type
      ,core
      ,mt
      ,bitmap_union_count(exposure_uv)        as exposure_uv
      ,bitmap_union_count(third_exposure_uv)   as third_exposure_uv
      ,bitmap_union_count(enter_group_uv)      as enter_group_uv
      ,bitmap_union_count(third_recharge_uv)   as third_recharge_uv
      ,sum(third_recharge_amount)              as third_recharge_amount
      ,sum(native_recharge_amount)             as native_recharge_amount
  from ads.ads_sv_third_payment_realtime_mon
 group by stat_time, product_id, user_type, core, mt
