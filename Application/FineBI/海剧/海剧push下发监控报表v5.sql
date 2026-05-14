-------------------------------------------------
-- 应用报表：海剧-策略效果报表/海剧PUSH下发监控报表
-------------------------------------------------

-- dau,开关人数
with dau_info as
(
select
	${if(维度1 == "汇总","'汇总'", "a1.`"+ 维度1+"`")} `维度1`,
	count(distinct a1.user_id) as dau,
	count(distinct case when app_notify=1 then a1.user_id end) msg_on_uv
from dws.dws_srsv_wide_user_type_info_di a1
left join dim.dim_short_video_user_accountinfo_daily a2
on a1.user_id=a2.user_id and a1.dt=a2.dt
where
	1=1
	and a1.product_id = 6833 and  user_period = 2
	and a1.dt >= '${开始时间}' and a1.dt <= '${结束时间}'
	${if(len(CORE) == 0,"","and a1.corever  in ('" + CORE + "')")}
	${if(len(终端) == 0,"","and  case
	when a1.mt=1 then 'iOS'
	when a1.mt=4 then 'Android'
 else '其他' end in ('" + 终端 + "')")}
GROUP by 1
),


-- 下发人数
send_view as(
select
	${if(维度1 == "汇总","'汇总'", 维度1)} `维度1`,
	${if(维度2 == "汇总","'汇总'", 维度2)} `维度2`,
	${if(维度3 == "汇总","'汇总'", 维度3)} `维度3`,
	count(distinct case when account_id<>0 then account_id end) send_uv,
	count(1) send_pv,
	count(distinct active_user_id) active_uv
from
	(
	select
		date(need_to_send_time) dt,
		case
		when push_position_id=1 then '签到push'
		when push_position_id=2 then '小安私信'
		else t1.push_type end push_type,
		push_position_id push_id,
		push_position_name push_name,
		account_id,
		active_user_id,
		t2.corever,
		case when t2.mt=1 then 'iOS' when t2.mt=4 then 'Android' else '其他' end as mt
	from
	ads.ads_center_push_position_message_di_analysis_json t1
	left join dim.dim_short_video_user_accountinfo t2 on t1.account_id = t2.user_id
	left join ads.ads_tidb_short_video_center_push_position_view dim_push on t1.push_position_id = dim_push.id
	where
		1=1
		and (send_status =1 or (push_position_id in (1,2)) )
		and t1.dt >= date_add('${开始时间}',-1) and t1.dt <= '${结束时间}'
		and t1.need_to_send_time>='${开始时间}' and t1.need_to_send_time<date_add('${结束时间}',1)
	union all
	select
		a1.dt,
		case when os ='Android' then '伪实时活动'
		else '实时活动' end  push_type,
		0 as push_id,
		case
			-- when os = 'Android' then '伪实时活动通知'
			when page_name in ('视频内容页','200800') then '开始播放'
			when page_name in ('签到页','福利中心页','201000') then '去领取'
			when page_name in ('for you','MiniDrama') then 'for you'
            else '其他'
			end as push_name,
		a1.login_id as account_id,
		a1.login_id active_user_id,
		substr(a1.app_id,-4,1) corever,
		a1.os mt
	from
		ads.ads_sensors_cd_video_ElmentExposure_view a1
	where a1.dt>='2025-04-15'
      and a1.dt >= '${开始时间}'
      and a1.dt <= '${结束时间}'
      and element_id=210015
      and	project_id =8
		union all
		select
		a2.dt,
	   '小窗播放'  push_type,
		0 as push_id,
	    page_name push_name,
		a2.login_id as account_id,
		a2.login_id active_user_id,
		substr(a2.app_id,-4,1) corever,
		a2.os mt
	from
		ads.ads_sensors_cd_video_ElmentExposure_view a2
	where a2.dt >= '${开始时间}' and a2.dt <= '${结束时间}' and a2.element_id in(210012)
--          and os = 'iOS'
          and (substr(a2.app_id,-4,1) = 4 and replace(left(app_version,5) , '.','') >= 172 and os = 'Android')
    --  and 1=2
		union all
		select
		a2.dt,
	    '正在播放' push_type,
		0 as push_id,
	    page_name push_name,
		a2.login_id as account_id,
		a2.login_id active_user_id,
		substr(a2.app_id,-4,1) corever,
		a2.os mt
	from
		ads.ads_sensors_cd_video_ElmentExposure_view a2
	where a2.dt >= '${开始时间}' and a2.dt <= '${结束时间}' and a2.element_id in(210032)
      and a2.os = 'Android'
      and substr(a2.app_id,-4,1)  = 1
	) a1
  where
  	1=1
    ${if(len(CORE) == 0,"","and corever in ('" + CORE + "')")}
    ${if(len(终端) == 0,"","and mt in ('" + 终端 + "')")}
  	${if(len(PUSHID) == 0,"","and  push_id in ('" + PUSHID + "')")}
		${if(len(PUSH名称) == 0,"","and  push_name in ('" + PUSH名称 + "')")}
		${if(len(推送类型) == 0,"","and  push_type in ('" + 推送类型 + "')")}
group by 1,2,3
),

-- 服务端送人人数
push_send_result as(
select
	${if(维度1 == "汇总","'汇总'", 维度1)} `维度1`,
	${if(维度2 == "汇总","'汇总'", 维度2)} `维度2`,
	${if(维度3 == "汇总","'汇总'", 维度3)} `维度3`,
	count(distinct login_id) send_success_uv,
	count( login_id) send_success_pv
from
	(
	select
		t1.dt,
		case
		when push_id=1 then '签到push'
		when push_id=2 then '小安私信'
		when t1.push_type is null then '签到push'
		when t1.push_type='' then '签到push'
		else t1.push_type  end  push_type,
		push_id ,
		push_position_name push_name,
		login_id
	from ads.ads_sensors_cd_video_pushsendresult_view  t1
	left join dim.dim_short_video_user_accountinfo t2
	ON t1.login_id = t2.user_id
	left join ads.ads_tidb_short_video_center_push_position_view dim_push
	on t1.push_id = dim_push.id
	where
		1=1
		and push_send_result ='成功' and project_id=8
		and t1.dt >= '${开始时间}' and t1.dt <= '${结束时间}'
		${if(len(PUSHID) == 0,"","and  push_id in ('" + PUSHID + "')")}
		${if(len(PUSH名称) == 0,"","and  push_position_name in ('" + PUSH名称 + "')")}
		${if(len(推送类型) == 0,"","and  case
		when push_id=1 then '签到push'
		when push_id=2 then '小安私信'
		else t1.push_type end  in ('" + 推送类型 + "')")}
		${if(len(CORE) == 0,"","and  corever in ('" + CORE + "')")}
		${if(len(终端) == 0,"","and  case
		when mt=1 then 'iOS'
		when mt=4 then 'Android'
		else '其他' end in ('" + 终端 + "')")}
	) a1
group by 1,2,3
),


-- 点击人数
push_click as(
select
	${if(维度1 == "汇总","'汇总'", 维度1)} `维度1`,
	${if(维度2 == "汇总","'汇总'", 维度2)} `维度2`,
	${if(维度3 == "汇总","'汇总'", 维度3)} `维度3`,
	count( distinct login_id ) push_click_unt,
	count(1) push_click_pv
from
	(
  select
		t1.dt,
		case
		when push_id=1 then '签到push'
		when push_id=2 then '小安私信'
		when t1.push_type is null then '签到push'
		when t1.push_type='' then '签到push'
		else t1.push_type  end push_type,
		push_id,
		push_position_name push_name,
		login_id,
		t1.os mt,
		substr(t1.app_id,-4,1) corever
	from  ads.ads_sensors_video_pushclick_view  t1
	left join ads.ads_tidb_short_video_center_push_position_view dim_push on t1.push_id = dim_push.id
	where
		t1.dt >= '${开始时间}' and t1.dt <= '${结束时间}' and project_id=8
  union all
  select
    t1.dt,
		case when os ='Android' then '伪实时活动'
		else '实时活动' end  push_type,
		0 as push_id,
		case
			-- when os = 'Android' then '伪实时活动通知'
			when page_name in ('视频内容页','200800') then '开始播放'
			when page_name in ('签到页','福利中心页','201000') then '去领取'
			when page_name in ('for you','MiniDrama') then 'for you'
            else '其他'
			end as push_name,
		login_id,
		t1.os mt,
		substr(t1.app_id,-4,1) corever
  from  ads.ads_sensors_cd_video_elmentclick_view   t1
  where t1.dt >= '${开始时间}'
      and t1.dt <= '${结束时间}'
      and element_id=210015
      and project_id=8
	union all
select
	a2.dt,
	case when element_type =1 then '小窗播放'
	     when element_type =2 then '正在播放'
     else '小窗播放' end push_type,
--	'小窗播放' as push_type,
	0 as push_id,
	page_name push_name,
		login_id,
		a2.os mt,
		substr(a2.app_id,-4,1) corever
from ads.ads_sensors_cd_video_elmentclick_view a2
where  a2.dt >= '${开始时间}' and a2.dt <= '${结束时间}'
      and a2.element_id = 210012
      -- and os = 'iOS'
      -- and substr(a2.app_id,-4,1) = 4
      and (substr(a2.app_id,-4,1) = 4 and replace(left(app_version,5) , '.','') >= 172 and os = 'Android')
    --  and 1=2
 union all
select
	a3.dt,
	'正在播放'  push_type,
	0 as push_id,
	page_name push_name,
		login_id,
		a3.os mt,
		substr(a3.app_id,-4,1) corever
from
	ads.ads_sensors_cd_video_elmentclick_view a3
where
	a3.dt >= '${开始时间}' and a3.dt <= '${结束时间}' and a3.element_id = 210032
      and a3.os = 'Android'
      and substr(a3.app_id,-4,1)  = 1

  ) a1
where
  1=1
  ${if(len(CORE) == 0,"","and corever in ('" + CORE + "')")}
  ${if(len(终端) == 0,"","and mt in ('" + 终端 + "')")}
  ${if(len(推送类型) == 0,"","and  case
		when push_type = '实时活动' then '实时活动'
		when push_type = '伪实时活动' then '伪实时活动'
		when push_type = '小窗播放' then '小窗播放'
		when push_type = '正在播放' then '正在播放'
		when push_id=0 and  mt ='iOS' then '实时活动'
		when push_id=0 and  mt ='Android' then '伪实时活动'
    when push_id=1 then '签到push'
		when push_id=2 then '小安私信'
		when push_type is null then '签到push'
		when push_type='' then '签到push'
		else push_type  end    in ('" + 推送类型 + "')")}
	${if(len(PUSHID) == 0,"","and  push_id in ('" + PUSHID + "')")}
	${if(len(PUSH名称) == 0,"","and  push_name in ('" + PUSH名称 + "')")}
group by 1,2,3
),


z2 as(
select
	COALESCE(send_view.`维度1`, push_click.`维度1`, push_send_result.`维度1`) AS `维度1`,
	COALESCE(send_view.`维度2` ,push_click.`维度2`, push_send_result.`维度2`) AS `维度2`,
	COALESCE(send_view.`维度3`, push_click.`维度3`, push_send_result.`维度3`) AS `维度3`,
	ifnull(send_uv,0) send_uv ,
	ifnull(send_pv,0) send_pv ,
	ifnull(active_uv,0) active_uv ,
	ifnull(push_click_unt, 0 ) push_click_unt,
	ifnull(push_click_pv, 0 ) push_click_pv,
	ifnull(send_success_uv, 0 ) send_success_uv,
	ifnull(send_success_pv, 0 ) send_success_pv
from send_view
full join push_click
on send_view.`维度1` = push_click.`维度1`
and send_view.`维度2` = push_click.`维度2`
and send_view.`维度3` = push_click.`维度3`
full join push_send_result
on send_view.`维度1` = push_send_result.`维度1`
and send_view.`维度2` = push_send_result.`维度2`
and send_view.`维度3` = push_send_result.`维度3`
)
select
	`维度1` ,
	`维度2` ,
	`维度3`,
	dau dau ,
	msg_on_uv 通知打开用户数,
	send_uv 下发人数,
	send_pv 下发次数,
	active_uv 下发活跃人数,
	push_click_unt 点击人数,
	push_click_pv 点击次数,
	send_success_uv 送达人数,
	send_success_pv 送达次数
from
	(
	select
		dau_info.`维度1`  ,
		dau_info.dau ,
		dau_info.msg_on_uv,
		z2.`维度2` ,
		z2.`维度3` ,
		z2.send_uv ,
		z2.send_pv ,
		z2.active_uv,
		z2.push_click_unt ,
		z2.push_click_pv,
		z2.send_success_uv,
		z2.send_success_pv
	from  dau_info
	left join  z2
	on dau_info.`维度1`  = z2.`维度1`
	) z12
