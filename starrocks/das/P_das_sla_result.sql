----------------------------------------------------------------
-- project_name     : data_quality
-- workflow_name    : das_sla
-- workflow_version : 49
-- create_user      : admin
-- task_name        : das_sla_result
-- task_version     : 38
-- update_time      : 2024-04-11 19:41:03
-- sql_path         : \data_quality\das_sla\das_sla_result
----------------------------------------------------------------
-- SQL语句
insert into das.das_sla_result
select
    '${bf_1_dt}' dt
     ,data_link_tm   -- 平均延迟时间
     ,sal_cnt   -- 任务流实例运行次数  正常一天就一次,值是1
     ,total_task_cnt  -- 0点到6点启动的所有任务数
     ,ontime_task_cnt  -- 0点到6点运行完成的任务数
     ,app_table_cnt  --  计算SR库中dim dwd  dwm  dws ads alg 层所有的表的个数
     ,f.qiye_cnt -- 数仓值班1点到6点有人起夜值就为1
     ,CURRENT_TIMESTAMP() etl_tm
from (
         select
             '${bf_1_dt}' dt
              ,count(1) sal_cnt
         from das.das_mysql_dolphinscheduler_t_ds_process_instance    -- 查询出前一天0点到6点任务流实例为 sch_all开头的任务流实例的运行次数
         where start_time >=concat('${bf_1_dt}', ' 00:00:00')
           and end_time <=concat('${bf_1_dt}', ' 06:00:00')
           and name rlike 'sch_all'
     )a
left join (
            select
                '${bf_1_dt}' dt
                ,count(1) `total_task_cnt`,
                sum(case when e.end_time <= concat('${bf_1_dt}', ' 06:00:00') then 1 else  0 end )  `ontime_task_cnt`
            from
                (
                    select c.name
                    from das.das_mysql_dolphinscheduler_t_ds_process_definition a   -- 海豚starrocks工作流定义表
                    left join das.das_mysql_dolphinscheduler_t_ds_process_task_relation b on a.code =b.process_definition_code --海豚调度-工作流任务关联关系表
                    left join das.das_mysql_dolphinscheduler_t_ds_task_definition c on c.code = b.pre_task_code -- 海豚starrocks 任务定义表
                    where a.name ='sch_all'  -- 只查总调度
                ) a left join das.das_mysql_dolphinscheduler_t_ds_process_definition b on a.name =b.name
                    left join das.das_mysql_dolphinscheduler_t_ds_process_task_relation c on b.code =c.process_definition_code
                    left join das.das_mysql_dolphinscheduler_t_ds_task_definition d on d.code = c.pre_task_code
                    left join das.das_mysql_dolphinscheduler_t_ds_task_instance e on d.code =e.task_code
            where d.name is not null
              and e.start_time between concat('${bf_1_dt}', ' 00:00:00') and concat('${bf_1_dt}', ' 06:00:00')
        )b
on a.dt = b.dt
left join (
            select
                '${bf_1_dt}' dt
                 ,count(1) app_table_cnt
             from das.das_dict_table   -- SR中的表
            where status=0   -- 0默认值  1下线
              and table_tp <>1   --表类型不为视图
              and db_nm not rlike 'ods|od_log'   -- 排除这2个数据库
           )c
on a.dt=c.dt
left join (
            select
                '${bf_1_dt}' dt
                 ,avg(time_diff) data_link_tm   --平均延迟时间
            from( select
                      time_diff
                       ,row_number() over( order by time_diff) row_num
                      ,count(1) over() total_num
                  from(
                          select
                              UNIX_TIMESTAMP(receive_time) - UNIX_TIMESTAMP(heartbeat_time) time_diff   -- 数据到达时间 减去 数据生成时间
                           from dwd.dwd_data_quality_link_monitor    -- 数据链路监控结果数据
                          where dt = '${bf_1_dt}'
                            and date_tp =1   -- 1业务数据  2日志数据
                      ) res
                ) res
            where row_num/total_num <=0.95   -- 取排名靠前的95% 也就是延迟从小到大排序,延迟时间小的前95%
            )d
on a.dt=d.dt
left join (
            SELECT
                create_date as  dt,
                COUNT(*)  AS qiye_cnt
            from ods.dolphin_task_fail_info
            where create_date = '${bf_1_dt}'
              and if_qiye = '1'
            group by create_date
        )f
on a.dt=f.dt;
