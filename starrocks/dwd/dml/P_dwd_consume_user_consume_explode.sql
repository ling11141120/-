insert into dwd.dwd_consume_user_consume_explode 
select dt,
       ProductId,
       Id                                           as auto_id,
       1                                            as types,
       UserId                                       as user_id,
       amount / if(chapter_num = 0, 1, chapter_num) as amount,
       1 / if(chapter_num = 0, 1, chapter_num)      as consume_cnt,
       RemainAmount                                 as remain_amount,
       BookId                                       as book_id,
       ChapterIds                                   as chapter_ids,
       t.unnest                                     as chapter_id,
       CreateTime                                   as create_time,
       PayType                                      as pay_type,
       mt,
       seq,
       AppId                                        as app_id,
       PositionId                                   as position_id,
       AppGameId                                    as app_game_id,
       SendId                                       as send_id,
       isFirst                                      as is_First ,now() as etl_time
from (
         select dt,ProductId,Id,UserId,Amount,RemainAmount,BookId,ChapterIds,split(substr(chapterids, 2, length(chapterids) - 2), ',') as chapter_id,
                if(ChapterIds is null or ChapterIds = '[]', 0,LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
                CreateTime,PayType,mt,seq,AppId,PositionId,AppGameId,SendId,null as isFirst
         from ods_log.ods_book_log_usermoneylog
         where dt >= '${bf_1_dt}' and dt <= '${dt}'
     ) t1,
     unnest(chapter_id) as t
union all
select dt,
       ProductId,
       Id                                           as auto_id,
       2                                            as types,
       UserId                                       as user_id,
       amount / if(chapter_num = 0, 1, chapter_num) as amount,
       1 / if(chapter_num = 0, 1, chapter_num)      as consume_cnt,
       RemainAmount                                 as remain_amount,
       BookId                                       as book_id,
       ChapterIds                                   as chapter_ids,
       t.unnest                                     as chapter_id,
       CreateTime                                   as create_time,
       PayType                                      as pay_type,
       mt,
       seq,
       AppId                                        as app_id,
       PositionId                                   as position_id,
       AppGameId                                    as app_game_id,
       SendId                                       as send_id,
       isFirst                                      as is_First ,now() as etl_time
from (
         select dt,ProductId,Id,UserId,Amount,RemainAmount,BookId,ChapterIds,split(substr(chapterids, 2, length(chapterids) - 2), ',') as chapter_id,
                if(ChapterIds is null or ChapterIds = '[]', 0,LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
                CreateTime,PayType,mt,seq,AppId,PositionId,AppGameId,SendId,null as isFirst
         from ods_log.ods_book_log_usergiftmoneylog
         where dt >= '${bf_1_dt}' and dt <= '${dt}'
     ) t1,
     unnest(chapter_id) as t
union all
select dt,
       ProductId,
       Id                                           as auto_id,
       3                                            as types,
       UserId                                       as user_id,
       amount / if(chapter_num = 0, 1, chapter_num) as amount,
       1 / if(chapter_num = 0, 1, chapter_num)      as consume_cnt,
       RemainAmount                                 as remain_amount,
       BookId                                       as book_id,
       ChapterIds                                   as chapter_ids,
       t.unnest                                     as chapter_id,
       CreateTime                                   as create_time,
       PayType                                      as pay_type,
       mt,
       seq,
       AppId                                        as app_id,
       PositionId                                   as position_id,
       AppGameId                                    as app_game_id,
       SendId                                       as send_id,
       isFirst                                      as is_First ,now() as etl_time
from (
         select dt,ProductId,Id,UserId,Amount,RemainAmount,BookId,ChapterIds,split(substr(chapterids, 2, length(chapterids) - 2), ',') as chapter_id,
                if(ChapterIds is null or ChapterIds = '[]', 0,LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
                CreateTime,PayType,mt,seq,AppId,PositionId,AppGameId,SendId,null as isFirst
         from ods_log.ods_book_log_userawardmoneylog
         where dt >= '${bf_1_dt}' and dt <= '${dt}'
     ) t1,
     unnest(chapter_id) as t
union all
select dt,
       ProductId,
       Id                                           as auto_id,
       4                                            as types,
       UserId                                       as user_id,
       amount / if(chapter_num = 0, 1, chapter_num) as amount,
       1 / if(chapter_num = 0, 1, chapter_num)      as consume_cnt,
       RemainAmount                                 as remain_amount,
       BookId                                       as book_id,
       ChapterIds                                   as chapter_ids,
       t.unnest                                     as chapter_id,
       CreateTime                                   as create_time,
       PayType                                      as pay_type,
       mt,
       seq,
       AppId                                        as app_id,
       PositionId                                   as position_id,
       AppGameId                                    as app_game_id,
       SendId                                       as send_id,
       IsFirst                                      as is_First ,now() as etl_time
from (
         select dt,ProductId,Id,UserId,Amount,RemainAmount,BookId,ChapterIds,split(substr(chapterids, 2, length(chapterids) - 2), ',') as chapter_id,
                if(ChapterIds is null or ChapterIds = '[]', 0,LENGTH(chapterids) - LENGTH(replace(chapterids, ',', '')) + 1) as chapter_num,
                CreateTime,PayType,mt,seq,AppId,null as PositionId,null as AppGameId,null as SendId,isFirst
         from ods_log.ods_book_log_userviplog
         where dt >= '${bf_1_dt}' and dt <= '${dt}'
     ) t1,
     unnest(chapter_id) as t;