select t1.dt,
       cast(t1.dt as STRING)                                                      as `日`,
       concat(if(dayofweek(t1.dt) = 2, t1.dt, cast(previous_day(t1.dt, 'Monday') as STRING)), '(', weekofyear(t1.dt),
              ')')                                                                as `周`,
       substr(t1.dt, 1, 7)                                                        as `月`,
       case
           when shop_item = 810 then 'SVIP'
           when shop_item = 830 then '福利包'
           when shop_item = 840 then '新福利包'
           when shop_item = 850 then 'VIP'
           when shop_item = 860 then 'NSVIP'
           end                                                                    as `订阅类型`,
       case when vip_type = '天卡' then '3天卡' else vip_type end                 as `订阅周期`,
       cast(item_count as varchar)                                                as `订阅价格`,
       cast(first_validity as varchar)                                            as `首订有效期`,
       cast(first_price as varchar)                                               as `首订价格`,
       cast(t1.user_id as varchar)                                                   user_id,
       after_charge                                                               as '税后金额',
       if(row_number() over (partition by t1.user_id,t1.item_id,order_id ) = 1, after_charge,
          0)                                                                         `税后金额_agg`, -- # 首订金额去重
       t2.autoRenew_times                                                         as `续订次数`,
       reg_lang                                                                   as `注册语言`,
       if(vip_expire_time <= CURDATE() or t2.autoRenew_times > 0, order_id, null) as `exp_order`,
       order_id                                                                   as `订单ID`,
       row_number() over (partition by t1.user_id,t1.item_id,order_id )           as rn
from (select t1.dt,
             shop_item,--订阅类型
             vip_type,--订阅周期
             price,--订阅价格
             item_count,--订单充值金额
             first_validity,--首充有效期
             first_price,--首充价格
             t1.user_id,--用户id
             country,--国家
             item_id,
             after_charge,--订单金额（分成后）
     		 t1.product_id,  --产品id
             t2.user_ad_source,--广告投流用户（0：正常用户；1：vip投流用户）
             t1.order_id,--订单号
             vip_expire_time,--过期时间（谷歌和苹果）
             dic_reglang.remarks as reg_lang
      from ads.ads_bi_trade_user_subscribe_di t1
               left join (SELECT order_id, corever
                          from ads.ads_trade_user_payorder_view
                          where dt >= '${开始时间}'
                            and dt <= '${结束时间}'
                            and get_json_object(cooorder_extinfo, '$.SubscribeStatus') <> 2
                            and shop_item <> 0) t1_ on t1.order_id = t1_.order_id -- 续订表core有问题，用原始订单表的core
               left join dim.dim_dic dic_reglang -- 注册语言
                         on t1.current_language2 = dic_reglang.enum_id
                             and dic_reglang.table_name = 'dim_producttype'
                             and dic_reglang.dic_column = 'language_id'
               left join dws.dws_user_wide_active_period_ed t2
                         on t1.dt = t2.dt
                             and t1.user_id = t2.user_id
                             and t2.period_type = 'ctt'
               left join (select a.product_id
                               , a.dt
                               , a.install_date
                               , a.source
                               , a.mt
                               , a.core
                               , a.book_id
                               , a.ad_id
                               , a.Creative
                               , a.ad_account_id
                               , a.unique_cd_reader_id
                               , a.user_id
                               , date(NextAttributeTime) next_dt
                          from ads.ads_advertisement_if_user_attribution_queue_view a
                                   inner join ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer b
                                              on a.id = b.Id
                          where b.IsDelete = 0) t3
                         on t1.user_id = t3.user_id and t1.dt>=t3.dt and t1.dt<t3.next_dt
               left join
           (select book_id, book_code
            from dim.dim_shuangwen_book_read_consume_info
            group by book_id, book_code) t4
           on t3.book_id = t4.book_id
      where sub_pay_type in ('GooglePlay', 'AppStore', 'AppGallery', 'PaypalV2', 'Stripe', 'PayPalV2')
        and shop_item <> 800
        and subscribe_status <> 2---（2续订，其他首订）
        and t1.dt >= '${开始时间}'
        and t1.dt <= '${结束时间}'
          ${if(len(产品ID) == 0,"","and t1.product_id in ('" + 产品ID + "')")}
          ${if(len(是否VIP投流) == 0,"","and
              case when t2.user_ad_source=1 then 'VIP投流'
                  else '其他'
              end in ('" + 是否VIP投流 + "')")}
          ${if(len(CORE) == 0,"","and t1_.corever in ('" + CORE + "')")}
          ${if(len(终端) == 0,"","and
              case
                  when t1.mt=1 then 'iOS'
                  when t1.mt=4 then 'Android'
                  else '其他'
              end in ('" + 终端 + "')")}
          ${if(len(注册语言) == 0,"","and  dic_reglang.remarks in ('" + 注册语言 + "')")}
          ${if(len(支付渠道) == 0,"","and
              case
                  when sub_pay_type = 'GooglePlay' then 'GooglePlay'
                  when sub_pay_type = 'AppStore' then 'AppStore'
                   when sub_pay_type = 'AppGallery' then 'AppGallery'
                  else '三方支付'
              end in ('" + 支付渠道 + "')")}
          ${if(len(投放拉起书籍) == 0,"","and  t3.tf_book_id in ('" + 投放拉起书籍 + "')")}
          ${if(len(书籍代号) == 0,"","and  t4.book_code in ('" + 书籍代号 + "')")}
          ${if(len(书籍代号系列) == 0,"","and  REGEXP_REPLACE(t4.book_code, '[0-9].*$', '') in ('" + 书籍代号系列 + "')")}

     ) t1
         left join dim.dim_dic dic_product  -- 产品名称
 			on t1.product_id = dic_product.enum_id
 			and dic_product.table_name = 'dwd_consume_user_consume_di'
 			and dic_product.dic_column = 'product_id'
         left JOIN (select dt,
                           user_id,
                           item_id,
                           autoRenew_times
                    from ads.ads_bi_trade_user_subscribe_di
                    where dt >= '${开始时间}'
                      and dt <= CURDATE()
                      and subscribe_status = 2
-- 	${if(len(CORE) == 0,"","and core  in ('" + CORE + "')")}
                        ${if(len(终端) == 0,"","and
                            case when mt=1 then 'iOS'
                                 when mt=4 then 'Android'  	else '其他'
                            end in ('" + 终端 + "')")} ${if(len(支付渠道) == 0,"","and
			case  when sub_pay_type = 'GooglePlay' then 'GooglePlay'
				  when sub_pay_type = 'AppStore' then 'AppStore'
                  when sub_pay_type = 'AppGallery' then 'AppGallery'
				else '三方支付'	end in ('" + 支付渠道 + "')")}) t2
                   on t1.user_id = t2.user_id
                       and t1.item_id = t2.item_id
                       and t1.dt <= t2.dt
    ${if(len(国家) == 0,"left join (","inner join (")}
select country,
       code
from dim.dim_country_dic
where 1 = 1 ${if(len(国家) == 0,"","and country in ('" + 国家 + "')")}
	)t3
on t1.country=t3.code
	--${if(len(产品名称) == 0,"","and  dic_product.remarks in ('" + 产品名称 + "')")}
    ${if(hitgroup == '否' ," "," inner join (
      select
        user_id,
        date(min(create_time)) as s_date,
        date(max(end_time)) as e_date
      from ads.ads_market_realtime_group_log_view
      where group_type = 1
        and op_type = 0
        and dt >= date_add('" + 开始时间 + "',-30)
        and dt  < date_add('" + 结束时间 + "',30)
        and group_id in ('" +  人群包ID + "')
      group by 1
       union all
      select
        UserId as user_id,
        date(min(CreateTime )) as s_date,
        date(max(EndTime)) as e_date
      from ads.ads_sr_beidou_group_crowd_log
      where ProjectId = 1
        and Operation = 1
        and dt >= date_add('" + 开始时间 + "',-30)
        and dt  < date_add('" + 结束时间 + "',30)
        and SubCrowdId in ('" +  人群包ID + "')
      group by 1

      ) t4
    on t1.user_id = t4.user_id
        and t1.dt >= s_date
        and t1.dt <= e_date ")}
where 1=1
${if(len(产品名称) == 0,"","and  dic_product.remarks in ('" + 产品名称 + "')")}