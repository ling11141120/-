----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sr_market_operation_exp_report_di
-- workflow_version : 2
-- create_user      : sjc
-- task_name        : tbl_dwd_sr_market_operation_exp_report_di
-- task_version     : 2
-- update_time      : 2024-11-05 08:42:44
-- sql_path         : \starrocks\tbl_dwd_sr_market_operation_exp_report_di\tbl_dwd_sr_market_operation_exp_report_di
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_sr_market_operation_exp_report_di where dt='${bf_1_dt}';

-- SQL语句
insert into  dwd.dwd_sr_market_operation_exp_report_di

select
	'${bf_1_dt}' 					as dt 					-- 日期
	,op.OperationUser				as operation_user      	-- 操作用户
	,ap.position_id											-- 资源位ID
	,ap.position_type										-- 资源位类型1：banner，2：悬浮窗，3：弹窗，4：闪屏，5：阅读页触达，8：章末推送，9：阅读器返回推，10：串书，11：TAB推荐
	,ap.position_name										-- 资源位名称
	,ap.rules_type											-- 显示规则类型 1 每日首次推送（只推一次）、2 间隔N章 、 3 立即推送
	,ap.app_type											-- 应用类型 1：正式，2：测试
	,ap.strategy_type										-- 策略类型 0：实验策略，1：固化策略
	,ap.sorted												-- 排序
	,am.actity_id											-- 活动ID
	,am.actity_type											-- 活动类型 1：充值档位推荐，2：VIP档位推荐,3:签到卡档位推荐,4:自定义活动,5:组合活动,6:推剧(剧目单),7:推剧(指定短剧)
	,am.actity_time											-- 活动时间
	,am.start_time											-- 活动开始时间
	,am.end_time											-- 活动结束时间
	,ca.action_id											-- 策略ID
	,ca.action_name											-- 策略名称
	,ca.statu												-- 状态1 开启，2 关闭
	,ca.exposure_rule										-- 过曝规则
	,ca.create_time											-- 活动策略创建时间
	,ap.jgroup_ids											-- 极光人群包
	,ap.tag_group_ids 										-- TAG人群包
	,now()							as etl_time				-- etl时间

from

(
select
	 Id 							as position_id			-- 资源位ID
	,ActionType 					as position_type		-- 资源位类型1：banner，2：悬浮窗，3：弹窗，4：闪屏，5：阅读页触达，8：章末推送，9：阅读器返回推，10：串书，11：TAB推荐
	,PositionName 					as position_name		-- 资源位名称
	,ActivityId						as activity_id			-- 活动Id
	,Sort   						as sorted				-- 排序
	,JGroupIds  					as jgroup_ids			-- 极光人群包
	,GroupIds						as tag_group_ids		-- TAG人群包
	,RulesType						as rules_type			-- 显示规则类型 1 每日首次推送（只推一次）、2 间隔N章 、 3 立即推送
	,ApplyType						as app_type				-- 应用类型 1：正式，2：测试
	,StrategyType					as strategy_type		-- 策略类型 0：实验策略，1：固化策略
	,CreateTime												-- 创建时间
from
	ods.ods_tidb_readernovel_tidb_tag_center_activity_position	-- 资源位表
where 1=1
and date(CreateTime) = '${bf_1_dt}'
) ap

inner join
(
select
	 PositionId
	,ActionId		-- 策略Id
	,ParentId		-- 父级Id
from
(

select
	 PositionId
	,ActionId		-- 策略Id
	,ParentId		-- 父级Id
	,CreateTime		-- 创建时间
	,row_number() over(partition by PositionId,ActionId order by CreateTime desc) rn
from
	ods.ods_tidb_readernovel_tidb_tag_center_position_info -- 资源位与活动策略关联表
where 1=1
and date(CreateTime) = '${bf_1_dt}'
) pi where rn=1
 -- PositionId =7320008 and ActionId=7601031
) pi
on ap.position_id = pi.PositionId

inner join
(
select
	 Id
	,CONCAT(Id,'_',Name)		as actity_id			-- 活动ID
	,ActityType 				as actity_type			-- 活动类型 1：充值档位推荐，2：VIP档位推荐,3:签到卡档位推荐,4:自定义活动,5:组合活动,6:推剧(剧目单),7:推剧(指定短剧)
	,CreateTime					as actity_time			-- 活动时间
	,StartTime 					as start_time			-- 活动开始时间
	,EndTime 					as end_time				-- 活动结束时间
from
	ods.ods_tidb_readernovel_tidb_tag_center_activity_main -- 活动主表
where 1=1
and date(CreateTime) = '${bf_1_dt}'
) am
on pi.ParentId = am.Id
inner join
(
select
	 Id								as action_id			-- 策略ID
	,Name							as action_name			-- 策略名称
	,Status 						as statu				-- 状态1 开启，2 关闭
	,ExposureRule					as exposure_rule		-- 过曝规则
	,CreateTime						as create_time			-- 创建时间

from
	ods.ods_tidb_readernovel_tidb_tag_center_activity -- 活动策略表
where 1=1
and date(CreateTime) ='${bf_1_dt}'
) ca
on pi.ActionId =ca.action_id

inner join
(
select
	 ActivityId		-- 活动id
	,ActionId		-- 策略Id
	,OperationUser	-- 操作用户
	,CreateTime		-- 操作时间
from
(select
	 ActivityId		-- 活动id
	,ActionId		-- 策略Id
	,OperationUser	-- 操作用户
	,CreateTime		-- 操作时间
	,row_number() over(partition by ActivityId order by CreateTime desc) rn
from
	ods.ods_tidb_readernovel_tidb_tag_operation_position -- 点位日志
where 1=1
and OperationStatus =0	-- 操作日志状态（0有效，1失效）
and date(CreateTime) = '${bf_1_dt}'
) op  where rn = 1
) op
on am.Id=op.ActivityId

;
