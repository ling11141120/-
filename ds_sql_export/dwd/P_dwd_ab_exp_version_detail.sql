----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_ab_exp_version_detail
-- workflow_version : 5
-- create_user      : xixg
-- task_name        : dwd_ab_exp_version_detail
-- task_version     : 5
-- update_time      : 2025-03-06 22:44:38
-- sql_path         : \starrocks\tbl_dwd_ab_exp_version_detail\dwd_ab_exp_version_detail
----------------------------------------------------------------
-- SQL语句
INSERT INTO  dwd.dwd_ab_exp_version_detail
WITH all_versions AS (
	select
		exp_id,
		exp_grp_ver_id,
		exp_start_time,
		exp_end_time,
		version_time as start_time,
		lag(version_time,1,'2999-01-01 00:00:00') over(partition by exp_id  order by version_time desc) as end_time
	from (
		select
			a.experiment_id AS exp_id ,
		    a.version AS exp_grp_ver_id,
		    b.start_time as exp_start_time,
			b.end_time  as exp_end_time,
		    min(a.update_time) as version_time
		from (
		         select id as experiment_id,
		                version ,
		                update_time
		         from ods.syncbi_ab_experiment
		         where status>=1
		         union all
		         select
		             experiment_id,
		             version,
		             update_time
		         from ods.ods_bigdata_ab_experiment_log
		         where status>=1
		     ) a
		     left join ods.syncbi_ab_experiment b on a.experiment_id=b.id
		group by 1,2,3,4
	) a
)
SELECT
      b.project_id AS project_id,               -- 项目ID
      a.exp_id AS exp_id,                       -- 实验ID
      c.version_number AS exp_grp_id,                  -- 实验组ID
      c.version_type AS exp_grp_type,           -- 实验组类型ID
      a.exp_grp_ver_id AS exp_grp_ver_id,       -- 实验版本ID
      a.exp_start_time,							-- 实验开始时间
      a.exp_end_time,							-- 实验结束时间
      a.start_time AS start_time,               -- 实验版本开始时间
      a.end_time AS end_time,               -- 实验版本开始时间
      b.experiment_name AS exp_name,            -- 实验名称
      c.version_name AS exp_grp_name,            -- 实验组名称
      NOW()
FROM all_versions a
INNER JOIN ods.syncbi_ab_experiment b
   ON  a.exp_id = b.id
INNER JOIN ods.syncbi_ab_experiment_versions c
   ON  a.exp_id = c.experiment_id;
