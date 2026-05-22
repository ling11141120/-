----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_shortvideo_feature
-- workflow_version : 11
-- create_user      : linq
-- task_name        : alg_shortvideo_feature
-- task_version     : 10
-- update_time      : 2024-12-12 16:22:24
-- sql_path         : \starrocks\tbl_alg_shortvideo_feature\alg_shortvideo_feature
----------------------------------------------------------------
-- 前置SQL语句
delete from alg.alg_shortvideo_feature where dt='${bf_1_dt}';

-- SQL语句
insert into alg.alg_shortvideo_feature
with t1 as (
    select a.dt,a.series_id,
           coalesce(watch_user_con,0) watch_user_con,
           coalesce(watch_epis_num,0) watch_epis_num,
           coalesce(end_watch_epis_num,0) end_watch_epis_num,
           coalesce(watch_user_con_1d,0) watch_user_con_1d,
           coalesce(watch_epis_num_1d,0) watch_epis_num_1d,
           coalesce(end_watch_epis_num_1d,0) end_watch_epis_num_1d,
           coalesce(watch_user_con_3d,0) watch_user_con_3d,
           coalesce(watch_epis_num_3d,0) watch_epis_num_3d,
           coalesce(end_watch_epis_num_3d,0) end_watch_epis_num_3d,
           coalesce(watch_user_con_7d,0) watch_user_con_7d,
           coalesce(watch_epis_num_7d,0) watch_epis_num_7d,
           coalesce(end_watch_epis_num_7d,0) end_watch_epis_num_7d,
           coalesce(watch_user_con_15d,0) watch_user_con_15d,
           coalesce(watch_epis_num_15d,0) watch_epis_num_15d,
           coalesce(end_watch_epis_num_15d,0) end_watch_epis_num_15d,
           coalesce(watch_user_con_30d,0) watch_user_con_30d,
           coalesce(watch_epis_num_30d,0) watch_epis_num_30d,
           coalesce(end_watch_epis_num_30d,0) end_watch_epis_num_30d,
           coalesce(watch_user_con_all,0) watch_user_con_all,
           coalesce(watch_epis_num_all,0) watch_epis_num_all,
           coalesce(end_watch_epis_num_all,0) end_watch_epis_num_all
    from(
        select date(create_time) as dt,
               series_id,
               count(distinct account_id) watch_user_con,
               count(epis_id) watch_epis_num,
               count(case when watch_stamp=0 then epis_id end ) end_watch_epis_num
        from dwd.dwd_video_short_video_epis_history
        where dt='${bf_1_dt}'
        group by 1,2
    )a
    left join(
		 select dt,series_id,sum(watch_user_con_1d) as watch_user_con_1d,sum(watch_epis_num_1d) as watch_epis_num_1d,sum(end_watch_epis_num_1d) as end_watch_epis_num_1d,sum(watch_user_con_3d) as watch_user_con_3d,sum(watch_epis_num_3d) as watch_epis_num_3d,sum(end_watch_epis_num_3d) as end_watch_epis_num_3d,sum(watch_user_con_7d) as watch_user_con_7d,sum(watch_epis_num_7d) as watch_epis_num_7d,sum(end_watch_epis_num_7d) as end_watch_epis_num_7d,sum(watch_user_con_15d) as watch_user_con_15d,sum(watch_epis_num_15d) as watch_epis_num_15d,sum(end_watch_epis_num_15d) as end_watch_epis_num_15d,sum(watch_user_con_30d) as watch_user_con_30d,sum(watch_epis_num_30d) as watch_epis_num_30d,sum(end_watch_epis_num_30d) as end_watch_epis_num_30d,sum(watch_user_con_all) as watch_user_con_all,sum(watch_epis_num_all) as watch_epis_num_all,sum(end_watch_epis_num_all) as end_watch_epis_num_all
			from (
			select '${bf_1_dt}' as dt,series_id,
				   count(distinct if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',account_id,null)) watch_user_con_1d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',epis_id,null)) watch_epis_num_1d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}' and watch_stamp=0,epis_id,null)) end_watch_epis_num_1d,
				   count(distinct if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',account_id,null)) watch_user_con_3d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',epis_id,null)) watch_epis_num_3d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}' and watch_stamp=0,epis_id,null)) end_watch_epis_num_3d,
				   count(distinct if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',account_id,null)) watch_user_con_7d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',epis_id,null)) watch_epis_num_7d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}' and watch_stamp=0,epis_id,null)) end_watch_epis_num_7d,
				   count(distinct if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',account_id,null)) watch_user_con_15d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',epis_id,null)) watch_epis_num_15d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}' and watch_stamp=0,epis_id,null)) end_watch_epis_num_15d,
				   count(distinct if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',account_id,null)) watch_user_con_30d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',epis_id,null)) watch_epis_num_30d,
				   count(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}' and watch_stamp=0,epis_id,null)) end_watch_epis_num_30d,
				   0 as  watch_user_con_all,
				   0 as  watch_epis_num_all,
				   0 as end_watch_epis_num_all
			from dwd.dwd_video_short_video_epis_history
			where dt<'${bf_1_dt}' and dt>=date_sub('${bf_1_dt}',interval 30 day )
			group by 1,2
			union all
			select '${bf_1_dt}' as dt,series_id,
			   null as  watch_user_con_1d,
			   null as watch_epis_num_1d,
			   null as end_watch_epis_num_1d,
			   null as watch_user_con_3d,
			   null as watch_epis_num_3d,
			   null as end_watch_epis_num_3d,
			   null as watch_user_con_7d,
			   null as watch_epis_num_7d,
			   null as end_watch_epis_num_7d,
			   null as watch_user_con_15d,
			   null as watch_epis_num_15d,
			   null as end_watch_epis_num_15d,
			   null as watch_user_con_30d,
			   null as watch_epis_num_30d,
			   null as end_watch_epis_num_30d,
			   count(distinct account_id) watch_user_con_all,
			   count(epis_id) watch_epis_num_all,
			   count(case when watch_stamp=0 then epis_id end ) end_watch_epis_num_all
			from dwd.dwd_video_short_video_epis_history
			where dt<'${bf_1_dt}'
			group by 1,2
		 ) a
		 group by 1,2
    )b on a.dt=b.dt and a.series_id=b.series_id
),t2 as (
    select a.dt,a.series_id,
           coalesce(consume_user_con,0) consume_user_con,
           coalesce(consume_epis_num,0) consume_epis_num,
           coalesce(consume_coin_amount,0) consume_coin_amount,
           coalesce(consume_amount,0) consume_amount,
           coalesce(consume_user_con_1d,0) consume_user_con_1d,
           coalesce(consume_epis_num_1d,0) consume_epis_num_1d,
           coalesce(consume_coin_amount_1d,0) consume_coin_amount_1d,
           coalesce(consume_amount_1d,0) consume_amount_1d,
           coalesce(consume_user_con_3d,0) consume_user_con_3d,
           coalesce(consume_epis_num_3d,0) consume_epis_num_3d,
           coalesce(consume_coin_amount_3d,0) consume_coin_amount_3d,
           coalesce(consume_amount_3d,0) consume_amount_3d,
           coalesce(consume_user_con_7d,0) consume_user_con_7d,
           coalesce(consume_epis_num_7d,0) consume_epis_num_7d,
           coalesce(consume_coin_amount_7d,0) consume_coin_amount_7d,
           coalesce(consume_amount_7d,0) consume_amount_7d,
           coalesce(consume_user_con_15d,0) consume_user_con_15d,
           coalesce(consume_epis_num_15d,0) consume_epis_num_15d,
           coalesce(consume_coin_amount_15d,0) consume_coin_amount_15d,
           coalesce(consume_amount_15d,0) consume_amount_15d,
           coalesce(consume_user_con_30d,0) consume_user_con_30d,
           coalesce(consume_epis_num_30d,0) consume_epis_num_30d,
           coalesce(consume_coin_amount_30d,0) consume_coin_amount_30d,
           coalesce(consume_amount_30d,0) consume_amount_30d,
           coalesce(consume_user_con_all,0) consume_user_con_all,
           coalesce(consume_epis_num_all,0) consume_epis_num_all,
           coalesce(consume_coin_amount_all,0) consume_coin_amount_all,
           coalesce(consume_amount_all,0) consume_amount_all
    from(
        select dt,series_id,
               count(distinct user_id) as consume_user_con,
               count(epis_num) as consume_epis_num,
               sum(epis_coin_consume_amount) as consume_coin_amount,
               sum(epis_coin_consume_amount)+sum(epis_cert_consume_amount) as consume_amount
        from(
            select dt,series_id,user_id,epis_num,
                   coalesce(epis_coin_consume_amount,0) epis_coin_consume_amount,
                   coalesce(epis_cert_consume_amount,0) epis_cert_consume_amount
            -- 视图,dws前
            from ads.ads_short_video_user_epis_consume_view
            where dt='${bf_1_dt}' and product_id=6833
            group by 1,2,3,4,5,6
            )a
        group by 1,2
    )a
    left join(
        select '${bf_1_dt}' as dt,series_id,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',user_id,null)) consume_user_con_1d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',epis_num,null)) consume_epis_num_1d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0)) consume_coin_amount_1d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0))+sum(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',epis_cert_consume_amount,0)) consume_amount_1d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',user_id,null)) consume_user_con_3d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',epis_num,null)) consume_epis_num_3d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0)) consume_coin_amount_3d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0))+sum(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',epis_cert_consume_amount,0)) consume_amount_3d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',user_id,null)) consume_user_con_7d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',epis_num,null)) consume_epis_num_7d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0)) consume_coin_amount_7d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0))+sum(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',epis_cert_consume_amount,0)) consume_amount_7d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',user_id,null)) consume_user_con_15d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',epis_num,null)) consume_epis_num_15d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0)) consume_coin_amount_15d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0))+sum(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',epis_cert_consume_amount,0)) consume_amount_15d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',user_id,null)) consume_user_con_30d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',epis_num,null)) consume_epis_num_30d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0)) consume_coin_amount_30d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',epis_coin_consume_amount,0))+sum(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',epis_cert_consume_amount,0)) consume_amount_30d,
               count(distinct user_id) consume_user_con_all,
               count(epis_num) consume_epis_num_all,
               sum(epis_coin_consume_amount) consume_coin_amount_all,
               sum(epis_coin_consume_amount)+sum(epis_cert_consume_amount) consume_amount_all
        from(
            select dt,series_id,user_id,epis_num,
                   coalesce(epis_coin_consume_amount,0) epis_coin_consume_amount,
                   coalesce(epis_cert_consume_amount,0) epis_cert_consume_amount
            from ads.ads_short_video_user_epis_consume_view
            where dt<'${bf_1_dt}' and product_id=6833
            group by 1,2,3,4,5,6
        )a
        group by 1,2
    )b on a.dt=b.dt and a.series_id=b.series_id
),t3 as (
    select a.dt,
           a.series_id,
           coalesce(charge_user_con,0) charge_user_con,
           coalesce(charge_con,0) charge_con,
           coalesce(base_amount,0) base_amount,
           coalesce(charge_user_con_1d,0) charge_user_con_1d,
           coalesce(charge_con_1d,0) charge_con_1d,
           coalesce(base_amount_1d,0) base_amount_1d,
           coalesce(charge_user_con_3d,0) charge_user_con_3d,
           coalesce(charge_con_3d,0) charge_con_3d,
           coalesce(base_amount_3d,0) base_amount_3d,
           coalesce(charge_user_con_7d,0) charge_user_con_7d,
           coalesce(charge_con_7d,0) charge_con_7d,
           coalesce(base_amount_7d,0) base_amount_7d,
           coalesce(charge_user_con_15d,0) charge_user_con_15d,
           coalesce(charge_con_15d,0) charge_con_15d,
           coalesce(base_amount_15d,0) base_amount_15d,
           coalesce(charge_user_con_30d,0) charge_user_con_30d,
           coalesce(charge_con_30d,0) charge_con_30d,
           coalesce(base_amount_30d,0) base_amount_30d,
           coalesce(charge_user_con_all,0) charge_user_con_all,
           coalesce(charge_con_all,0) charge_con_all,
           coalesce(base_amount_all,0) base_amount_all
    from(
        select dt,
               get_json_string(custom_data,'seriesId') as series_id,
               count(distinct user_id) charge_user_con,
               count(user_id) charge_con,
               sum(base_amount)/100 base_amount
        from dwd.dwd_trade_short_video_payorder
        where dt='${bf_1_dt}' and test_flag =0 and status=0
        group by 1,2
    )a
    left join(
        select '${bf_1_dt}' as dt,
               get_json_string(custom_data,'seriesId') as series_id,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',user_id,null)) charge_user_con_1d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',user_id,null)) charge_con_1d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 1 day ) and dt<'${bf_1_dt}',base_amount,0))/100 base_amount_1d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',user_id,null)) charge_user_con_3d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',user_id,null)) charge_con_3d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 3 day ) and dt<'${bf_1_dt}',base_amount,0))/100 base_amount_3d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',user_id,null)) charge_user_con_7d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',user_id,null)) charge_con_7d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 7 day ) and dt<'${bf_1_dt}',base_amount,0))/100 base_amount_7d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',user_id,null)) charge_user_con_15d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',user_id,null)) charge_con_15d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 15 day ) and dt<'${bf_1_dt}',base_amount,0))/100 base_amount_15d,
               count(distinct if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',user_id,null)) charge_user_con_30d,
               count(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',user_id,null)) charge_con_30d,
               sum(if(dt>=date_sub('${bf_1_dt}',interval 30 day ) and dt<'${bf_1_dt}',base_amount,0))/100 base_amount_30d,
               count(distinct user_id) charge_user_con_all,
               count(user_id) charge_con_all,
               sum(base_amount)/100 base_amount_all
        from dwd.dwd_trade_short_video_payorder
        where dt<'${bf_1_dt}' and test_flag =0 and status=0
        group by 1,2
    )b on a.dt=b.dt and a.series_id=b.series_id
    where a.series_id is not null
)
select coalesce(t1.dt,t2.dt,t3.dt) dt,
       coalesce(t1.series_id,t2.series_id,t3.series_id) series_id,
       coalesce(watch_user_con,0) watch_user_con,
       coalesce(watch_epis_num,0) watch_epis_num,
       coalesce(end_watch_epis_num,0) end_watch_epis_num,
       coalesce(watch_user_con_1d,0) watch_user_con_1d,
       coalesce(watch_epis_num_1d,0) watch_epis_num_1d,
       coalesce(end_watch_epis_num_1d,0) end_watch_epis_num_1d,
       coalesce(watch_user_con_3d,0) watch_user_con_3d,
       coalesce(watch_epis_num_3d,0) watch_epis_num_3d,
       coalesce(end_watch_epis_num_3d,0) end_watch_epis_num_3d,
       coalesce(watch_user_con_7d,0) watch_user_con_7d,
       coalesce(watch_epis_num_7d,0) watch_epis_num_7d,
       coalesce(end_watch_epis_num_7d,0) end_watch_epis_num_7d,
       coalesce(watch_user_con_15d,0) watch_user_con_15d,
       coalesce(watch_epis_num_15d,0) watch_epis_num_15d,
       coalesce(end_watch_epis_num_15d,0) end_watch_epis_num_15d,
       coalesce(watch_user_con_30d,0) watch_user_con_30d,
       coalesce(watch_epis_num_30d,0) watch_epis_num_30d,
       coalesce(end_watch_epis_num_30d,0) end_watch_epis_num_30d,
       coalesce(watch_user_con_all,0) watch_user_con_all,
       coalesce(watch_epis_num_all,0) watch_epis_num_all,
       coalesce(end_watch_epis_num_all,0) end_watch_epis_num_all,
	   coalesce(consume_user_con,0) consume_user_con,
       coalesce(consume_epis_num,0) consume_epis_num,
       coalesce(consume_coin_amount,0) consume_coin_amount,
       coalesce(consume_amount,0) consume_amount,
       coalesce(consume_user_con_1d,0) consume_user_con_1d,
       coalesce(consume_epis_num_1d,0) consume_epis_num_1d,
       coalesce(consume_coin_amount_1d,0) consume_coin_amount_1d,
       coalesce(consume_amount_1d,0) consume_amount_1d,
       coalesce(consume_user_con_3d,0) consume_user_con_3d,
       coalesce(consume_epis_num_3d,0) consume_epis_num_3d,
       coalesce(consume_coin_amount_3d,0) consume_coin_amount_3d,
       coalesce(consume_amount_3d,0) consume_amount_3d,
       coalesce(consume_user_con_7d,0) consume_user_con_7d,
       coalesce(consume_epis_num_7d,0) consume_epis_num_7d,
       coalesce(consume_coin_amount_7d,0) consume_coin_amount_7d,
       coalesce(consume_amount_7d,0) consume_amount_7d,
       coalesce(consume_user_con_15d,0) consume_user_con_15d,
       coalesce(consume_epis_num_15d,0) consume_epis_num_15d,
       coalesce(consume_coin_amount_15d,0) consume_coin_amount_15d,
       coalesce(consume_amount_15d,0) consume_amount_15d,
       coalesce(consume_user_con_30d,0) consume_user_con_30d,
       coalesce(consume_epis_num_30d,0) consume_epis_num_30d,
       coalesce(consume_coin_amount_30d,0) consume_coin_amount_30d,
       coalesce(consume_amount_30d,0) consume_amount_30d,
       coalesce(consume_user_con_all,0) consume_user_con_all,
       coalesce(consume_epis_num_all,0) consume_epis_num_all,
       coalesce(consume_coin_amount_all,0) consume_coin_amount_all,
       coalesce(consume_amount_all,0) consume_amount_all,
       coalesce(charge_user_con,0) charge_user_con,
       coalesce(charge_con,0) charge_con,
       coalesce(base_amount,0) base_amount,
       coalesce(charge_user_con_1d,0) charge_user_con_1d,
       coalesce(charge_con_1d,0) charge_con_1d,
       coalesce(base_amount_1d,0) base_amount_1d,
       coalesce(charge_user_con_3d,0) charge_user_con_3d,
       coalesce(charge_con_3d,0) charge_con_3d,
       coalesce(base_amount_3d,0) base_amount_3d,
       coalesce(charge_user_con_7d,0) charge_user_con_7d,
       coalesce(charge_con_7d,0) charge_con_7d,
       coalesce(base_amount_7d,0) base_amount_7d,
       coalesce(charge_user_con_15d,0) charge_user_con_15d,
       coalesce(charge_con_15d,0) charge_con_15d,
       coalesce(base_amount_15d,0) base_amount_15d,
       coalesce(charge_user_con_30d,0) charge_user_con_30d,
       coalesce(charge_con_30d,0) charge_con_30d,
       coalesce(base_amount_30d,0) base_amount_30d,
       coalesce(charge_user_con_all,0) charge_user_con_all,
       coalesce(charge_con_all,0) charge_con_all,
       coalesce(base_amount_all,0) base_amount_all
from t1
full join t2 on t1.dt=t2.dt and t1.series_id=t2.series_id
full join t3 on t1.dt=t3.dt and t1.series_id=t3.series_id;
