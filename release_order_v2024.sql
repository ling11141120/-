SELECT project_id,pull_image_duration/1000/60,start_pull_image_time,end_pull_image_time FROM workflow_deploy_k8s_logs where project_id = "1730177229335433216" and create_time >= "2024-07-01 00:00:00" 
order by pull_image_duration desc



SELECT
p.project_name,
	e.cluster_address,
	(w.pull_image_duration / 1000 / 60) a 
FROM
	`workflow_deploy_k8s_logs` w
	INNER JOIN project_env e ON w.project_env_id = e.id 
	INNER JOIN project p on w.project_id = p.id
WHERE
	pull_image_duration > 0 
	AND w.create_time >= "2024-10-01 00:00:00" 
ORDER BY
	pull_image_duration DESC 
	LIMIT 100
	
	
	
	
	
SELECT
p.project_name,
	e.cluster_address,
	(w.pull_image_duration / 1000 / 60)  拉取时长（分钟）,
	w.create_time
FROM
	`workflow_deploy_k8s_logs` w
	INNER JOIN project_env e ON w.project_env_id = e.id 
	INNER JOIN project p on w.project_id = p.id
WHERE
	pull_image_duration > 0 
	AND w.create_time >= "2024-10-01 00:00:00" AND e.cluster_address not in ("newtest","test","inner-kunlun")
ORDER BY
	pull_image_duration DESC
	LIMIT 100；
	
	
	
	
	
SELECT p.project_name NAME,p.leader, 平均分钟, 构建总次数, 构建总时长分钟 from 
(SELECT 
    project_id,
    ROUND(sum(build_deploy_duration )/ 1000/60,2) 构建总时长分钟,
    sum(build_deploy_count) 构建总次数,
    ROUND(sum( build_deploy_duration )/ sum( build_deploy_count )/ 1000 / 60, 2 ) 平均分钟
    FROM
        `project_stat_data` 
    WHERE date >= "2024-12-25" 
    GROUP BY project_id 
    ) t left join project p on t.project_id = p.id
ORDER BY 平均分钟 DESC