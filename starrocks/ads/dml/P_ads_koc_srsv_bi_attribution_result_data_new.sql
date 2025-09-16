----------------------------------------------------------------
-- 程序功能： koc归因数据报表(新)
-- 程序名： P_ads_koc_srsv_bi_attribution_result_data_new
-- 目标表： ads.ads_koc_srsv_bi_attribution_result_data_new
-- 负责人： qhr
-- 开发日期： 2025-09-08
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_koc_srsv_bi_attribution_result_data_new
--激活用户
with attribution_user as(
    select  a.product_id
           ,a.dt
           ,a.user_id
           ,a.koc_text
           ,if(minutes_diff(d.create_time,b.create_time)<1440,1,2) as user_type
           ,ifnull(b.reg_country,-99) as reg_country
           ,a.mt
           ,a.chl
           ,a.current_language
           ,core
           ,a.begin_time
           ,a.end_time
           ,a.resource_id
           ,a.create_time
           ,c.InstitutionId as institution_id
           ,c.StarId as star_id
      from (
        select  a.product_id
               ,user_id
               ,date(begin_time) as dt
               ,begin_time
               ,end_time
               ,resource_id
               ,koc_text
               ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Mt=', -1),'|',1) as int ) as mt
               ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Chl2=', -1),'|',1) as string ) as chl
               ,ifnull(c.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language
               ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Core=', -1),'|',1) as int ) as core
               ,min(create_time) as create_time
          from dwd.dwd_srsv_advertisement_koc_attribution_record_view a 
          left join 
          (
              select 6833 as product_id
                     ,series_id as book_id
                     ,language as languageid
                from dim.dim_short_video_series_view    
              union all     
              select product_id
                     ,book_id
                     ,languageid
                from dim.dim_shuangwen_book_read_consume_info
          ) c on a.product_id = c.product_id and a.resource_id = c.book_id 
         where begin_time>='${bf_20_dt}' 
         group by 1,2,3,4,5,6,7,8,9,10,11
    ) a 
    left join (
        select product_id
               ,id as user_id
               ,create_time
               ,reg_country
          from dim.dim_user_account_info_view 
        union all     
        select product_id
               ,user_id
               ,create_time
               ,reg_country
          from dim.dim_short_video_user_accountinfo
    ) b on a.product_id = b.product_id and a.user_id = b.user_id
    left join ods.ods_tidb_koc_codeinfo c on a.koc_text = c.KocCode 
    left join ( 
        select product_id
               ,user_id
               ,koc_text
               ,date(begin_time) as dt
               ,min(create_time) as create_time
          from dwd.dwd_srsv_advertisement_koc_attribution_record_view 
         where begin_time>='${bf_20_dt}' 
         group by 1,2,3,4
    ) d on a.dt=d.dt and a.product_id = d.product_id and a.user_id = d.user_id and a.koc_text=d.koc_text
),
active_user as (
    select  a.product_id
           ,a.dt
           ,a.koc_text
           ,a.user_type
           ,a.reg_country
           ,count(distinct a.user_id) as dev_unt
      from attribution_user a
     group by 1,2,3,4,5
)
,
non_natural_active_user as 
(
    select a.dt
           ,a.project_tp
           ,a.user_id
           ,3 as user_type
           ,a.reg_country
           ,b.koc_text
           ,b.product_id
           ,b.institution_id
           ,b.star_id
           ,b.mt
           ,b.chl
           ,b.current_language
           ,b.core
           ,b.book_id
      from (
        select dt
               ,1 as project_tp
               ,user_id
               ,ifnull(reg_country,-99) as reg_country 
          from dws.dws_user_wide_active_ed 
         where dt>='${bf_3_dt}' 
        union all
        select dt
               ,2 as project_tp
               ,user_id
               ,ifnull(reg_country,-99) as reg_country 
          from dws.dws_user_short_video_wide_active_ed 
         where dt>='${bf_3_dt}' 
    ) a
    inner join 
    (
            select *
              from (
                select  project_tp
                       ,user_id
                       ,3 as user_type
                       ,koc_text
                       ,product_id
                       ,a.create_time
                       ,c.InstitutionId as institution_id
                       ,c.StarId as star_id
                       ,a.mt
                       ,a.chl
                       ,a.current_language
                       ,core
                       ,c.DataId as book_id
                       ,row_number() over(partition by project_tp,user_id order by a.create_time desc ) rn
                  from (
                    select if(a.product_id=6833,2,1) as project_tp
                           ,a.product_id
                           ,user_id
                           ,3 as user_type
                           ,koc_text
                           ,a.create_time
                           ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Mt=', -1),'|',1) as int ) as mt
                           ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Chl2=', -1),'|',1) as string ) as chl
                           ,ifnull(c.languageid,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'CurrentLanguage2=', -1),'|',1) as int )) as current_language
                           ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(a.ad_id, 'Core=', -1),'|',1) as int ) as core
                      from dwd.dwd_srsv_advertisement_koc_attribution_record_view a
                      left join 
                      (
                          select 6833 as product_id
                                 ,series_id as book_id
                                 ,language as languageid
                            from dim.dim_short_video_series_view    
                          union all     
                          select product_id
                                 ,book_id
                                 ,languageid
                            from dim.dim_shuangwen_book_read_consume_info 
                      ) c on a.product_id = c.product_id and a.resource_id = c.book_id 
                  ) a
                  left join ods.ods_tidb_koc_codeinfo c on a.koc_text = c.KocCode 
              ) a 
             where rn=1
    ) b on a.project_tp=b.project_tp and a.user_id = b.user_id
    left join (
        select b.datestr as dt
               ,if(a.product_id=6833,2,1) as project_tp
               ,user_id
          from dwd.dwd_srsv_advertisement_koc_attribution_record_view a 
          left join dim.dim_date b on b.datestr >=date(a.begin_time) and b.datestr <= date(a.end_time)
         where begin_time>='${bf_20_dt}' 
           and b.datestr <='${dt}'
         group by 1,2,3
    ) c on a.dt=c.dt and a.project_tp=c.project_tp and a.user_id = c.user_id
     where c.user_id is null
)
,
non_natural_active_data as 
(
    select a.dt
           ,a.product_id
           ,a.user_type
           ,a.reg_country
           ,a.koc_text
           ,a.project_tp
           ,a.institution_id
           ,a.star_id
           ,a.mt
           ,a.chl
           ,a.core
           ,a.current_language
           ,a.book_id
           ,count(distinct a.user_id) as non_natural_active_unt
           ,count(b.user_id) as order_num
           ,sum(item_count) as amount
           ,sum(base_amount) as base_amount
      from non_natural_active_user a 
      left join 
      (
        select  dt
               ,ProductId as product_id 
               ,UserId as user_id
               ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id
               ,CreateTime as create_time
               ,OrderId as order_id
               ,sum(ItemCount) item_count
               ,sum(BaseAmount)/100 as base_amount  
          from dwd.dwd_sr_user_koc_payorder_view
         where dt>='${bf_3_dt}' 
           and dt<='${dt}'
            --and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
         group by 1,2,3,4,5,6
        union all 
        -- 海剧的充值订单--- 
        select  dt
               ,product_id 
               ,user_id 
               ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id
               ,create_time 
               ,order_id
               ,sum(item_count) as item_count 
               ,sum(base_amount)/100 as base_amount 
          from dwd.dwd_trade_short_video_payorder_view 
         where dt >= '${bf_3_dt}' 
           and dt<='${dt}'
           and product_id = 6833 
            --and  package_id like  '%Ps_Half%' 
           and test_flag = 0 
           and status =0 -- 正常订单
         group by 1,2,3,4,5,6 
      ) b on a.dt=b.dt and project_tp = if(b.product_id=6833,2,1) and a.user_id= b.user_id 
     group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)
,
koc_order as (
    select a.dt
           ,a.product_id
           ,a.koc_text
           ,a.user_type
           ,a.reg_country
           ,a.resource_id
           ,a.user_id
           ,a.mt
           ,a.core
           ,a.chl
           ,a.current_language
           ,a.institution_id
           ,a.star_id
           ,a.user_dt
           ,b.item_count
           ,b.base_amount
           ,b.order_id
      from (
            select  b.datestr as dt 
                   ,a.product_id
                   ,a.user_id
                   ,a.resource_id
                   ,a.begin_time
                   ,a.end_time                            
                   ,a.koc_text
                   ,a.institution_id
                   ,a.star_id
                   ,a.mt
                   ,a.core
                   ,a.chl
                   ,a.current_language
                   ,date(a.create_time) as user_dt
                   ,a.user_type
                   ,a.reg_country
              from attribution_user a 
              left join dim.dim_date b on b.datestr >='${bf_20_dt}' and b.datestr <= '${dt}'
          ) a
          left join 
          (
            select  dt
                   ,ProductId as product_id 
                   ,UserId as user_id
                   ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id
                   ,CreateTime as create_time
                   ,OrderId as order_id
                   ,sum(ItemCount) item_count
                   ,sum(BaseAmount)/100 as base_amount  
              from dwd.dwd_sr_user_koc_payorder_view
             where dt>='${bf_30_dt}' 
               and dt<='${dt}'
               and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
               and CreateTime<date_sub(now(),interval 1 hour)
             group by 1,2,3,4,5,6
            union all 
            -- 海剧的充值订单--- 
            select  dt
                   ,product_id 
                   ,user_id 
                   ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id
                   ,create_time 
                   ,order_id
                   ,sum(item_count) as item_count 
                   ,sum(base_amount)/100 as base_amount 
              from dwd.dwd_trade_short_video_payorder_view 
             where dt >= '${bf_30_dt}' 
               and dt<='${dt}'
               and product_id = 6833 
               and create_time<date_sub(now(),interval 1 hour)
               and package_id like  '%Ps_Half%' 
               and test_flag = 0 
               and status =0 -- 正常订单
             group by 1,2,3,4,5,6 
          ) b on a.dt=b.dt and if(a.product_id=6833,2,1) = if(b.product_id=6833,2,1) and a.user_id= b.user_id and b.create_time>=a.begin_time and b.create_time<a.end_time
         where a.begin_time>='${bf_20_dt}' and a.dt<'2024-12-11'
         group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
        
        union all
        
        select a.dt
               ,a.product_id
               ,a.koc_text
               ,a.user_type
               ,a.reg_country
               ,a.resource_id
               ,a.user_id
               ,a.mt
               ,a.core
               ,a.chl
               ,a.current_language
               ,a.institution_id
               ,a.star_id
               ,a.user_dt
               ,b.item_count
               ,b.base_amount
               ,b.order_id
          from (
                select  b.datestr as dt 
                       ,a.product_id
                       ,a.user_id
                       ,a.resource_id
                       ,a.begin_time
                       ,a.end_time                            
                       ,a.koc_text
                       ,a.institution_id
                       ,a.star_id
                       ,a.mt
                       ,a.core
                       ,a.chl
                       ,a.current_language
                       ,date(a.create_time) as user_dt
                       ,a.user_type
                       ,a.reg_country
                  from attribution_user a 
                  left join dim.dim_date b on b.datestr >='${bf_20_dt}' and b.datestr <= '${dt}'
              ) a
              left join 
              (
                select  dt
                       ,ProductId as product_id 
                       ,UserId as user_id
                       ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id
                       ,CreateTime as create_time
                       ,OrderId as order_id
                       ,sum(ItemCount) item_count
                       ,sum(BaseAmount)/100 as base_amount  
                  from dwd.dwd_sr_user_koc_payorder_view
                 where dt>='${bf_30_dt}' 
                   and dt<='${dt}'
                   and CreateTime<date_sub(now(),interval 1 hour)
                    --and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
                 group by 1,2,3,4,5,6
                union all 
                -- 海剧的充值订单--- 
                select  dt
                       ,product_id 
                       ,user_id 
                       ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id
                       ,create_time 
                       ,order_id
                       ,sum(item_count) as item_count 
                       ,sum(base_amount)/100 as base_amount 
                  from dwd.dwd_trade_short_video_payorder_view 
                 where dt >= '${bf_30_dt}' 
                   and dt<='${dt}'
                   and product_id = 6833 
                   and create_time<date_sub(now(),interval 1 hour)
                    --and  package_id like  '%Ps_Half%' 
                   and test_flag = 0 
                   and status =0 -- 正常订单
                 group by 1,2,3,4,5,6 
              ) b on a.dt=b.dt and if(a.product_id=6833,2,1) = if(b.product_id=6833,2,1) and a.user_id= b.user_id and b.create_time>=a.begin_time and b.create_time<a.end_time
             where a.begin_time>='${bf_20_dt}' and ((a.dt>='2024-12-11' and a.dt<'2024-12-14') or a.dt>='2025-01-02')
             group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
                
        union all
        
        select a.dt
               ,a.product_id
               ,a.koc_text
               ,a.user_type
               ,a.reg_country
               ,a.resource_id
               ,a.user_id
               ,a.mt
               ,a.core
               ,a.chl
               ,a.current_language
               ,a.institution_id
               ,a.star_id
               ,a.user_dt
               ,b.item_count
               ,b.base_amount
               ,b.order_id
          from (
                select  b.datestr as dt 
                       ,a.product_id
                       ,a.user_id
                       ,a.resource_id
                       ,a.begin_time
                       ,a.end_time                            
                       ,a.koc_text
                       ,a.institution_id
                       ,a.star_id
                       ,a.mt
                       ,a.core
                       ,a.chl
                       ,a.current_language
                       ,date(a.create_time) as user_dt
                       ,a.user_type
                       ,a.reg_country
                  from attribution_user a 
                  left join dim.dim_date b on b.datestr >='${bf_20_dt}' and b.datestr <= '${dt}'
              ) a
              left join 
              (
                select  dt
                       ,ProductId as product_id 
                       ,UserId as user_id
                       ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid,'|',1), 'Ps_Half_', -1),'Ps_Shop_half_',-1), '_', 1), '_', -1) as int ) as book_id
                       ,CreateTime as create_time
                       ,OrderId as order_id
                       ,sum(ItemCount) item_count
                       ,sum(BaseAmount)/100 as base_amount  
                  from dwd.dwd_sr_user_koc_payorder_view
                 where dt>='${bf_30_dt}' 
                   and dt<='${dt}'
                   and (PackageId like  '%Ps_Half%' or PackageId like  '%Ps_Shop_half%')
                   and CreateTime<date_sub(now(),interval 1 hour)
                 group by 1,2,3,4,5,6
                union all 
                -- 海剧的充值订单--- 
                select  dt
                       ,product_id 
                       ,user_id 
                       ,cast(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(packageid, 'Ps_Half_', -1), '_', 1), '_', -1) as int ) as book_id
                       ,create_time 
                       ,order_id
                       ,sum(item_count) as item_count 
                       ,sum(base_amount)/100 as base_amount 
                  from dwd.dwd_trade_short_video_payorder_view 
                 where dt >= '${bf_30_dt}' 
                   and dt<='${dt}'
                   and product_id = 6833 
                   and create_time<date_sub(now(),interval 1 hour)
                   and package_id like  '%Ps_Half%' 
                   and test_flag = 0 
                   and status =0 -- 正常订单
                 group by 1,2,3,4,5,6 
              ) b on a.dt=b.dt and if(a.product_id=6833,2,1) = if(b.product_id=6833,2,1) and a.user_id= b.user_id and b.create_time>=a.begin_time and b.create_time<a.end_time
             where a.begin_time>='${bf_20_dt}' and a.dt>='2024-12-14' and a.dt<'2025-01-02'                
             group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
)
select  a.dt
       ,a.product_id
       ,a.koc_code
       ,a.user_type
       ,a.reg_country
       ,a.project_tp
       ,a.book_id
       ,a.mt
       ,a.core
       ,a.source_chl
       ,a.chl
       ,a.current_language
       ,a.institution_id
       ,a.star_id
       ,b.dev_unt
       ,a.order_num
       ,a.koc_amt
       ,a.koc_amt_after
       ,now() as etl_tm
  from (
    select a.dt 
          ,a.product_id
          ,a.koc_text as koc_code
          ,a.user_type
          ,a.reg_country
          ,if(max(a.product_id)=6833,2,1) as project_tp -- 1:海阅 2：海剧
          ,max(a.resource_id) as book_id
          ,max(a.mt) as mt
          ,max(a.core) as core
          ,'koc' as source_chl
          ,max(a.chl) as chl
          ,max(a.current_language) as current_language 
          ,max(a.institution_id) as institution_id
          ,max(a.star_id) as star_id
          ,count(order_id) as order_num
          ,sum(item_count) as koc_amt
          ,sum(base_amount) as koc_amt_after
      from koc_order a
     group by 1,2,3,4,5
) a 
  left join active_user b on a.dt=b.dt and a.product_id =b.product_id and a.koc_code=b.koc_text and a.user_type=b.user_type and a.reg_country=b.reg_country
 where 1=1
   and (b.dev_unt>0 or a.koc_amt>0)
   and a.reg_country<>-99
   and a.dt >= '${bf_3_dt}' 
   and a.dt >= '2024-09-01'
   and a.core in (1,15)

union all 
select  a.dt
       ,a.product_id
       ,a.koc_text as koc_code
       ,a.user_type
       ,a.reg_country
       ,a.project_tp
       ,a.book_id
       ,a.mt
       ,a.core
       ,'koc' as source_chl
       ,a.chl
       ,a.current_language
       ,a.institution_id
       ,a.star_id
       ,a.non_natural_active_unt as dev_unt
       ,a.order_num
       ,a.amount as koc_amt
       ,a.base_amount as koc_amt_after
       ,now() as etl_tm
  from non_natural_active_data a
 where (non_natural_active_unt>0 or order_num>0)
   and a.dt >= '${bf_3_dt}' 
   and a.dt >= '2024-09-01'
   and a.core in (1,15)
;