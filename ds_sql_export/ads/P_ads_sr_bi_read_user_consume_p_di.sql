----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_bi_read_user_consume_p_di
-- workflow_version : 11
-- create_user      : hufengju
-- task_name        : ads_sr_bi_read_user_consume_p_di
-- task_version     : 10
-- update_time      : 2025-06-13 17:44:15
-- sql_path         : \starrocks\tbl_ads_sr_bi_read_user_consume_p_di\ads_sr_bi_read_user_consume_p_di
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sr_bi_read_user_consume_p_di  where dt>='${bf_8_dt}' and dt<'${dt}';

-- SQL语句
insert into ads.ads_sr_bi_read_user_consume_p_di
       -- --------投放激活归因表------------
with ins as (
	-- ------------------按产品，用户，激活时间，书籍id 开窗，以媒体类型降序以及激活时间升序取当天的第一条激活数据-------------------
	 select dt,install_date,product_id,user_id,next_attribute_time,source,book_id,nick_name
	   from
	  (
		  select date(install_date) as dt,a.product_id,a.user_id,a.install_date,a.next_attribute_time,a.source,a.book_id,a.ad_id,c.nick_name
		  from -- 西五区广告投放激活表
			dwd.dwd_user_install_info_ed_est_mid a
		  left join --  通过广告id关联广告配置表获取优化师工号
			dwd.dwd_advertisement_adext_view b  on a.ad_id=b.ad_id
		  left join
		  -- --通过工号关联员工信息表获取员工姓名（去重）
		  ( select account ,nick_name  from     dim.dim_kpi_user_info_view
			qualify row_number() over(partition by account  order by last_login_time desc  ) =1
		 ) c
			on b.ad_optimizer_uid =c.account
		 where  a.dt>=date_sub('${bf_1_dt}',interval 7 day) and a.dt<'${dt}' and
		 a.product_id not in  (6833,6883,-1)  and a.book_id >0  and user_id>0 -- 过滤异常数据
	)  a
	qualify row_number() over (partition by product_id,user_id,date(install_date),book_id order by (case when source in ('fbs2s','facebook','tt','appleadservice','sem','adwords') then 3  when source = 'officialsite' then 2 else 1 end) desc, install_date) =1
)
 select   rd.dt,rd.product_id,rd.user_id,rd.book_id,rd.fst_read_tm,rd.mt,
     case when right(rd.book_id,3)=322 then 3
		 when right(rd.book_id,3)='001' then 3
		 when right(rd.book_id,3)=418 then 7
		 when right(rd.book_id,3)=409 then 5
		 when right(rd.book_id,3)=414 then 11
		 when right(rd.book_id,3)=445 then 15
		 when right(rd.book_id,3)=375 then 4
		 when right(rd.book_id,3)=410 then 6
		 when right(rd.book_id,3)=419 then 9
		 when right(rd.book_id,3)=433 then 12
		 when right(rd.book_id,3)=436 then 14
		 when right(rd.book_id,3)=412 then 16
		 when right(rd.book_id,3)=491 then 19
		 when right(rd.book_id,3)=492 then 20
		 when rd.product_id =3333 then 2
		 when rd.product_id in (7757,8858,7777,8888) then  1 end as lang_id,
     case  when  rd.dt=date(rd.reg_time) then 1  -- ctt 新用户
            when  rd.dt=date(ins.install_date) and date(rd.reg_time)!=date(ins.install_date)  then 2  -- rmt用户
            else 3 end as source_user_tp,-- 其他归因用户
     if(rd.fst_read_tm >= ins.install_date and rd.fst_read_tm <= ins.next_attribute_time and rd.book_id =ins.book_id,ins.source,null) as source,
	 ins.nick_name,-- 优化师名称
	 c.book_name,
	 c.book_code
 from (
		 select a.dt,a.product_id,a.user_id,a.book_id,a.fst_read_tm,
				b.mt,b.reg_time
		 from  dws.dws_user_first_read_book_est_temp a
        left join  -- ------关联账户表 获取用户注册时间 mt平台--------------------
		 (
			select id,hours_add(create_time,-13) as reg_time,product_id,mt from  dim.dim_user_account_info_view
		 ) b on a.product_id=b.product_id  and a.user_id =b.id
) rd
   left join
	   ins -- 关联激活表
		on rd.dt=ins.dt and rd.product_id=ins.product_id and rd.user_id=ins.user_id  and rd.book_id=ins.book_id
  left join
   -- 获取书名，书籍代号
  (select book_id,book_name,book_code from  dim.dim_shuangwen_book_read_consume_info )  c
	on rd.book_id=c.book_id
 where rd.dt>=date_sub('${bf_1_dt}',interval 7 day) and rd.dt<'${dt}';
