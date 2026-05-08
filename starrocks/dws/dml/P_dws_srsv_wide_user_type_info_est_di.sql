-- -------------新用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_est_di
select
   date(date_add(a.createtime,interval -13 hour)) as dt,
    a.productid as product_id,
    a.id as user_id ,
    1 as user_period,
    case when a.CoreVer is null or a.corever=0 then 1 else a.corever end as corever,
	a.mt ,
	case when a.RegCountry ='' then 'unknown' else  a.RegCountry end  as reg_country,
	case when b.level is null then 2 else b.level end  as country_level  ,
	case when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3311 then 6
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3322 then 5
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3333 then 2
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3366 then 3
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3371 then 7
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3388 then 4
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3501 then 11
	when (a.CurrentLanguage2  is null or a.CurrentLanguage2=0) and a.productid=3511 then 12
	else a.CurrentLanguage2
	end as current_language2,
	 case when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
		when c.last_source in ('officialsite','(not set)') then 2
		else 1 end  as source,
	 if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
	 a.chl2,
	 a.chl,
	now() as etl_time
 from dim.dim_read_and_short_video_accountinfo_tmp_view a
 -- 获取国家等级------
 left join dim.dim_countrylevel b on a.productid =b.product_id   and a.RegCountry =b.short_name

 left join
 -- 获取媒体来源------------
 (select product_id,user_id,mt,corever,lang2,last_source from dws.dws_user_market_channel_info_detail_est_da where dt='${bf_1_dt}' ) c
 on a.productid =c.product_id and a.id=c.user_id and a.mt=c.mt and a.corever=c.corever and a.CurrentLanguage2=c.lang2  and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)

  left join  -- ------判断用户是否收费--------------------
 ( -- 阅读的充值表-----------------
 select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_est_ed where dt<='${bf_1_dt}' group by 1,2
 union all
 -- 海剧的充值--------------------
 select product_id,user_id from dws.dws_trade_short_video_payorder_est_ed where dt<='${bf_1_dt}' group by 1,2
 ) d
on a.productid=d.product_id and a.id=d.user_id

 where date_add(a.createtime,interval -13 hour) >='${bf_1_dt}' and date_add(a.createtime,interval -13 hour)<'${dt}' and a.productid  not in (3521,3531,6883) ;



-- -------------活跃用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_est_di
select
    a.dt ,
    a.product_id,
    a.user_id ,
    2 as user_period,
    case when a.CoreVer is null or a.corever=0 then 1 else a.corever end as corever,
    a.mt ,
    case when a.Reg_Country ='' then 'unknown' else  a.Reg_Country end  as reg_country,
    case when a.country_level is null then 2 else a.country_level end  as country_level ,
    a.current_language2,
    case when c.last_source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
         when c.last_source in ('officialsite','(not set)') then 2
         else 1 end  as source,
    if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
    e.chl2,
    e.chl,
    now() as etl_time
from
    (	select dt,product_id,user_id,corever,mt,reg_country,country_level,current_language2 from  dws.dws_user_wide_active_est_ed a where  a.dt >='${bf_1_dt}' and a.dt<'${dt}' and a.product_id  not in (3521,3531) and a.user_id >0
         union all
         select date(date_add(a.reg_time,interval -13 hour)) as dt,product_id,user_id,corever,mt,reg_country,country_level,current_language2 from  dws.dws_user_short_video_wide_active_ed a where date(date_add(a.reg_time,interval -13 hour)) >='${bf_1_dt}' and date(date_add(a.reg_time,interval -13 hour))<'${dt}' and a.product_id  in (6833)  and a.user_id >0
    ) a
        left join
    (select product_id,user_id,mt,corever,lang2,last_source from dws.dws_user_market_channel_info_detail_est_da where dt='${bf_1_dt}' ) c
    on a.product_id =c.product_id and a.user_id=c.user_id and a.mt=c.mt and a.corever=c.corever and a.current_language2=c.lang2  and c.product_id in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)

        left join  -- ------判断用户是否收费--------------------
        ( -- 阅读的充值表-----------------
            select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_est_ed where dt<='${bf_1_dt}' group by 1,2
            union all
            -- 海剧的充值--------------------
            select product_id,user_id from dws.dws_trade_short_video_payorder_est_ed where dt<='${bf_1_dt}' group by 1,2
        ) d
                   on a.product_id=d.product_id and a.user_id=d.user_id
        left join
    (select productid ,id ,chl2,chl from  dim.dim_read_and_short_video_accountinfo_tmp_view where productid  !=6883)  e
    on a.product_id =e.productid and a.user_id =e.id
;



-- -------------rmt 用户按天的----------------------------
insert into dws.dws_srsv_wide_user_type_info_est_di
select
    a1.dt  ,
    a1.product_id,
    a1.user_id ,
    a1.user_period,
    a1.corever,
    a1.mt ,
    a1.reg_country,
    case when b.level is null then 2 else b.level end  as country_level  ,
    a1.current_language2,
    a1.source,
    if(d.user_id is not null ,1,0) as  is_pay, -- 1:付费 0：非付费
    a2.chl2,
    a2.chl,
    now() as etl_time
from (
         select x.dt,
                x.install_date,
                x.product_id,
                x.user_id ,
                x.corever,
                x.mt ,
                x.reg_country,
                x.current_language2,
                x.source,
                x.user_period
         from (
                  select
                      dt ,
                      install_date,
                      product_id,
                      user_id,
                      core as corever,
                      mt,
                      case when a.Country ='' then 'unknown' else  a.Country end  as reg_country,
                      a.current_language2,
                      case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                           when source in ('officialsite','(not set)') then 2 else 1 end as source ,
                      3 as user_period,
                      row_number() over(partition by product_id,user_id order by
                    case when source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3
                    when source in ('officialsite','(not set)') then 2 else 1 end desc,install_date) as rn
                  from dwd.dwd_user_install_info_ed_est_view a
                  where      a.dt >='${bf_1_dt}' and a.dt<'${dt}' and a.product_id   in (3311,3322,3333,3366,3371,3388,3501,3511,3399,7757,8858,6833)  and a.User_Id !=-1 and a.IsDelete =0
              ) x where x.rn =1
     ) a1
         inner join (
		select productid,id,date_add(createtime,interval -13 hour) as createtime,chl2,chl  from dim.dim_read_and_short_video_accountinfo_tmp_view where productid  not in (3521,3531)
	) a2
                    on a1.product_id = a2.productid   and a1.user_id = a2.id
                        and a2.createtime < date_sub(a1.install_date, interval 1 HOUR)
         left join dim.dim_countrylevel b on a1.product_id =b.product_id   and a1.reg_country =b.short_name

         left join  -- ------判断用户是否收费--------------------
    ( -- 阅读的充值表-----------------
        select productid as product_id,userid as user_id from dws.dws_trade_user_shopitem_charge_est_ed where dt<='${bf_1_dt}' group by 1,2
        union all
        -- 海剧的充值--------------------
        select product_id,user_id from dws.dws_trade_short_video_payorder_est_ed where dt<='${bf_1_dt}' group by 1,2
    ) d
                    on a1.product_id=d.product_id and a1.user_id=d.user_id  ;
