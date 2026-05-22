----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_consume_user_consume
-- workflow_version : 4
-- create_user      : linq
-- task_name        : dwd_consume_user_consume
-- task_version     : 4
-- update_time      : 2023-10-30 15:30:44
-- sql_path         : \starrocks\tbl_dwd_consume_user_consume\dwd_consume_user_consume
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_consume_user_consume
select dt,
       ProductId,
       Id                                                                as auto_id,
       1                                                                 as types,
       if(UserId is null or UserId = '', -99, UserId)                    as user_id,
       if(Amount is null or Amount = '', -99, Amount)                    as amount,
       if(RemainAmount is null or RemainAmount = '', -99, RemainAmount)  as remain_amount,
       if(BookId is null or BookId = '', -99, BookId)                    as book_id,
       if(ChapterIds is null or ChapterIds = '[]', -99, ChapterIds)      as chapter_ids,
       if(ChapterIds is null or ChapterIds = '[]', 0,
          LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
       if(CreateTime is null or CreateTime = '', -99, CreateTime)        as create_time,
       if(PayType is null or PayType = '', -99, PayType)                 as pay_type,
       if(MT is null or MT = '', -99, MT)                                as mt,
       if(Seq is null or Seq = '', -99, Seq)                             as seq,
       if(AppId is null or AppId = '', -99, AppId)                       as app_id,
       if(PositionId is null or PositionId = '', -99, PositionId)        as position_id,
       if(AppGameId is null or AppGameId = '', -99, AppGameId)           as app_game_id,
       if(SendId is null or SendId = '', -99, SendId)                    as send_id,
       -99                                                               as is_First ,now() as etl_time
from ods_log.ods_book_log_usermoneylog
where dt >= '${bf_1_dt}' and dt<='${dt}'
union all
select dt,
       ProductId,
       Id                                                                as auto_id,
       2                                                                 as types,
       if(UserId is null or UserId = '', -99, UserId)                    as user_id,
       if(Amount is null or Amount = '', -99, Amount)                    as amount,
       if(RemainAmount is null or RemainAmount = '', -99, RemainAmount)  as remain_amount,
       if(BookId is null or BookId = '', -99, BookId)                    as book_id,
       if(ChapterIds is null or ChapterIds = '[]', -99, ChapterIds)      as chapter_ids,
       if(ChapterIds is null or ChapterIds = '[]', 0,
          LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
       if(CreateTime is null or CreateTime = '', -99, CreateTime)        as create_time,
       if(PayType is null or PayType = '', -99, PayType)                 as pay_type,
       if(MT is null or MT = '', -99, MT)                                as mt,
       if(Seq is null or Seq = '', -99, Seq)                             as seq,
       if(AppId is null or AppId = '', -99, AppId)                       as app_id,
       if(PositionId is null or PositionId = '', -99, PositionId)        as position_id,
       if(AppGameId is null or AppGameId = '', -99, AppGameId)           as app_game_id,
       if(SendId is null or SendId = '', -99, SendId)                    as send_id,
       -99                                                               as is_First ,now() as etl_time
from ods_log.ods_book_log_usergiftmoneylog
where dt >= '${bf_1_dt}' and dt<='${dt}'
union all
select dt,
       ProductId,
       Id                                                                as auto_id,
       3                                                                 as types,
       if(UserId is null or UserId = '', -99, UserId)                    as user_id,
       if(Amount is null or Amount = '', -99, Amount)                    as amount,
       if(RemainAmount is null or RemainAmount = '', -99, RemainAmount)  as remain_amount,
       if(BookId is null or BookId = '', -99, BookId)                    as book_id,
       if(ChapterIds is null or ChapterIds = '[]', -99, ChapterIds)      as chapter_ids,
       if(ChapterIds is null or ChapterIds = '[]', 0,
          LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
       if(CreateTime is null or CreateTime = '', -99, CreateTime)        as create_time,
       if(PayType is null or PayType = '', -99, PayType)                 as pay_type,
       if(MT is null or MT = '', -99, MT)                                as mt,
       if(Seq is null or Seq = '', -99, Seq)                             as seq,
       if(AppId is null or AppId = '', -99, AppId)                       as app_id,
       if(PositionId is null or PositionId = '', -99, PositionId)        as position_id,
       if(AppGameId is null or AppGameId = '', -99, AppGameId)           as app_game_id,
       if(SendId is null or SendId = '', -99, SendId)                    as send_id,
       -99                                                               as is_First ,now() as etl_time
from ods_log.ods_book_log_userawardmoneylog
where dt >= '${bf_1_dt}' and dt<='${dt}'
union all
select dt,
       ProductId,
       Id                                                                as auto_id,
       4                                                                 as types,
       if(UserId is null or UserId = '', -99, UserId)                    as user_id,
       if(Amount is null or Amount = '', -99, Amount)                    as amount,
       if(RemainAmount is null or RemainAmount = '', -99, RemainAmount)  as remain_amount,
       if(BookId is null or BookId = '', -99, BookId)                    as book_id,
       if(ChapterIds is null or ChapterIds = '[]', -99, ChapterIds)      as chapter_ids,
       if(ChapterIds is null or ChapterIds = '[]', 0,
          LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
       if(CreateTime is null or CreateTime = '', -99, CreateTime)        as create_time,
       if(PayType is null or PayType = '', -99, PayType)                 as pay_type,
       if(MT is null or MT = '', -99, MT)                                as mt,
       if(Seq is null or Seq = '', -99, Seq)                             as seq,
       if(AppId is null or AppId = '', -99, AppId)                       as app_id,
       -99                                                               as position_id,
       -99                                                               as app_game_id,
       -99                                                               as send_id,
       if(isFirst is null or isFirst = '', -99, isFirst)                 as is_First ,now() as etl_time
from ods_log.ods_book_log_userviplog
where dt >= '${bf_1_dt}' and dt<='${dt}';
