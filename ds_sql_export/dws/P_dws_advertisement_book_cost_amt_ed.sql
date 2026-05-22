----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_advertisement_book_cost_amt_ed
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dws_advertisement_book_cost_amt_ed
-- task_version     : 4
-- update_time      : 2024-01-11 17:46:16
-- sql_path         : \starrocks\tbl_dws_advertisement_book_cost_amt_ed\dws_advertisement_book_cost_amt_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_advertisement_book_cost_amt_ed where dt>='${bf_7_dt}';

-- SQL语句
insert into   dws.dws_advertisement_book_cost_amt_ed
      select t.dt,right(t.book_id,3) as site_id ,t.book_id,t.book_nature,sum(t.costamount) as cost_amt,now()
      from
  (
     select ae.book_id,
                         faliir.dt,
                            ae.book_nature,
                            sum(faliir.cost_amount)as costamount
                            from
	                          dwd.dwd_advertisement_fbadroiinstallreferrer_view faliir    --  ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer   dwd.dwd_advertisement_fbadroiinstallreferrer_view
                            left join  dwd.dwd_advertisement_adext_view ae                   --  dwd.dwd_advertisement_adext_view
                             on faliir.product_id = ae.product_id  and faliir.ad_id = ae.ad_id
		                left join  dim.dim_ad_account fa                    -- dim.dim_ad_account
                             on fa.account=ae.fb_account
                            where
                            faliir.dt >= '${bf_7_dt}'
		                  and faliir.dt <  '${dt}'
                              and faliir.product_id in(3311,3322,3366,3371,3388,3501,3511)
                              and  ae.book_nature in(3,5)
                            and (fa.fb_account_type=0 or fa.fb_account_type is null)
                            group by 1,2,3
           						union all

							select ae.book_id, date(faliir.create_time) as dt ,ae.book_nature,sum(faliir.cost_amount)as costamount
                            from
	                           dwd.dwd_advertisement_fb_adroi_remarketing_view faliir     --  dwd.dwd_advertisement_fb_adroi_remarketing_view
                            left join  dwd.dwd_advertisement_adext_view ae on               --  dwd.dwd_advertisement_adext_view
	                            faliir.product_id = ae.product_id
	                            and faliir.ad_id = ae.ad_id
							left join dim.dim_ad_account fa on fa.account=ae.fb_account   -- dim.dim_ad_account
                            where
                             faliir.create_time  >= '${bf_7_dt}'
		                  and faliir.create_time < '${dt}'
                          and faliir.product_id in(3311,3322,3366,3371,3388,3501,3511)
                          and   ae.book_nature in(3,5)
                          and (fa.fb_account_type is null or fa.fb_account_type = 1)
		                    group by 1,2 ,3
	   )      t   group by 1,2,3,4 ;
