----------------------------------------------------------------
-- 程序功能： 周期型内容域目标书籍进度事实表
-- 程序名： P_dwd_content_book_capacity_monitoring_snap
-- 目标表： dwd.dwd_content_book_capacity_monitoring_snap
-- 负责人： qhr
-- 开发日期： 2025-10-17
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into dwd.dwd_content_book_capacity_monitoring_snap
select ifnull(a2.dt, date_sub(curdate(), interval 1 day))               as dt                  -- 日期
      ,ifnull(a2.ToBookId, a1.bookid)                                   as to_book_id          -- 书籍id
      ,ifnull(a2.ToLanguage, a1.siteid)                                 as site_id             -- 语言id
      ,a1.ResourceType                                                  as resource_type       -- 生产位
      ,a1.bookname                                                      as book_name           -- 书籍名称
      ,a1.bookcode                                                      as book_code           -- 书籍代码
      ,a2.BookStatus                                                    as book_status         -- 书籍状态
      ,a3.AccountName                                                   as account_name        -- 项管名称
      ,ifnull(a2.ProofreadLength, 0)                                    as proofread_length    -- 精修（二校）字数
      ,ifnull(a2.PublishLength, 0)                                      as publish_length      -- 发布字数
      ,a1.LengthTarget                                                  as length_target       -- 目标字数
      ,  (ifnull(a2.StartNum, 0) + ifnull(a2.StartPlusNum, 0) / 7)
       * (ifnull(a2.PublishLength, 0) / ifnull(a2.PublishNumber, 1))    as daily_publish       -- 日更字数
      ,a1.Priority                                                      as pri_cd              -- 优先级编号
      ,case when a1.Priority = 0 then 'P0'
            when a1.Priority = 1 then 'P1'
            when a1.Priority = 2 then 'P2'
            else null
       end                                                              as pri_name            -- 优先级名称
      ,now()                                                            as etl_time            -- etl清洗时间
  from (select b1.bookid
              ,b1.siteid
              ,b1.MonthTime
              ,b1.ResourceType
              ,b1.bookname
              ,b1.bookcode
              ,b1.LengthTarget
              ,b1.Priority
          from ods.ods_tidb_shuangwen_en_viscfocusbookconfig                    as b1
         where date_format('${bf_1_dt}', '%Y-%m') = date_format(b1.MonthTime, '%Y-%m')
           and b1.DelStatus = 0
       )                                                                        as a1
  left join (select b2.dt                 as dt
                   ,b2.ToBookId           as ToBookId
                   ,b2.ToLanguage         as ToLanguage
                   ,b2.BookStatus         as BookStatus
                   ,b2.ProofreadLength    as ProofreadLength
                   ,b2.PublishLength      as PublishLength
                   ,b2.StartNum           as StartNum
                   ,b2.StartPlusNum       as StartPlusNum
                   ,b2.PublishNumber      as PublishNumber
               from (select c1.dt
                           ,c1.ToBookId
                           ,c1.ToLanguage
                           ,c1.BookStatus
                           ,c1.ProofreadLength
                           ,c1.PublishLength
                           ,c1.StartNum
                           ,c1.StartPlusNum
                           ,c1.PublishNumber
                           ,row_number() over(partition by c1.dt, c1.ToBookId, c1.ToLanguage
                                                  order by c1.id desc
                                             )                                  as rn
                       from ods.ods_tidb_shuangwen_en_bookcapacitymonitoring    as c1
                      where c1.dt = '${bf_1_dt}'
                    )                                                           as b2
              where b2.rn = 1
            )                                                                   as a2
    on a2.tobookid = a1.bookid
   and a2.tolanguage = a1.siteid
  left join ods.ods_tidb_shuangwen_en_viscadminconfig                           as a3
    on a1.siteid = a3.siteid
;