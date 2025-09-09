insert into dwd.dwd_trade_short_video_payorder
with ref_ord as (
    select id
          ,classtype
          ,get_json_string(args, '$.OrderId')    as orderid
          ,scheduletime
          ,status
          ,execcount
          ,exectime
      from ods.ods_short_video_commandtask
     where scheduletime >= '${bf_1_dt}'
)
select dt
      ,product_id
      ,id
      ,status
      ,`type`
      ,userid
      ,used
      ,orderid
      ,flag
      ,createtime
      ,gettime
      ,itemcount
      ,systemtype
      ,receivedate
      ,mt
      ,couponid
      ,packageid
      ,shopitem
      ,extinfo
      ,vip_expire_time
      ,real_money
      ,give_money
      ,amount
      ,prod_id
      ,pay_config_id
      ,corever
      ,unique_guid
      ,test_flag
      ,buy_token
      ,base_amount
      ,version
      ,subpay_type
      ,gift_money
      ,order_init_time
      ,cooorderextinfo
      ,custom_data
      ,scheduletime
      ,etl_tm
  from (select dt
              ,6833 product_id
              ,id
              ,0 status
              ,`type`
              ,userid
              ,used
              ,orderid
              ,flag
              ,createtime
              ,gettime
              ,itemcount
              ,systemtype
              ,receivedate
              ,mt
              ,couponid
              ,packageid
              ,shopitem
              ,extinfo
              ,vip_expire_time
              ,real_money
              ,give_money
              ,amount
              ,prod_id
              ,pay_config_id
              ,corever
              ,unique_guid
              ,test_flag
              ,buy_token
              ,base_amount
              ,version
              ,subpay_type
              ,gift_money
              ,order_init_time
              ,cooorderextinfo
              ,custom_data
              ,null scheduletime
              ,now() etl_tm
          from ods.ods_tidb_short_video_payorder
         where dt >= '${bf_1_dt}'
         union all
        select date(scheduletime) dt
              ,6833 product_id
              ,b.id
              ,1 status
              ,b.`type`
              ,b.userid
              ,b.used
              ,b.orderid
              ,b.flag
              ,b.createtime
              ,b.gettime
              ,b.itemcount * -1
              ,b.systemtype
              ,b.receivedate
              ,b.mt
              ,b.couponid
              ,b.packageid
              ,b.shopitem
              ,b.extinfo
              ,b.vip_expire_time
              ,b.real_money
              ,b.give_money
              ,b.amount
              ,b.prod_id
              ,b.pay_config_id
              ,b.corever
              ,b.unique_guid
              ,b.test_flag
              ,b.buy_token
              ,b.base_amount * -1
              ,b.version
              ,b.subpay_type
              ,b.gift_money
              ,b.order_init_time
              ,b.cooorderextinfo
              ,b.custom_data
              ,scheduletime
              ,now() etl_tm
          from ods.ods_tidb_short_video_payorder b
          join ref_ord
            on b.orderid = ref_ord.orderid
       ) a
;