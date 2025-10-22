insert into ads.ads_center_push_position_message_di_analysis_json
select
    a.dt,
    a.id,
    a.push_position_id,
    a.generate_day,
    a.account_id,
    b.user_id as active_user_id,
    case when push_position_id=1 then '签到push'
        when push_position_id=2 then '小安私信'
        else push_type end as push_type,
    a.group_id,
    a.push_jump_page,
    a.title,
    a.act,
    a.utc_offset,
    a.need_to_send_time,
    a.send_status,
    a.send_success_time,
    a.create_time,
    a.update_time,
    now() as etl_tm
from (
    select dt,
           id,
           push_position_id,
           generate_day,
           account_id,
           get_json_string(msg_body, '$.custom.pushType') as push_type,
           get_json_string(msg_body, '$.custom.groupId') as group_id,
           get_json_string(msg_body, '$.custom.pushJumpPage') as push_jump_page,
           get_json_string(msg_body, '$.aps.alert.title') as title,
           left(substring_index(get_json_string(msg_body, '$.act'), 'activityLink=', -1),
           length(substring_index(get_json_string(msg_body, '$.act'), 'activityLink=', -1))-1) as act,
           utc_offset,
           need_to_send_time,
           send_status,
           send_success_time,
           create_time,
           update_time
    from dwd.dwd_center_push_position_message_di
    where need_to_send_time >= '${bf_1_dt}' and app_id%2 = 1
    union all
    select dt,
           id,
           push_position_id,
           generate_day,
           account_id,
           get_json_string(get_json_string(msg_body, '$.Data.custom'), '$.pushType') as push_type,
           get_json_string(get_json_string(msg_body, '$.Data.custom'), '$.groupId') as group_id,
           get_json_string(get_json_string(msg_body, '$.Data.custom'), '$.pushJumpPage') as push_jump_page,
           get_json_string(msg_body, '$.Notification.Title') as title,
           left(substring_index(get_json_string(msg_body, '$.Data.act'), 'activityLink=', -1),
           length(substring_index(get_json_string(msg_body, '$.Data.act'), 'activityLink=', -1))-1) as act,
           utc_offset,
           need_to_send_time,
           send_status,
           send_success_time,
           create_time,
           update_time
    from dwd.dwd_center_push_position_message_di
    where need_to_send_time >= '${bf_1_dt}' and app_id%2 = 0
) a
left join (
    select
        dt,
        user_id
    from dws.dws_user_short_video_wide_active_period_ed
    where dt >= '${bf_1_dt}'
) b
on date(a.need_to_send_time) = b.dt and a.account_id = b.user_id and (send_status =1 or (push_position_id in (1,2)));