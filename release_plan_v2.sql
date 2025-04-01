SELECT
t1.project_id,
(SELECT `project_name` from project where id = t1.project_id) as "应用名称",
t1.c1 as "测试发布总次数（包含stage）",
t2.c2 as "stage总次数",
t3.c3 as "生产发布总次数",
t4.id as "是否有预发"

from (
SELECT 
l.project_id,
(SELECT `project_name` from project where id = l.project_id) name,
count(*) c1 from workflow_deploy_logs l,project_env p where l.project_env_id = p.id and p.is_pro = 0 and l.create_time >= "2024-07-01 00:00:00" and deploy_source = 1 and l.employee_id !='系统' GROUP BY l.project_id
) t1 LEFT JOIN
(
SELECT 
l.project_id,
count(*) c2 from workflow_deploy_logs l,project_env p where l.project_env_id = p.id and p.is_pro = 1 and l.create_time >= "2024-07-01 00:00:00" and deploy_source = 1 GROUP BY l.project_id
) t2 on t1.project_id = t2.project_id
LEFT JOIN
(
SELECT 
l.project_id,
count(*) c3 from workflow_deploy_logs l,project_env p where l.project_env_id = p.id and p.is_pro = 1 and l.create_time >= "2024-07-01 00:00:00" and deploy_source = 2 GROUP BY l.project_id
) t3 on t1.project_id = t3.project_id
LEFT JOIN (SELECT project_id,id from project_env where is_pro = 1 and namespace="stage") t4 on t1.project_id = t4.project_id

test123123123
