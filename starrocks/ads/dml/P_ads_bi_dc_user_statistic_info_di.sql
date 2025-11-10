----------------------------------------------------------------
-- 程序功能：分销机构用户统计报表
-- 程序名： P_ads_bi_dc_user_statistic_info_di
-- 目标表： ads.ads_bi_dc_user_statistic_info_di
-- 负责人： qhr
-- 开发日期： 2025-11-07
-- 版本号： v1.0.0
----------------------------------------------------------------

insert into ads.ads_bi_dc_user_statistic_info_di
with install_user_count as (
    select a1.dt
          ,a1.product_id
          ,a1.ad_id
          ,a2.inst_id
          ,a2.dc_acct
          ,a1.core
          ,a1.mt
          ,count(distinct a1.user_id)           as dev_unt
      from dwd.dwd_user_install_info_ed_view    as a1
      join dwd.dwd_advertisement_adext_view     as a2
        on a1.ad_id = a2.ad_id
       and a2.product_id = 6833
       and a2.inst_id > 0
     where a1.dt >= date_sub('${bf_1_dt}', interval 10 day)
       and a1.Product_Id = 6833
       and a1.IsDelete = 0
     group by 1,2,3,4,5,6,7
)
select a1.dt                                   as dt                  -- 统计日期
      ,md5(concat_ws( '_',a1.dt,a1.product_id,a1.user_type
                     ,a1.dc_code,a1.dc_account,a1.core,a1.mt
                    )
          )                                    as md5_key             -- 主键md5key
      ,a1.product_id                           as product_id          -- 产品id
      ,a1.dc_code                              as dc_code             -- 所属机构
      ,a1.dc_account                           as dc_account          -- 机构投放账号
      ,a1.core                                 as core                -- core
      ,a1.mt                                   as mt                  -- 终端
      ,a1.user_type                            as user_type           -- 用户类型
      ,coalesce(sum(a1.new_user_count), 0)     as new_user_count      -- 新增用户数
      ,coalesce(sum(a1.pay_user_count),0)      as pay_user_count      -- 新增用户数
      ,coalesce(sum(a1.pay_order_count),0)     as pay_order_count     -- 订单数
      ,coalesce(sum(a1.pay_order_amount),0)    as pay_order_amount    -- 订单金额
      ,now()                                   as etl_tm              -- 数据清洗时间
  from (select b1.dt                                                          as dt
              ,6833                                                           as product_id
              ,if(date(b1.AccountCreateTime)=date(b1.OrderCreateTime),1,0)    as user_type
              ,b1.dc                                                          as dc_code
              ,b1.DcAccount                                                   as dc_account
              ,b1.core                                                        as core
              ,b1.OsType                                                      as mt
              ,null                                                           as new_user_count
              ,count(distinct b1.UserId)                                      as pay_user_count
              ,count(b1.OrderSerialId)                                        as pay_order_count
              ,coalesce(sum(b1.Amount/100),0)                                 as pay_order_amount
          from dwd.dwd_pay_order_for_dc_view    as b1
         where b1.dt >= date_sub('${bf_1_dt}', interval 10 day)
         group by 1,2,3,4,5,6,7
         union all
         select b2.dt
               ,b2.product_id
               ,1                                                             as user_type
               ,b2.inst_id                                                    as dc_code
               ,b2.dc_acct                                                    as dc_account
               ,b2.core
               ,b2.mt
               ,b2.dev_unt                                                    as new_user_count
               ,0                                                             as pay_user_count
               ,0                                                             as pay_order_count
               ,0                                                             as pay_order_amount
           from install_user_count              as b2
       )                                        as a1
 group by 1,2,3,4,5,6,7,8
;