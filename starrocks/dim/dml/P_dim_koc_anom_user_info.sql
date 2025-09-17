----------------------------------------------------------------
-- 程序功能： koc异常用户信息
-- 程序名： P_dim_koc_anom_user_info
-- 目标表： dim.dim_koc_anom_user_info
-- 负责人： qhr
-- 开发日期： 2025-09-15
----------------------------------------------------------------

insert into dim.dim_koc_anom_user_info
select a1.user_id                  as user_id             -- 用户id
      ,a1.anomaly_type             as anom_type_cd        -- 异常类型编码
      ,case when a1.anomaly_type = 1 then '刷券'
            when a1.anomaly_type = 2 then '撞库'
            when a1.anomaly_type = 3 then '薅羊毛'
            when a1.anomaly_type = 4 then '套现'
            else cast(a1.anomaly_type as varchar(50))
        end                        as anom_type_name      -- 异常类型名称
      ,a1.status                   as anom_status_cd      -- 异常状态编码
      ,case when a1.status = 1 then '生效'
            when a1.status = 2 then '已解除'
            else cast(a1.status as varchar(50))
        end                        as anom_status_name    -- 异常状态名称
      ,a1.start_time               as anom_start_time     -- 异常开始时间
      ,a1.end_time                 as anom_end_time       -- 异常结束时间
      ,a1.remark                   as manl_rmk            -- 人工备注
      ,a1.created_at               as create_time         -- 创建时间
      ,a1.updated_at               as update_time         -- 更新时间
      ,now()                       as etl_time            -- etl时间
  from ods.ods_mysql_koc_db_koc_risk_user_anomaly    as a1
;