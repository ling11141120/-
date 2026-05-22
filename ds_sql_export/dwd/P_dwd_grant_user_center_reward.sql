----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_grant_user_center_reward
-- workflow_version : 6
-- create_user      : linq
-- task_name        : dwd_grant_user_center_reward
-- task_version     : 5
-- update_time      : 2023-11-28 16:37:19
-- sql_path         : \starrocks\tbl_dwd_grant_user_center_reward\dwd_grant_user_center_reward
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_grant_user_center_reward where dt>='${bf_3_dt}' and dt<'${dt}';

-- SQL语句
insert into dwd.dwd_grant_user_center_reward
select dt,product_id,Id,user_id,sign_id,sign_name,use_type,Days,Type,reward_id,award_type,send_num,send_id,sing_date,source_key,is_special_reward,create_time,AppId,now() as etl_time
from(
    select a.dt,a.product_id,a.Id,a.UserId as user_id,a.SignId as sign_id,b.Name as sign_name,b.UseType as use_type,a.Days,a.Type,a.RewardId as reward_id,a.awardType as award_type,
           a.SendNum as send_num,a.SendId as send_id,a.SignDate as sing_date,a.SourceKey as source_key,a.IsSpecialReward as is_special_reward,
           a.CreateTime as create_time,a.AppId,
           row_number() over (partition by a.dt,a.product_id,a.UserId,a.SignId,a.Days,a.Type,a.RewardId,a.AwardType,a.SendNum,a.SendId,a.SignDate,a.SourceKey,a.IsSpecialReward,a.CreateTime,a.AppId order by a.id desc) as rn
    from ods_log.ods_tidb_readerlog_Log_UserCenterRewardLog a
    left join ods.ods_tidb_readernovel_tidb_tag_center_sign b on a.SignId=b.Id
    where dt>='${bf_3_dt}' and dt<'${dt}'
)t1
where rn=1;
