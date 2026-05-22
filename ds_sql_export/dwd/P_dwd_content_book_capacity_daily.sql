----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_content_book_capacity_daily
-- workflow_version : 1
-- create_user      : zhengtt
-- task_name        : dwd_content_book_capacity_daily
-- task_version     : 1
-- update_time      : 2024-01-23 10:05:09
-- sql_path         : \starrocks\tbl_dwd_content_book_capacity_daily\dwd_content_book_capacity_daily
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_content_book_capacity_daily
select  dt, to_book_id, ToLanguage, ToBookName, CNBookName, IsPutdown, StatisticsTime, UpdateTime, StartTime,
        EndTime, PlanCount, RealityCount, PublishNumber, ProofreadNumber, ProofreadLength, PublishLength,
        publish_number_today,proofread_number_today,proofread_length_today,
        book_type,price,proofread_length_today/1000*price as proofread_price_rmb_today,
        proofread_length_today/(1000*6.5)*price as proofread_price_today,publish_length_today,
        AddNum, WeekRate, MonthRate, TotalRate, BookCode, InterpreterStartTime, InterpreterEndTime,
        InterpreterPlanCount, InterpreterRealityCount, ForeignStartTime, ForeignEndTime, ForeignPlanCount,
        ForeignRealityCount, StopTime, NoForeignLength, NoProofreadLength, BookStatus, BookCreateTime,
        amount_7, amount_30, ForeignName, ProofreadName, InterpreterName, StartNum, StartPlusNum,
        RowVersion,
        now() as etl_time
from
(   select  dt, ToBookId*1000+ToLanguage as to_book_id,  ToLanguage, ToBookName, CNBookName, IsPutdown, StatisticsTime, UpdateTime, StartTime,
            EndTime, PlanCount, RealityCount, PublishNumber, ProofreadNumber, ProofreadLength, PublishLength,
            PublishNumber-last_publish_number as publish_number_today,
            ProofreadNumber-last_proofread_number as proofread_number_today,
            if(ProofreadLength-last_proofread_length < 0 ,0,ProofreadLength-last_proofread_length) as proofread_length_today,
            b.book_type,c.price,
            PublishLength-last_publish_length as publish_length_today,
            AddNum, WeekRate, MonthRate, TotalRate, BookCode, InterpreterStartTime, InterpreterEndTime,
            InterpreterPlanCount, InterpreterRealityCount, ForeignStartTime, ForeignEndTime, ForeignPlanCount,
            ForeignRealityCount, StopTime, NoForeignLength, NoProofreadLength, BookStatus, BookCreateTime,
            amount_7, amount_30, ForeignName, ProofreadName, InterpreterName, StartNum, StartPlusNum,
            RowVersion
    from
        (   select  dt, ToBookId, ToLanguage, Id, ToBookName, CNBookName, IsPutdown, StatisticsTime, UpdateTime, StartTime,
                    EndTime, PlanCount, RealityCount, PublishNumber, ProofreadNumber, ProofreadLength, PublishLength,
                    AddNum, WeekRate, MonthRate, TotalRate, BookCode, InterpreterStartTime, InterpreterEndTime,
                    InterpreterPlanCount, InterpreterRealityCount, ForeignStartTime, ForeignEndTime, ForeignPlanCount,
                    ForeignRealityCount, StopTime, NoForeignLength, NoProofreadLength, BookStatus, BookCreateTime,
                    amount_7, amount_30, ForeignName, ProofreadName, InterpreterName, StartNum, StartPlusNum,
                    RowVersion,
                    lag(PublishNumber,1,0) over(partition by ToBookId,ToLanguage order by dt) as last_publish_number,
                    lag(ProofreadNumber,1,0) over(partition by ToBookId,ToLanguage order by dt) as last_proofread_number,
                    lag(ProofreadLength,1,0) over(partition by ToBookId,ToLanguage order by dt) as last_proofread_length,
                    lag(PublishLength,1,0) over(partition by ToBookId,ToLanguage order by dt) as last_publish_length,
                    row_number() over (partition by ToBookId,ToLanguage order by dt) as rn
            from
                (   select  dt, ToBookId, ToLanguage, Id, ToBookName, CNBookName, IsPutdown, StatisticsTime, UpdateTime, StartTime,
                            EndTime, PlanCount, RealityCount, PublishNumber, ProofreadNumber, ProofreadLength, PublishLength,
                            AddNum, WeekRate, MonthRate, TotalRate, BookCode, InterpreterStartTime, InterpreterEndTime,
                            InterpreterPlanCount, InterpreterRealityCount, ForeignStartTime, ForeignEndTime, ForeignPlanCount,
                            ForeignRealityCount, StopTime, NoForeignLength, NoProofreadLength, BookStatus, BookCreateTime,
                            amount_7, amount_30, ForeignName, ProofreadName, InterpreterName, StartNum, StartPlusNum,
                            RowVersion,
                            row_number() over(partition by dt,ToBookId,ToLanguage order by id desc) as rn
                    from ods.ods_tidb_shuangwen_en_bookcapacitymonitoring
                    where dt >= '${bf_2_dt}' and dt <= '${bf_1_dt}'
                ) a
            where rn = 1
        ) a
            left join dim.dim_book_shuangwen_en_objectbook_info_view b
                      on a.ToBookId = b.swbook_id and  a.ToLanguage = b.to_language
            left join dim.dim_translate_book_price_info_view c
                      on a.ToLanguage = c.site_id and b.book_type = c.book_type
    where a.rn > 1
    ) a;
